From: akpm@linux-foundation.org
Subject: + ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn.patch added to -mm tree
Date: Tue, 02 Sep 2008 17:11:32 -0700
Message-ID: <200809030011.m830BWX7019939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753888AbYICALn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 20:11:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oomichi@mxs.nes.nec.co.jp, bwalle@suse.de, jlan@sgi.com, tony.luck@intel.com


The patch titled
     ia64: fix the difference between node_mem_map and node_start_pfn
has been added to the -mm tree.  Its filename is
     ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -47,7 +47,6 @@ extern int reserve_elfcorehdr(unsigned l
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

ia64-fix-the-difference-between-node_mem_map-and-node_start_pfn.patch

