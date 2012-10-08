From: akpm@linux-foundation.org
Subject: [folded-dropped] memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:09:40 -0700
Message-ID: <20121008230941.71248200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:54170 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2JHXJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:09:44 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so240044lah.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:09:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch

This patch was dropped because it was folded into memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix

small cleanup

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_isolation.c~memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix mm/page_isolation.c
--- a/mm/page_isolation.c~memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix
+++ a/mm/page_isolation.c
@@ -209,8 +209,9 @@ __test_page_isolated_in_pageblock(unsign
 			 * MIGRATE_ISOLATE list.
 			 */
 			if (get_freepage_migratetype(page) != MIGRATE_ISOLATE) {
-				struct page *end_page = page +
-						(1 << page_order(page)) - 1;
+				struct page *end_page;
+
+				end_page = page + (1 << page_order(page)) - 1;
 				move_freepages(page_zone(page), page, end_page,
 						MIGRATE_ISOLATE);
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
rbtree-performance-and-correctness-test.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-count-free-cma-pages.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

