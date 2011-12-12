From: akpm@linux-foundation.org
Subject: + c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch added to -mm tree
Date: Mon, 12 Dec 2011 13:53:57 -0800
Message-ID: <201112122153.pBCLrwSY006155@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:64512 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab1LLVyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2011 16:54:03 -0500
Received: by eekc1 with SMTP id c1so16287eek.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2011 13:54:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, avagin@openvz.org, ebiederm@xmission.com, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org


The patch titled
     Subject: c/r: procfs: add start_data, end_data, start_brk members to /proc/$pid/stat v4
has been added to the -mm tree.  Its filename is
     c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: procfs: add start_data, end_data, start_brk members to /proc/$pid/stat v4

The mm->start_code/end_code, mm->start_data/end_data, mm->start_brk are
involved into calculation of program text/data segment sizes (which might
be seen in /proc/<pid>/statm) and into brk() call final address.

For restore we need to know all these values.  While
mm->start_code/end_code already present in /proc/$pid/stat, the rest
members are not, so this patch brings them in.

The restore procedure of these members is addressed in another patch using
prctl().

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 +++
 fs/proc/array.c                    |    7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4
+++ a/Documentation/filesystems/proc.txt
@@ -307,6 +307,9 @@ Table 1-4: Contents of the stat files (a
   blkio_ticks   time spent waiting for block IO
   gtime         guest time of the task in jiffies
   cgtime        guest time of the task children in jiffies
+  start_data    address above which program data+bss is placed
+  end_data      address below which program data+bss is placed
+  start_brk     address above which program heap can be expaned with brk() call
 ..............................................................................
 
 The /proc/PID/maps file containing the currently mapped memory regions and
diff -puN fs/proc/array.c~c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4 fs/proc/array.c
--- a/fs/proc/array.c~c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4
+++ a/fs/proc/array.c
@@ -464,7 +464,7 @@ static int do_task_stat(struct seq_file 
 
 	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
+%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
 		pid_nr_ns(pid, ns),
 		tcomm,
 		state,
@@ -511,7 +511,10 @@ static int do_task_stat(struct seq_file 
 		task->policy,
 		(unsigned long long)delayacct_blkio_ticks(task),
 		cputime_to_clock_t(gtime),
-		cputime_to_clock_t(cgtime));
+		cputime_to_clock_t(cgtime),
+		(mm && permitted) ? mm->start_data : 0,
+		(mm && permitted) ? mm->end_data : 0,
+		(mm && permitted) ? mm->start_brk : 0);
 	if (mm)
 		mmput(mm);
 	return 0;
_
Subject: Subject: c/r: procfs: add start_data, end_data, start_brk members to /proc/$pid/stat v4

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
sysctl-add-the-kernelns_last_pid-control.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

