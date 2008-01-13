From: akpm@linux-foundation.org
Subject: - fix-crash-with-flat_memory-and-arch_pfn_offset-=-0.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:33:16 -0800
Message-ID: <200801131132.m0DBWurC009807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47109 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300AbYAMLeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:34:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsbogend@alpha.franken.de, ak@muc.de, apw@shadowen.org, benh@kernel.crashing.org, bob.picco@hp.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kmannth@gmail.com, mel@csn.ul.i


The patch titled
     Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
has been removed from the -mm tree.  Its filename was
     fix-crash-with-flat_memory-and-arch_pfn_offset-=-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

When using FLAT_MEMORY and ARCH_PFN_OFFSET is not 0, the kernel crashes in
memmap_init_zone().  This bug got introduced by commit
c713216deebd95d2b0ab38fef8bb2361c0180c2d

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Bob Picco <bob.picco@hp.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Keith Mannthey" <kmannth@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~fix-crash-with-flat_memory-and-arch_pfn_offset-=-0 mm/page_alloc.c
--- a/mm/page_alloc.c~fix-crash-with-flat_memory-and-arch_pfn_offset-=-0
+++ a/mm/page_alloc.c
@@ -3438,7 +3438,7 @@ static void __init_refok alloc_node_mem_
 		mem_map = NODE_DATA(0)->node_mem_map;
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
 		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
-			mem_map -= pgdat->node_start_pfn;
+			mem_map -= (pgdat->node_start_pfn - ARCH_PFN_OFFSET);
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 	}
 #endif
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

origin.patch
git-mips.patch
git-netdev-all.patch
git-watchdog.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
partition-use-default_sgi_partition-for-sgi_partion-default.patch
