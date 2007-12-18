From: akpm@linux-foundation.org
Subject: + fix-crash-with-flat_memory-and-arch_pfn_offset-=-0.patch added to -mm tree
Date: Tue, 18 Dec 2007 04:23:36 -0800
Message-ID: <200712181223.lBICNaPN001987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625AbXLRM0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 07:26:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsbogend@alpha.franken.de, ak@muc.de, apw@shadowen.org, benh@kernel.crashing.org, bob.picco@hp.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kmannth@gmail.com, mel@csn.ul.ie, paulus@samba.org, tony.luck@intel.com, y-goto@jp.fujitsu.com


The patch titled
     Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
has been added to the -mm tree.  Its filename is
     fix-crash-with-flat_memory-and-arch_pfn_offset-=-0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

When using FLAT_MEMORY and ARCH_PFN_OFFSET is not 0, the kernel crashes in
memmap_init_zone().  This bug got introduced by commit
c713216deebd95d2b0ab38fef8bb2361c0180c2d

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Mel Gorman <mel@csn.ul.ie>
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

fix-crash-with-flat_memory-and-arch_pfn_offset-=-0.patch
git-mips.patch
git-netdev-all.patch
watchdog-use-sgi_has_indydog-for-indydog-depends.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
partition-use-default_sgi_partition-for-sgi_partion-default.patch
