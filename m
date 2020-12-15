Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039DFC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD4B6224B1
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgLODMZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727657AbgLODMP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:15 -0500
Date:   Mon, 14 Dec 2020 19:09:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001769;
        bh=8tr3WEpnesS0vWwhNSOvE/GWMZu3PtFrtQnYh2A80hE=;
        h=From:To:Subject:In-Reply-To:From;
        b=RTTHNlN+BIyHYjZE7/e+VoHNzktrNd7uCzg2D0crukbr4gmLRDLo5bAGbtIWPzh/n
         i7S+/AUqmzlNxFrWv/RgsSdwXzWKLl6F1/e5rsBtcV7Qz1EmgEbBj2wIQ5u4RZ7Ksw
         GO+UskvKRRbu/iOzHR8u2m6D53+p0DtFjRnrzpZI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org,
        gerg@linux-m68k.org, glaubitz@physik.fu-berlin.de,
        linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com,
        mm-commits@vger.kernel.org, mroos@linux.ee, rppt@linux.ibm.com,
        schmitzmic@gmail.com, tony.luck@intel.com,
        torvalds@linux-foundation.org, vgupta@synopsys.com, will@kernel.org
Subject:  [patch 106/200] alpha: switch from DISCONTIGMEM to
 SPARSEMEM
Message-ID: <20201215030928.gbkxQ3DC3%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
