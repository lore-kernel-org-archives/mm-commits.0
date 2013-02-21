From: akpm@linux-foundation.org
Subject: + mm-cleanup-swapcache-in-do_swap_page.patch added to -mm tree
Date: Thu, 21 Feb 2013 14:10:05 -0800
Message-ID: <20130221221006.4123C5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:62356 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab3BUWKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 17:10:07 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so3790qcr.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 14:10:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com


The patch titled
     Subject: mm: cleanup "swapcache" in do_swap_page
has been added to the -mm tree.  Its filename is
     mm-cleanup-swapcache-in-do_swap_page.patch

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
Subject: mm: cleanup "swapcache" in do_swap_page

I dislike the way in which "swapcache" gets used in do_swap_page(): there
is always a page from swapcache there (even if maybe uncached by the time
we lock it), but tests are made according to "swapcache".  Rework that
with "page != swapcache", as has been done in unuse_pte().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN mm/memory.c~mm-cleanup-swapcache-in-do_swap_page mm/memory.c
--- a/mm/memory.c~mm-cleanup-swapcache-in-do_swap_page
+++ a/mm/memory.c
@@ -2954,7 +2954,7 @@ static int do_swap_page(struct mm_struct
 		unsigned int flags, pte_t orig_pte)
 {
 	spinlock_t *ptl;
-	struct page *page, *swapcache = NULL;
+	struct page *page, *swapcache;
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
@@ -3005,9 +3005,11 @@ static int do_swap_page(struct mm_struct
 		 */
 		ret = VM_FAULT_HWPOISON;
 		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+		swapcache = page;
 		goto out_release;
 	}
 
+	swapcache = page;
 	locked = lock_page_or_retry(page, mm, flags);
 
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
@@ -3025,16 +3027,12 @@ static int do_swap_page(struct mm_struct
 	if (unlikely(!PageSwapCache(page) || page_private(page) != entry.val))
 		goto out_page;
 
-	swapcache = page;
 	page = ksm_might_need_to_copy(page, vma, address);
 	if (unlikely(!page)) {
 		ret = VM_FAULT_OOM;
 		page = swapcache;
-		swapcache = NULL;
 		goto out_page;
 	}
-	if (page == swapcache)
-		swapcache = NULL;
 
 	if (mem_cgroup_try_charge_swapin(mm, page, GFP_KERNEL, &ptr)) {
 		ret = VM_FAULT_OOM;
@@ -3078,10 +3076,10 @@ static int do_swap_page(struct mm_struct
 	}
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
-	if (swapcache) /* ksm created a completely new copy */
-		page_add_new_anon_rmap(page, vma, address);
-	else
+	if (page == swapcache)
 		do_page_add_anon_rmap(page, vma, address, exclusive);
+	else /* ksm created a completely new copy */
+		page_add_new_anon_rmap(page, vma, address);
 	/* It's better to call commit-charge after rmap is established */
 	mem_cgroup_commit_charge_swapin(page, ptr);
 
@@ -3089,7 +3087,7 @@ static int do_swap_page(struct mm_struct
 	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
 		try_to_free_swap(page);
 	unlock_page(page);
-	if (swapcache) {
+	if (page != swapcache) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
 		 * until we take the PT lock for the pte_same() check
@@ -3122,7 +3120,7 @@ out_page:
 	unlock_page(page);
 out_release:
 	page_cache_release(page);
-	if (swapcache) {
+	if (page != swapcache) {
 		unlock_page(swapcache);
 		page_cache_release(swapcache);
 	}
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
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
swap-make-each-swap-partition-have-one-address_space-fix-fix.patch
swap-add-per-partition-lock-for-swapfile.patch
swap-add-per-partition-lock-for-swapfile-fix-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
ksm-allow-trees-per-numa-node.patch
ksm-add-sysfs-abi-documentation.patch
ksm-trivial-tidyups.patch
ksm-trivial-tidyups-fix.patch
ksm-reorganize-ksm_check_stable_tree.patch
ksm-get_ksm_page-locked.patch
ksm-remove-old-stable-nodes-more-thoroughly.patch
ksm-make-ksm-page-migration-possible.patch
ksm-make-merge_across_nodes-migration-safe.patch
ksm-enable-ksm-page-migration.patch
mm-remove-offlining-arg-to-migrate_pages.patch
ksm-stop-hotremove-lockdep-warning.patch
mm-shmem-use-new-radix-tree-iterator.patch
mm-mlockc-document-scary-looking-stack-expansion-mlock-chain.patch
mmu_notifier_unregister-null-pointer-deref-and-multiple-release-callouts.patch
mm-use-up-free-swap-space-before-reaching-oom-kill.patch
memcg-stop-warning-on-memcg_propagate_kmem.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-accelerate-mm_populate-treatment-of-thp-pages.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
tmpfs-fix-use-after-free-of-mempolicy-object.patch
tmpfs-fix-mempolicy-object-leaks.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch
ksm-add-some-comments.patch
ksm-treat-unstable-nid-like-in-stable-tree.patch
ksm-shrink-32-bit-rmap_item-back-to-32-bytes.patch
mmksm-foll_migration-do-migration_entry_wait.patch
mmksm-swapoff-might-need-to-copy.patch
mm-cleanup-swapcache-in-do_swap_page.patch
ksm-allocate-roots-when-needed.patch

