Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB2AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353356AbiBKUtO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:49:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353355AbiBKUtN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:49:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D39FCEC
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:49:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8130620A5
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223B4C340E9;
        Fri, 11 Feb 2022 20:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612550;
        bh=Fy3qo8Ik4gXMLTnd4JV7xb7h5v1IBEieLZtbX5Y2RvI=;
        h=Date:To:From:Subject:From;
        b=dKxFZnKq0MIDB83ahYzRr7vnnf/ymAlJkoa3a7/yf+U8OGr0MbHJtKXfGEVX/C0Bi
         3QmF7CdKuhtx3FJneMB9zgvyw92KQPaq2sY5EONjhDiTMwB5LRylfZaTlRR2z5iU8K
         hgVlLzUx2wI0xp3vZvRpgalWTI6UIh6nvr1izufQ=
Date:   Fri, 11 Feb 2022 12:49:09 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alex.sierra@amd.com,
        alexander.deucher@amd.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-extra-zone_device-struct-page-refcount.patch added to -mm tree
Message-Id: <20220211204910.223B4C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove the extra ZONE_DEVICE struct page refcount
has been added to the -mm tree.  Its filename is
     mm-remove-the-extra-zone_device-struct-page-refcount.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-extra-zone_device-struct-page-refcount.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-extra-zone_device-struct-page-refcount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove the extra ZONE_DEVICE struct page refcount

ZONE_DEVICE struct pages have an extra reference count that complicates
the code for put_page() and several places in the kernel that need to
check the reference count to see that a page is not being used (gup,
compaction, migration, etc.). Clean up the code so the reference count
doesn't need to be treated specially for ZONE_DEVICE pages.

Note that this excludes the special idle page wakeup for fsdax pages,
which still happens at refcount 1.  This is a separate issue and will
be sorted out later.  Given that only fsdax pages require the
notifiacation when the refcount hits 1 now, the PAGEMAP_OPS Kconfig
symbol can go away and be replaced with a FS_DAX check for this hook
in the put_page fastpath.

Based on an earlier patch from Ralph Campbell <rcampbell@nvidia.com>.

Link: https://lkml.kernel.org/r/20220210072828.2930359-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -712,7 +712,6 @@ static struct page *kvmppc_uvmem_get_pag
 
 	dpage = pfn_to_page(uvmem_pfn);
 	dpage->zone_device_data = pvt;
-	get_page(dpage);
 	lock_page(dpage);
 	return dpage;
 out_clear:
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -225,7 +225,6 @@ svm_migrate_get_vram_page(struct svm_ran
 	page = pfn_to_page(pfn);
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
-	get_page(page);
 	lock_page(page);
 }
 
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -326,7 +326,6 @@ nouveau_dmem_page_alloc_locked(struct no
 			return NULL;
 	}
 
-	get_page(page);
 	lock_page(page);
 	return page;
 }
--- a/fs/Kconfig~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/fs/Kconfig
@@ -48,7 +48,6 @@ config FS_DAX
 	bool "File system based Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
-	select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
 	select FS_IOMAP
 	select DAX
 	help
--- a/include/linux/memremap.h~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/include/linux/memremap.h
@@ -68,9 +68,9 @@ enum memory_type {
 
 struct dev_pagemap_ops {
 	/*
-	 * Called once the page refcount reaches 1.  (ZONE_DEVICE pages never
-	 * reach 0 refcount unless there is a refcount bug. This allows the
-	 * device driver to implement its own memory management.)
+	 * Called once the page refcount reaches 0.  The reference count will be
+	 * reset to one by the core code after the method is called to prepare
+	 * for handing out the page again.
 	 */
 	void (*page_free)(struct page *page);
 
@@ -133,16 +133,14 @@ static inline unsigned long pgmap_vmemma
 
 static inline bool is_device_private_page(const struct page *page)
 {
-	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
-		IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
+	return IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
 		is_zone_device_page(page) &&
 		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
 }
 
 static inline bool is_pci_p2pdma_page(const struct page *page)
 {
-	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
-		IS_ENABLED(CONFIG_PCI_P2PDMA) &&
+	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
 		is_zone_device_page(page) &&
 		page->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
 }
--- a/include/linux/mm.h~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/include/linux/mm.h
@@ -1085,7 +1085,7 @@ static inline bool is_zone_movable_page(
 	return page_zonenum(page) == ZONE_MOVABLE;
 }
 
-#ifdef CONFIG_DEV_PAGEMAP_OPS
+#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_FS_DAX)
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 
 bool __put_devmap_managed_page(struct page *page);
@@ -1098,12 +1098,12 @@ static inline bool put_devmap_managed_pa
 	return __put_devmap_managed_page(page);
 }
 
-#else /* CONFIG_DEV_PAGEMAP_OPS */
+#else /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
 static inline bool put_devmap_managed_page(struct page *page)
 {
 	return false;
 }
-#endif /* CONFIG_DEV_PAGEMAP_OPS */
+#endif /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
 
 /* 127: arbitrary random number, small enough to assemble well */
 #define folio_ref_zero_or_close_to_overflow(folio) \
--- a/lib/test_hmm.c~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/lib/test_hmm.c
@@ -566,7 +566,6 @@ static struct page *dmirror_devmem_alloc
 	}
 
 	dpage->zone_device_data = rpage;
-	get_page(dpage);
 	lock_page(dpage);
 	return dpage;
 
--- a/mm/internal.h~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/mm/internal.h
@@ -717,4 +717,6 @@ int numa_migrate_prep(struct page *page,
 
 DECLARE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
+void free_zone_device_page(struct page *page);
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/Kconfig~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/mm/Kconfig
@@ -782,9 +782,6 @@ config ZONE_DEVICE
 
 	  If FS_DAX is enabled, then say Y.
 
-config DEV_PAGEMAP_OPS
-	bool
-
 #
 # Helpers to mirror range of the CPU page tables of a process into device page
 # tables.
@@ -796,7 +793,6 @@ config HMM_MIRROR
 config DEVICE_PRIVATE
 	bool "Unaddressable device memory (GPU memory, ...)"
 	depends on ZONE_DEVICE
-	select DEV_PAGEMAP_OPS
 
 	help
 	  Allows creation of struct pages to represent unaddressable device
--- a/mm/memcontrol.c~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/mm/memcontrol.c
@@ -5506,17 +5506,12 @@ static struct page *mc_handle_swap_pte(s
 		return NULL;
 
 	/*
-	 * Handle MEMORY_DEVICE_PRIVATE which are ZONE_DEVICE page belonging to
-	 * a device and because they are not accessible by CPU they are store
-	 * as special swap entry in the CPU page table.
+	 * Handle device private pages that are not accessible by the CPU, but
+	 * stored as special swap entries in the page table.
 	 */
 	if (is_device_private_entry(ent)) {
 		page = pfn_swap_entry_to_page(ent);
-		/*
-		 * MEMORY_DEVICE_PRIVATE means ZONE_DEVICE page and which have
-		 * a refcount of 1 when free (unlike normal page)
-		 */
-		if (!page_ref_add_unless(page, 1, 1))
+		if (!get_page_unless_zero(page))
 			return NULL;
 		return page;
 	}
--- a/mm/memremap.c~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/mm/memremap.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/wait_bit.h>
 #include <linux/xarray.h>
+#include "internal.h"
 
 static DEFINE_XARRAY(pgmap_array);
 
@@ -37,21 +38,19 @@ unsigned long memremap_compat_align(void
 EXPORT_SYMBOL_GPL(memremap_compat_align);
 #endif
 
-#ifdef CONFIG_DEV_PAGEMAP_OPS
+#ifdef CONFIG_FS_DAX
 DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
 EXPORT_SYMBOL(devmap_managed_key);
 
 static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
 {
-	if (pgmap->type == MEMORY_DEVICE_PRIVATE ||
-	    pgmap->type == MEMORY_DEVICE_FS_DAX)
+	if (pgmap->type == MEMORY_DEVICE_FS_DAX)
 		static_branch_dec(&devmap_managed_key);
 }
 
 static void devmap_managed_enable_get(struct dev_pagemap *pgmap)
 {
-	if (pgmap->type == MEMORY_DEVICE_PRIVATE ||
-	    pgmap->type == MEMORY_DEVICE_FS_DAX)
+	if (pgmap->type == MEMORY_DEVICE_FS_DAX)
 		static_branch_inc(&devmap_managed_key);
 }
 #else
@@ -61,7 +60,7 @@ static void devmap_managed_enable_get(st
 static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
 {
 }
-#endif /* CONFIG_DEV_PAGEMAP_OPS */
+#endif /* CONFIG_FS_DAX */
 
 static void pgmap_array_delete(struct range *range)
 {
@@ -102,13 +101,6 @@ static unsigned long pfn_end(struct dev_
 	return (range->start + range_len(range)) >> PAGE_SHIFT;
 }
 
-static unsigned long pfn_next(struct dev_pagemap *pgmap, unsigned long pfn)
-{
-	if (pfn % (1024 << pgmap->vmemmap_shift))
-		cond_resched();
-	return pfn + pgmap_vmemmap_nr(pgmap);
-}
-
 static unsigned long pfn_len(struct dev_pagemap *pgmap, unsigned long range_id)
 {
 	return (pfn_end(pgmap, range_id) -
@@ -135,10 +127,6 @@ bool pfn_zone_device_reserved(unsigned l
 	return ret;
 }
 
-#define for_each_device_pfn(pfn, map, i) \
-	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); \
-	     pfn = pfn_next(map, pfn))
-
 static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 {
 	struct range *range = &pgmap->ranges[range_id];
@@ -167,13 +155,11 @@ static void pageunmap_range(struct dev_p
 
 void memunmap_pages(struct dev_pagemap *pgmap)
 {
-	unsigned long pfn;
 	int i;
 
 	percpu_ref_kill(&pgmap->ref);
 	for (i = 0; i < pgmap->nr_range; i++)
-		for_each_device_pfn(pfn, pgmap, i)
-			put_page(pfn_to_page(pfn));
+		percpu_ref_put_many(&pgmap->ref, pfn_len(pgmap, i));
 	wait_for_completion(&pgmap->done);
 	percpu_ref_exit(&pgmap->ref);
 
@@ -485,14 +471,10 @@ struct dev_pagemap *get_dev_pagemap(unsi
 }
 EXPORT_SYMBOL_GPL(get_dev_pagemap);
 
-#ifdef CONFIG_DEV_PAGEMAP_OPS
-void free_devmap_managed_page(struct page *page)
+void free_zone_device_page(struct page *page)
 {
-	/* notify page idle for dax */
-	if (!is_device_private_page(page)) {
-		wake_up_var(&page->_refcount);
+	if (WARN_ON_ONCE(!is_device_private_page(page)))
 		return;
-	}
 
 	__ClearPageWaiters(page);
 
@@ -521,28 +503,27 @@ void free_devmap_managed_page(struct pag
 	 */
 	page->mapping = NULL;
 	page->pgmap->ops->page_free(page);
+
+	/*
+	 * Reset the page count to 1 to prepare for handing out the page again.
+	 */
+	set_page_count(page, 1);
 }
 
+#ifdef CONFIG_FS_DAX
 bool __put_devmap_managed_page(struct page *page)
 {
-	if (page->pgmap->type != MEMORY_DEVICE_PRIVATE &&
-	    page->pgmap->type != MEMORY_DEVICE_FS_DAX)
+	if (page->pgmap->type != MEMORY_DEVICE_FS_DAX)
 		return false;
 
 	/*
-	 * devmap page refcounts are 1-based, rather than 0-based: if
+	 * fsdax page refcounts are 1-based, rather than 0-based: if
 	 * refcount is 1, then the page is free and the refcount is
 	 * stable because nobody holds a reference on the page.
 	 */
-	switch (page_ref_dec_return(page)) {
-	case 1:
-		free_devmap_managed_page(page);
-		break;
-	case 0:
-		__put_page(page);
-		break;
-	}
+	if (page_ref_dec_return(page) == 1)
+		wake_up_var(&page->_refcount);
 	return true;
 }
 EXPORT_SYMBOL(__put_devmap_managed_page);
-#endif /* CONFIG_DEV_PAGEMAP_OPS */
+#endif /* CONFIG_FS_DAX */
--- a/mm/migrate.c~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/mm/migrate.c
@@ -341,14 +341,8 @@ static int expected_page_refs(struct add
 {
 	int expected_count = 1;
 
-	/*
-	 * Device private pages have an extra refcount as they are
-	 * ZONE_DEVICE pages.
-	 */
-	expected_count += is_device_private_page(page);
 	if (mapping)
 		expected_count += compound_nr(page) + page_has_private(page);
-
 	return expected_count;
 }
 
--- a/mm/swap.c~mm-remove-the-extra-zone_device-struct-page-refcount
+++ a/mm/swap.c
@@ -122,17 +122,9 @@ static void __put_compound_page(struct p
 
 void __put_page(struct page *page)
 {
-	if (is_zone_device_page(page)) {
-		put_dev_pagemap(page->pgmap);
-
-		/*
-		 * The page belongs to the device that created pgmap. Do
-		 * not return it to page allocator.
-		 */
-		return;
-	}
-
-	if (unlikely(PageCompound(page)))
+	if (unlikely(is_zone_device_page(page)))
+		free_zone_device_page(page);
+	else if (unlikely(PageCompound(page)))
 		__put_compound_page(page);
 	else
 		__put_single_page(page);
@@ -933,7 +925,7 @@ void release_pages(struct page **pages,
 			if (put_devmap_managed_page(page))
 				continue;
 			if (put_page_testzero(page))
-				put_dev_pagemap(page->pgmap);
+				free_zone_device_page(page);
 			continue;
 		}
 
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-page_init_poison.patch
mm-remove-a-pointless-config_zone_device-check-in-memremap_pages.patch
mm-remove-the-__kernel__-guard-from-linux-mmh.patch
mm-remove-pointless-includes-from-linux-hmmh.patch
mm-move-free_devmap_managed_page-to-memremapc.patch
mm-simplify-freeing-of-devmap-managed-pages.patch
mm-dont-include-linux-memremaph-in-linux-mmh.patch
mm-remove-the-extra-zone_device-struct-page-refcount.patch
fsdax-depend-on-zone_device-fs_dax_limited.patch
mm-generalize-the-pgmap-based-page_free-infrastructure.patch
mm-refactor-check_and_migrate_movable_pages.patch
mm-refactor-the-zone_device-handling-in-migrate_vma_insert_page.patch
mm-refactor-the-zone_device-handling-in-migrate_vma_pages.patch
mm-move-the-migrate_vma_-device-migration-code-into-its-own-file.patch
mm-build-migrate_vma_-for-all-configs-with-zone_device-support.patch
mm-add-zone-device-coherent-type-memory-support.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch

