Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A13C433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD16921941
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600295947;
	bh=XtmqDfdbZ9OHXTRtPQVt3sZPIvrIs2tkJUtwKpyRoC0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ad9aVg4GwadDS4ajlQZA+Qf0TvD7w5KkqiHcRezAvK38gKeHl/SF95Ued6iI8KLQa
	 EJOg6241tWaQ/zHYlEBj9JArd/RX09doBfXQywdENVN3OJvclUIMmLWba7V96cib3F
	 08YX1GjiowG4oEn2GsIFdyUuJEBo8Z/o6N6q7ZZA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgIPWjG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 18:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgIPWjB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 18:39:01 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9936620732;
        Wed, 16 Sep 2020 22:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600295941;
        bh=XtmqDfdbZ9OHXTRtPQVt3sZPIvrIs2tkJUtwKpyRoC0=;
        h=Date:From:To:Subject:From;
        b=1qUdU+8qjkuATLj7jq5a2CC6ua746Xhm9RZ1DifsDAJvVV7wbkgKChuQVGBclTvDg
         tLSH1DVd6i89VPW0prx77Z3PTOIaS0uhr7fW44/e91X+z9jd1y+WtP9HK68tJFf1qN
         pSPKqPwxYYSziaRSimZKqaWdsJBrFEUayfWi8rz8=
Date:   Wed, 16 Sep 2020 15:38:59 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com,
        sfr@canb.auug.org.au, rppt@kernel.org, riel@surriel.com,
        mhocko@kernel.org, js1304@gmail.com, guro@fb.com, aslan@fb.com,
        mike.kravetz@oracle.com
Subject:  [withdrawn]
 cma-make-number-of-cma-areas-dynamic-remove-config_cma_areas.patch removed
 from -mm tree
Message-ID: <20200916223859.pfRz1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: make number of CMA areas dynamic, remove CONFIG_CMA_AREAS
has been removed from the -mm tree.  Its filename was
     cma-make-number-of-cma-areas-dynamic-remove-config_cma_areas.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/cma: make number of CMA areas dynamic, remove CONFIG_CMA_AREAS

The number of distinct CMA areas is limited by the constant
CONFIG_CMA_AREAS.  In most environments, this was set to a default
value of 7.  Not too long ago, support was added to allocate hugetlb
gigantic pages from CMA.  More recent changes to make dma_alloc_coherent
NUMA-aware on arm64 added more potential users of CMA areas.  Along
with the dma_alloc_coherent changes, the default value of CMA_AREAS
was bumped up to 19 if NUMA is enabled.

It seems that the number of CMA users is likely to grow.  Instead of
using a static array for cma areas, use a simple linked list.  These
areas are used before normal memory allocators, so use the memblock
allocator.

Link: https://lkml.kernel.org/r/20200915205703.34572-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Aslan Bakirov <aslan@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c              |   28 +++++++++++------
 arch/mips/configs/cu1000-neo_defconfig |    1 
 arch/mips/configs/cu1830-neo_defconfig |    1 
 include/linux/cma.h                    |   12 -------
 mm/Kconfig                             |   11 ------
 mm/cma.c                               |   37 +++++++++--------------
 mm/cma.h                               |    4 +-
 mm/cma_debug.c                         |    6 +--
 8 files changed, 39 insertions(+), 61 deletions(-)

--- a/arch/arm/mm/dma-mapping.c~cma-make-number-of-cma-areas-dynamic-remove-config_cma_areas
+++ a/arch/arm/mm/dma-mapping.c
@@ -383,25 +383,33 @@ postcore_initcall(atomic_pool_init);
 struct dma_contig_early_reserve {
 	phys_addr_t base;
 	unsigned long size;
+	struct list_head areas;
 };
 
-static struct dma_contig_early_reserve dma_mmu_remap[MAX_CMA_AREAS] __initdata;
-
-static int dma_mmu_remap_num __initdata;
+static __initdata LIST_HEAD(dma_mmu_remap_areas);
 
 void __init dma_contiguous_early_fixup(phys_addr_t base, unsigned long size)
 {
-	dma_mmu_remap[dma_mmu_remap_num].base = base;
-	dma_mmu_remap[dma_mmu_remap_num].size = size;
-	dma_mmu_remap_num++;
+	struct dma_contig_early_reserve *d;
+
+	d = memblock_alloc(sizeof(*d), sizeof(void *));
+	if (!d) {
+		pr_err("Unable to allocate dma_contig_early_reserve struct!\n");
+		return;
+	}
+
+	d->base = base;
+	d->size = size;
+	list_add_tail(&d->areas, &dma_mmu_remap_areas);
 }
 
 void __init dma_contiguous_remap(void)
 {
-	int i;
-	for (i = 0; i < dma_mmu_remap_num; i++) {
-		phys_addr_t start = dma_mmu_remap[i].base;
-		phys_addr_t end = start + dma_mmu_remap[i].size;
+	struct dma_contig_early_reserve *d;
+
+	list_for_each_entry(d, &dma_mmu_remap_areas, areas) {
+		phys_addr_t start = d->base;
+		phys_addr_t end = start + d->size;
 		struct map_desc map;
 		unsigned long addr;
 
--- a/arch/mips/configs/cu1000-neo_defconfig~cma-make-number-of-cma-areas-dynamic-remove-config_cma_areas
+++ a/arch/mips/configs/cu1000-neo_defconfig
@@ -31,7 +31,6 @@ CONFIG_HZ_100=y
 # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
 # CONFIG_COMPACTION is not set
 CONFIG_CMA=y
-CONFIG_CMA_AREAS=7
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
--- a/arch/mips/configs/cu1830-neo_defconfig~cma-make-number-of-cma-areas-dynamic-remove-config_cma_areas
+++ a/arch/mips/configs/cu1830-neo_defconfig
@@ -31,7 +31,6 @@ CONFIG_HZ_100=y
 # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
 # CONFIG_COMPACTION is not set
 CONFIG_CMA=y
-CONFIG_CMA_AREAS=7
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
--- a/include/linux/cma.h~cma-make-number-of-cma-areas-dynamic-remove-config_cma_areas
+++ a/include/linux/cma.h
@@ -6,18 +6,6 @@
 #include <linux/types.h>
 #include <linux/numa.h>
 
-/*
- * There is always at least global CMA area and a few optional
- * areas configured in kernel .config.
- */
-#ifdef CONFIG_CMA_AREAS
-#define MAX_CMA_AREAS	(1 + CONFIG_CMA_AREAS)
-
-#else
-#define MAX_CMA_AREAS	(0)
-
-#endif
-
 struct cma;
 
 extern unsigned long totalcma_pages;
--- a/mm/cma.c~cma-make-number-of-cma-areas-dynamic-remove-config_cma_areas
+++ a/mm/cma.c
@@ -36,8 +36,9 @@
 
 #include "cma.h"
 
-struct cma cma_areas[MAX_CMA_AREAS];
-unsigned cma_area_count;
+/* modify here */
+LIST_HEAD(cma_areas);
+static unsigned int cma_area_count;
 static DEFINE_MUTEX(cma_mutex);
 
 phys_addr_t cma_get_base(const struct cma *cma)
@@ -143,10 +144,10 @@ out_error:
 
 static int __init cma_init_reserved_areas(void)
 {
-	int i;
+	struct cma *c;
 
-	for (i = 0; i < cma_area_count; i++)
-		cma_activate_area(&cma_areas[i]);
+	list_for_each_entry(c, &cma_areas, areas)
+		cma_activate_area(c);
 
 	return 0;
 }
@@ -172,12 +173,6 @@ int __init cma_init_reserved_mem(phys_ad
 	struct cma *cma;
 	phys_addr_t alignment;
 
-	/* Sanity checks */
-	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
-		pr_err("Not enough slots for CMA reserved regions!\n");
-		return -ENOSPC;
-	}
-
 	if (!size || !memblock_is_region_reserved(base, size))
 		return -EINVAL;
 
@@ -192,12 +187,17 @@ int __init cma_init_reserved_mem(phys_ad
 	if (ALIGN(base, alignment) != base || ALIGN(size, alignment) != size)
 		return -EINVAL;
 
+	cma = memblock_alloc(sizeof(*cma), sizeof(long));
+	if (!cma) {
+		pr_err("Unable to allocate CMA descriptor!\n");
+		return -ENOSPC;
+	}
+	list_add_tail(&cma->areas, &cma_areas);
+
 	/*
 	 * Each reserved area must be initialised later, when more kernel
 	 * subsystems (like slab allocator) are available.
 	 */
-	cma = &cma_areas[cma_area_count];
-
 	if (name)
 		snprintf(cma->name, CMA_MAX_NAME, name);
 	else
@@ -253,11 +253,6 @@ int __init cma_declare_contiguous_nid(ph
 	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
 		__func__, &size, &base, &limit, &alignment);
 
-	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
-		pr_err("Not enough slots for CMA reserved regions!\n");
-		return -ENOSPC;
-	}
-
 	if (!size)
 		return -EINVAL;
 
@@ -530,10 +525,10 @@ bool cma_release(struct cma *cma, const
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
 {
-	int i;
+	struct cma *c;
 
-	for (i = 0; i < cma_area_count; i++) {
-		int ret = it(&cma_areas[i], data);
+	list_for_each_entry(c, &cma_areas, areas) {
+		int ret = it(c, data);
 
 		if (ret)
 			return ret;
--- a/mm/cma_debug.c~cma-make-number-of-cma-areas-dynamic-remove-config_cma_areas
+++ a/mm/cma_debug.c
@@ -188,12 +188,12 @@ static void cma_debugfs_add_one(struct c
 static int __init cma_debugfs_init(void)
 {
 	struct dentry *cma_debugfs_root;
-	int i;
+	struct cma *c;
 
 	cma_debugfs_root = debugfs_create_dir("cma", NULL);
 
-	for (i = 0; i < cma_area_count; i++)
-		cma_debugfs_add_one(&cma_areas[i], cma_debugfs_root);
+	list_for_each_entry(c, &cma_areas, areas)
+		cma_debugfs_add_one(c, cma_debugfs_root);
 
 	return 0;
 }
--- a/mm/cma.h~cma-make-number-of-cma-areas-dynamic-remove-config_cma_areas
+++ a/mm/cma.h
@@ -17,11 +17,11 @@ struct cma {
 	spinlock_t mem_head_lock;
 	struct debugfs_u32_array dfs_bitmap;
 #endif
+	struct list_head areas;
 	char name[CMA_MAX_NAME];
 };
 
-extern struct cma cma_areas[MAX_CMA_AREAS];
-extern unsigned cma_area_count;
+extern struct list_head cma_areas;
 
 static inline unsigned long cma_bitmap_maxno(struct cma *cma)
 {
--- a/mm/Kconfig~cma-make-number-of-cma-areas-dynamic-remove-config_cma_areas
+++ a/mm/Kconfig
@@ -513,17 +513,6 @@ config CMA_DEBUGFS
 	help
 	  Turns on the DebugFS interface for CMA.
 
-config CMA_AREAS
-	int "Maximum count of the CMA areas"
-	depends on CMA
-	default 7
-	help
-	  CMA allows to create CMA areas for particular purpose, mainly,
-	  used as device private area. This parameter sets the maximum
-	  number of CMA area in the system.
-
-	  If unsure, leave the default value "7".
-
 config MEM_SOFT_DIRTY
 	bool "Track memory changes"
 	depends on CHECKPOINT_RESTORE && HAVE_ARCH_SOFT_DIRTY && PROC_FS
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-add-lockdep-check-for-i_mmap_rwsem-held-in-huge_pmd_share.patch

