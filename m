From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-skip-the-range-until-proper-target-pageblock-is-met.patch
 removed from -mm tree
Date: Mon, 17 Nov 2014 12:50:32 -0800
Message-ID: <546a5f98.KK9Q81KZ7roSPRTw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaKQUud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 15:50:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: skip the range until proper target pageblock is met
has been removed from the -mm tree.  Its filename was
     mm-compaction-skip-the-range-until-proper-target-pageblock-is-met.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: skip the range until proper target pageblock is met

commit 7d49d8868336 ("mm, compaction: reduce zone checking frequency in
the migration scanner") has a side-effect that changes the iteration range
calculation.  Before the change, block_end_pfn is calculated using
start_pfn, but now it blindly adds pageblock_nr_pages to the previous
value.

This causes the problem that isolation_start_pfn is larger than
block_end_pfn when we isolate the page with more than pageblock order.  In
this case, isolation would fail due to an invalid range parameter.

To prevent this, this patch implements skipping the range until a proper
target pageblock is met.  Without this patch, CMA with more than pageblock
order always fails but with this patch it will succeed.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/compaction.c~mm-compaction-skip-the-range-until-proper-target-pageblock-is-met mm/compaction.c
--- a/mm/compaction.c~mm-compaction-skip-the-range-until-proper-target-pageblock-is-met
+++ a/mm/compaction.c
@@ -479,6 +479,16 @@ isolate_freepages_range(struct compact_c
 
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
+		/*
+		 * pfn could pass the block_end_pfn if isolated freepage
+		 * is more than pageblock order. In this case, we adjust
+		 * scanning range to right one.
+		 */
+		if (pfn >= block_end_pfn) {
+			block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+			block_end_pfn = min(block_end_pfn, end_pfn);
+		}
+
 		if (!pageblock_pfn_to_page(pfn, block_end_pfn, cc->zone))
 			break;
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-slub-fix-format-mismatches-in-slab_err-callers.patch
slab-improve-checking-for-invalid-gfp_flags.patch
slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
mm-cma-align-to-physical-address-not-cma-region-position.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
page-owners-correct-page-order-when-to-free-page.patch

