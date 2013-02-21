From: akpm@linux-foundation.org
Subject: + mmksm-foll_migration-do-migration_entry_wait.patch added to -mm tree
Date: Thu, 21 Feb 2013 14:09:59 -0800
Message-ID: <20130221221000.438C231C1B7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:55346 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab3BUWKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 17:10:02 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so3691vch.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 14:10:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com


The patch titled
     Subject: mm,ksm: FOLL_MIGRATION do migration_entry_wait
has been added to the -mm tree.  Its filename is
     mmksm-foll_migration-do-migration_entry_wait.patch

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
Subject: mm,ksm: FOLL_MIGRATION do migration_entry_wait

In "ksm: remove old stable nodes more thoroughly" I said that I'd never
seen its WARN_ON_ONCE(page_mapped(page)).  True at the time of writing,
but it soon appeared once I tried fuller tests on the whole series.

It turned out to be due to the KSM page migration itself: unmerge_and_
remove_all_rmap_items() failed to locate and replace all the KSM pages,
because of that hiatus in page migration when old pte has been replaced by
migration entry, but not yet by new pte.  follow_page() finds no page at
that instant, but a KSM page reappears shortly after, without a fault.

Add FOLL_MIGRATION flag, so follow_page() can do migration_entry_wait()
for KSM's break_cow().  I'd have preferred to avoid another flag, and do
it every time, in case someone else makes the same easy mistake; but did
not find another transgressor (the common get_user_pages() is of course
safe), and cannot be sure that every follow_page() caller is prepared to
sleep - ia64's xencomm_vtop()?  Now, THP's wait_split_huge_page() can
already sleep there, since anon_vma locking was changed to mutex, but
maybe that's somehow excluded.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/ksm.c           |    2 +-
 mm/memory.c        |   20 ++++++++++++++++++--
 3 files changed, 20 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mmksm-foll_migration-do-migration_entry_wait include/linux/mm.h
--- a/include/linux/mm.h~mmksm-foll_migration-do-migration_entry_wait
+++ a/include/linux/mm.h
@@ -1653,6 +1653,7 @@ static inline struct page *follow_page(s
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
+#define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff -puN mm/ksm.c~mmksm-foll_migration-do-migration_entry_wait mm/ksm.c
--- a/mm/ksm.c~mmksm-foll_migration-do-migration_entry_wait
+++ a/mm/ksm.c
@@ -364,7 +364,7 @@ static int break_ksm(struct vm_area_stru
 
 	do {
 		cond_resched();
-		page = follow_page(vma, addr, FOLL_GET);
+		page = follow_page(vma, addr, FOLL_GET | FOLL_MIGRATION);
 		if (IS_ERR_OR_NULL(page))
 			break;
 		if (PageKsm(page))
diff -puN mm/memory.c~mmksm-foll_migration-do-migration_entry_wait mm/memory.c
--- a/mm/memory.c~mmksm-foll_migration-do-migration_entry_wait
+++ a/mm/memory.c
@@ -1548,8 +1548,24 @@ split_fallthrough:
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 
 	pte = *ptep;
-	if (!pte_present(pte))
-		goto no_page;
+	if (!pte_present(pte)) {
+		swp_entry_t entry;
+		/*
+		 * KSM's break_ksm() relies upon recognizing a ksm page
+		 * even while it is being migrated, so for that case we
+		 * need migration_entry_wait().
+		 */
+		if (likely(!(flags & FOLL_MIGRATION)))
+			goto no_page;
+		if (pte_none(pte) || pte_file(pte))
+			goto no_page;
+		entry = pte_to_swp_entry(pte);
+		if (!is_migration_entry(entry))
+			goto no_page;
+		pte_unmap_unlock(ptep, ptl);
+		migration_entry_wait(mm, pmd, address);
+		goto split_fallthrough;
+	}
 	if ((flags & FOLL_NUMA) && pte_numa(pte))
 		goto no_page;
 	if ((flags & FOLL_WRITE) && !pte_write(pte))
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

