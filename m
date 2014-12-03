From: akpm@linux-foundation.org
Subject: +
 mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
 added to -mm tree
Date: Wed, 03 Dec 2014 14:51:31 -0800
Message-ID: <547f93f3.vDyi9TGk87vFy5Ay%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaLCWvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2014 17:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, fengguang.wu@intel.com, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: reserve more space in case of unaligned node range
has been added to the -mm tree.  Its filename is
     mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch

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
Subject: mm/page_ext: reserve more space in case of unaligned node range

When page allocator's buddy algorithm checks buddy's status, checked page
could be in invalid range.  In this case, lookup_page_ext() will return
invalid address and it results in invalid address defereference problem. 
For example, if node_start_pfn is 1 and page with pfn 1 is freed to page
allocator, page_is_buddy() would check the page with pfn 0.  In page_ext
code, offset would be calculated by pfn - node_start_pfn, so, 0 - 1 = -1. 
This causes following problem reported by Fengguang.

[    0.480155] BUG: unable to handle kernel
[    0.480155] BUG: unable to handle kernel paging requestpaging request at d26bdffc
 at d26bdffc
[    0.481566] IP:
[    0.481566] IP: [<c110bc7a>] free_one_page+0x31a/0x3e0
 [<c110bc7a>] free_one_page+0x31a/0x3e0
[    0.482801] *pdpt = 0000000001866001
[    0.482801] *pdpt = 0000000001866001 *pde = 0000000012584067 *pde = 0000000012584067 *pte = 80000000126bd060 *pte = 80000000126bd060
[    0.483333] Oops: 0000 [#1]
[    0.483333] Oops: 0000 [#1] SMP SMP DEBUG_PAGEALLOCDEBUG_PAGEALLOC
snip...
[    0.483333] Call Trace:
[    0.483333] Call Trace:
[    0.483333]  [<c110bdec>] __free_pages_ok+0xac/0xf0
[    0.483333]  [<c110bdec>] __free_pages_ok+0xac/0xf0
[    0.483333]  [<c110c769>] __free_pages+0x19/0x30
[    0.483333]  [<c110c769>] __free_pages+0x19/0x30
[    0.483333]  [<c1144ca5>] kfree+0x75/0xf0
[    0.483333]  [<c1144ca5>] kfree+0x75/0xf0
[    0.483333]  [<c111b595>] ? kvfree+0x45/0x50
[    0.483333]  [<c111b595>] ? kvfree+0x45/0x50
[    0.483333]  [<c111b595>] kvfree+0x45/0x50
[    0.483333]  [<c111b595>] kvfree+0x45/0x50
[    0.483333]  [<c134bb73>] rhashtable_expand+0x1b3/0x1e0
[    0.483333]  [<c134bb73>] rhashtable_expand+0x1b3/0x1e0
[    0.483333]  [<c17fc9f9>] test_rht_init+0x173/0x2e8
[    0.483333]  [<c17fc9f9>] test_rht_init+0x173/0x2e8
[    0.483333]  [<c134b750>] ? jhash2+0xe0/0xe0
[    0.483333]  [<c134b750>] ? jhash2+0xe0/0xe0
[    0.483333]  [<c134b790>] ? rhashtable_hashfn+0x20/0x20
[    0.483333]  [<c134b790>] ? rhashtable_hashfn+0x20/0x20
[    0.483333]  [<c134b7b0>] ? rht_grow_above_75+0x20/0x20
[    0.483333]  [<c134b7b0>] ? rht_grow_above_75+0x20/0x20
[    0.483333]  [<c134b7d0>] ? rht_shrink_below_30+0x20/0x20
[    0.483333]  [<c134b7d0>] ? rht_shrink_below_30+0x20/0x20
[    0.483333]  [<c134b750>] ? jhash2+0xe0/0xe0
[    0.483333]  [<c134b750>] ? jhash2+0xe0/0xe0
[    0.483333]  [<c134b790>] ? rhashtable_hashfn+0x20/0x20
[    0.483333]  [<c134b790>] ? rhashtable_hashfn+0x20/0x20
[    0.483333]  [<c134b7b0>] ? rht_grow_above_75+0x20/0x20
[    0.483333]  [<c134b7b0>] ? rht_grow_above_75+0x20/0x20
[    0.483333]  [<c134b7d0>] ? rht_shrink_below_30+0x20/0x20
[    0.483333]  [<c134b7d0>] ? rht_shrink_below_30+0x20/0x20
[    0.483333]  [<c17fc886>] ? test_rht_lookup+0x8f/0x8f
[    0.483333]  [<c17fc886>] ? test_rht_lookup+0x8f/0x8f
[    0.483333]  [<c1000486>] do_one_initcall+0xc6/0x210
[    0.483333]  [<c1000486>] do_one_initcall+0xc6/0x210
[    0.483333]  [<c17fc886>] ? test_rht_lookup+0x8f/0x8f
[    0.483333]  [<c17fc886>] ? test_rht_lookup+0x8f/0x8f
[    0.483333]  [<c17d0505>] ? repair_env_string+0x12/0x54
[    0.483333]  [<c17d0505>] ? repair_env_string+0x12/0x54
[    0.483333]  [<c17d0cf3>] kernel_init_freeable+0x193/0x213
[    0.483333]  [<c17d0cf3>] kernel_init_freeable+0x193/0x213
[    0.483333]  [<c1512500>] kernel_init+0x10/0xf0
[    0.483333]  [<c1512500>] kernel_init+0x10/0xf0
[    0.483333]  [<c151c5c1>] ret_from_kernel_thread+0x21/0x30
[    0.483333]  [<c151c5c1>] ret_from_kernel_thread+0x21/0x30
[    0.483333]  [<c15124f0>] ? rest_init+0xb0/0xb0
[    0.483333]  [<c15124f0>] ? rest_init+0xb0/0xb0
snip...
[    0.483333] EIP: [<c110bc7a>]
[    0.483333] EIP: [<c110bc7a>] free_one_page+0x31a/0x3e0free_one_page+0x31a/0x3e0 SS:ESP 0068:c0041de0
 SS:ESP 0068:c0041de0
[    0.483333] CR2: 00000000d26bdffc
[    0.483333] CR2: 00000000d26bdffc
[    0.483333] ---[ end trace 7648e12f817ef2ad ]---
[    0.483333] ---[ end trace 7648e12f817ef2ad ]---

This case is already handled in case of struct page by considering
alignment of node_start_pfn. So, this patch follows that way to fix this
situation.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/page_ext.c~mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix mm/page_ext.c
--- a/mm/page_ext.c~mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix
+++ a/mm/page_ext.c
@@ -104,7 +104,8 @@ struct page_ext *lookup_page_ext(struct
 	if (unlikely(!base))
 		return NULL;
 #endif
-	offset = pfn - NODE_DATA(page_to_nid(page))->node_start_pfn;
+	offset = pfn - round_down(node_start_pfn(page_to_nid(page)),
+					MAX_ORDER_NR_PAGES);
 	return base + offset;
 }
 
@@ -118,6 +119,15 @@ static int __init alloc_node_page_ext(in
 	if (!nr_pages)
 		return 0;
 
+	/*
+	 * Need extra space if node range is not aligned with
+	 * MAX_ORDER_NR_PAGES. When page allocator's buddy algorithm
+	 * checks buddy's status, range could be out of exact node range.
+	 */
+	if (!IS_ALIGNED(node_start_pfn(nid), MAX_ORDER_NR_PAGES) ||
+		!IS_ALIGNED(node_end_pfn(nid), MAX_ORDER_NR_PAGES))
+		nr_pages += MAX_ORDER_NR_PAGES;
+
 	table_size = sizeof(struct page_ext) * nr_pages;
 
 	base = memblock_virt_alloc_try_nid_nopanic(
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
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
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
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
include-linux-kmemleakh-needs-slabh.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
fix-memory-ordering-bug-in-mm-vmallocc.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

