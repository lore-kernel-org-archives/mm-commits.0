Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF96C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJLW6p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJLW55 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:57:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34FD120BCE
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF2BDB81BE0
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950E9C4314A;
        Wed, 12 Oct 2022 22:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615455;
        bh=g3pnL8U4vDv2PPc+dDIn2RslWoM3cQfnAOtJPR5vSNU=;
        h=Date:To:From:Subject:From;
        b=x7oa8YMoOwjRhTanZTzSlKT/oADRTgzq9GM4/LGmrUr7By4jv1N6WqdxMwutZEmpb
         LV01iSPXHZGs6ftf/KvrZpOClqFQT3k+vMKGvfbdjlyZ6RKuv5pnfyThtubi3XuK6l
         qQ2MKJ9C7uzuHtNxlAhVENl7I1tP5PNL03Irb9Lw=
Date:   Wed, 12 Oct 2022 15:57:34 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, shy828301@gmail.com, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, david@redhat.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, alex.sierra@amd.com, alexander.deucher@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nouveau-dmem-refactor-nouveau_dmem_fault_copy_one.patch removed from -mm tree
Message-Id: <20221012225735.950E9C4314A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nouveau/dmem: refactor nouveau_dmem_fault_copy_one()
has been removed from the -mm tree.  Its filename was
     nouveau-dmem-refactor-nouveau_dmem_fault_copy_one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 drivers/gpu/drm/nouveau/nouveau_dmem.c |   58 +++++++++++------------
 1 file changed, 28 insertions(+), 30 deletions(-)

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

nouveau-dmem-evict-device-private-memory-during-release.patch
hmm-tests-add-test-for-migrate_device_range.patch

