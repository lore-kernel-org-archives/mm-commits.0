From: akpm@linux-foundation.org
Subject: [merged] xtensa-cope-with-ram-beginning-at-higher-addresses.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:54 -0700
Message-ID: <200904061939.n36JdsKu014063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753882AbZDFTnO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:43:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jw@emlix.com, chris@zankel.net, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: cope with ram beginning at higher addresses
has been removed from the -mm tree.  Its filename was
     xtensa-cope-with-ram-beginning-at-higher-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: cope with ram beginning at higher addresses
From: Johannes Weiner <jw@emlix.com>

The current assumption of the memory code is that the first RAM PFN in
the system is 0.

Adjust the relevant code to play well with setups where memory starts
at higher addresses, indicated by PLATFORM_DEFAULT_MEM_START.

The new memory model looks like this:

+----------+--+----------------------+----------------+
|          |  |                      |                |
|          |  |         RAM          |                |
|          |  |                      |                |
+----------+--+----------------------+----------------+
|          |  |                      |                |
+- PFN 0   |  +- min_low_pfn         +- max_low_pfn   +- max_pfn
           |
           +- ARCH_PFN_OFFSET
           +- PLATFORM_DEFAULT_MEM_START >> PAGE_SIZE

The memory map contains pages starting from pfn ARCH_PFN_OFFSET up to
max_low_pfn.  The only zone used right now will span exactly the same
region.

Usually, ARCH_PFN_OFFSET and min_low_pfn are the same value.  Handle
them separately for robustness.  Gapping pages will be in the memory
map but marked as reserved and won't be touched.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/page.h |    5 ++++-
 arch/xtensa/mm/init.c          |   10 +++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff -puN arch/xtensa/include/asm/page.h~xtensa-cope-with-ram-beginning-at-higher-addresses arch/xtensa/include/asm/page.h
--- a/arch/xtensa/include/asm/page.h~xtensa-cope-with-ram-beginning-at-higher-addresses
+++ a/arch/xtensa/include/asm/page.h
@@ -14,6 +14,7 @@
 #include <asm/processor.h>
 #include <asm/types.h>
 #include <asm/cache.h>
+#include <platform/hardware.h>
 
 /*
  * Fixed TLB translations in the processor.
@@ -156,9 +157,11 @@ extern void copy_user_page(void*, void*,
  * addresses.
  */
 
+#define ARCH_PFN_OFFSET		(PLATFORM_DEFAULT_MEM_START >> PAGE_SHIFT)
+
 #define __pa(x)			((unsigned long) (x) - PAGE_OFFSET)
 #define __va(x)			((void *)((unsigned long) (x) + PAGE_OFFSET))
-#define pfn_valid(pfn)		((unsigned long)pfn < max_mapnr)
+#define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET && ((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
 #ifdef CONFIG_DISCONTIGMEM
 # error CONFIG_DISCONTIGMEM not supported
 #endif
diff -puN arch/xtensa/mm/init.c~xtensa-cope-with-ram-beginning-at-higher-addresses arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~xtensa-cope-with-ram-beginning-at-higher-addresses
+++ a/arch/xtensa/mm/init.c
@@ -160,7 +160,7 @@ void __init zones_init(void)
 
 	/* All pages are DMA-able, so we put them all in the DMA zone. */
 
-	zones_size[ZONE_DMA] = max_low_pfn;
+	zones_size[ZONE_DMA] = max_low_pfn - ARCH_PFN_OFFSET;
 	for (i = 1; i < MAX_NR_ZONES; i++)
 		zones_size[i] = 0;
 
@@ -168,7 +168,7 @@ void __init zones_init(void)
 	zones_size[ZONE_HIGHMEM] = max_pfn - max_low_pfn;
 #endif
 
-	free_area_init(zones_size);
+	free_area_init_node(0, zones_size, ARCH_PFN_OFFSET, NULL);
 }
 
 /*
@@ -180,8 +180,8 @@ void __init mem_init(void)
 	unsigned long codesize, reservedpages, datasize, initsize;
 	unsigned long highmemsize, tmp, ram;
 
-	max_mapnr = num_physpages = max_low_pfn;
-	high_memory = (void *) __va(max_mapnr << PAGE_SHIFT);
+	max_mapnr = num_physpages = max_low_pfn - ARCH_PFN_OFFSET;
+	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 	highmemsize = 0;
 
 #ifdef CONFIG_HIGHMEM
@@ -191,7 +191,7 @@ void __init mem_init(void)
 	totalram_pages += free_all_bootmem();
 
 	reservedpages = ram = 0;
-	for (tmp = 0; tmp < max_low_pfn; tmp++) {
+	for (tmp = 0; tmp < max_mapnr; tmp++) {
 		ram++;
 		if (PageReserved(mem_map+tmp))
 			reservedpages++;
_

Patches currently in -mm which might be from jw@emlix.com are

origin.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-variant-specific-code.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch

