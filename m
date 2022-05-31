Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F54BC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 17:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346565AbiEaRc5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 13:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346581AbiEaRcu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 13:32:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C6995A12
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 10:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7937C6103C
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 17:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC336C385A9;
        Tue, 31 May 2022 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654018367;
        bh=3HutrY0Iri/xXV4tVRqZj/rlPX8xvSqceyNn+O9vvWA=;
        h=Date:To:From:Subject:From;
        b=oyfHHfLiux1M3sCKJzehjXXebyBgxibYHdSzvm6YLlwJ9Woov/3w7EDCX9ZWrn1tv
         iMCusWNnx+4dkrSEpr3jydy7Eutk/cQOga+hqtTC+XQOX9Jk0KAGwoBFvBT6ZTK+y3
         ARNl86fzT4Rdn6yKgvhfedfyUo2toTwgPKtsf5ac=
Date:   Tue, 31 May 2022 10:32:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-amdkfd-add-spm-support-for-svm.patch added to mm-unstable branch
Message-Id: <20220531173247.CC336C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/amdkfd: add SPM support for SVM
has been added to the -mm mm-unstable branch.  Its filename is
     drm-amdkfd-add-spm-support-for-svm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-amdkfd-add-spm-support-for-svm.patch

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
From: Alex Sierra <alex.sierra@amd.com>
Subject: drm/amdkfd: add SPM support for SVM
Date: Tue, 31 May 2022 10:56:22 -0500

When CPU is connected throug XGMI, it has coherent access to VRAM
resource.  In this case that resource is taken from a table in the device
gmc aperture base.  This resource is used along with the device type,
which could be DEVICE_PRIVATE or DEVICE_COHERENT to create the device page
map region.

Also, MIGRATE_VMA_SELECT_DEVICE_COHERENT flag is selected for coherent
type case during migration to device.

Link: https://lkml.kernel.org/r/20220531155629.20057-7-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |   34 ++++++++++++---------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~drm-amdkfd-add-spm-support-for-svm
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -671,13 +671,15 @@ svm_migrate_vma_to_ram(struct amdgpu_dev
 	migrate.vma = vma;
 	migrate.start = start;
 	migrate.end = end;
-	migrate.flags = MIGRATE_VMA_SELECT_DEVICE_PRIVATE;
 	migrate.pgmap_owner = SVM_ADEV_PGMAP_OWNER(adev);
+	if (adev->gmc.xgmi.connected_to_cpu)
+		migrate.flags = MIGRATE_VMA_SELECT_DEVICE_COHERENT;
+	else
+		migrate.flags = MIGRATE_VMA_SELECT_DEVICE_PRIVATE;
 
 	buf = kvcalloc(npages,
 		       2 * sizeof(*migrate.src) + sizeof(uint64_t) + sizeof(dma_addr_t),
 		       GFP_KERNEL);
-
 	if (!buf)
 		goto out;
 
@@ -947,7 +949,7 @@ int svm_migrate_init(struct amdgpu_devic
 {
 	struct kfd_dev *kfddev = adev->kfd.dev;
 	struct dev_pagemap *pgmap;
-	struct resource *res;
+	struct resource *res = NULL;
 	unsigned long size;
 	void *r;
 
@@ -962,28 +964,34 @@ int svm_migrate_init(struct amdgpu_devic
 	 * should remove reserved size
 	 */
 	size = ALIGN(adev->gmc.real_vram_size, 2ULL << 20);
-	res = devm_request_free_mem_region(adev->dev, &iomem_resource, size);
-	if (IS_ERR(res))
-		return -ENOMEM;
+	if (adev->gmc.xgmi.connected_to_cpu) {
+		pgmap->range.start = adev->gmc.aper_base;
+		pgmap->range.end = adev->gmc.aper_base + adev->gmc.aper_size - 1;
+		pgmap->type = MEMORY_DEVICE_COHERENT;
+	} else {
+		res = devm_request_free_mem_region(adev->dev, &iomem_resource, size);
+		if (IS_ERR(res))
+			return -ENOMEM;
+		pgmap->range.start = res->start;
+		pgmap->range.end = res->end;
+		pgmap->type = MEMORY_DEVICE_PRIVATE;
+	}
 
-	pgmap->type = MEMORY_DEVICE_PRIVATE;
 	pgmap->nr_range = 1;
-	pgmap->range.start = res->start;
-	pgmap->range.end = res->end;
 	pgmap->ops = &svm_migrate_pgmap_ops;
 	pgmap->owner = SVM_ADEV_PGMAP_OWNER(adev);
-	pgmap->flags = MIGRATE_VMA_SELECT_DEVICE_PRIVATE;
-
+	pgmap->flags = 0;
 	/* Device manager releases device-specific resources, memory region and
 	 * pgmap when driver disconnects from device.
 	 */
 	r = devm_memremap_pages(adev->dev, pgmap);
 	if (IS_ERR(r)) {
 		pr_err("failed to register HMM device memory\n");
-
 		/* Disable SVM support capability */
 		pgmap->type = 0;
-		devm_release_mem_region(adev->dev, res->start, resource_size(res));
+		if (pgmap->type == MEMORY_DEVICE_PRIVATE)
+			devm_release_mem_region(adev->dev, res->start,
+						res->end - res->start + 1);
 		return PTR_ERR(r);
 	}
 
_

Patches currently in -mm which might be from alex.sierra@amd.com are

mm-add-zone-device-coherent-type-memory-support.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch
drm-amdkfd-add-spm-support-for-svm.patch
lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
lib-test_hmm-add-module-param-for-zone-device-type.patch
lib-add-support-for-device-coherent-type-in-test_hmm.patch
tools-update-hmm-test-to-support-device-coherent-type.patch
tools-update-test_hmm-script-to-support-sp-config.patch
tools-add-hmm-gup-tests-for-device-coherent-type.patch
tools-add-selftests-to-hmm-for-cow-in-device-memory.patch

