From: akpm@linux-foundation.org
Subject: [merged] ksm-fix-endless-loop-on-oom.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:00 -0700
Message-ID: <200909222040.n8MKe0G4004628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbZIVUkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: fix endless loop on oom
has been removed from the -mm tree.  Its filename was
     ksm-fix-endless-loop-on-oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: fix endless loop on oom
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

break_ksm has been looping endlessly ignoring VM_FAULT_OOM: that should
only be a problem for ksmd when a memory control group imposes limits
(normally the OOM killer will kill others with an mm until it succeeds);
but in general (especially for MADV_UNMERGEABLE and KSM_RUN_UNMERGE) we
do need to route the error (or kill) back to the caller (or sighandling).

Test signal_pending in unmerge_ksm_pages, which could be a lengthy
procedure if it has to spill into swap: returning -ERESTARTSYS so that
trivial signals will restart but fatals will terminate (is that right?
we do different things in different places in mm, none exactly this).

unmerge_and_remove_all_rmap_items was forgetting to lock when going
down the mm_list: fix that.  Whether it's successful or not, reset
ksm_scan cursor to head; but only if it's successful, reset seqnr
(shown in full_scans) - page counts will have gone down to zero.

This patch leaves a significant OOM deadlock, but it's a good step
on the way, and that deadlock is fixed in a subsequent patch.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |  108 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 85 insertions(+), 23 deletions(-)

diff -puN mm/ksm.c~ksm-fix-endless-loop-on-oom mm/ksm.c
--- a/mm/ksm.c~ksm-fix-endless-loop-on-oom
+++ a/mm/ksm.c
@@ -294,10 +294,10 @@ static inline int in_stable_tree(struct 
  * Could a ksm page appear anywhere else?  Actually yes, in a VM_PFNMAP
  * mmap of /dev/mem or /dev/kmem, where we would not want to touch it.
  */
-static void break_ksm(struct vm_area_struct *vma, unsigned long addr)
+static int break_ksm(struct vm_area_struct *vma, unsigned long addr)
 {
 	struct page *page;
-	int ret;
+	int ret = 0;
 
 	do {
 		cond_resched();
@@ -310,9 +310,36 @@ static void break_ksm(struct vm_area_str
 		else
 			ret = VM_FAULT_WRITE;
 		put_page(page);
-	} while (!(ret & (VM_FAULT_WRITE | VM_FAULT_SIGBUS)));
-
-	/* Which leaves us looping there if VM_FAULT_OOM: hmmm... */
+	} while (!(ret & (VM_FAULT_WRITE | VM_FAULT_SIGBUS | VM_FAULT_OOM)));
+	/*
+	 * We must loop because handle_mm_fault() may back out if there's
+	 * any difficulty e.g. if pte accessed bit gets updated concurrently.
+	 *
+	 * VM_FAULT_WRITE is what we have been hoping for: it indicates that
+	 * COW has been broken, even if the vma does not permit VM_WRITE;
+	 * but note that a concurrent fault might break PageKsm for us.
+	 *
+	 * VM_FAULT_SIGBUS could occur if we race with truncation of the
+	 * backing file, which also invalidates anonymous pages: that's
+	 * okay, that truncation will have unmapped the PageKsm for us.
+	 *
+	 * VM_FAULT_OOM: at the time of writing (late July 2009), setting
+	 * aside mem_cgroup limits, VM_FAULT_OOM would only be set if the
+	 * current task has TIF_MEMDIE set, and will be OOM killed on return
+	 * to user; and ksmd, having no mm, would never be chosen for that.
+	 *
+	 * But if the mm is in a limited mem_cgroup, then the fault may fail
+	 * with VM_FAULT_OOM even if the current task is not TIF_MEMDIE; and
+	 * even ksmd can fail in this way - though it's usually breaking ksm
+	 * just to undo a merge it made a moment before, so unlikely to oom.
+	 *
+	 * That's a pity: we might therefore have more kernel pages allocated
+	 * than we're counting as nodes in the stable tree; but ksm_do_scan
+	 * will retry to break_cow on each pass, so should recover the page
+	 * in due course.  The important thing is to not let VM_MERGEABLE
+	 * be cleared while any such pages might remain in the area.
+	 */
+	return (ret & VM_FAULT_OOM) ? -ENOMEM : 0;
 }
 
 static void break_cow(struct mm_struct *mm, unsigned long addr)
@@ -462,39 +489,61 @@ static void remove_trailing_rmap_items(s
  * to the next pass of ksmd - consider, for example, how ksmd might be
  * in cmp_and_merge_page on one of the rmap_items we would be removing.
  */
-static void unmerge_ksm_pages(struct vm_area_struct *vma,
-			      unsigned long start, unsigned long end)
+static int unmerge_ksm_pages(struct vm_area_struct *vma,
+			     unsigned long start, unsigned long end)
 {
 	unsigned long addr;
+	int err = 0;
 
-	for (addr = start; addr < end; addr += PAGE_SIZE)
-		break_ksm(vma, addr);
+	for (addr = start; addr < end && !err; addr += PAGE_SIZE) {
+		if (signal_pending(current))
+			err = -ERESTARTSYS;
+		else
+			err = break_ksm(vma, addr);
+	}
+	return err;
 }
 
-static void unmerge_and_remove_all_rmap_items(void)
+static int unmerge_and_remove_all_rmap_items(void)
 {
 	struct mm_slot *mm_slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
+	int err = 0;
+
+	spin_lock(&ksm_mmlist_lock);
+	mm_slot = list_entry(ksm_mm_head.mm_list.next,
+						struct mm_slot, mm_list);
+	spin_unlock(&ksm_mmlist_lock);
 
-	list_for_each_entry(mm_slot, &ksm_mm_head.mm_list, mm_list) {
+	while (mm_slot != &ksm_mm_head) {
 		mm = mm_slot->mm;
 		down_read(&mm->mmap_sem);
 		for (vma = mm->mmap; vma; vma = vma->vm_next) {
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
-			unmerge_ksm_pages(vma, vma->vm_start, vma->vm_end);
+			err = unmerge_ksm_pages(vma,
+						vma->vm_start, vma->vm_end);
+			if (err) {
+				up_read(&mm->mmap_sem);
+				goto out;
+			}
 		}
 		remove_trailing_rmap_items(mm_slot, mm_slot->rmap_list.next);
 		up_read(&mm->mmap_sem);
+
+		spin_lock(&ksm_mmlist_lock);
+		mm_slot = list_entry(mm_slot->mm_list.next,
+						struct mm_slot, mm_list);
+		spin_unlock(&ksm_mmlist_lock);
 	}
 
+	ksm_scan.seqnr = 0;
+out:
 	spin_lock(&ksm_mmlist_lock);
-	if (ksm_scan.mm_slot != &ksm_mm_head) {
-		ksm_scan.mm_slot = &ksm_mm_head;
-		ksm_scan.seqnr++;
-	}
+	ksm_scan.mm_slot = &ksm_mm_head;
 	spin_unlock(&ksm_mmlist_lock);
+	return err;
 }
 
 static void remove_mm_from_lists(struct mm_struct *mm)
@@ -1051,6 +1100,8 @@ static void cmp_and_merge_page(struct pa
 	/*
 	 * A ksm page might have got here by fork, but its other
 	 * references have already been removed from the stable tree.
+	 * Or it might be left over from a break_ksm which failed
+	 * when the mem_cgroup had reached its limit: try again now.
 	 */
 	if (PageKsm(page))
 		break_cow(rmap_item->mm, rmap_item->address);
@@ -1286,6 +1337,7 @@ int ksm_madvise(struct vm_area_struct *v
 		unsigned long end, int advice, unsigned long *vm_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	int err;
 
 	switch (advice) {
 	case MADV_MERGEABLE:
@@ -1298,9 +1350,11 @@ int ksm_madvise(struct vm_area_struct *v
 				 VM_MIXEDMAP  | VM_SAO))
 			return 0;		/* just ignore the advice */
 
-		if (!test_bit(MMF_VM_MERGEABLE, &mm->flags))
-			if (__ksm_enter(mm) < 0)
-				return -EAGAIN;
+		if (!test_bit(MMF_VM_MERGEABLE, &mm->flags)) {
+			err = __ksm_enter(mm);
+			if (err)
+				return err;
+		}
 
 		*vm_flags |= VM_MERGEABLE;
 		break;
@@ -1309,8 +1363,11 @@ int ksm_madvise(struct vm_area_struct *v
 		if (!(*vm_flags & VM_MERGEABLE))
 			return 0;		/* just ignore the advice */
 
-		if (vma->anon_vma)
-			unmerge_ksm_pages(vma, start, end);
+		if (vma->anon_vma) {
+			err = unmerge_ksm_pages(vma, start, end);
+			if (err)
+				return err;
+		}
 
 		*vm_flags &= ~VM_MERGEABLE;
 		break;
@@ -1441,8 +1498,13 @@ static ssize_t run_store(struct kobject 
 	mutex_lock(&ksm_thread_mutex);
 	if (ksm_run != flags) {
 		ksm_run = flags;
-		if (flags & KSM_RUN_UNMERGE)
-			unmerge_and_remove_all_rmap_items();
+		if (flags & KSM_RUN_UNMERGE) {
+			err = unmerge_and_remove_all_rmap_items();
+			if (err) {
+				ksm_run = KSM_RUN_STOP;
+				count = err;
+			}
+		}
 	}
 	mutex_unlock(&ksm_thread_mutex);
 
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

