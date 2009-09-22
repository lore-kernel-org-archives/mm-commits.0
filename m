From: akpm@linux-foundation.org
Subject: [merged] ksm-distribute-remove_mm_from_lists.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:03 -0700
Message-ID: <200909222040.n8MKe3Wq004758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbZIVUkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:40:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: distribute remove_mm_from_lists
has been removed from the -mm tree.  Its filename was
     ksm-distribute-remove_mm_from_lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: distribute remove_mm_from_lists
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Do some housekeeping in ksm.c, to help make the next patch easier
to understand: remove the function remove_mm_from_lists, distributing
its code to its callsites scan_get_next_rmap_item and __ksm_exit.

That turns out to be a win in scan_get_next_rmap_item: move its
remove_trailing_rmap_items and cursor advancement up, and it becomes
simpler than before.  __ksm_exit becomes messier, but will change
again; and moving its remove_trailing_rmap_items up lets us strengthen
the unstable tree item's age condition in remove_rmap_item_from_tree.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   97 ++++++++++++++++++++++-------------------------------
 1 file changed, 42 insertions(+), 55 deletions(-)

diff -puN mm/ksm.c~ksm-distribute-remove_mm_from_lists mm/ksm.c
--- a/mm/ksm.c~ksm-distribute-remove_mm_from_lists
+++ a/mm/ksm.c
@@ -444,14 +444,9 @@ static void remove_rmap_item_from_tree(s
 		 * But __ksm_exit has to be careful: do the rb_erase
 		 * if it's interrupting a scan, and this rmap_item was
 		 * inserted by this scan rather than left from before.
-		 *
-		 * Because of the case in which remove_mm_from_lists
-		 * increments seqnr before removing rmaps, unstable_nr
-		 * may even be 2 behind seqnr, but should never be
-		 * further behind.  Yes, I did have trouble with this!
 		 */
 		age = (unsigned char)(ksm_scan.seqnr - rmap_item->address);
-		BUG_ON(age > 2);
+		BUG_ON(age > 1);
 		if (!age)
 			rb_erase(&rmap_item->node, &root_unstable_tree);
 		ksm_pages_unshared--;
@@ -546,37 +541,6 @@ out:
 	return err;
 }
 
-static void remove_mm_from_lists(struct mm_struct *mm)
-{
-	struct mm_slot *mm_slot;
-
-	spin_lock(&ksm_mmlist_lock);
-	mm_slot = get_mm_slot(mm);
-
-	/*
-	 * This mm_slot is always at the scanning cursor when we're
-	 * called from scan_get_next_rmap_item; but it's a special
-	 * case when we're called from __ksm_exit.
-	 */
-	if (ksm_scan.mm_slot == mm_slot) {
-		ksm_scan.mm_slot = list_entry(
-			mm_slot->mm_list.next, struct mm_slot, mm_list);
-		ksm_scan.address = 0;
-		ksm_scan.rmap_item = list_entry(
-			&ksm_scan.mm_slot->rmap_list, struct rmap_item, link);
-		if (ksm_scan.mm_slot == &ksm_mm_head)
-			ksm_scan.seqnr++;
-	}
-
-	hlist_del(&mm_slot->link);
-	list_del(&mm_slot->mm_list);
-	spin_unlock(&ksm_mmlist_lock);
-
-	remove_trailing_rmap_items(mm_slot, mm_slot->rmap_list.next);
-	free_mm_slot(mm_slot);
-	clear_bit(MMF_VM_MERGEABLE, &mm->flags);
-}
-
 static u32 calc_checksum(struct page *page)
 {
 	u32 checksum;
@@ -1241,33 +1205,31 @@ next_mm:
 		}
 	}
 
-	if (!ksm_scan.address) {
-		/*
-		 * We've completed a full scan of all vmas, holding mmap_sem
-		 * throughout, and found no VM_MERGEABLE: so do the same as
-		 * __ksm_exit does to remove this mm from all our lists now.
-		 */
-		remove_mm_from_lists(mm);
-		up_read(&mm->mmap_sem);
-		slot = ksm_scan.mm_slot;
-		if (slot != &ksm_mm_head)
-			goto next_mm;
-		return NULL;
-	}
-
 	/*
 	 * Nuke all the rmap_items that are above this current rmap:
 	 * because there were no VM_MERGEABLE vmas with such addresses.
 	 */
 	remove_trailing_rmap_items(slot, ksm_scan.rmap_item->link.next);
-	up_read(&mm->mmap_sem);
 
 	spin_lock(&ksm_mmlist_lock);
-	slot = list_entry(slot->mm_list.next, struct mm_slot, mm_list);
-	ksm_scan.mm_slot = slot;
+	ksm_scan.mm_slot = list_entry(slot->mm_list.next,
+						struct mm_slot, mm_list);
+	if (ksm_scan.address == 0) {
+		/*
+		 * We've completed a full scan of all vmas, holding mmap_sem
+		 * throughout, and found no VM_MERGEABLE: so do the same as
+		 * __ksm_exit does to remove this mm from all our lists now.
+		 */
+		hlist_del(&slot->link);
+		list_del(&slot->mm_list);
+		free_mm_slot(slot);
+		clear_bit(MMF_VM_MERGEABLE, &mm->flags);
+	}
 	spin_unlock(&ksm_mmlist_lock);
+	up_read(&mm->mmap_sem);
 
 	/* Repeat until we've completed scanning the whole list */
+	slot = ksm_scan.mm_slot;
 	if (slot != &ksm_mm_head)
 		goto next_mm;
 
@@ -1408,13 +1370,38 @@ int __ksm_enter(struct mm_struct *mm)
 
 void __ksm_exit(struct mm_struct *mm)
 {
+	struct mm_slot *mm_slot;
+
 	/*
 	 * This process is exiting: doesn't hold and doesn't need mmap_sem;
 	 * but we do need to exclude ksmd and other exiters while we modify
 	 * the various lists and trees.
 	 */
 	mutex_lock(&ksm_thread_mutex);
-	remove_mm_from_lists(mm);
+	spin_lock(&ksm_mmlist_lock);
+	mm_slot = get_mm_slot(mm);
+	if (!list_empty(&mm_slot->rmap_list)) {
+		spin_unlock(&ksm_mmlist_lock);
+		remove_trailing_rmap_items(mm_slot, mm_slot->rmap_list.next);
+		spin_lock(&ksm_mmlist_lock);
+	}
+
+	if (ksm_scan.mm_slot == mm_slot) {
+		ksm_scan.mm_slot = list_entry(
+			mm_slot->mm_list.next, struct mm_slot, mm_list);
+		ksm_scan.address = 0;
+		ksm_scan.rmap_item = list_entry(
+			&ksm_scan.mm_slot->rmap_list, struct rmap_item, link);
+		if (ksm_scan.mm_slot == &ksm_mm_head)
+			ksm_scan.seqnr++;
+	}
+
+	hlist_del(&mm_slot->link);
+	list_del(&mm_slot->mm_list);
+	spin_unlock(&ksm_mmlist_lock);
+
+	free_mm_slot(mm_slot);
+	clear_bit(MMF_VM_MERGEABLE, &mm->flags);
 	mutex_unlock(&ksm_thread_mutex);
 }
 
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

