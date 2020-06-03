From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 011/131] mm: memblock: replace dereferences of
 memblock_region.nid with API calls
Date: Wed, 03 Jun 2020 15:56:53 -0700
Message-ID: <20200603225653.ORDy1rui3%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFCW4z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:56:55 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@kernel.org, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@use

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: memblock: replace dereferences of memblock_region.nid with API calls

Patch series "mm: rework free_area_init*() funcitons".

After the discussion [1] about removal of CONFIG_NODES_SPAN_OTHER_NODES
and CONFIG_HAVE_MEMBLOCK_NODE_MAP options, I took it a bit further and
updated the node/zone initialization.  

Since all architectures have memblock, it is possible to use only the
newer version of free_area_init_node() that calculates the zone and node
boundaries based on memblock node mapping and architectural limits on
possible zone PFNs.  

The architectures that still determined zone and hole sizes can be
switched to the generic code and the old code that took those zone and
hole sizes can be simply removed.

And, since it all started from the removal of
CONFIG_NODES_SPAN_OTHER_NODES, the memmap_init() is now updated to iterate
over memblocks and so it does not need to perform early_pfn_to_nid() query
for every PFN.

[1] https://lore.kernel.org/lkml/1585420282-25630-1-git-send-email-Hoan@os.amperecomputing.com


This patch (of 21):

There are several places in the code that directly dereference
memblock_region.nid despite this field being defined only when
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y.

Replace these with calls to memblock_get_region_nid() to improve code
robustness and to avoid possible breakage when
CONFIG_HAVE_MEMBLOCK_NODE_MAP will be removed.

Link: http://lkml.kernel.org/r/20200412194859.12663-1-rppt@kernel.org
Link: http://lkml.kernel.org/r/20200412194859.12663-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Tested-by: Hoan Tran <hoan@os.amperecomputing.com>	[arm64]
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/numa.c |    9 ++++++---
 arch/x86/mm/numa.c   |    6 ++++--
 mm/memblock.c        |    8 +++++---
 mm/page_alloc.c      |    4 ++--
 4 files changed, 17 insertions(+), 10 deletions(-)

--- a/arch/arm64/mm/numa.c~mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls
+++ a/arch/arm64/mm/numa.c
@@ -350,13 +350,16 @@ static int __init numa_register_nodes(vo
 	struct memblock_region *mblk;
 
 	/* Check that valid nid is set to memblks */
-	for_each_memblock(memory, mblk)
-		if (mblk->nid == NUMA_NO_NODE || mblk->nid >= MAX_NUMNODES) {
+	for_each_memblock(memory, mblk) {
+		int mblk_nid = memblock_get_region_node(mblk);
+
+		if (mblk_nid == NUMA_NO_NODE || mblk_nid >= MAX_NUMNODES) {
 			pr_warn("Warning: invalid memblk node %d [mem %#010Lx-%#010Lx]\n",
-				mblk->nid, mblk->base,
+				mblk_nid, mblk->base,
 				mblk->base + mblk->size - 1);
 			return -EINVAL;
 		}
+	}
 
 	/* Finally register nodes. */
 	for_each_node_mask(nid, numa_nodes_parsed) {
--- a/arch/x86/mm/numa.c~mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls
+++ a/arch/x86/mm/numa.c
@@ -517,8 +517,10 @@ static void __init numa_clear_kernel_nod
 	 *   reserve specific pages for Sandy Bridge graphics. ]
 	 */
 	for_each_memblock(reserved, mb_region) {
-		if (mb_region->nid != MAX_NUMNODES)
-			node_set(mb_region->nid, reserved_nodemask);
+		int nid = memblock_get_region_node(mb_region);
+
+		if (nid != MAX_NUMNODES)
+			node_set(nid, reserved_nodemask);
 	}
 
 	/*
--- a/mm/memblock.c~mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls
+++ a/mm/memblock.c
@@ -1207,13 +1207,15 @@ void __init_memblock __next_mem_pfn_rang
 {
 	struct memblock_type *type = &memblock.memory;
 	struct memblock_region *r;
+	int r_nid;
 
 	while (++*idx < type->cnt) {
 		r = &type->regions[*idx];
+		r_nid = memblock_get_region_node(r);
 
 		if (PFN_UP(r->base) >= PFN_DOWN(r->base + r->size))
 			continue;
-		if (nid == MAX_NUMNODES || nid == r->nid)
+		if (nid == MAX_NUMNODES || nid == r_nid)
 			break;
 	}
 	if (*idx >= type->cnt) {
@@ -1226,7 +1228,7 @@ void __init_memblock __next_mem_pfn_rang
 	if (out_end_pfn)
 		*out_end_pfn = PFN_DOWN(r->base + r->size);
 	if (out_nid)
-		*out_nid = r->nid;
+		*out_nid = r_nid;
 }
 
 /**
@@ -1810,7 +1812,7 @@ int __init_memblock memblock_search_pfn_
 	*start_pfn = PFN_DOWN(type->regions[mid].base);
 	*end_pfn = PFN_DOWN(type->regions[mid].base + type->regions[mid].size);
 
-	return type->regions[mid].nid;
+	return memblock_get_region_node(&type->regions[mid]);
 }
 #endif
 
--- a/mm/page_alloc.c~mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls
+++ a/mm/page_alloc.c
@@ -7220,7 +7220,7 @@ static void __init find_zone_movable_pfn
 			if (!memblock_is_hotpluggable(r))
 				continue;
 
-			nid = r->nid;
+			nid = memblock_get_region_node(r);
 
 			usable_startpfn = PFN_DOWN(r->base);
 			zone_movable_pfn[nid] = zone_movable_pfn[nid] ?
@@ -7241,7 +7241,7 @@ static void __init find_zone_movable_pfn
 			if (memblock_is_mirror(r))
 				continue;
 
-			nid = r->nid;
+			nid = memblock_get_region_node(r);
 
 			usable_startpfn = memblock_region_memory_base_pfn(r);
 
_
