Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C614C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 19:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbiBATx4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:53:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58354 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbiBATx4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 14:53:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DE31B82F7C
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 19:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BC2C340EB;
        Tue,  1 Feb 2022 19:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643745234;
        bh=0wYlhrBDgJTNbtwNjkgM2776i5i8R5SM/92YGXwnb9Q=;
        h=Date:To:From:Subject:From;
        b=n60Exuo4v1Hv0Kvg0nMJpcuac19v/Xg+V0PcU5n+kwLuszIyXFuPwZyOBvkskPV9e
         KrxePQb/M1vZzc6b/N3Xn/s8ydkr/a85/rwiOgWV+k/1r7sP09BLMUVdd2b9Ba3QJQ
         onE3r3Hq31pjSuG9YwbkhPMLsA6VzSmZ1Bujat/8=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 11:53:52 -0800
Date:   Tue, 01 Feb 2022 11:53:52 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, apopple@nvidia.com,
        alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-amdkfd-add-spm-support-for-svm.patch added to -mm tree
Message-Id: <20220201195352.C4BC2C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/amdkfd: add SPM support for SVM
has been added to the -mm tree.  Its filename is
     drm-amdkfd-add-spm-support-for-svm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drm-amdkfd-add-spm-support-for-svm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drm-amdkfd-add-spm-support-for-svm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Sierra <alex.sierra@amd.com>
Subject: drm/amdkfd: add SPM support for SVM

When CPU is connected throug XGMI, it has coherent access to VRAM
resource.  In this case that resource is taken from a table in the device
gmc aperture base.  This resource is used along with the device type,
which could be DEVICE_PRIVATE or DEVICE_COHERENT to create the device page
map region.

Link: https://lkml.kernel.org/r/20220201154901.7921-5-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |   29 +++++++++++++--------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~drm-amdkfd-add-spm-support-for-svm
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -933,7 +933,7 @@ int svm_migrate_init(struct amdgpu_devic
 {
 	struct kfd_dev *kfddev = adev->kfd.dev;
 	struct dev_pagemap *pgmap;
-	struct resource *res;
+	struct resource *res = NULL;
 	unsigned long size;
 	void *r;
 
@@ -948,28 +948,34 @@ int svm_migrate_init(struct amdgpu_devic
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
 
@@ -982,3 +988,4 @@ int svm_migrate_init(struct amdgpu_devic
 
 	return 0;
 }
+
_

Patches currently in -mm which might be from alex.sierra@amd.com are

mm-add-zone-device-coherent-type-memory-support.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch
mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch
drm-amdkfd-add-spm-support-for-svm.patch
drm-amdkfd-coherent-type-as-sys-mem-on-migration-to-ram.patch
lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
lib-test_hmm-add-module-param-for-zone-device-type.patch
lib-add-support-for-device-coherent-type-in-test_hmm.patch
tools-update-hmm-test-to-support-device-coherent-type.patch
tools-update-test_hmm-script-to-support-sp-config.patch

