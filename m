From: akpm@linux-foundation.org
Subject: + mm-compaction-do-not-compact-pgdat-for-order-0.patch added to
 -mm tree
Date: Thu, 15 Aug 2013 13:58:13 -0700
Message-ID: <520d40e5.b236EwHXomco4OT3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3HOU6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 16:58:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, dhillf@gmail.com, mgorman@suse.de

Subject: + mm-compaction-do-not-compact-pgdat-for-order-0.patch added to -mm tree
To: mgorman@suse.de,dhillf@gmail.com,minchan@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 13:58:13 -0700


The patch titled
     Subject: mm: compaction: do not compact pgdat for order-0
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-compact-pgdat-for-order-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-do-not-compact-pgdat-for-order-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-do-not-compact-pgdat-for-order-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: do not compact pgdat for order-0

If kswapd was reclaiming for a high order and resets it to 0 due to
fragmentation it will still call compact_pgdat.  For the most part, this
will fail a compaction_suitable() test and not compact but it is
unnecessarily sloppy.  It could be fixed in the caller but fix it in the
API instead.

[dhillf@gmail.com: pointed out that it was a potential problem]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/compaction.c~mm-compaction-do-not-compact-pgdat-for-order-0 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-do-not-compact-pgdat-for-order-0
+++ a/mm/compaction.c
@@ -1131,6 +1131,9 @@ void compact_pgdat(pg_data_t *pgdat, int
 		.sync = false,
 	};
 
+	if (!order)
+		return;
+
 	__compact_pgdat(pgdat, &cc);
 }
 
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
mm-kill-one-if-loop-in-__free_pages_bootmem.patch
mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd.patch
mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch
mm-page_alloc-fair-zone-allocator-policy.patch
mm-page_alloc-fair-zone-allocator-policy-v2.patch
mm-page_alloc-fair-zone-allocator-policy-v2-fix.patch
mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
mm-move-pgtable-related-functions-to-right-place.patch
swap-clean-up-ifdef-in-page_mapping.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-compaction-do-not-compact-pgdat-for-order-0.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch

