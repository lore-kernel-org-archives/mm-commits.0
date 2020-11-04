Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6C5C2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D644223C7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459533;
	bh=4z4sFTd41ugwEjIiUDvhwPtLTsQ9gIpd4oHlXtU8nv8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Yc4bWQ5uNb8JLgbooQcaFWiG+i2AXWz4IkvgezneJ3Cf76y3262UGvaSspuRCJRoc
	 zuAmCQwgmitxTiNSIA2XvtNMnT+QjHt3ydJSdq/pHc303CiAQqHzOMnJ+w97mEsr64
	 X36WbfBNASHo0+M3F5DyZrEdabRxOdCETecaL9tc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbgKDDMM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:12:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730081AbgKDDMM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:12:12 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22EF92067B;
        Wed,  4 Nov 2020 03:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459531;
        bh=4z4sFTd41ugwEjIiUDvhwPtLTsQ9gIpd4oHlXtU8nv8=;
        h=Date:From:To:Subject:From;
        b=U+/TI/BL54GvmbuVwrYO1nYzurWLZ4rN7FC4CDYpwI+8Gl45gGOUOP/bp9r6n2d52
         ix9f09RdYE5bquQVz+SLqE5IDXGV1BmEArlqEDf0YZMNsUhSFnEiZxWpOYGOEbGf6b
         GHAN8tW4XNC8AQrAgEhGK6OR+pEykvkiorVWuFoI=
Date:   Tue, 03 Nov 2020 19:12:07 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        tony.luck@intel.com, schmitzmic@gmail.com, mroos@linux.ee,
        mattst88@gmail.com, linux@armlinux.org.uk,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, corbet@lwn.net, catalin.marinas@arm.com,
        adobriyan@gmail.com, rppt@linux.ibm.com
Subject:  +
 m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch added to
 -mm tree
Message-ID: <20201104031207.b557t%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k/mm: enable use of generic memory_model.h for !DISCONTIGMEM
has been added to the -mm tree.  Its filename is
     m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch

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
Subject: m68k/mm: enable use of generic memory_model.h for !DISCONTIGMEM

The pg_data_map and pg_data_table arrays as well as page_to_pfn() and
pfn_to_page() are required only for DISCONTIGMEM. Other memory models can
use the generic definitions in asm-generic/memory_model.h.

Link: https://lkml.kernel.org/r/20201101170454.9567-13-rppt@kernel.org
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

 arch/m68k/Kconfig.cpu               |    1 -
 arch/m68k/include/asm/page.h        |    2 ++
 arch/m68k/include/asm/page_mm.h     |    5 +++++
 arch/m68k/include/asm/virtconvert.h |    5 -----
 arch/m68k/mm/init.c                 |    6 +++---
 5 files changed, 10 insertions(+), 9 deletions(-)

--- a/arch/m68k/include/asm/page.h~m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem
+++ a/arch/m68k/include/asm/page.h
@@ -62,8 +62,10 @@ extern unsigned long _ramend;
 #include <asm/page_no.h>
 #endif
 
+#ifdef CONFIG_DISCONTIGMEM
 #define __phys_to_pfn(paddr)	((unsigned long)((paddr) >> PAGE_SHIFT))
 #define __pfn_to_phys(pfn)	PFN_PHYS(pfn)
+#endif
 
 #include <asm-generic/getorder.h>
 
--- a/arch/m68k/include/asm/page_mm.h~m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem
+++ a/arch/m68k/include/asm/page_mm.h
@@ -153,6 +153,7 @@ static inline __attribute_const__ int __
 	pfn_to_virt(page_to_pfn(page));					\
 })
 
+#ifdef CONFIG_DISCONTIGMEM
 #define pfn_to_page(pfn) ({						\
 	unsigned long __pfn = (pfn);					\
 	struct pglist_data *pgdat;					\
@@ -165,6 +166,10 @@ static inline __attribute_const__ int __
 	pgdat = &pg_data_map[page_to_nid(__p)];				\
 	((__p) - pgdat->node_mem_map) + pgdat->node_start_pfn;		\
 })
+#else
+#define ARCH_PFN_OFFSET (m68k_memory[0].addr)
+#include <asm-generic/memory_model.h>
+#endif
 
 #define virt_addr_valid(kaddr)	((void *)(kaddr) >= (void *)PAGE_OFFSET && (void *)(kaddr) < high_memory)
 #define pfn_valid(pfn)		virt_addr_valid(pfn_to_virt(pfn))
--- a/arch/m68k/include/asm/virtconvert.h~m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem
+++ a/arch/m68k/include/asm/virtconvert.h
@@ -29,12 +29,7 @@ static inline void *phys_to_virt(unsigne
 }
 
 /* Permanent address of a page. */
-#if defined(CONFIG_MMU) && !defined(CONFIG_DISCONTIGMEM)
-#define page_to_phys(page) \
-	__pa(PAGE_OFFSET + (((page) - pg_data_map[0].node_mem_map) << PAGE_SHIFT))
-#else
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
-#endif
 
 /*
  * IO bus memory addresses are 1:1 with the physical address,
--- a/arch/m68k/Kconfig.cpu~m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem
+++ a/arch/m68k/Kconfig.cpu
@@ -374,7 +374,6 @@ config SINGLE_MEMORY_CHUNK
 	bool "Use one physical chunk of memory only" if ADVANCED && !SUN3
 	depends on MMU
 	default y if SUN3 || MMU_COLDFIRE
-	select NEED_MULTIPLE_NODES
 	help
 	  Ignore all but the first contiguous chunk of physical memory for VM
 	  purposes.  This will save a few bytes kernel size and may speed up
--- a/arch/m68k/mm/init.c~m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem
+++ a/arch/m68k/mm/init.c
@@ -42,12 +42,12 @@ EXPORT_SYMBOL(empty_zero_page);
 
 #ifdef CONFIG_MMU
 
-pg_data_t pg_data_map[MAX_NUMNODES];
-EXPORT_SYMBOL(pg_data_map);
-
 int m68k_virt_to_node_shift;
 
 #ifdef CONFIG_DISCONTIGMEM
+pg_data_t pg_data_map[MAX_NUMNODES];
+EXPORT_SYMBOL(pg_data_map);
+
 pg_data_t *pg_data_table[65];
 EXPORT_SYMBOL(pg_data_table);
 #endif
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

