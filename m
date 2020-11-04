Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1B3C2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54492223FB
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459458;
	bh=yS//EAUcytoqSL4exDU9mn7T+1TXklxN2+fXwU3f0oc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Mh6L2sQsFrAQk/wpEKmyit0lzouWo9iz4QdBsHIA74gYm5teBcOQvBT74zgbchMRt
	 NWrrUYP5XlG7FC1N1zemhHakd66dDxf7PtQUwDTOVUzn3uMHN2h2autRIWY8MVEQjE
	 XjwHuB0PxvfxEqXJ8n4hdyFw2j9/KZ/DilNqSuyM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgKDDK5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbgKDDK5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:10:57 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90417223BF;
        Wed,  4 Nov 2020 03:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459456;
        bh=yS//EAUcytoqSL4exDU9mn7T+1TXklxN2+fXwU3f0oc=;
        h=Date:From:To:Subject:From;
        b=aua2dCKZmbguxNisXCIgrbqs3RGOVEVYMFzYFfWfFfsxKrhWDHT9yk4R9DtFt0GTE
         ZU2ca9TVG4R/zaDkYV+z7OE2x18vB8rbTMvt8hGAgymbYVd1nh9Ysu6nebg1ZU0SYY
         5CyCZB50z7WZJ3JVMvA1tJQBSI3kJkYOBgN9VsnI=
Date:   Tue, 03 Nov 2020 19:10:54 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        tony.luck@intel.com, schmitzmic@gmail.com, mroos@linux.ee,
        mattst88@gmail.com, linux@armlinux.org.uk,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, corbet@lwn.net, catalin.marinas@arm.com,
        adobriyan@gmail.com, rppt@linux.ibm.com
Subject:  + alpha-switch-from-discontigmem-to-sparsemem.patch added
 to -mm tree
Message-ID: <20201104031054.9knSi%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: switch from DISCONTIGMEM to SPARSEMEM
has been added to the -mm tree.  Its filename is
     alpha-switch-from-discontigmem-to-sparsemem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/alpha-switch-from-discontigmem-to-sparsemem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/alpha-switch-from-discontigmem-to-sparsemem.patch

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
Subject: alpha: switch from DISCONTIGMEM to SPARSEMEM

Patch series "arch, mm: deprecate DISCONTIGMEM", v2.

It's been a while since DISCONTIGMEM is generally considered deprecated,
but it is still used by four architectures.  This set replaces
DISCONTIGMEM with a different way to handle holes in the memory map and
marks DISCONTIGMEM configuration as BROKEN in Kconfigs of these
architectures with the intention to completely remove it in several
releases.

While for 64-bit alpha and ia64 the switch to SPARSEMEM is quite obvious
and was a matter of moving some bits around, for smaller 32-bit arc and
m68k SPARSEMEM is not necessarily the best thing to do.

On 32-bit machines SPARSEMEM would require large sections to make section
index fit in the page flags, but larger sections mean that more memory is
wasted for unused memory map.

Besides, pfn_to_page() and page_to_pfn() become less efficient, at least
on arc.

So I've decided to generalize arm's approach for freeing of unused parts
of the memory map with FLATMEM and enable it for both arc and m68k.  The
details are in the description of patches 10 (arc) and 13 (m68k).


This patch (of 13):

Enable SPARSEMEM support on alpha and deprecate DISCONTIGMEM.

The required changes are mostly around moving duplicated definitions of
page access and address conversion macros to a common place and making sure
they are available for all memory models.

The DISCONTINGMEM support is marked as BROKEN an will be removed in a
couple of releases.

Link: https://lkml.kernel.org/r/20201101170454.9567-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20201101170454.9567-2-rppt@kernel.org
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

 arch/alpha/Kconfig                 |    8 ++++++++
 arch/alpha/include/asm/mmzone.h    |   14 ++------------
 arch/alpha/include/asm/page.h      |    7 ++++---
 arch/alpha/include/asm/pgtable.h   |   12 +++++-------
 arch/alpha/include/asm/sparsemem.h |   18 ++++++++++++++++++
 arch/alpha/kernel/setup.c          |    1 +
 6 files changed, 38 insertions(+), 22 deletions(-)

--- a/arch/alpha/include/asm/mmzone.h~alpha-switch-from-discontigmem-to-sparsemem
+++ a/arch/alpha/include/asm/mmzone.h
@@ -6,6 +6,8 @@
 #ifndef _ASM_MMZONE_H_
 #define _ASM_MMZONE_H_
 
+#ifdef CONFIG_DISCONTIGMEM
+
 #include <asm/smp.h>
 
 /*
@@ -45,8 +47,6 @@ PLAT_NODE_DATA_LOCALNR(unsigned long p,
 }
 #endif
 
-#ifdef CONFIG_DISCONTIGMEM
-
 /*
  * Following are macros that each numa implementation must define.
  */
@@ -68,11 +68,6 @@ PLAT_NODE_DATA_LOCALNR(unsigned long p,
 /* XXX: FIXME -- nyc */
 #define kern_addr_valid(kaddr)	(0)
 
-#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
-
-#define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> 32))
-#define pte_pfn(pte)		(pte_val(pte) >> 32)
-
 #define mk_pte(page, pgprot)						     \
 ({								 	     \
 	pte_t pte;                                                           \
@@ -95,16 +90,11 @@ PLAT_NODE_DATA_LOCALNR(unsigned long p,
 	__xx;                                                           \
 })
 
-#define page_to_pa(page)						\
-	(page_to_pfn(page) << PAGE_SHIFT)
-
 #define pfn_to_nid(pfn)		pa_to_nid(((u64)(pfn) << PAGE_SHIFT))
 #define pfn_valid(pfn)							\
 	(((pfn) - node_start_pfn(pfn_to_nid(pfn))) <			\
 	 node_spanned_pages(pfn_to_nid(pfn)))					\
 
-#define virt_addr_valid(kaddr)	pfn_valid((__pa(kaddr) >> PAGE_SHIFT))
-
 #endif /* CONFIG_DISCONTIGMEM */
 
 #endif /* _ASM_MMZONE_H_ */
--- a/arch/alpha/include/asm/page.h~alpha-switch-from-discontigmem-to-sparsemem
+++ a/arch/alpha/include/asm/page.h
@@ -83,12 +83,13 @@ typedef struct page *pgtable_t;
 
 #define __pa(x)			((unsigned long) (x) - PAGE_OFFSET)
 #define __va(x)			((void *)((unsigned long) (x) + PAGE_OFFSET))
-#ifndef CONFIG_DISCONTIGMEM
+
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
+#define virt_addr_valid(kaddr)	pfn_valid((__pa(kaddr) >> PAGE_SHIFT))
 
+#ifdef CONFIG_FLATMEM
 #define pfn_valid(pfn)		((pfn) < max_mapnr)
-#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
-#endif /* CONFIG_DISCONTIGMEM */
+#endif /* CONFIG_FLATMEM */
 
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
--- a/arch/alpha/include/asm/pgtable.h~alpha-switch-from-discontigmem-to-sparsemem
+++ a/arch/alpha/include/asm/pgtable.h
@@ -203,10 +203,10 @@ extern unsigned long __zero_page(void);
  * Conversion functions:  convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  */
-#ifndef CONFIG_DISCONTIGMEM
-#define page_to_pa(page)	(((page) - mem_map) << PAGE_SHIFT)
-
+#define page_to_pa(page)	(page_to_pfn(page) << PAGE_SHIFT)
 #define pte_pfn(pte)	(pte_val(pte) >> 32)
+
+#ifndef CONFIG_DISCONTIGMEM
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 #define mk_pte(page, pgprot)						\
 ({									\
@@ -236,10 +236,8 @@ pmd_page_vaddr(pmd_t pmd)
 	return ((pmd_val(pmd) & _PFN_MASK) >> (32-PAGE_SHIFT)) + PAGE_OFFSET;
 }
 
-#ifndef CONFIG_DISCONTIGMEM
-#define pmd_page(pmd)	(mem_map + ((pmd_val(pmd) & _PFN_MASK) >> 32))
-#define pud_page(pud)	(mem_map + ((pud_val(pud) & _PFN_MASK) >> 32))
-#endif
+#define pmd_page(pmd)	(pfn_to_page(pmd_val(pmd) >> 32))
+#define pud_page(pud)	(pfn_to_page(pud_val(pud) >> 32))
 
 extern inline unsigned long pud_page_vaddr(pud_t pgd)
 { return PAGE_OFFSET + ((pud_val(pgd) & _PFN_MASK) >> (32-PAGE_SHIFT)); }
--- /dev/null
+++ a/arch/alpha/include/asm/sparsemem.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ALPHA_SPARSEMEM_H
+#define _ASM_ALPHA_SPARSEMEM_H
+
+#ifdef CONFIG_SPARSEMEM
+
+#define SECTION_SIZE_BITS	27
+
+/*
+ * According to "Alpha Architecture Reference Manual" physical
+ * addresses are at most 48 bits.
+ * https://download.majix.org/dec/alpha_arch_ref.pdf
+ */
+#define MAX_PHYSMEM_BITS	48
+
+#endif /* CONFIG_SPARSEMEM */
+
+#endif /* _ASM_ALPHA_SPARSEMEM_H */
--- a/arch/alpha/Kconfig~alpha-switch-from-discontigmem-to-sparsemem
+++ a/arch/alpha/Kconfig
@@ -40,6 +40,7 @@ config ALPHA
 	select CPU_NO_EFFICIENT_FFS if !ALPHA_EV67
 	select MMU_GATHER_NO_RANGE
 	select SET_FS
+	select SPARSEMEM_EXTREME if SPARSEMEM
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
@@ -551,12 +552,19 @@ config NR_CPUS
 
 config ARCH_DISCONTIGMEM_ENABLE
 	bool "Discontiguous Memory Support"
+	depends on BROKEN
 	help
 	  Say Y to support efficient handling of discontiguous physical memory,
 	  for architectures which are either NUMA (Non-Uniform Memory Access)
 	  or have huge holes in the physical address space for other reasons.
 	  See <file:Documentation/vm/numa.rst> for more.
 
+config ARCH_SPARSEMEM_ENABLE
+	bool "Sparse Memory Support"
+	help
+	  Say Y to support efficient handling of discontiguous physical memory,
+	  for systems that have huge holes in the physical address space.
+
 config NUMA
 	bool "NUMA Support (EXPERIMENTAL)"
 	depends on DISCONTIGMEM && BROKEN
--- a/arch/alpha/kernel/setup.c~alpha-switch-from-discontigmem-to-sparsemem
+++ a/arch/alpha/kernel/setup.c
@@ -648,6 +648,7 @@ setup_arch(char **cmdline_p)
 	/* Find our memory.  */
 	setup_memory(kernel_end);
 	memblock_set_bottom_up(true);
+	sparse_init();
 
 	/* First guess at cpu cache sizes.  Do this before init_arch.  */
 	determine_cpu_caches(cpu->type);
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

