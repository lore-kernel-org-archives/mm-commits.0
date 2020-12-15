Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27DEC49EBE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C3F222CAE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgLOX7P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgLOXWk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:40 -0500
Date:   Tue, 15 Dec 2020 15:21:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074469;
        bh=oVH5QwoNp/Mo8BcYiYw3iVGdPOpuv9EJwISRaMHbRWo=;
        h=From:To:Subject:From;
        b=2qa+vTfuZMU7QflllzjjhB/OQVe2tzMneAVKmF8+9MnTUwQwiL12b2abkqX1yngEE
         GAK4oXSsTNWjbaA9Cs1KUvQSUUsYjRHhIdgRCcPDPr+hiGe43pf4k7BDqMfXjeLPe2
         rpxU43IxkYeoibo7fiB2AXfh91aoDNJF2IemQbe8=
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, catalin.marinas@arm.com, corbet@lwn.net,
        geert@linux-m68k.org, gerg@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, linux@armlinux.org.uk,
        mattst88@gmail.com, mm-commits@vger.kernel.org, mroos@linux.ee,
        rppt@linux.ibm.com, schmitzmic@gmail.com, tony.luck@intel.com,
        vgupta@synopsys.com, will@kernel.org
Subject:  [merged]
 m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch removed
 from -mm tree
Message-ID: <20201215232108.q32WW_hYn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k/mm: enable use of generic memory_model.h for !DISCONTIGMEM
has been removed from the -mm tree.  Its filename was
     m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

