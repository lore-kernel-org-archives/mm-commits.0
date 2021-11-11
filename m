Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C34C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A46F6134F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhKKEf3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 23:35:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhKKEf3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 23:35:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75A80610A5;
        Thu, 11 Nov 2021 04:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636605160;
        bh=xFGh4+88X8NDNKzPDwoAVkTCwJuuL9r3DPA+DnY9Myo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QBiyB3165YwkfAvtBFT1A7dSpwpDLHYcKjLjRgkTkfgEFoxZQWUaInR8/vVpCNL1I
         ubMRlSrF9DrfjcNLJhKRdYlq4VN9sszMsRXe3UOQ/4gsFP7vlZwOz+7pPndT6ZCzjH
         Kg1Ss6lW8Ic/TKedercTPDaCzTbvvL8NMBbVbsPk=
Date:   Wed, 10 Nov 2021 20:32:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.deucher@amd.com,
        apopple@nvidia.com, bskeggs@redhat.com, Felix.Kuehling@amd.com,
        hch@lst.de, jglisse@redhat.com, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 4/7] mm/migrate.c: remove MIGRATE_PFN_LOCKED
Message-ID: <20211111043240.E2eKPjFtl%akpm@linux-foundation.org>
In-Reply-To: <20211110203204.37de96048c3279ab2da758a5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>
Subject: mm/migrate.c: remove MIGRATE_PFN_LOCKED

MIGRATE_PFN_LOCKED is used to indicate to migrate_vma_prepare() that a
source page was already locked during migrate_vma_collect().  If it wasn't
then the a second attempt is made to lock the page.  However if the first
attempt failed it's unlikely a second attempt will succeed, and the retry
adds complexity.  So clean this up by removing the retry and
MIGRATE_PFN_LOCKED flag.

Destination pages are also meant to have the MIGRATE_PFN_LOCKED flag set,
but nothing actually checks that.

Link: https://lkml.kernel.org/r/20211025041608.289017-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hmm.rst                 |    2 
 arch/powerpc/kvm/book3s_hv_uvmem.c       |    4 
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    2 
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |    4 
 include/linux/migrate.h                  |    1 
 lib/test_hmm.c                           |    5 
 mm/migrate.c                             |  145 ++++-----------------
 7 files changed, 35 insertions(+), 128 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-migratec-remove-migrate_pfn_locked
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -560,7 +560,7 @@ static int __kvmppc_svm_page_out(struct
 				  gpa, 0, page_shift);
 
 	if (ret == U_SUCCESS)
-		*mig.dst = migrate_pfn(pfn) | MIGRATE_PFN_LOCKED;
+		*mig.dst = migrate_pfn(pfn);
 	else {
 		unlock_page(dpage);
 		__free_page(dpage);
@@ -774,7 +774,7 @@ static int kvmppc_svm_page_in(struct vm_
 		}
 	}
 
-	*mig.dst = migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
+	*mig.dst = migrate_pfn(page_to_pfn(dpage));
 	migrate_vma_pages(&mig);
 out_finalize:
 	migrate_vma_finalize(&mig);
--- a/Documentation/vm/hmm.rst~mm-migratec-remove-migrate_pfn_locked
+++ a/Documentation/vm/hmm.rst
@@ -360,7 +360,7 @@ between device driver specific code and
    system memory page, locks the page with ``lock_page()``, and fills in the
    ``dst`` array entry with::
 
-     dst[i] = migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
+     dst[i] = migrate_pfn(page_to_pfn(dpage));
 
    Now that the driver knows that this page is being migrated, it can
    invalidate device private MMU mappings and copy device private memory
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-migratec-remove-migrate_pfn_locked
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -317,7 +317,6 @@ svm_migrate_copy_to_vram(struct amdgpu_d
 			migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
 			svm_migrate_get_vram_page(prange, migrate->dst[i]);
 			migrate->dst[i] = migrate_pfn(migrate->dst[i]);
-			migrate->dst[i] |= MIGRATE_PFN_LOCKED;
 			src[i] = dma_map_page(dev, spage, 0, PAGE_SIZE,
 					      DMA_TO_DEVICE);
 			r = dma_mapping_error(dev, src[i]);
@@ -610,7 +609,6 @@ svm_migrate_copy_to_ram(struct amdgpu_de
 				     dst[i] >> PAGE_SHIFT, page_to_pfn(dpage));
 
 		migrate->dst[i] = migrate_pfn(page_to_pfn(dpage));
-		migrate->dst[i] |= MIGRATE_PFN_LOCKED;
 		j++;
 	}
 
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-migratec-remove-migrate_pfn_locked
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -166,7 +166,7 @@ static vm_fault_t nouveau_dmem_fault_cop
 		goto error_dma_unmap;
 	mutex_unlock(&svmm->mutex);
 
-	args->dst[0] = migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
+	args->dst[0] = migrate_pfn(page_to_pfn(dpage));
 	return 0;
 
 error_dma_unmap:
@@ -602,7 +602,7 @@ static unsigned long nouveau_dmem_migrat
 		((paddr >> PAGE_SHIFT) << NVIF_VMM_PFNMAP_V0_ADDR_SHIFT);
 	if (src & MIGRATE_PFN_WRITE)
 		*pfn |= NVIF_VMM_PFNMAP_V0_W;
-	return migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
+	return migrate_pfn(page_to_pfn(dpage));
 
 out_dma_unmap:
 	dma_unmap_page(dev, *dma_addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
--- a/include/linux/migrate.h~mm-migratec-remove-migrate_pfn_locked
+++ a/include/linux/migrate.h
@@ -110,7 +110,6 @@ static inline int migrate_misplaced_page
  */
 #define MIGRATE_PFN_VALID	(1UL << 0)
 #define MIGRATE_PFN_MIGRATE	(1UL << 1)
-#define MIGRATE_PFN_LOCKED	(1UL << 2)
 #define MIGRATE_PFN_WRITE	(1UL << 3)
 #define MIGRATE_PFN_SHIFT	6
 
--- a/lib/test_hmm.c~mm-migratec-remove-migrate_pfn_locked
+++ a/lib/test_hmm.c
@@ -613,8 +613,7 @@ static void dmirror_migrate_alloc_and_co
 		 */
 		rpage->zone_device_data = dmirror;
 
-		*dst = migrate_pfn(page_to_pfn(dpage)) |
-			    MIGRATE_PFN_LOCKED;
+		*dst = migrate_pfn(page_to_pfn(dpage));
 		if ((*src & MIGRATE_PFN_WRITE) ||
 		    (!spage && args->vma->vm_flags & VM_WRITE))
 			*dst |= MIGRATE_PFN_WRITE;
@@ -1137,7 +1136,7 @@ static vm_fault_t dmirror_devmem_fault_a
 		lock_page(dpage);
 		xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
 		copy_highpage(dpage, spage);
-		*dst = migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
+		*dst = migrate_pfn(page_to_pfn(dpage));
 		if (*src & MIGRATE_PFN_WRITE)
 			*dst |= MIGRATE_PFN_WRITE;
 	}
--- a/mm/migrate.c~mm-migratec-remove-migrate_pfn_locked
+++ a/mm/migrate.c
@@ -2362,7 +2362,6 @@ again:
 		 * can't be dropped from it).
 		 */
 		get_page(page);
-		migrate->cpages++;
 
 		/*
 		 * Optimize for the common case where page is only mapped once
@@ -2372,7 +2371,7 @@ again:
 		if (trylock_page(page)) {
 			pte_t swp_pte;
 
-			mpfn |= MIGRATE_PFN_LOCKED;
+			migrate->cpages++;
 			ptep_get_and_clear(mm, addr, ptep);
 
 			/* Setup special migration page table entry */
@@ -2406,6 +2405,9 @@ again:
 
 			if (pte_present(pte))
 				unmapped++;
+		} else {
+			put_page(page);
+			mpfn = 0;
 		}
 
 next:
@@ -2510,15 +2512,17 @@ static bool migrate_vma_check_page(struc
 }
 
 /*
- * migrate_vma_prepare() - lock pages and isolate them from the lru
+ * migrate_vma_unmap() - replace page mapping with special migration pte entry
  * @migrate: migrate struct containing all migration information
  *
- * This locks pages that have been collected by migrate_vma_collect(). Once each
- * page is locked it is isolated from the lru (for non-device pages). Finally,
- * the ref taken by migrate_vma_collect() is dropped, as locked pages cannot be
- * migrated by concurrent kernel threads.
+ * Isolate pages from the LRU and replace mappings (CPU page table pte) with a
+ * special migration pte entry and check if it has been pinned. Pinned pages are
+ * restored because we cannot migrate them.
+ *
+ * This is the last step before we call the device driver callback to allocate
+ * destination memory and copy contents of original page over to new page.
  */
-static void migrate_vma_prepare(struct migrate_vma *migrate)
+static void migrate_vma_unmap(struct migrate_vma *migrate)
 {
 	const unsigned long npages = migrate->npages;
 	const unsigned long start = migrate->start;
@@ -2527,32 +2531,12 @@ static void migrate_vma_prepare(struct m
 
 	lru_add_drain();
 
-	for (i = 0; (i < npages) && migrate->cpages; i++) {
+	for (i = 0; i < npages; i++) {
 		struct page *page = migrate_pfn_to_page(migrate->src[i]);
-		bool remap = true;
 
 		if (!page)
 			continue;
 
-		if (!(migrate->src[i] & MIGRATE_PFN_LOCKED)) {
-			/*
-			 * Because we are migrating several pages there can be
-			 * a deadlock between 2 concurrent migration where each
-			 * are waiting on each other page lock.
-			 *
-			 * Make migrate_vma() a best effort thing and backoff
-			 * for any page we can not lock right away.
-			 */
-			if (!trylock_page(page)) {
-				migrate->src[i] = 0;
-				migrate->cpages--;
-				put_page(page);
-				continue;
-			}
-			remap = false;
-			migrate->src[i] |= MIGRATE_PFN_LOCKED;
-		}
-
 		/* ZONE_DEVICE pages are not on LRU */
 		if (!is_zone_device_page(page)) {
 			if (!PageLRU(page) && allow_drain) {
@@ -2562,16 +2546,9 @@ static void migrate_vma_prepare(struct m
 			}
 
 			if (isolate_lru_page(page)) {
-				if (remap) {
-					migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
-					migrate->cpages--;
-					restore++;
-				} else {
-					migrate->src[i] = 0;
-					unlock_page(page);
-					migrate->cpages--;
-					put_page(page);
-				}
+				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+				migrate->cpages--;
+				restore++;
 				continue;
 			}
 
@@ -2579,80 +2556,20 @@ static void migrate_vma_prepare(struct m
 			put_page(page);
 		}
 
-		if (!migrate_vma_check_page(page)) {
-			if (remap) {
-				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
-				migrate->cpages--;
-				restore++;
-
-				if (!is_zone_device_page(page)) {
-					get_page(page);
-					putback_lru_page(page);
-				}
-			} else {
-				migrate->src[i] = 0;
-				unlock_page(page);
-				migrate->cpages--;
+		if (page_mapped(page))
+			try_to_migrate(page, 0);
 
-				if (!is_zone_device_page(page))
-					putback_lru_page(page);
-				else
-					put_page(page);
+		if (page_mapped(page) || !migrate_vma_check_page(page)) {
+			if (!is_zone_device_page(page)) {
+				get_page(page);
+				putback_lru_page(page);
 			}
-		}
-	}
-
-	for (i = 0, addr = start; i < npages && restore; i++, addr += PAGE_SIZE) {
-		struct page *page = migrate_pfn_to_page(migrate->src[i]);
 
-		if (!page || (migrate->src[i] & MIGRATE_PFN_MIGRATE))
+			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+			migrate->cpages--;
+			restore++;
 			continue;
-
-		remove_migration_pte(page, migrate->vma, addr, page);
-
-		migrate->src[i] = 0;
-		unlock_page(page);
-		put_page(page);
-		restore--;
-	}
-}
-
-/*
- * migrate_vma_unmap() - replace page mapping with special migration pte entry
- * @migrate: migrate struct containing all migration information
- *
- * Replace page mapping (CPU page table pte) with a special migration pte entry
- * and check again if it has been pinned. Pinned pages are restored because we
- * cannot migrate them.
- *
- * This is the last step before we call the device driver callback to allocate
- * destination memory and copy contents of original page over to new page.
- */
-static void migrate_vma_unmap(struct migrate_vma *migrate)
-{
-	const unsigned long npages = migrate->npages;
-	const unsigned long start = migrate->start;
-	unsigned long addr, i, restore = 0;
-
-	for (i = 0; i < npages; i++) {
-		struct page *page = migrate_pfn_to_page(migrate->src[i]);
-
-		if (!page || !(migrate->src[i] & MIGRATE_PFN_MIGRATE))
-			continue;
-
-		if (page_mapped(page)) {
-			try_to_migrate(page, 0);
-			if (page_mapped(page))
-				goto restore;
 		}
-
-		if (migrate_vma_check_page(page))
-			continue;
-
-restore:
-		migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
-		migrate->cpages--;
-		restore++;
 	}
 
 	for (addr = start, i = 0; i < npages && restore; addr += PAGE_SIZE, i++) {
@@ -2665,12 +2582,8 @@ restore:
 
 		migrate->src[i] = 0;
 		unlock_page(page);
+		put_page(page);
 		restore--;
-
-		if (is_zone_device_page(page))
-			put_page(page);
-		else
-			putback_lru_page(page);
 	}
 }
 
@@ -2693,8 +2606,8 @@ restore:
  * it for all those entries (ie with MIGRATE_PFN_VALID and MIGRATE_PFN_MIGRATE
  * flag set).  Once these are allocated and copied, the caller must update each
  * corresponding entry in the dst array with the pfn value of the destination
- * page and with the MIGRATE_PFN_VALID and MIGRATE_PFN_LOCKED flags set
- * (destination pages must have their struct pages locked, via lock_page()).
+ * page and with MIGRATE_PFN_VALID. Destination pages must be locked via
+ * lock_page().
  *
  * Note that the caller does not have to migrate all the pages that are marked
  * with MIGRATE_PFN_MIGRATE flag in src array unless this is a migration from
@@ -2764,8 +2677,6 @@ int migrate_vma_setup(struct migrate_vma
 	migrate_vma_collect(args);
 
 	if (args->cpages)
-		migrate_vma_prepare(args);
-	if (args->cpages)
 		migrate_vma_unmap(args);
 
 	/*
_
