Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCA3C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84989611C0
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348295AbhIIVEE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348319AbhIIVDU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:03:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CC08611BD;
        Thu,  9 Sep 2021 21:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221330;
        bh=LxRSEIqfg2RFoCtDTjbBjmv0Bie9P0PukmaJhiblO7c=;
        h=Date:From:To:Subject:From;
        b=FrXWeWiNNcG4VaRzt6fMxRwjvpwYCEfYnO129AzM1GaCbAYur9dBPCcj0HfLAOOWO
         Aw639KQMpWS1OAuI4qsYj63I66Dh3A/ZSpgw329F3ZfB9tBrXdAUqfZ4YkQU+td2Tc
         wlcjIrYUnWDbPuIQpf+RkYkxQN2mh/FfsguYAX98=
Date:   Thu, 09 Sep 2021 14:02:10 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, npiggin@gmail.com,
        peterz@infradead.org
Subject:  [merged] mm-move-ioremap_page_range-to-vmallocc.patch
 removed from -mm tree
Message-ID: <20210909210210.QhPyhcsqJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move ioremap_page_range to vmalloc.c
has been removed from the -mm tree.  Its filename was
     mm-move-ioremap_page_range-to-vmallocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: move ioremap_page_range to vmalloc.c

Patch series "small ioremap cleanups".

The first patch moves a little code around the vmalloc/ioremap boundary
following a bigger move by Nick earlier.  The second enforces
non-executable mapping on ioremap just like we do for vmap.  No driver
currently uses executable mappings anyway, as they should.


This patch (of 2):

This keeps it together with the implementation, and to remove the
vmap_range wrapper.

Link: https://lkml.kernel.org/r/20210824091259.1324527-1-hch@lst.de
Link: https://lkml.kernel.org/r/20210824091259.1324527-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    3 ---
 mm/Makefile             |    3 ++-
 mm/ioremap.c            |   25 -------------------------
 mm/vmalloc.c            |   22 +++++++++++++++++-----
 4 files changed, 19 insertions(+), 34 deletions(-)

--- a/include/linux/vmalloc.h~mm-move-ioremap_page_range-to-vmallocc
+++ a/include/linux/vmalloc.h
@@ -225,9 +225,6 @@ static inline bool is_vm_area_hugepages(
 }
 
 #ifdef CONFIG_MMU
-int vmap_range(unsigned long addr, unsigned long end,
-			phys_addr_t phys_addr, pgprot_t prot,
-			unsigned int max_page_shift);
 void vunmap_range(unsigned long addr, unsigned long end);
 static inline void set_vm_flush_reset_perms(void *addr)
 {
--- a/mm/ioremap.c~mm-move-ioremap_page_range-to-vmallocc
+++ a/mm/ioremap.c
@@ -8,33 +8,9 @@
  */
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
-#include <linux/sched.h>
 #include <linux/io.h>
 #include <linux/export.h>
-#include <asm/cacheflush.h>
 
-#include "pgalloc-track.h"
-
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-static unsigned int __ro_after_init iomap_max_page_shift = BITS_PER_LONG - 1;
-
-static int __init set_nohugeiomap(char *str)
-{
-	iomap_max_page_shift = PAGE_SHIFT;
-	return 0;
-}
-early_param("nohugeiomap", set_nohugeiomap);
-#else /* CONFIG_HAVE_ARCH_HUGE_VMAP */
-static const unsigned int iomap_max_page_shift = PAGE_SHIFT;
-#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
-
-int ioremap_page_range(unsigned long addr,
-		       unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
-{
-	return vmap_range(addr, end, phys_addr, prot, iomap_max_page_shift);
-}
-
-#ifdef CONFIG_GENERIC_IOREMAP
 void __iomem *ioremap_prot(phys_addr_t addr, size_t size, unsigned long prot)
 {
 	unsigned long offset, vaddr;
@@ -71,4 +47,3 @@ void iounmap(volatile void __iomem *addr
 	vunmap((void *)((unsigned long)addr & PAGE_MASK));
 }
 EXPORT_SYMBOL(iounmap);
-#endif /* CONFIG_GENERIC_IOREMAP */
--- a/mm/Makefile~mm-move-ioremap_page_range-to-vmallocc
+++ a/mm/Makefile
@@ -38,7 +38,7 @@ mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= highmem.o memory.o mincore.o \
 			   mlock.o mmap.o mmu_gather.o mprotect.o mremap.o \
 			   msync.o page_vma_mapped.o pagewalk.o \
-			   pgtable-generic.o rmap.o vmalloc.o ioremap.o
+			   pgtable-generic.o rmap.o vmalloc.o
 
 
 ifdef CONFIG_CROSS_MEMORY_ATTACH
@@ -128,3 +128,4 @@ obj-$(CONFIG_PTDUMP_CORE) += ptdump.o
 obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
 obj-$(CONFIG_IO_MAPPING) += io-mapping.o
 obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
+obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
--- a/mm/vmalloc.c~mm-move-ioremap_page_range-to-vmallocc
+++ a/mm/vmalloc.c
@@ -44,6 +44,19 @@
 #include "internal.h"
 #include "pgalloc-track.h"
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+static unsigned int __ro_after_init ioremap_max_page_shift = BITS_PER_LONG - 1;
+
+static int __init set_nohugeiomap(char *str)
+{
+	ioremap_max_page_shift = PAGE_SHIFT;
+	return 0;
+}
+early_param("nohugeiomap", set_nohugeiomap);
+#else /* CONFIG_HAVE_ARCH_HUGE_VMAP */
+static const unsigned int ioremap_max_page_shift = PAGE_SHIFT;
+#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
+
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
 static bool __ro_after_init vmap_allow_huge = true;
 
@@ -298,15 +311,14 @@ static int vmap_range_noflush(unsigned l
 	return err;
 }
 
-int vmap_range(unsigned long addr, unsigned long end,
-			phys_addr_t phys_addr, pgprot_t prot,
-			unsigned int max_page_shift)
+int ioremap_page_range(unsigned long addr, unsigned long end,
+		phys_addr_t phys_addr, pgprot_t prot)
 {
 	int err;
 
-	err = vmap_range_noflush(addr, end, phys_addr, prot, max_page_shift);
+	err = vmap_range_noflush(addr, end, phys_addr, prot,
+				 ioremap_max_page_shift);
 	flush_cache_vmap(addr, end);
-
 	return err;
 }
 
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

