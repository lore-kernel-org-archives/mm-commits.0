From: akpm@linux-foundation.org
Subject: [merged] mm-suppress-pfn-range-output-for-zones-without-pages.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:27 -0800
Message-ID: <201003091904.o29J4RW7031041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755618Ab0CITFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux-foundation.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: suppress pfn range output for zones without pages
has been removed from the -mm tree.  Its filename was
     mm-suppress-pfn-range-output-for-zones-without-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: suppress pfn range output for zones without pages
From: David Rientjes <rientjes@google.com>

free_area_init_nodes() emits pfn ranges for all zones on the system. 
There may be no pages on a higher zone, however, due to memory limitations
or the use of the mem= kernel parameter.  For example:

Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000

The implementation copies the previous zone's highest pfn, if any, as the
next zone's lowest pfn.  If its highest pfn is then greater than the
amount of addressable memory, the upper memory limit is used instead. 
Thus, both the lowest and highest possible pfn for higher zones without
memory may be the same.

The pfn range for zones without memory is now shown as "empty" instead.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-suppress-pfn-range-output-for-zones-without-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-suppress-pfn-range-output-for-zones-without-pages
+++ a/mm/page_alloc.c
@@ -4392,8 +4392,12 @@ void __init free_area_init_nodes(unsigne
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		if (i == ZONE_MOVABLE)
 			continue;
-		printk("  %-8s %0#10lx -> %0#10lx\n",
-				zone_names[i],
+		printk("  %-8s ", zone_names[i]);
+		if (arch_zone_lowest_possible_pfn[i] ==
+				arch_zone_highest_possible_pfn[i])
+			printk("empty\n");
+		else
+			printk("%0#10lx -> %0#10lx\n",
 				arch_zone_lowest_possible_pfn[i],
 				arch_zone_highest_possible_pfn[i]);
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
memcg-handle-panic_on_oom=always-case-v2.patch
memcg-fix-oom-kill-behavior-v3.patch
cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
nodemask-fix-the-declaration-of-nodemask_alloc.patch
cpuset-alloc-nodemask_t-at-heap-not-stack.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch

