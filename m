From: akpm@linux-foundation.org
Subject: + c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch added to -mm tree
Date: Thu, 19 Apr 2012 11:52:21 -0700
Message-ID: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64358 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2DSSwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Apr 2012 14:52:24 -0400
Received: by eaaq10 with SMTP id q10so426624eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Apr 2012 11:52:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, gorcunov@openvz.org, keescook@chromium.org, kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, oleg@redhat.com, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file_vmas removal
has been added to the -mm tree.  Its filename is
     c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file_vmas removal

[ fix for "c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2" from mm tree ]

After removing mm->num_exe_file_vmas kernel keeps mm->exe_file until final
mmput(), it never becomes NULL while task is alive.

We can check for other mapped files in mm instead of checking
mm->num_exe_file_vmas, and mark mm with flag MMF_EXE_FILE_CHANGED in order
to forbid second changing of mm->exe_file.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 kernel/sys.c          |   31 +++++++++++++++++++------------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff -puN include/linux/sched.h~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal include/linux/sched.h
--- a/include/linux/sched.h~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal
+++ a/include/linux/sched.h
@@ -437,6 +437,7 @@ extern int get_dumpable(struct mm_struct
 					/* leave room for more dump flags */
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
 #define MMF_VM_HUGEPAGE		17	/* set when VM_HUGEPAGE is set on vma */
+#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
diff -puN kernel/sys.c~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal
+++ a/kernel/sys.c
@@ -1714,17 +1714,11 @@ static bool vma_flags_mismatch(struct vm
 
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
+	struct vm_area_struct *vma;
 	struct file *exe_file;
 	struct dentry *dentry;
 	int err;
 
-	/*
-	 * Setting new mm::exe_file is only allowed when no VM_EXECUTABLE vma's
-	 * remain. So perform a quick test first.
-	 */
-	if (mm->num_exe_file_vmas)
-		return -EBUSY;
-
 	exe_file = fget(fd);
 	if (!exe_file)
 		return -EBADF;
@@ -1745,17 +1739,30 @@ static int prctl_set_mm_exe_file(struct 
 	if (err)
 		goto exit;
 
+	down_write(&mm->mmap_sem);
+
+	/*
+	 * Forbid mm->exe_file change if there are mapped other files.
+	 */
+	err = -EBUSY;
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (vma->vm_file && !path_equal(&vma->vm_file->f_path,
+						&exe_file->f_path))
+			goto exit_unlock;
+	}
+
 	/*
 	 * The symlink can be changed only once, just to disallow arbitrary
 	 * transitions malicious software might bring in. This means one
 	 * could make a snapshot over all processes running and monitor
 	 * /proc/pid/exe changes to notice unusual activity if needed.
 	 */
-	down_write(&mm->mmap_sem);
-	if (likely(!mm->exe_file))
-		set_mm_exe_file(mm, exe_file);
-	else
-		err = -EBUSY;
+	err = -EPERM;
+	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags))
+		goto exit_unlock;
+
+	set_mm_exe_file(mm, exe_file);
+exit_unlock:
 	up_write(&mm->mmap_sem);
 
 exit:
_
Subject: Subject: c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file_vmas removal

Patches currently in -mm which might be from khlebnikov@openvz.org are

mm-hugetlb-fix-warning-in-alloc_huge_page-dequeue_huge_page_vma.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

