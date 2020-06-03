From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 027/131] mm: free_area_init: allow defining
 max_zone_pfn in descending order
Date: Wed, 03 Jun 2020 15:58:03 -0700
Message-ID: <20200603225803.QxNH0HPdw%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW6H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:58:07 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, linux@roeck-us.net, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: free_area_init: allow defining max_zone_pfn in descending order

Some architectures (e.g.  ARC) have the ZONE_HIGHMEM zone below the
ZONE_NORMAL.  Allowing free_area_init() parse max_zone_pfn array even it
is sorted in descending order allows using free_area_init() on such
architectures.

Add top -> down traversal of max_zone_pfn array in free_area_init() and
use the latter in ARC node/zone initialization.

[rppt@kernel.org: ARC fix]
  Link: http://lkml.kernel.org/r/20200504153901.GM14260@kernel.org
[rppt@linux.ibm.com: arc: free_area_init(): take into account PAE40 mode]
  Link: http://lkml.kernel.org/r/20200507205900.GH683243@linux.ibm.com
[akpm@linux-foundation.org: declare arch_has_descending_max_zone_pfns()]
Link: http://lkml.kernel.org/r/20200412194859.12663-18-rppt@kernel.org
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
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c |   41 ++++++++++++-----------------------------
 include/linux/mm.h |    1 +
 mm/page_alloc.c    |   26 +++++++++++++++++++++-----
 3 files changed, 34 insertions(+), 34 deletions(-)

--- a/arch/arc/mm/init.c~mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order
+++ a/arch/arc/mm/init.c
@@ -63,11 +63,13 @@ void __init early_init_dt_add_memory_arc
 
 		low_mem_sz = size;
 		in_use = 1;
+		memblock_add_node(base, size, 0);
 	} else {
 #ifdef CONFIG_HIGHMEM
 		high_mem_start = base;
 		high_mem_sz = size;
 		in_use = 1;
+		memblock_add_node(base, size, 1);
 #endif
 	}
 
@@ -75,6 +77,11 @@ void __init early_init_dt_add_memory_arc
 		base, TO_MB(size), !in_use ? "Not used":"");
 }
 
+bool arch_has_descending_max_zone_pfns(void)
+{
+	return !IS_ENABLED(CONFIG_ARC_HAS_PAE40);
+}
+
 /*
  * First memory setup routine called from setup_arch()
  * 1. setup swapper's mm @init_mm
@@ -83,8 +90,7 @@ void __init early_init_dt_add_memory_arc
  */
 void __init setup_arch_memory(void)
 {
-	unsigned long zones_size[MAX_NR_ZONES];
-	unsigned long zones_holes[MAX_NR_ZONES];
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 
 	init_mm.start_code = (unsigned long)_text;
 	init_mm.end_code = (unsigned long)_etext;
@@ -115,7 +121,6 @@ void __init setup_arch_memory(void)
 	 * the crash
 	 */
 
-	memblock_add_node(low_mem_start, low_mem_sz, 0);
 	memblock_reserve(CONFIG_LINUX_LINK_BASE,
 			 __pa(_end) - CONFIG_LINUX_LINK_BASE);
 
@@ -133,22 +138,7 @@ void __init setup_arch_memory(void)
 	memblock_dump_all();
 
 	/*----------------- node/zones setup --------------------------*/
-	memset(zones_size, 0, sizeof(zones_size));
-	memset(zones_holes, 0, sizeof(zones_holes));
-
-	zones_size[ZONE_NORMAL] = max_low_pfn - min_low_pfn;
-	zones_holes[ZONE_NORMAL] = 0;
-
-	/*
-	 * We can't use the helper free_area_init(zones[]) because it uses
-	 * PAGE_OFFSET to compute the @min_low_pfn which would be wrong
-	 * when our kernel doesn't start at PAGE_OFFSET, i.e.
-	 * PAGE_OFFSET != CONFIG_LINUX_RAM_BASE
-	 */
-	free_area_init_node(0,			/* node-id */
-			    zones_size,		/* num pages per zone */
-			    min_low_pfn,	/* first pfn of node */
-			    zones_holes);	/* holes */
+	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
 
 #ifdef CONFIG_HIGHMEM
 	/*
@@ -168,20 +158,13 @@ void __init setup_arch_memory(void)
 	min_high_pfn = PFN_DOWN(high_mem_start);
 	max_high_pfn = PFN_DOWN(high_mem_start + high_mem_sz);
 
-	zones_size[ZONE_NORMAL] = 0;
-	zones_holes[ZONE_NORMAL] = 0;
-
-	zones_size[ZONE_HIGHMEM] = max_high_pfn - min_high_pfn;
-	zones_holes[ZONE_HIGHMEM] = 0;
-
-	free_area_init_node(1,			/* node-id */
-			    zones_size,		/* num pages per zone */
-			    min_high_pfn,	/* first pfn of node */
-			    zones_holes);	/* holes */
+	max_zone_pfn[ZONE_HIGHMEM] = max_high_pfn;
 
 	high_memory = (void *)(min_high_pfn << PAGE_SHIFT);
 	kmap_init();
 #endif
+
+	free_area_init(max_zone_pfn);
 }
 
 /*
--- a/include/linux/mm.h~mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order
+++ a/include/linux/mm.h
@@ -2473,6 +2473,7 @@ extern void setup_per_cpu_pageset(void);
 extern int min_free_kbytes;
 extern int watermark_boost_factor;
 extern int watermark_scale_factor;
+extern bool arch_has_descending_max_zone_pfns(void);
 
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
--- a/mm/page_alloc.c~mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order
+++ a/mm/page_alloc.c
@@ -7408,6 +7408,15 @@ static void check_for_memory(pg_data_t *
 	}
 }
 
+/*
+ * Some architecturs, e.g. ARC may have ZONE_HIGHMEM below ZONE_NORMAL. For
+ * such cases we allow max_zone_pfn sorted in the descending order
+ */
+bool __weak arch_has_descending_max_zone_pfns(void)
+{
+	return false;
+}
+
 /**
  * free_area_init - Initialise all pg_data_t and zone data
  * @max_zone_pfn: an array of max PFNs for each zone
@@ -7424,7 +7433,8 @@ static void check_for_memory(pg_data_t *
 void __init free_area_init(unsigned long *max_zone_pfn)
 {
 	unsigned long start_pfn, end_pfn;
-	int i, nid;
+	int i, nid, zone;
+	bool descending;
 
 	/* Record where the zone boundaries are */
 	memset(arch_zone_lowest_possible_pfn, 0,
@@ -7433,14 +7443,20 @@ void __init free_area_init(unsigned long
 				sizeof(arch_zone_highest_possible_pfn));
 
 	start_pfn = find_min_pfn_with_active_regions();
+	descending = arch_has_descending_max_zone_pfns();
 
 	for (i = 0; i < MAX_NR_ZONES; i++) {
-		if (i == ZONE_MOVABLE)
+		if (descending)
+			zone = MAX_NR_ZONES - i - 1;
+		else
+			zone = i;
+
+		if (zone == ZONE_MOVABLE)
 			continue;
 
-		end_pfn = max(max_zone_pfn[i], start_pfn);
-		arch_zone_lowest_possible_pfn[i] = start_pfn;
-		arch_zone_highest_possible_pfn[i] = end_pfn;
+		end_pfn = max(max_zone_pfn[zone], start_pfn);
+		arch_zone_lowest_possible_pfn[zone] = start_pfn;
+		arch_zone_highest_possible_pfn[zone] = end_pfn;
 
 		start_pfn = end_pfn;
 	}
_
