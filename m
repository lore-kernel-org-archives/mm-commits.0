From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 parisc-simplify-detection-of-memory-zone-boundaries.patch added to -mm tree
Date: Mon, 13 Apr 2020 17:26:22 -0700
Message-ID: <20200414002622.mibAQHtqB%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgDNA0Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:26:25 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, Hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.sourceforge.jp


The patch titled
     Subject: parisc: simplify detection of memory zone boundaries
has been added to the -mm tree.  Its filename is
     parisc-simplify-detection-of-memory-zone-boundaries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-simplify-detection-of-memory-zone-boundaries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-simplify-detection-of-memory-zone-boundaries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: parisc: simplify detection of memory zone boundaries

free_area_init() only requires the definition of maximal PFN for each of
the supported zone rater than calculation of actual zone sizes and the
sizes of the holes between the zones.

After removal of CONFIG_HAVE_MEMBLOCK_NODE_MAP the free_area_init() is
available to all architectures.

Using this function instead of free_area_init_node() simplifies the zone
detection.

Link: http://lkml.kernel.org/r/20200412194859.12663-12-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
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
Cc: Hoan Tran <Hoan@os.amperecomputing.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
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

 arch/parisc/mm/init.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

--- a/arch/parisc/mm/init.c~parisc-simplify-detection-of-memory-zone-boundaries
+++ a/arch/parisc/mm/init.c
@@ -675,27 +675,11 @@ static void __init gateway_init(void)
 
 static void __init parisc_bootmem_free(void)
 {
-	unsigned long zones_size[MAX_NR_ZONES] = { 0, };
-	unsigned long holes_size[MAX_NR_ZONES] = { 0, };
-	unsigned long mem_start_pfn = ~0UL, mem_end_pfn = 0, mem_size_pfn = 0;
-	int i;
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0, };
 
-	for (i = 0; i < npmem_ranges; i++) {
-		unsigned long start = pmem_ranges[i].start_pfn;
-		unsigned long size = pmem_ranges[i].pages;
-		unsigned long end = start + size;
+	max_zone_pfn[0] = memblock_end_of_DRAM();
 
-		if (mem_start_pfn > start)
-			mem_start_pfn = start;
-		if (mem_end_pfn < end)
-			mem_end_pfn = end;
-		mem_size_pfn += size;
-	}
-
-	zones_size[0] = mem_end_pfn - mem_start_pfn;
-	holes_size[0] = zones_size[0] - mem_size_pfn;
-
-	free_area_init_node(0, zones_size, mem_start_pfn, holes_size);
+	free_area_init(max_zone_pfn);
 }
 
 void __init paging_init(void)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls.patch
mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch
mm-remove-config_have_memblock_node_map-option.patch
mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes.patch
mm-use-free_area_init-instead-of-free_area_init_nodes.patch
alpha-simplify-detection-of-memory-zone-boundaries.patch
arm-simplify-detection-of-memory-zone-boundaries.patch
arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch
csky-simplify-detection-of-memory-zone-boundaries.patch
m68k-mm-simplify-detection-of-memory-zone-boundaries.patch
parisc-simplify-detection-of-memory-zone-boundaries.patch
sparc32-simplify-detection-of-memory-zone-boundaries.patch
unicore32-simplify-detection-of-memory-zone-boundaries.patch
xtensa-simplify-detection-of-memory-zone-boundaries.patch
mm-remove-early_pfn_in_nid-and-config_nodes_span_other_nodes.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order.patch
mm-rename-free_area_init_node-to-free_area_init_memoryless_node.patch
mm-clean-up-free_area_init_node-and-its-helpers.patch
mm-simplify-find_min_pfn_with_active_regions.patch
docs-vm-update-memory-models-documentation.patch
