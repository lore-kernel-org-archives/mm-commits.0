Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725F8C6FA90
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 15:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiI1PNk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiI1PNj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 11:13:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B686548
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 08:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F82F61EE8
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 15:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5406CC433D6;
        Wed, 28 Sep 2022 15:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664378017;
        bh=Dy/qU05Ys+UAvU+pM/29QZD38nbxhr0ZE1UsNYdi24M=;
        h=Date:To:From:Subject:From;
        b=JNbGLaAxzDZXHFPgs+jEYQ31+o9f0ysXG15zzBD+PWU+e2Uyxx4g7jB7kYQPmAtWy
         +JzihtFqOj8Y9iZpFFi4A4ZrpTYA5iKfaa5arFglOMSyNMQmApHb8pn21OKezgL/59
         JdQ5A0BdFdPljXdWVoZ8PqHRtNonAyceA8kxDl3A=
Date:   Wed, 28 Sep 2022 08:13:33 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, shy828301@gmail.com, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, david@redhat.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, alex.sierra@amd.com, alexander.deucher@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nouveau-dmem-refactor-nouveau_dmem_fault_copy_one.patch added to mm-unstable branch
Message-Id: <20220928151337.5406CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nouveau/dmem: refactor nouveau_dmem_fault_copy_one()
has been added to the -mm mm-unstable branch.  Its filename is
     nouveau-dmem-refactor-nouveau_dmem_fault_copy_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nouveau-dmem-refactor-nouveau_dmem_fault_copy_one.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: nouveau/dmem: refactor nouveau_dmem_fault_copy_one()
Date: Wed, 28 Sep 2022 22:01:20 +1000

nouveau_dmem_fault_copy_one() is used during handling of CPU faults via
the migrate_to_ram() callback and is used to copy data from GPU to CPU
memory.  It is currently specific to fault handling, however a future
patch implementing eviction of data during teardown needs similar
functionality.

Refactor out the core functionality so that it is not specific to fault
handling.

Link: https://lkml.kernel.org/r/20573d7b4e641a78fde9935f948e64e71c9e709e.1664366292.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~nouveau-dmem-refactor-nouveau_dmem_fault_copy_one
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -139,44 +139,24 @@ static void nouveau_dmem_fence_done(stru
 	}
 }
 
-static vm_fault_t nouveau_dmem_fault_copy_one(struct nouveau_drm *drm,
-		struct vm_fault *vmf, struct migrate_vma *args,
-		dma_addr_t *dma_addr)
+static int nouveau_dmem_copy_one(struct nouveau_drm *drm, struct page *spage,
+				struct page *dpage, dma_addr_t *dma_addr)
 {
 	struct device *dev = drm->dev->dev;
-	struct page *dpage, *spage;
-	struct nouveau_svmm *svmm;
-
-	spage = migrate_pfn_to_page(args->src[0]);
-	if (!spage || !(args->src[0] & MIGRATE_PFN_MIGRATE))
-		return 0;
 
-	dpage = alloc_page_vma(GFP_HIGHUSER, vmf->vma, vmf->address);
-	if (!dpage)
-		return VM_FAULT_SIGBUS;
 	lock_page(dpage);
 
 	*dma_addr = dma_map_page(dev, dpage, 0, PAGE_SIZE, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, *dma_addr))
-		goto error_free_page;
+		return -EIO;
 
-	svmm = spage->zone_device_data;
-	mutex_lock(&svmm->mutex);
-	nouveau_svmm_invalidate(svmm, args->start, args->end);
 	if (drm->dmem->migrate.copy_func(drm, 1, NOUVEAU_APER_HOST, *dma_addr,
-			NOUVEAU_APER_VRAM, nouveau_dmem_page_addr(spage)))
-		goto error_dma_unmap;
-	mutex_unlock(&svmm->mutex);
+					 NOUVEAU_APER_VRAM, nouveau_dmem_page_addr(spage))) {
+		dma_unmap_page(dev, *dma_addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
+		return -EIO;
+	}
 
-	args->dst[0] = migrate_pfn(page_to_pfn(dpage));
 	return 0;
-
-error_dma_unmap:
-	mutex_unlock(&svmm->mutex);
-	dma_unmap_page(dev, *dma_addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
-error_free_page:
-	__free_page(dpage);
-	return VM_FAULT_SIGBUS;
 }
 
 static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
@@ -184,9 +164,11 @@ static vm_fault_t nouveau_dmem_migrate_t
 	struct nouveau_drm *drm = page_to_drm(vmf->page);
 	struct nouveau_dmem *dmem = drm->dmem;
 	struct nouveau_fence *fence;
+	struct nouveau_svmm *svmm;
+	struct page *spage, *dpage;
 	unsigned long src = 0, dst = 0;
 	dma_addr_t dma_addr = 0;
-	vm_fault_t ret;
+	vm_fault_t ret = 0;
 	struct migrate_vma args = {
 		.vma		= vmf->vma,
 		.start		= vmf->address,
@@ -207,9 +189,25 @@ static vm_fault_t nouveau_dmem_migrate_t
 	if (!args.cpages)
 		return 0;
 
-	ret = nouveau_dmem_fault_copy_one(drm, vmf, &args, &dma_addr);
-	if (ret || dst == 0)
+	spage = migrate_pfn_to_page(src);
+	if (!spage || !(src & MIGRATE_PFN_MIGRATE))
+		goto done;
+
+	dpage = alloc_page_vma(GFP_HIGHUSER, vmf->vma, vmf->address);
+	if (!dpage)
+		goto done;
+
+	dst = migrate_pfn(page_to_pfn(dpage));
+
+	svmm = spage->zone_device_data;
+	mutex_lock(&svmm->mutex);
+	nouveau_svmm_invalidate(svmm, args.start, args.end);
+	ret = nouveau_dmem_copy_one(drm, spage, dpage, &dma_addr);
+	mutex_unlock(&svmm->mutex);
+	if (ret) {
+		ret = VM_FAULT_SIGBUS;
 		goto done;
+	}
 
 	nouveau_fence_new(dmem->migrate.chan, false, &fence);
 	migrate_vma_pages(&args);
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-memoryc-fix-race-when-faulting-a-device-private-page.patch
mm-free-device-private-pages-have-zero-refcount.patch
mm-memremapc-take-a-pgmap-reference-on-page-allocation.patch
mm-migrate_devicec-refactor-migrate_vma-and-migrate_deivce_coherent_page.patch
mm-migrate_devicec-add-migrate_device_range.patch
nouveau-dmem-refactor-nouveau_dmem_fault_copy_one.patch
nouveau-dmem-evict-device-private-memory-during-release.patch
hmm-tests-add-test-for-migrate_device_range.patch

