From: akpm@linux-foundation.org
Subject: - ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn.patch removed from -mm tree
Date: Thu, 06 Nov 2008 11:20:01 -0800
Message-ID: <200811061920.mA6JK1WA003528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281AbYKFTUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 14:20:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oomichi@mxs.nes.nec.co.jp, bwalle@suse.de, jlan@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: fix the difference between node_mem_map and node_start_pfn
has been removed from the -mm tree.  Its filename was
     ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: fix the difference between node_mem_map and node_start_pfn
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

makedumpfile[1] cannot run on ia64 discontigmem kernel, because the member
node_mem_map of struct pgdat_list has invalid value.  This patch fixes it.

node_start_pfn shows the start pfn of each node, and node_mem_map should
point 'struct page' of each node's node_start_pfn.  On my machine, node0's
node_start_pfn shows 0x400 and its node_mem_map points 0xa0007fffbf000000.
 This address is the same as vmem_map, so the node_mem_map points 'struct
page' of pfn 0, even if its node_start_pfn shows 0x400.

The cause is due to the round down of min_pfn in count_node_pages() and
node0's node_mem_map points 'struct page' of inactive pfn (0x0).  This
patch fixes it.

makedumpfile[1]: dump filtering command
https://sourceforge.net/projects/makedumpfile/

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Cc: Bernhard Walle <bwalle@suse.de>
Cc: Jay Lan <jlan@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/meminit.h |    1 -
 arch/ia64/mm/discontig.c        |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/ia64/include/asm/meminit.h~ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn arch/ia64/include/asm/meminit.h
--- a/arch/ia64/include/asm/meminit.h~ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn
+++ a/arch/ia64/include/asm/meminit.h
@@ -48,7 +48,6 @@ extern int reserve_elfcorehdr(unsigned l
  */
 #define GRANULEROUNDDOWN(n)	((n) & ~(IA64_GRANULE_SIZE-1))
 #define GRANULEROUNDUP(n)	(((n)+IA64_GRANULE_SIZE-1) & ~(IA64_GRANULE_SIZE-1))
-#define ORDERROUNDDOWN(n)	((n) & ~((PAGE_SIZE<<MAX_ORDER)-1))
 
 #ifdef CONFIG_NUMA
   extern void call_pernode_memory (unsigned long start, unsigned long len, void *func);
diff -puN arch/ia64/mm/discontig.c~ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn
+++ a/arch/ia64/mm/discontig.c
@@ -635,7 +635,6 @@ static __init int count_node_pages(unsig
 			(min(end, __pa(MAX_DMA_ADDRESS)) - start) >>PAGE_SHIFT;
 #endif
 	start = GRANULEROUNDDOWN(start);
-	start = ORDERROUNDDOWN(start);
 	end = GRANULEROUNDUP(end);
 	mem_data[node].max_pfn = max(mem_data[node].max_pfn,
 				     end >> PAGE_SHIFT);
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

linux-next.patch

