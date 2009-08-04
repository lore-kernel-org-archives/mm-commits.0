From: akpm@linux-foundation.org
Subject: + ksm-distribute-remove_mm_from_lists.patch added to -mm tree
Date: Tue, 04 Aug 2009 15:01:15 -0700
Message-ID: <200908042201.n74M1GlJ013756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932508AbZHDWPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 18:15:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com


The patch titled
     ksm: distribute remove_mm_from_lists
has been added to the -mm tree.  Its filename is
     ksm-distribute-remove_mm_from_lists.patch

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
@@ -1248,33 +1212,31 @@ next_mm:
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
 
@@ -1415,13 +1377,38 @@ int __ksm_enter(struct mm_struct *mm)
 
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

acpi-fix-null-bug-for-hid-uid-string.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

