From: akpm@linux-foundation.org
Subject: +
 mm-debug-pagealloc-correct-freepage-accounting-and-order-resetting.patch
 added to -mm tree
Date: Wed, 12 Nov 2014 13:25:33 -0800
Message-ID: <5463d04d.gvtU908K5YlqQYaM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaKLVZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 16:25:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, gioh.kim@lge.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug-pagealloc: correct freepage accounting and order resetting
has been added to the -mm tree.  Its filename is
     mm-debug-pagealloc-correct-freepage-accounting-and-order-resetting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-pagealloc-correct-freepage-accounting-and-order-resetting.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-pagealloc-correct-freepage-accounting-and-order-resetting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/debug-pagealloc: correct freepage accounting and order resetting

One thing I did in this patch is fixing freepage accounting.  If we clear
guard page and link it onto isolate buddy list, we should not increase
freepage count.  This patch adds conditional branch to skip counting in
this case.  Without this patch, this overcounting happens frequently if
guard order is set and CMA is used.

Another thing fixed in this patch is the target to reset order.  In
__free_one_page(), we check the buddy page whether it is a guard page or
not.  And, if so, we should clear guard attribute on the buddy page and
reset order of it to 0.  But, current code resets original page's order
rather than buddy one's.  Maybe, this doesn't have any problem, because
whole merged page's order will be re-assigned soon.  But, it is better to
correct code.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Gioh Kim <gioh.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-debug-pagealloc-correct-freepage-accounting-and-order-resetting mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug-pagealloc-correct-freepage-accounting-and-order-resetting
+++ a/mm/page_alloc.c
@@ -583,9 +583,11 @@ static inline void __free_one_page(struc
 		 */
 		if (page_is_guard(buddy)) {
 			clear_page_guard_flag(buddy);
-			set_page_private(page, 0);
-			__mod_zone_freepage_state(zone, 1 << order,
-						  migratetype);
+			set_page_private(buddy, 0);
+			if (!is_migrate_isolate(migratetype)) {
+				__mod_zone_freepage_state(zone, 1 << order,
+							  migratetype);
+			}
 		} else {
 			list_del(&buddy->lru);
 			zone->free_area[order].nr_free--;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-skip-the-range-until-proper-target-pageblock-is-met.patch
mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mm-slab-fix-unalignment-problem-on-malta-with-eva-due-to-slab-merge.patch
mm-compaction-prevent-infinite-loop-in-compact_zone.patch
mm-debug-pagealloc-correct-freepage-accounting-and-order-resetting.patch
mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-slub-fix-format-mismatches-in-slab_err-callers.patch
slab-improve-checking-for-invalid-gfp_flags.patch
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

