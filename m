From: akpm@linux-foundation.org
Subject: [merged] c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:35:27 -0700
Message-ID: <20120601193527.8710EA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:52866 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933410Ab2FATf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:35:28 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so288149yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:35:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, avagin@openvz.org, ebiederm@xmission.com, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: procfs: add arg_start/end, env_start/end and exit_code members to /proc/$pid/stat
has been removed from the -mm tree.  Its filename was
     c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -517,9 +517,23 @@ static int do_task_stat(struct seq_file 
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

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

