Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED54C04A95
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 15:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbiI1PN5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbiI1PNq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 11:13:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B46B2D89
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 08:13:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8100C61EEA
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 15:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6503C433D6;
        Wed, 28 Sep 2022 15:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664378022;
        bh=+eNS0atTbVOrqetARvwinYFskY+Z4MLxNnRoi6oIPlg=;
        h=Date:To:From:Subject:From;
        b=pSPIpQ0ocVUo7CN77sZtgTxWlWAo8lK6RjlNboddca+6mIMdH6+wiTZUY3wGJzKBt
         g1nzCRVvwoLR6WJjxGpz18iZBvqG1HCxBzXOW8+cO6UmOuM81gb+TcCMmdAICoYkCE
         0cR0EHalq3eyCQCIPOdViU17ZQzqd/YlkNv1eKgo=
Date:   Wed, 28 Sep 2022 08:13:38 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, shy828301@gmail.com, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, david@redhat.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, alex.sierra@amd.com, alexander.deucher@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nouveau-dmem-evict-device-private-memory-during-release.patch added to mm-unstable branch
Message-Id: <20220928151342.B6503C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nouveau/dmem: evict device private memory during release
has been added to the -mm mm-unstable branch.  Its filename is
     nouveau-dmem-evict-device-private-memory-during-release.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nouveau-dmem-evict-device-private-memory-during-release.patch

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
Subject: nouveau/dmem: evict device private memory during release
Date: Wed, 28 Sep 2022 22:01:21 +1000

When the module is unloaded or a GPU is unbound from the module it is
possible for device private pages to still be mapped in currently running
processes.  This can lead to a hangs and RCU stall warnings when unbinding
the device as memunmap_pages() will wait in an uninterruptible state until
all device pages have been freed which may never happen.

Fix this by migrating device mappings back to normal CPU memory prior to
freeing the GPU memory chunks and associated device private pages.

Link: https://lkml.kernel.org/r/66277601fb8fda9af408b33da9887192bf895bda.1664366292.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Lyude Paul <lyude@redhat.com>
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


--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~nouveau-dmem-evict-device-private-memory-during-release
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -367,6 +367,52 @@ nouveau_dmem_suspend(struct nouveau_drm
 	mutex_unlock(&drm->dmem->mutex);
 }
 
+/*
+ * Evict all pages mapping a chunk.
+ */
+static void
+nouveau_dmem_evict_chunk(struct nouveau_dmem_chunk *chunk)
+{
+	unsigned long i, npages = range_len(&chunk->pagemap.range) >> PAGE_SHIFT;
+	unsigned long *src_pfns, *dst_pfns;
+	dma_addr_t *dma_addrs;
+	struct nouveau_fence *fence;
+
+	src_pfns = kcalloc(npages, sizeof(*src_pfns), GFP_KERNEL);
+	dst_pfns = kcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL);
+	dma_addrs = kcalloc(npages, sizeof(*dma_addrs), GFP_KERNEL);
+
+	migrate_device_range(src_pfns, chunk->pagemap.range.start >> PAGE_SHIFT,
+			npages);
+
+	for (i = 0; i < npages; i++) {
+		if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
+			struct page *dpage;
+
+			/*
+			 * _GFP_NOFAIL because the GPU is going away and there
+			 * is nothing sensible we can do if we can't copy the
+			 * data back.
+			 */
+			dpage = alloc_page(GFP_HIGHUSER | __GFP_NOFAIL);
+			dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
+			nouveau_dmem_copy_one(chunk->drm,
+					migrate_pfn_to_page(src_pfns[i]), dpage,
+					&dma_addrs[i]);
+		}
+	}
+
+	nouveau_fence_new(chunk->drm->dmem->migrate.chan, false, &fence);
+	migrate_device_pages(src_pfns, dst_pfns, npages);
+	nouveau_dmem_fence_done(&fence);
+	migrate_device_finalize(src_pfns, dst_pfns, npages);
+	kfree(src_pfns);
+	kfree(dst_pfns);
+	for (i = 0; i < npages; i++)
+		dma_unmap_page(chunk->drm->dev->dev, dma_addrs[i], PAGE_SIZE, DMA_BIDIRECTIONAL);
+	kfree(dma_addrs);
+}
+
 void
 nouveau_dmem_fini(struct nouveau_drm *drm)
 {
@@ -378,8 +424,10 @@ nouveau_dmem_fini(struct nouveau_drm *dr
 	mutex_lock(&drm->dmem->mutex);
 
 	list_for_each_entry_safe(chunk, tmp, &drm->dmem->chunks, list) {
+		nouveau_dmem_evict_chunk(chunk);
 		nouveau_bo_unpin(chunk->bo);
 		nouveau_bo_ref(NULL, &chunk->bo);
+		WARN_ON(chunk->callocated);
 		list_del(&chunk->list);
 		memunmap_pages(&chunk->pagemap);
 		release_mem_region(chunk->pagemap.range.start,
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

