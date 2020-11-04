Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B1FC388F2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7649223FD
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459509;
	bh=2q4gNjgi5NNCgRE2hlEXaTlVTyl2cr46RMtxhkePk8w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=l4mcK9FerPpxNG92IWIu+uPFmzNgdut3qcEKMkrKdXA7NVn30unD/NjgwrZEyxarH
	 4+mKsuFSDPKWpBS+s6cboHIsF+BxU7dHgQJCdZ6e7AQvbX9Mm/fJLauVoI03xErgUb
	 jnCyO/giNLwqnI1gFn4OJGg3Hx5/thEKyvaLkHqA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbgKDDLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:11:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbgKDDLt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:11:49 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B5692067B;
        Wed,  4 Nov 2020 03:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459508;
        bh=2q4gNjgi5NNCgRE2hlEXaTlVTyl2cr46RMtxhkePk8w=;
        h=Date:From:To:Subject:From;
        b=HMzdx8XBhl1/YLapQ/lFlK39xygm8kdCsCn9AdV3X5zLwRuyjpcEfCSD9fqT4BjUK
         khXD5O/hBl7FVrbMvK4Muba/3ZdX65mqZ9GmiHaRrEZiIimQhg2M4zkDk1oHmwR/qa
         YAvq4r3HiqlR/zAQRIo/5yeJSoM7VD/gwWYUkXFQ=
Date:   Tue, 03 Nov 2020 19:11:44 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        tony.luck@intel.com, schmitzmic@gmail.com, mroos@linux.ee,
        mattst88@gmail.com, linux@armlinux.org.uk,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, corbet@lwn.net, catalin.marinas@arm.com,
        adobriyan@gmail.com, rppt@linux.ibm.com
Subject:  +
 =?us-ascii?Q?arc-use-flatmem-with-freeing-of-unused-memory-map-instead-o?=
 =?us-ascii?Q?f-discontigmem.patch?= added to -mm tree
Message-ID: <20201104031144.ip-8N%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arc: use FLATMEM with freeing of unused memory map instead of DISCONTIGMEM
has been added to the -mm tree.  Its filename is
     arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch

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
Subject: arc: use FLATMEM with freeing of unused memory map instead of DISCONTIGMEM

Currently ARC uses DISCONTIGMEM to cope with sparse physical memory address
space on systems with 2 memory banks. While DISCONTIGMEM avoids wasting
memory on unpopulated memory map, it adds both memory and CPU overhead
relatively to FLATMEM. Moreover, DISCONTINGMEM is generally considered
deprecated.

The obvious replacement for DISCONTIGMEM would be SPARSEMEM, but it is also
less efficient than FLATMEM in pfn_to_page() and page_to_pfn() conversions.
Besides it requires tuning of SECTION_SIZE which is not trivial for
possible ARC memory configuration.

Since the memory map for both banks is always allocated from the "lowmem"
bank, it is possible to use FLATMEM for two-bank configuration and simply
free the unused hole in the memory map. All is required for that is to
provide ARC-specific pfn_valid() that will take into account actual
physical memory configuration and define HAVE_ARCH_PFN_VALID.

The resulting kernel image configured with defconfig + HIGHMEM=y is
smaller:

$ size a/vmlinux b/vmlinux
   text    data     bss     dec     hex filename
4673503 1245456  279756 6198715  5e95bb a/vmlinux
4658706 1246864  279756 6185326  5e616e b/vmlinux

$ ./scripts/bloat-o-meter a/vmlinux b/vmlinux
add/remove: 28/30 grow/shrink: 42/399 up/down: 10986/-29025 (-18039)
...
Total: Before=4709315, After=4691276, chg -0.38%

Booting nSIM with haps_ns.dts results in the following memory usage
reports:

a:
Memory: 1559104K/1572864K available (3531K kernel code, 595K rwdata, 752K rodata, 136K init, 275K bss, 13760K reserved, 0K cma-reserved, 1048576K highmem)

b:
Memory: 1559112K/1572864K available (3519K kernel code, 594K rwdata, 752K rodata, 136K init, 280K bss, 13752K reserved, 0K cma-reserved, 1048576K highmem)

Link: https://lkml.kernel.org/r/20201101170454.9567-11-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig            |    3 ++-
 arch/arc/include/asm/page.h |   20 +++++++++++++++++---
 arch/arc/mm/init.c          |   29 ++++++++++++++++++++++-------
 3 files changed, 41 insertions(+), 11 deletions(-)

--- a/arch/arc/include/asm/page.h~arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem
+++ a/arch/arc/include/asm/page.h
@@ -82,11 +82,25 @@ typedef pte_t * pgtable_t;
  */
 #define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
 
-#define ARCH_PFN_OFFSET		virt_to_pfn(CONFIG_LINUX_RAM_BASE)
+/*
+ * When HIGHMEM is enabled we have holes in the memory map so we need
+ * pfn_valid() that takes into account the actual extents of the physical
+ * memory
+ */
+#ifdef CONFIG_HIGHMEM
+
+extern unsigned long arch_pfn_offset;
+#define ARCH_PFN_OFFSET		arch_pfn_offset
 
-#ifdef CONFIG_FLATMEM
+extern int pfn_valid(unsigned long pfn);
+#define pfn_valid		pfn_valid
+
+#else /* CONFIG_HIGHMEM */
+
+#define ARCH_PFN_OFFSET		virt_to_pfn(CONFIG_LINUX_RAM_BASE)
 #define pfn_valid(pfn)		(((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
-#endif
+
+#endif /* CONFIG_HIGHMEM */
 
 /*
  * __pa, __va, virt_to_page (ALERT: deprecated, don't use them)
--- a/arch/arc/Kconfig~arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem
+++ a/arch/arc/Kconfig
@@ -67,6 +67,7 @@ config GENERIC_CSUM
 
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool n
+	depends on BROKEN
 
 config ARCH_FLATMEM_ENABLE
 	def_bool y
@@ -506,7 +507,7 @@ config LINUX_RAM_BASE
 
 config HIGHMEM
 	bool "High Memory Support"
-	select ARCH_DISCONTIGMEM_ENABLE
+	select HAVE_ARCH_PFN_VALID
 	help
 	  With ARC 2G:2G address split, only upper 2G is directly addressable by
 	  kernel. Enable this to potentially allow access to rest of 2G and PAE
--- a/arch/arc/mm/init.c~arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem
+++ a/arch/arc/mm/init.c
@@ -28,6 +28,8 @@ static unsigned long low_mem_sz;
 static unsigned long min_high_pfn, max_high_pfn;
 static phys_addr_t high_mem_start;
 static phys_addr_t high_mem_sz;
+unsigned long arch_pfn_offset;
+EXPORT_SYMBOL(arch_pfn_offset);
 #endif
 
 #ifdef CONFIG_DISCONTIGMEM
@@ -98,16 +100,11 @@ void __init setup_arch_memory(void)
 	init_mm.brk = (unsigned long)_end;
 
 	/* first page of system - kernel .vector starts here */
-	min_low_pfn = ARCH_PFN_OFFSET;
+	min_low_pfn = virt_to_pfn(CONFIG_LINUX_RAM_BASE);
 
 	/* Last usable page of low mem */
 	max_low_pfn = max_pfn = PFN_DOWN(low_mem_start + low_mem_sz);
 
-#ifdef CONFIG_FLATMEM
-	/* pfn_valid() uses this */
-	max_mapnr = max_low_pfn - min_low_pfn;
-#endif
-
 	/*------------- bootmem allocator setup -----------------------*/
 
 	/*
@@ -153,7 +150,9 @@ void __init setup_arch_memory(void)
 	 * DISCONTIGMEM in turns requires multiple nodes. node 0 above is
 	 * populated with normal memory zone while node 1 only has highmem
 	 */
+#ifdef CONFIG_DISCONTIGMEM
 	node_set_online(1);
+#endif
 
 	min_high_pfn = PFN_DOWN(high_mem_start);
 	max_high_pfn = PFN_DOWN(high_mem_start + high_mem_sz);
@@ -161,8 +160,15 @@ void __init setup_arch_memory(void)
 	max_zone_pfn[ZONE_HIGHMEM] = min_low_pfn;
 
 	high_memory = (void *)(min_high_pfn << PAGE_SHIFT);
+
+	arch_pfn_offset = min(min_low_pfn, min_high_pfn);
 	kmap_init();
-#endif
+
+#else /* CONFIG_HIGHMEM */
+	/* pfn_valid() uses this when FLATMEM=y and HIGHMEM=n */
+	max_mapnr = max_low_pfn - min_low_pfn;
+
+#endif /* CONFIG_HIGHMEM */
 
 	free_area_init(max_zone_pfn);
 }
@@ -190,3 +196,12 @@ void __init mem_init(void)
 	highmem_init();
 	mem_init_print_info(NULL);
 }
+
+#ifdef CONFIG_HIGHMEM
+int pfn_valid(unsigned long pfn)
+{
+	return (pfn >= min_high_pfn && pfn <= max_high_pfn) ||
+		(pfn >= min_low_pfn && pfn <= max_low_pfn);
+}
+EXPORT_SYMBOL(pfn_valid);
+#endif
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-introduce-debug_pagealloc_map_pages-helper.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch
alpha-switch-from-discontigmem-to-sparsemem.patch
ia64-remove-custom-__early_pfn_to_nid.patch
ia64-remove-ifdef-config_zone_dma32-statements.patch
ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
ia64-split-virtual-map-initialization-out-of-paging_init.patch
ia64-forbid-using-virtual_mem_map-with-flatmem.patch
ia64-make-sparsemem-default-and-disable-discontigmem.patch
arm-remove-config_arch_has_holes_memorymodel.patch
arm-arm64-move-free_unused_memmap-to-generic-mm.patch
arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
m68k-deprecate-discontigmem.patch

