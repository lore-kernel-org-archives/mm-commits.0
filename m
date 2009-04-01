From: akpm@linux-foundation.org
Subject: + xtensa-cope-with-ram-beginning-at-higher-addresses.patch added to -mm tree
Date: Wed, 01 Apr 2009 13:14:44 -0700
Message-ID: <200904012014.n31KEjAa004122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761162AbZDAUR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 16:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jw@emlix.com, chris@zankel.net, os@emlix.com


The patch titled
     xtensa: cope with ram beginning at higher addresses
has been added to the -mm tree.  Its filename is
     xtensa-cope-with-ram-beginning-at-higher-addresses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
xtensa-remove-redefinition-of-xchal_mmu_asid_bits.patch
xtensa-use-correct-stack-pointer-for-stack-traces.patch
xtensa-fix-init_bootmem_node-argument-order.patch
xtensa-dont-make-bootmem-bitmap-larger-than-required.patch
xtensa-cope-with-ram-beginning-at-higher-addresses.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch

