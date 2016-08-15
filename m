From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-fix-node-spanned-pages-when-we-have-a-movable-node.patch added
 to -mm tree
Date: Mon, 15 Aug 2016 14:34:24 -0700
Message-ID: <57b23560.xZAroUcDn/nKzjmi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbcHOVe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 17:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, iamjoonsoo.kim@lge.com, izumi.taku@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: fix node spanned pages when we have a movable node
has been added to the -mm tree.  Its filename is
     mem-hotplug-fix-node-spanned-pages-when-we-have-a-movable-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-fix-node-spanned-pages-when-we-have-a-movable-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-fix-node-spanned-pages-when-we-have-a-movable-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mem-hotplug: fix node spanned pages when we have a movable node

342332e6a925e9e ("mm/page_alloc.c: introduce kernelcore=mirror option")
rewrote the calculation of node spanned pages.  But when we have a movable
node, the size of node spanned pages is double added.  That's because we
have an empty normal zone, the present pages is zero, but its spanned
pages is not zero.

e.g.
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000007c7fffffff]
[    0.000000] Movable zone start for each node
[    0.000000]   Node 1: 0x0000001080000000
[    0.000000]   Node 2: 0x0000002080000000
[    0.000000]   Node 3: 0x0000003080000000
[    0.000000]   Node 4: 0x0000003c80000000
[    0.000000]   Node 5: 0x0000004c80000000
[    0.000000]   Node 6: 0x0000005c80000000
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000007552afff]
[    0.000000]   node   0: [mem 0x000000007bd46000-0x000000007bd46fff]
[    0.000000]   node   0: [mem 0x000000007bdcd000-0x000000007bffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000107fffffff]
[    0.000000]   node   1: [mem 0x0000001080000000-0x000000207fffffff]
[    0.000000]   node   2: [mem 0x0000002080000000-0x000000307fffffff]
[    0.000000]   node   3: [mem 0x0000003080000000-0x0000003c7fffffff]
[    0.000000]   node   4: [mem 0x0000003c80000000-0x0000004c7fffffff]
[    0.000000]   node   5: [mem 0x0000004c80000000-0x0000005c7fffffff]
[    0.000000]   node   6: [mem 0x0000005c80000000-0x0000006c7fffffff]
[    0.000000]   node   7: [mem 0x0000006c80000000-0x0000007c7fffffff]

node1:
[  760.227767] Normal, start=0x1080000, present=0x0, spanned=0x1000000
[  760.234024] Movable, start=0x1080000, present=0x1000000, spanned=0x1000000
[  760.240883] pgdat, start=0x1080000, present=0x1000000, spanned=0x2000000

After apply this patch, the problem is fixed.
node1:
[  289.770922] Normal, start=0x0, present=0x0, spanned=0x0
[  289.776153] Movable, start=0x1080000, present=0x1000000, spanned=0x1000000
[  289.783019] pgdat, start=0x1080000, present=0x1000000, spanned=0x1000000

Link: http://lkml.kernel.org/r/57A325E8.6070100@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   54 +++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 31 deletions(-)

diff -puN mm/page_alloc.c~mem-hotplug-fix-node-spanned-pages-when-we-have-a-movable-node mm/page_alloc.c
--- a/mm/page_alloc.c~mem-hotplug-fix-node-spanned-pages-when-we-have-a-movable-node
+++ a/mm/page_alloc.c
@@ -5051,15 +5051,6 @@ void __meminit memmap_init_zone(unsigned
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 		/*
-		 * If not mirrored_kernelcore and ZONE_MOVABLE exists, range
-		 * from zone_movable_pfn[nid] to end of each node should be
-		 * ZONE_MOVABLE not ZONE_NORMAL. skip it.
-		 */
-		if (!mirrored_kernelcore && zone_movable_pfn[nid])
-			if (zone == ZONE_NORMAL && pfn >= zone_movable_pfn[nid])
-				continue;
-
-		/*
 		 * Check given memblock attribute by firmware which can affect
 		 * kernel memory layout.  If zone==ZONE_MOVABLE but memory is
 		 * mirrored, it's an overlapped memmap init. skip it.
@@ -5502,6 +5493,12 @@ static void __meminit adjust_zone_range_
 			*zone_end_pfn = min(node_end_pfn,
 				arch_zone_highest_possible_pfn[movable_zone]);
 
+		/* Adjust for ZONE_MOVABLE starting within this range */
+		} else if (!mirrored_kernelcore &&
+			*zone_start_pfn < zone_movable_pfn[nid] &&
+			*zone_end_pfn > zone_movable_pfn[nid]) {
+			*zone_end_pfn = zone_movable_pfn[nid];
+
 		/* Check if this whole range is within ZONE_MOVABLE */
 		} else if (*zone_start_pfn >= zone_movable_pfn[nid])
 			*zone_start_pfn = *zone_end_pfn;
@@ -5605,28 +5602,23 @@ static unsigned long __meminit zone_abse
 	 * Treat pages to be ZONE_MOVABLE in ZONE_NORMAL as absent pages
 	 * and vice versa.
 	 */
-	if (zone_movable_pfn[nid]) {
-		if (mirrored_kernelcore) {
-			unsigned long start_pfn, end_pfn;
-			struct memblock_region *r;
-
-			for_each_memblock(memory, r) {
-				start_pfn = clamp(memblock_region_memory_base_pfn(r),
-						  zone_start_pfn, zone_end_pfn);
-				end_pfn = clamp(memblock_region_memory_end_pfn(r),
-						zone_start_pfn, zone_end_pfn);
-
-				if (zone_type == ZONE_MOVABLE &&
-				    memblock_is_mirror(r))
-					nr_absent += end_pfn - start_pfn;
-
-				if (zone_type == ZONE_NORMAL &&
-				    !memblock_is_mirror(r))
-					nr_absent += end_pfn - start_pfn;
-			}
-		} else {
-			if (zone_type == ZONE_NORMAL)
-				nr_absent += node_end_pfn - zone_movable_pfn[nid];
+	if (mirrored_kernelcore && zone_movable_pfn[nid]) {
+		unsigned long start_pfn, end_pfn;
+		struct memblock_region *r;
+
+		for_each_memblock(memory, r) {
+			start_pfn = clamp(memblock_region_memory_base_pfn(r),
+					  zone_start_pfn, zone_end_pfn);
+			end_pfn = clamp(memblock_region_memory_end_pfn(r),
+					zone_start_pfn, zone_end_pfn);
+
+			if (zone_type == ZONE_MOVABLE &&
+			    memblock_is_mirror(r))
+				nr_absent += end_pfn - start_pfn;
+
+			if (zone_type == ZONE_NORMAL &&
+			    !memblock_is_mirror(r))
+				nr_absent += end_pfn - start_pfn;
 		}
 	}
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mem-hotplug-fix-node-spanned-pages-when-we-have-a-movable-node.patch
mm-fix-set-pageblock-migratetype-in-deferred-struct-page-init.patch

