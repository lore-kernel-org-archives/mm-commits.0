Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6C2C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353389AbiBKUtq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:49:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353355AbiBKUti (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:49:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2023CCEC
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:49:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B29EC620A8
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C79C340E9;
        Fri, 11 Feb 2022 20:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612576;
        bh=V5CI8eFPOhi6hYQLLV/wY5sc+ouUa1KcRo78VDM6Sy0=;
        h=Date:To:From:Subject:From;
        b=aO9bnez3jk6PUwqqkAl1nhlT//pzEF4BTw4LmQ9mHFSak8HXNM4mNIsThaP18/bWL
         EbmUCJ3wHUWYpH4VSGHEoUTf6qLecxNOSLmQ66VPeRa12SewVUKjz2BjTP8QGyATkG
         sOHszUw3DaYO80kzJ7rYQHt76mLVBIOl+9Jtn8d8=
Date:   Fri, 11 Feb 2022 12:49:35 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alex.sierra@amd.com,
        alexander.deucher@amd.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-device-coherent-vma-selection-for-memory-migration.patch added to -mm tree
Message-Id: <20220211204936.08C79C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add device coherent vma selection for memory migration
has been added to the -mm tree.  Its filename is
     mm-add-device-coherent-vma-selection-for-memory-migration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-device-coherent-vma-selection-for-memory-migration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-device-coherent-vma-selection-for-memory-migration.patch

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
Subject: mm: add device coherent vma selection for memory migration


This case is used to migrate pages from device memory, back to system
memory. Device coherent type memory is cache coherent from device and CPU
point of view.

Link: https://lkml.kernel.org/r/20220210072828.2930359-17-hch@lst.de
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alistair Poppple <apopple@nvidia.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/migrate.h~mm-add-device-coherent-vma-selection-for-memory-migration
+++ a/include/linux/migrate.h
@@ -130,6 +130,7 @@ static inline unsigned long migrate_pfn(
 enum migrate_vma_direction {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
+	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
 };
 
 struct migrate_vma {
--- a/mm/migrate_device.c~mm-add-device-coherent-vma-selection-for-memory-migration
+++ a/mm/migrate_device.c
@@ -147,15 +147,21 @@ again:
 			if (is_writable_device_private_entry(entry))
 				mpfn |= MIGRATE_PFN_WRITE;
 		} else {
-			if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM))
-				goto next;
 			pfn = pte_pfn(pte);
-			if (is_zero_pfn(pfn)) {
+			if (is_zero_pfn(pfn) &&
+			    (migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
 				mpfn = MIGRATE_PFN_MIGRATE;
 				migrate->cpages++;
 				goto next;
 			}
 			page = vm_normal_page(migrate->vma, addr, pte);
+			if (page && !is_zone_device_page(page) &&
+			    !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM))
+				goto next;
+			else if (page && is_device_coherent_page(page) &&
+			    (!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
+			     page->pgmap->owner != migrate->pgmap_owner))
+				goto next;
 			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
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

