From: akpm@linux-foundation.org
Subject: - proc-seqfile-convert-proc_pid_statm.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:02 -0800
Message-ID: <200802082011.m18KBhMq010140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52105 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbYBHVAy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:00:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@gmail.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     seqfile convert proc_pid_statm
has been removed from the -mm tree.  Its filename was
     proc-seqfile-convert-proc_pid_statm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seqfile convert proc_pid_statm
From: Eric W. Biederman <ebiederm@xmission.com>

This conversion is just for code cleanliness, uniformity, and general safety.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c    |    8 +++++---
 fs/proc/base.c     |    4 ++--
 fs/proc/internal.h |    3 ++-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/proc/array.c~proc-seqfile-convert-proc_pid_statm fs/proc/array.c
--- a/fs/proc/array.c~proc-seqfile-convert-proc_pid_statm
+++ a/fs/proc/array.c
@@ -563,7 +563,8 @@ int proc_tgid_stat(struct seq_file *m, s
 	return do_task_stat(m, ns, pid, task, 1);
 }
 
-int proc_pid_statm(struct task_struct *task, char *buffer)
+int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
 {
 	int size = 0, resident = 0, shared = 0, text = 0, lib = 0, data = 0;
 	struct mm_struct *mm = get_task_mm(task);
@@ -572,7 +573,8 @@ int proc_pid_statm(struct task_struct *t
 		size = task_statm(mm, &shared, &text, &data, &resident);
 		mmput(mm);
 	}
+	seq_printf(m, "%d %d %d %d %d %d %d\n",
+			size, resident, shared, text, lib, data, 0);
 
-	return sprintf(buffer, "%d %d %d %d %d %d %d\n",
-		       size, resident, shared, text, lib, data, 0);
+	return 0;
 }
diff -puN fs/proc/base.c~proc-seqfile-convert-proc_pid_statm fs/proc/base.c
--- a/fs/proc/base.c~proc-seqfile-convert-proc_pid_statm
+++ a/fs/proc/base.c
@@ -2281,7 +2281,7 @@ static const struct pid_entry tgid_base_
 #endif
 	INF("cmdline",    S_IRUGO, pid_cmdline),
 	ONE("stat",       S_IRUGO, tgid_stat),
-	INF("statm",      S_IRUGO, pid_statm),
+	ONE("statm",      S_IRUGO, pid_statm),
 	REG("maps",       S_IRUGO, maps),
 #ifdef CONFIG_NUMA
 	REG("numa_maps",  S_IRUGO, numa_maps),
@@ -2612,7 +2612,7 @@ static const struct pid_entry tid_base_s
 #endif
 	INF("cmdline",   S_IRUGO, pid_cmdline),
 	ONE("stat",      S_IRUGO, tid_stat),
-	INF("statm",     S_IRUGO, pid_statm),
+	ONE("statm",     S_IRUGO, pid_statm),
 	REG("maps",      S_IRUGO, maps),
 #ifdef CONFIG_NUMA
 	REG("numa_maps", S_IRUGO, numa_maps),
diff -puN fs/proc/internal.h~proc-seqfile-convert-proc_pid_statm fs/proc/internal.h
--- a/fs/proc/internal.h~proc-seqfile-convert-proc_pid_statm
+++ a/fs/proc/internal.h
@@ -54,7 +54,8 @@ extern int proc_tid_stat(struct seq_file
 extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
 extern int proc_pid_status(struct task_struct *, char *);
-extern int proc_pid_statm(struct task_struct *, char *);
+extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task);
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
 
 extern const struct file_operations proc_maps_operations;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-x86.patch
deprecate-find_task_by_pid-kgdb.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
