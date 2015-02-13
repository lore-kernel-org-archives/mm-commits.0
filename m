From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-fix-wrong-order-check-in-compact_finished.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:20:38 -0800
Message-ID: <54de5c96.hZaZuYlu9yx01Wxt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbbBMUUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: fix wrong order check in compact_finished()
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-wrong-order-check-in-compact_finished.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: fix wrong order check in compact_finished()

What we want to check here is whether there is highorder freepage in buddy
list of other migratetype in order to steal it without fragmentation. 
But, current code just checks cc->order which means allocation request
order.  So, this is wrong.

Without this fix, non-movable synchronous compaction below pageblock order
would not stopped until compaction is complete, because migratetype of
most pageblocks are movable and high order freepage made by compaction is
usually on movable type buddy list.

There is some report related to this bug. See below link.

http://www.spinics.net/lists/linux-mm/msg81666.html

Although the issued system still has load spike comes from compaction,
this makes that system completely stable and responsive according to his
report.

stress-highalloc test in mmtests with non movable order 7 allocation
doesn't show any notable difference in allocation success rate, but, it
shows more compaction success rate.

Compaction success rate (Compaction success * 100 / Compaction stalls, %)
18.47 : 28.94

Fixes: 1fb3f8ca0e922253 ("mm: compaction: capture a suitable high-order page immediately when it is made available")
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>	[3.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-fix-wrong-order-check-in-compact_finished mm/compaction.c
--- a/mm/compaction.c~mm-compaction-fix-wrong-order-check-in-compact_finished
+++ a/mm/compaction.c
@@ -1173,7 +1173,7 @@ static int __compact_finished(struct zon
 			return COMPACT_PARTIAL;
 
 		/* Job done if allocation would set block type */
-		if (cc->order >= pageblock_order && area->nr_free)
+		if (order >= pageblock_order && area->nr_free)
 			return COMPACT_PARTIAL;
 	}
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
kasan-disable-memory-hotplug.patch
x86_64-add-kasan-support.patch
mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
mm-slub-introduce-virt_to_obj-function.patch
mm-slub-share-object_err-function.patch
mm-slub-introduce-metadata_access_enable-metadata_access_disable.patch
mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch
fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch
kmemleak-disable-kasan-instrumentation-for-kmemleak.patch
lib-add-kasan-test-module.patch
x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch
kasan-enable-stack-instrumentation.patch
mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch
mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch
kernel-add-support-for-init_array-constructors.patch
module-fix-types-of-device-tables-aliases.patch
kasan-enable-instrumentation-of-global-variables.patch

