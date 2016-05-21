From: akpm@linux-foundation.org
Subject: [patch 074/162] procfs: expose umask in /proc/<PID>/status
Date: Fri, 20 May 2016 17:00:05 -0700
Message-ID: <573fa505.F9EfpNizNgLreURR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbcEUAAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:00:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rjones@redhat.com, jmarchan@redhat.com, keescook@chromium.org, koct9i@gmail.com, mhocko@kernel.org, pierre@spotify.com, tytso@mit.edu

From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: procfs: expose umask in /proc/<PID>/status

It's not possible to read the process umask without also modifying it,
which is what umask(2) does.  A library cannot read umask safely,
especially if the main program might be multithreaded.

Add a new status line ("Umask") in /proc/<PID>/status.  It contains
the file mode creation mask (umask) in octal.  It is only shown for
tasks which have task->fs.

This patch is adapted from one originally written by Pierre Carrier.


The use case is that we have endless trouble with people setting weird
umask() values (usually on the grounds of "security"), and then everything
breaking.  I'm on the hook to fix these.  We'd like to add debugging to
our program so we can dump out the umask in debug reports.

Previous versions of the patch used a syscall so you could only read your
own umask.  That's all I need.  However there was quite a lot of push-back
from those, so this new version exports it in /proc.

See:

https://lkml.org/lkml/2016/4/13/704 [umask2]
https://lkml.org/lkml/2016/4/13/487 [getumask]
Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pierre Carrier <pierre@spotify.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    1 +
 fs/proc/array.c                    |   20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~procfs-expose-umask-in-proc-pid-status Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-expose-umask-in-proc-pid-status
+++ a/Documentation/filesystems/proc.txt
@@ -225,6 +225,7 @@ Table 1-2: Contents of the status files
  TracerPid                   PID of process tracing this process (0 if not)
  Uid                         Real, effective, saved set, and  file system UIDs
  Gid                         Real, effective, saved set, and  file system GIDs
+ Umask                       file mode creation mask
  FDSize                      number of file descriptor slots currently allocated
  Groups                      supplementary group list
  NStgid                      descendant namespace thread group ID hierarchy
diff -puN fs/proc/array.c~procfs-expose-umask-in-proc-pid-status fs/proc/array.c
--- a/fs/proc/array.c~procfs-expose-umask-in-proc-pid-status
+++ a/fs/proc/array.c
@@ -83,6 +83,7 @@
 #include <linux/tracehook.h>
 #include <linux/string_helpers.h>
 #include <linux/user_namespace.h>
+#include <linux/fs_struct.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -139,12 +140,25 @@ static inline const char *get_task_state
 	return task_state_array[fls(state)];
 }
 
+static inline int get_task_umask(struct task_struct *tsk)
+{
+	struct fs_struct *fs;
+	int umask = -ENOENT;
+
+	task_lock(tsk);
+	fs = tsk->fs;
+	if (fs)
+		umask = fs->umask;
+	task_unlock(tsk);
+	return umask;
+}
+
 static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *p)
 {
 	struct user_namespace *user_ns = seq_user_ns(m);
 	struct group_info *group_info;
-	int g;
+	int g, umask;
 	struct task_struct *tracer;
 	const struct cred *cred;
 	pid_t ppid, tpid = 0, tgid, ngid;
@@ -162,6 +176,10 @@ static inline void task_state(struct seq
 	ngid = task_numa_group_id(p);
 	cred = get_task_cred(p);
 
+	umask = get_task_umask(p);
+	if (umask >= 0)
+		seq_printf(m, "Umask:\t%#04o\n", umask);
+
 	task_lock(p);
 	if (p->files)
 		max_fds = files_fdtable(p->files)->max_fds;
_
