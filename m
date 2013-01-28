From: akpm@linux-foundation.org
Subject: + ksm-remove-old-stable-nodes-more-thoroughly.patch added to -mm tree
Date: Mon, 28 Jan 2013 15:50:46 -0800
Message-ID: <20130128235047.564395A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:56204 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab3A1Xut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 18:50:49 -0500
Received: by mail-ie0-f201.google.com with SMTP id c14so129573ieb.0
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 15:50:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, gerald.schaefer@de.ibm.com, izik.eidus@ravellosystems.com, kosaki.motohiro@gmail.com, pholasek@redhat.com, riel@redhat.com


The patch titled
     Subject: ksm: remove old stable nodes more thoroughly
has been added to the -mm tree.  Its filename is
     ksm-remove-old-stable-nodes-more-thoroughly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: remove old stable nodes more thoroughly

Switching merge_across_nodes after running KSM is liable to oops on stale
nodes still left over from the previous stable tree.  It's not something
that people will often want to do, but it would be lame to demand a reboot
when they're trying to determine which merge_across_nodes setting is best.

How can this happen?  We only permit switching merge_across_nodes when
pages_shared is 0, and usually set run 2 to force that beforehand, which
ought to unmerge everything: yet oopses still occur when you then run 1.

Three causes:

1. The old stable tree (built according to the inverse
   merge_across_nodes) has not been fully torn down.  A stable node
   lingers until get_ksm_page() notices that the page it references no
   longer references it: but the page is not necessarily freed as soon as
   expected, particularly when swapcache.

   Fix this with a pass through the old stable tree, applying
   get_ksm_page() to each of the remaining nodes (most found stale and
   removed immediately), with forced removal of any left over.  Unless the
   page is still mapped: I've not seen that case, it shouldn't occur, but
   better to WARN_ON_ONCE and EBUSY than BUG.

2. __ksm_enter() has a nice little optimization, to insert the new mm
   just behind ksmd's cursor, so there's a full pass for it to stabilize
   (or be removed) before ksmd addresses it.  Nice when ksmd is running,
   but not so nice when we're trying to unmerge all mms: we were missing
   those mms forked and inserted behind the unmerge cursor.  Easily fixed
   by inserting at the end when KSM_RUN_UNMERGE.

3.  It is possible for a KSM page to be faulted back from swapcache
   into an mm, just after unmerge_and_remove_all_rmap_items() scanned past
   it.  Fix this by copying on fault when KSM_RUN_UNMERGE: but that is
   private to ksm.c, so dissolve the distinction between
   ksm_might_need_to_copy() and ksm_does_need_to_copy(), doing it all in
   the one call into ksm.c.

A long outstanding, unrelated bugfix sneaks in with that third fix:
ksm_does_need_to_copy() would copy from a !PageUptodate page (implying I/O
error when read in from swap) to a page which it then marks Uptodate.  Fix
this case by not copying, letting do_swap_page() discover the error.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |   18 ++-------
 mm/ksm.c            |   83 +++++++++++++++++++++++++++++++++++++++---
 mm/memory.c         |   19 ++++-----
 3 files changed, 92 insertions(+), 28 deletions(-)

diff -puN include/linux/ksm.h~ksm-remove-old-stable-nodes-more-thoroughly include/linux/ksm.h
--- a/include/linux/ksm.h~ksm-remove-old-stable-nodes-more-thoroughly
+++ a/include/linux/ksm.h
@@ -16,9 +16,6 @@
 struct stable_node;
 struct mem_cgroup;
 
-struct page *ksm_does_need_to_copy(struct page *page,
-			struct vm_area_struct *vma, unsigned long address);
-
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, unsigned long *vm_flags);
@@ -73,15 +70,8 @@ static inline void set_page_stable_node(
  * We'd like to make this conditional on vma->vm_flags & VM_MERGEABLE,
  * but what if the vma was unmerged while the page was swapped out?
  */
-static inline int ksm_might_need_to_copy(struct page *page,
-			struct vm_area_struct *vma, unsigned long address)
-{
-	struct anon_vma *anon_vma = page_anon_vma(page);
-
-	return anon_vma &&
-		(anon_vma->root != vma->anon_vma->root ||
-		 page->index != linear_page_index(vma, address));
-}
+struct page *ksm_might_need_to_copy(struct page *page,
+			struct vm_area_struct *vma, unsigned long address);
 
 int page_referenced_ksm(struct page *page,
 			struct mem_cgroup *memcg, unsigned long *vm_flags);
@@ -113,10 +103,10 @@ static inline int ksm_madvise(struct vm_
 	return 0;
 }
 
-static inline int ksm_might_need_to_copy(struct page *page,
+static inline struct page *ksm_might_need_to_copy(struct page *page,
 			struct vm_area_struct *vma, unsigned long address)
 {
-	return 0;
+	return page;
 }
 
 static inline int page_referenced_ksm(struct page *page,
diff -puN mm/ksm.c~ksm-remove-old-stable-nodes-more-thoroughly mm/ksm.c
--- a/mm/ksm.c~ksm-remove-old-stable-nodes-more-thoroughly
+++ a/mm/ksm.c
@@ -644,6 +644,57 @@ static int unmerge_ksm_pages(struct vm_a
 /*
  * Only called through the sysfs control interface:
  */
+static int remove_stable_node(struct stable_node *stable_node)
+{
+	struct page *page;
+	int err;
+
+	page = get_ksm_page(stable_node, true);
+	if (!page) {
+		/*
+		 * get_ksm_page did remove_node_from_stable_tree itself.
+		 */
+		return 0;
+	}
+
+	if (WARN_ON_ONCE(page_mapped(page)))
+		err = -EBUSY;
+	else {
+		/*
+		 * This page might be in a pagevec waiting to be freed,
+		 * or it might be PageSwapCache (perhaps under writeback),
+		 * or it might have been removed from swapcache a moment ago.
+		 */
+		set_page_stable_node(page, NULL);
+		remove_node_from_stable_tree(stable_node);
+		err = 0;
+	}
+
+	unlock_page(page);
+	put_page(page);
+	return err;
+}
+
+static int remove_all_stable_nodes(void)
+{
+	struct stable_node *stable_node;
+	int nid;
+	int err = 0;
+
+	for (nid = 0; nid < nr_node_ids; nid++) {
+		while (root_stable_tree[nid].rb_node) {
+			stable_node = rb_entry(root_stable_tree[nid].rb_node,
+						struct stable_node, node);
+			if (remove_stable_node(stable_node)) {
+				err = -EBUSY;
+				break;	/* proceed to next nid */
+			}
+			cond_resched();
+		}
+	}
+	return err;
+}
+
 static int unmerge_and_remove_all_rmap_items(void)
 {
 	struct mm_slot *mm_slot;
@@ -691,6 +742,8 @@ static int unmerge_and_remove_all_rmap_i
 		}
 	}
 
+	/* Clean up stable nodes, but don't worry if some are still busy */
+	remove_all_stable_nodes();
 	ksm_scan.seqnr = 0;
 	return 0;
 
@@ -1586,11 +1639,19 @@ int __ksm_enter(struct mm_struct *mm)
 	spin_lock(&ksm_mmlist_lock);
 	insert_to_mm_slots_hash(mm, mm_slot);
 	/*
-	 * Insert just behind the scanning cursor, to let the area settle
+	 * When KSM_RUN_MERGE (or KSM_RUN_STOP),
+	 * insert just behind the scanning cursor, to let the area settle
 	 * down a little; when fork is followed by immediate exec, we don't
 	 * want ksmd to waste time setting up and tearing down an rmap_list.
+	 *
+	 * But when KSM_RUN_UNMERGE, it's important to insert ahead of its
+	 * scanning cursor, otherwise KSM pages in newly forked mms will be
+	 * missed: then we might as well insert at the end of the list.
 	 */
-	list_add_tail(&mm_slot->mm_list, &ksm_scan.mm_slot->mm_list);
+	if (ksm_run & KSM_RUN_UNMERGE)
+		list_add_tail(&mm_slot->mm_list, &ksm_mm_head.mm_list);
+	else
+		list_add_tail(&mm_slot->mm_list, &ksm_scan.mm_slot->mm_list);
 	spin_unlock(&ksm_mmlist_lock);
 
 	set_bit(MMF_VM_MERGEABLE, &mm->flags);
@@ -1640,11 +1701,25 @@ void __ksm_exit(struct mm_struct *mm)
 	}
 }
 
-struct page *ksm_does_need_to_copy(struct page *page,
+struct page *ksm_might_need_to_copy(struct page *page,
 			struct vm_area_struct *vma, unsigned long address)
 {
+	struct anon_vma *anon_vma = page_anon_vma(page);
 	struct page *new_page;
 
+	if (PageKsm(page)) {
+		if (page_stable_node(page) &&
+		    !(ksm_run & KSM_RUN_UNMERGE))
+			return page;	/* no need to copy it */
+	} else if (!anon_vma) {
+		return page;		/* no need to copy it */
+	} else if (anon_vma->root == vma->anon_vma->root &&
+		 page->index == linear_page_index(vma, address)) {
+		return page;		/* still no need to copy it */
+	}
+	if (!PageUptodate(page))
+		return page;		/* let do_swap_page report the error */
+
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 	if (new_page) {
 		copy_user_highpage(new_page, page, address, vma);
@@ -2024,7 +2099,7 @@ static ssize_t merge_across_nodes_store(
 
 	mutex_lock(&ksm_thread_mutex);
 	if (ksm_merge_across_nodes != knob) {
-		if (ksm_pages_shared)
+		if (ksm_pages_shared || remove_all_stable_nodes())
 			err = -EBUSY;
 		else
 			ksm_merge_across_nodes = knob;
diff -puN mm/memory.c~ksm-remove-old-stable-nodes-more-thoroughly mm/memory.c
--- a/mm/memory.c~ksm-remove-old-stable-nodes-more-thoroughly
+++ a/mm/memory.c
@@ -2994,17 +2994,16 @@ static int do_swap_page(struct mm_struct
 	if (unlikely(!PageSwapCache(page) || page_private(page) != entry.val))
 		goto out_page;
 
-	if (ksm_might_need_to_copy(page, vma, address)) {
-		swapcache = page;
-		page = ksm_does_need_to_copy(page, vma, address);
-
-		if (unlikely(!page)) {
-			ret = VM_FAULT_OOM;
-			page = swapcache;
-			swapcache = NULL;
-			goto out_page;
-		}
+	swapcache = page;
+	page = ksm_might_need_to_copy(page, vma, address);
+	if (unlikely(!page)) {
+		ret = VM_FAULT_OOM;
+		page = swapcache;
+		swapcache = NULL;
+		goto out_page;
 	}
+	if (page == swapcache)
+		swapcache = NULL;
 
 	if (mem_cgroup_try_charge_swapin(mm, page, GFP_KERNEL, &ptr)) {
 		ret = VM_FAULT_OOM;
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix-fix.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
swap-add-per-partition-lock-for-swapfile.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
ksm-allow-trees-per-numa-node.patch
ksm-add-sysfs-abi-documentation.patch
ksm-trivial-tidyups.patch
ksm-reorganize-ksm_check_stable_tree.patch
ksm-get_ksm_page-locked.patch
ksm-remove-old-stable-nodes-more-thoroughly.patch
ksm-make-ksm-page-migration-possible.patch
ksm-make-merge_across_nodes-migration-safe.patch
ksm-enable-ksm-page-migration.patch
mm-remove-offlining-arg-to-migrate_pages.patch
ksm-stop-hotremove-lockdep-warning.patch
mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch

