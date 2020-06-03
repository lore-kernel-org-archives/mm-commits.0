From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 021/131] parisc: simplify detection of memory zone
 boundaries
Date: Wed, 03 Jun 2020 15:57:37 -0700
Message-ID: <20200603225737.dh0YOpQLO%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW5j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:57:39 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.sourceforge.jp

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
Tested-by: Hoan Tran <hoan@os.amperecomputing.com>	[arm64]
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
