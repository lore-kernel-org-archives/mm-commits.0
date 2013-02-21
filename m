From: akpm@linux-foundation.org
Subject: + mmksm-swapoff-might-need-to-copy.patch added to -mm tree
Date: Thu, 21 Feb 2013 14:10:03 -0800
Message-ID: <20130221221003.A84AD5A4253@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:61400 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab3BUWKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 17:10:04 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so3755yen.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 14:10:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com


The patch titled
     Subject: mm,ksm: swapoff might need to copy
has been added to the -mm tree.  Its filename is
     mmksm-swapoff-might-need-to-copy.patch

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
Subject: mm,ksm: swapoff might need to copy

Before establishing that KSM page migration was the cause of my
WARN_ON_ONCE(page_mapped(page))s, I suspected that they came from the lack
of a ksm_might_need_to_copy() in swapoff's unuse_pte() - which in many
respects is equivalent to faulting in a page.

In fact I've never caught that as the cause: but in theory it does at
least need the KSM_RUN_UNMERGE check in ksm_might_need_to_copy(), to avoid
bringing a KSM page back in when it's not supposed to be.

I intended to copy how it's done in do_swap_page(), but have a strong
aversion to how "swapcache" ends up being used there: rework it with "page
!= swapcache".

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~mmksm-swapoff-might-need-to-copy mm/swapfile.c
--- a/mm/swapfile.c~mmksm-swapoff-might-need-to-copy
+++ a/mm/swapfile.c
@@ -874,11 +874,17 @@ unsigned int count_swap_pages(int type, 
 static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, swp_entry_t entry, struct page *page)
 {
+	struct page *swapcache;
 	struct mem_cgroup *memcg;
 	spinlock_t *ptl;
 	pte_t *pte;
 	int ret = 1;
 
+	swapcache = page;
+	page = ksm_might_need_to_copy(page, vma, addr);
+	if (unlikely(!page))
+		return -ENOMEM;
+
 	if (mem_cgroup_try_charge_swapin(vma->vm_mm, page,
 					 GFP_KERNEL, &memcg)) {
 		ret = -ENOMEM;
@@ -897,7 +903,10 @@ static int unuse_pte(struct vm_area_stru
 	get_page(page);
 	set_pte_at(vma->vm_mm, addr, pte,
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
-	page_add_anon_rmap(page, vma, addr);
+	if (page == swapcache)
+		page_add_anon_rmap(page, vma, addr);
+	else /* ksm created a completely new copy */
+		page_add_new_anon_rmap(page, vma, addr);
 	mem_cgroup_commit_charge_swapin(page, memcg);
 	swap_free(entry);
 	/*
@@ -908,6 +917,10 @@ static int unuse_pte(struct vm_area_stru
 out:
 	pte_unmap_unlock(pte, ptl);
 out_nolock:
+	if (page != swapcache) {
+		unlock_page(page);
+		put_page(page);
+	}
 	return ret;
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

