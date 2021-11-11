Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5F7C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC12B61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhKKCtJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCtJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A750E61247;
        Thu, 11 Nov 2021 02:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598780;
        bh=rM1JL+ZaTOAztLPQtG3kx3z4nZ0M2iDjAlMpCjAI92k=;
        h=Date:From:To:Subject:From;
        b=DbrXTZEo58fNiCSGq044cMyTAcg3b7XrQBLtTMQ9i+IvZXt/iNaGnWyYvo3VWNs+d
         7CkmyMYTLdYTDanTjt+TmmaCWnJggfgfdVc4YcJa0+LjUEEI4XK28iVfp+arJGSA+l
         tYhUDouGDMGy904h5NGKbFPNTLhmhgs8yXva2Sao=
Date:   Wed, 10 Nov 2021 18:46:20 -0800
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, jgross@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        Shahab.Vahedi@synopsys.com
Subject:  [merged]
 memblock-drop-memblock_free_early_nid-and-memblock_free_early.patch removed
 from -mm tree
Message-ID: <20211111024620.HWScOjSFB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: drop memblock_free_early_nid() and memblock_free_early()
has been removed from the -mm tree.  Its filename was
     memblock-drop-memblock_free_early_nid-and-memblock_free_early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: drop memblock_free_early_nid() and memblock_free_early()

memblock_free_early_nid() is unused and memblock_free_early() is an alias
for memblock_free().

Replace calls to memblock_free_early() with calls to memblock_free() and
remove memblock_free_early() and memblock_free_early_nid().

Link: https://lkml.kernel.org/r/20210930185031.18648-4-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Juergen Gross <jgross@suse.com>
Cc: Shahab Vahedi <Shahab.Vahedi@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/init.c                  |    2 +-
 arch/powerpc/platforms/pseries/svm.c |    3 +--
 arch/s390/kernel/smp.c               |    2 +-
 drivers/base/arch_numa.c             |    2 +-
 drivers/s390/char/sclp_early.c       |    2 +-
 include/linux/memblock.h             |   12 ------------
 kernel/dma/swiotlb.c                 |    2 +-
 lib/cpumask.c                        |    2 +-
 mm/percpu.c                          |    8 ++++----
 mm/sparse.c                          |    2 +-
 10 files changed, 12 insertions(+), 25 deletions(-)

--- a/arch/mips/mm/init.c~memblock-drop-memblock_free_early_nid-and-memblock_free_early
+++ a/arch/mips/mm/init.c
@@ -529,7 +529,7 @@ static void * __init pcpu_fc_alloc(unsig
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
 {
-	memblock_free_early(__pa(ptr), size);
+	memblock_free(__pa(ptr), size);
 }
 
 void __init setup_per_cpu_areas(void)
--- a/arch/powerpc/platforms/pseries/svm.c~memblock-drop-memblock_free_early_nid-and-memblock_free_early
+++ a/arch/powerpc/platforms/pseries/svm.c
@@ -56,8 +56,7 @@ void __init svm_swiotlb_init(void)
 		return;
 
 
-	memblock_free_early(__pa(vstart),
-			    PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
+	memblock_free(__pa(vstart), PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
 	panic("SVM: Cannot allocate SWIOTLB buffer");
 }
 
--- a/arch/s390/kernel/smp.c~memblock-drop-memblock_free_early_nid-and-memblock_free_early
+++ a/arch/s390/kernel/smp.c
@@ -880,7 +880,7 @@ void __init smp_detect_cpus(void)
 
 	/* Add CPUs present at boot */
 	__smp_rescan_cpus(info, true);
-	memblock_free_early((unsigned long)info, sizeof(*info));
+	memblock_free((unsigned long)info, sizeof(*info));
 }
 
 /*
--- a/drivers/base/arch_numa.c~memblock-drop-memblock_free_early_nid-and-memblock_free_early
+++ a/drivers/base/arch_numa.c
@@ -166,7 +166,7 @@ static void * __init pcpu_fc_alloc(unsig
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
 {
-	memblock_free_early(__pa(ptr), size);
+	memblock_free(__pa(ptr), size);
 }
 
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
--- a/drivers/s390/char/sclp_early.c~memblock-drop-memblock_free_early_nid-and-memblock_free_early
+++ a/drivers/s390/char/sclp_early.c
@@ -139,7 +139,7 @@ int __init sclp_early_get_core_info(stru
 	}
 	sclp_fill_core_info(info, sccb);
 out:
-	memblock_free_early((unsigned long)sccb, length);
+	memblock_free((unsigned long)sccb, length);
 	return rc;
 }
 
--- a/include/linux/memblock.h~memblock-drop-memblock_free_early_nid-and-memblock_free_early
+++ a/include/linux/memblock.h
@@ -441,18 +441,6 @@ static inline void *memblock_alloc_node(
 				      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
 }
 
-static inline void memblock_free_early(phys_addr_t base,
-					      phys_addr_t size)
-{
-	memblock_free(base, size);
-}
-
-static inline void memblock_free_early_nid(phys_addr_t base,
-						  phys_addr_t size, int nid)
-{
-	memblock_free(base, size);
-}
-
 static inline void memblock_free_late(phys_addr_t base, phys_addr_t size)
 {
 	__memblock_free_late(base, size);
--- a/kernel/dma/swiotlb.c~memblock-drop-memblock_free_early_nid-and-memblock_free_early
+++ a/kernel/dma/swiotlb.c
@@ -247,7 +247,7 @@ swiotlb_init(int verbose)
 	return;
 
 fail_free_mem:
-	memblock_free_early(__pa(tlb), bytes);
+	memblock_free(__pa(tlb), bytes);
 fail:
 	pr_warn("Cannot allocate buffer");
 }
--- a/lib/cpumask.c~memblock-drop-memblock_free_early_nid-and-memblock_free_early
+++ a/lib/cpumask.c
@@ -188,7 +188,7 @@ EXPORT_SYMBOL(free_cpumask_var);
  */
 void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 {
-	memblock_free_early(__pa(mask), cpumask_size());
+	memblock_free(__pa(mask), cpumask_size());
 }
 #endif
 
--- a/mm/percpu.c~memblock-drop-memblock_free_early_nid-and-memblock_free_early
+++ a/mm/percpu.c
@@ -2472,7 +2472,7 @@ struct pcpu_alloc_info * __init pcpu_all
  */
 void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai)
 {
-	memblock_free_early(__pa(ai), ai->__ai_size);
+	memblock_free(__pa(ai), ai->__ai_size);
 }
 
 /**
@@ -3134,7 +3134,7 @@ out_free_areas:
 out_free:
 	pcpu_free_alloc_info(ai);
 	if (areas)
-		memblock_free_early(__pa(areas), areas_size);
+		memblock_free(__pa(areas), areas_size);
 	return rc;
 }
 #endif /* BUILD_EMBED_FIRST_CHUNK */
@@ -3256,7 +3256,7 @@ enomem:
 		free_fn(page_address(pages[j]), PAGE_SIZE);
 	rc = -ENOMEM;
 out_free_ar:
-	memblock_free_early(__pa(pages), pages_size);
+	memblock_free(__pa(pages), pages_size);
 	pcpu_free_alloc_info(ai);
 	return rc;
 }
@@ -3286,7 +3286,7 @@ static void * __init pcpu_dfl_fc_alloc(u
 
 static void __init pcpu_dfl_fc_free(void *ptr, size_t size)
 {
-	memblock_free_early(__pa(ptr), size);
+	memblock_free(__pa(ptr), size);
 }
 
 void __init setup_per_cpu_areas(void)
--- a/mm/sparse.c~memblock-drop-memblock_free_early_nid-and-memblock_free_early
+++ a/mm/sparse.c
@@ -451,7 +451,7 @@ static void *sparsemap_buf_end __meminit
 static inline void __meminit sparse_buffer_free(unsigned long size)
 {
 	WARN_ON(!sparsemap_buf || size == 0);
-	memblock_free_early(__pa(sparsemap_buf), size);
+	memblock_free(__pa(sparsemap_buf), size);
 }
 
 static void __init sparse_buffer_init(unsigned long size, int nid)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


