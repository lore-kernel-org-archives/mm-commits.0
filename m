From: akpm@linux-foundation.org
Subject: + c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch added to -mm tree
Date: Tue, 14 Feb 2012 15:15:46 -0800
Message-ID: <20120214231546.2D2C1A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51454 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab2BNXWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 18:22:33 -0500
Received: by eaaf13 with SMTP id f13so13608eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 15:22:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, avagin@openvz.org, ebiederm@xmission.com, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: c/r: procfs: add arg_start/end, env_start/end and exit_code members to /proc/$pid/stat
has been added to the -mm tree.  Its filename is
     c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: procfs: add arg_start/end, env_start/end and exit_code members to /proc/$pid/stat

We would like to have an ability to restore command line arguments and
program environment pointers but first we need to obtain them somehow. 
Thus we put these values into /proc/$pid/stat.  The exit_code is needed to
restore zombie tasks.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    5 +++++
 fs/proc/array.c                    |   20 +++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/proc.txt~c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat
+++ a/Documentation/filesystems/proc.txt
@@ -311,6 +311,11 @@ Table 1-4: Contents of the stat files (a
   start_data    address above which program data+bss is placed
   end_data      address below which program data+bss is placed
   start_brk     address above which program heap can be expanded with brk()
+  arg_start     address above which program command line is placed
+  arg_end       address below which program command line is placed
+  env_start     address above which program environment is placed
+  env_end       address below which program environment is placed
+  exit_code     the thread's exit_code in the form reported by the waitpid system call
 ..............................................................................
 
 The /proc/PID/maps file containing the currently mapped memory regions and
diff -puN fs/proc/array.c~c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat fs/proc/array.c
--- a/fs/proc/array.c~c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat
+++ a/fs/proc/array.c
@@ -508,9 +508,23 @@ static int do_task_stat(struct seq_file 
 	seq_put_decimal_ull(m, ' ', delayacct_blkio_ticks(task));
 	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(gtime));
 	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cgtime));
-	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->start_data : 0);
-	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->end_data : 0);
-	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->start_brk : 0);
+
+	if (mm && permitted) {
+		seq_put_decimal_ull(m, ' ', mm->start_data);
+		seq_put_decimal_ull(m, ' ', mm->end_data);
+		seq_put_decimal_ull(m, ' ', mm->start_brk);
+		seq_put_decimal_ull(m, ' ', mm->arg_start);
+		seq_put_decimal_ull(m, ' ', mm->arg_end);
+		seq_put_decimal_ull(m, ' ', mm->env_start);
+		seq_put_decimal_ull(m, ' ', mm->env_end);
+	} else
+		seq_printf(m, " 0 0 0 0 0 0 0");
+
+	if (permitted)
+		seq_put_decimal_ll(m, ' ', task->exit_code);
+	else
+		seq_put_decimal_ll(m, ' ', 0);
+
 	seq_putc(m, '\n');
 	if (mm)
 		mmput(mm);
_
Subject: Subject: c/r: procfs: add arg_start/end, env_start/end and exit_code members to /proc/$pid/stat

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

