Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B312C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353359AbiBKUtc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:49:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353355AbiBKUt2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:49:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30C1CFA
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:49:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A012B82CFE
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3753C340E9;
        Fri, 11 Feb 2022 20:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612564;
        bh=rdNQ2OdMhdLjdHkaIisGpsxPj6+ENuREt+ZxqV5/UUg=;
        h=Date:To:From:Subject:From;
        b=1jmszDy5Z75yp/HDgZy3IKJmBeSeknXD2+PhT0HiVo5MBrWjS/kwg67OoTOYNIHXt
         4JGlQZDykeRXU4kjiXRxZgb+5s+NMxDatnjBLGnK9bMOnNbVCihHcbCvQ7guwJjSfq
         6vFSVQKmc2n4uLeOhsgRmRyurfc+DE8feRzTsPLA=
Date:   Fri, 11 Feb 2022 12:49:23 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alex.sierra@amd.com,
        alexander.deucher@amd.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-the-zone_device-handling-in-migrate_vma_pages.patch added to -mm tree
Message-Id: <20220211204923.F3753C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor the ZONE_DEVICE handling in migrate_vma_pages
has been added to the -mm tree.  Its filename is
     mm-refactor-the-zone_device-handling-in-migrate_vma_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-refactor-the-zone_device-handling-in-migrate_vma_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-refactor-the-zone_device-handling-in-migrate_vma_pages.patch

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
Subject: mm: refactor the ZONE_DEVICE handling in migrate_vma_pages

Make the flow a little more clear and prepare for adding a new
ZONE_DEVICE memory type.

Link: https://lkml.kernel.org/r/20220210072828.2930359-13-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Tested-by: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
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


--- a/mm/migrate.c~mm-refactor-the-zone_device-handling-in-migrate_vma_pages
+++ a/mm/migrate.c
@@ -2822,24 +2822,21 @@ void migrate_vma_pages(struct migrate_vm
 
 		mapping = page_mapping(page);
 
-		if (is_zone_device_page(newpage)) {
-			if (is_device_private_page(newpage)) {
-				/*
-				 * For now only support private anonymous when
-				 * migrating to un-addressable device memory.
-				 */
-				if (mapping) {
-					migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
-					continue;
-				}
-			} else {
-				/*
-				 * Other types of ZONE_DEVICE page are not
-				 * supported.
-				 */
+		if (is_device_private_page(newpage)) {
+			/*
+			 * For now only support private anonymous when migrating
+			 * to un-addressable device memory.
+			 */
+			if (mapping) {
 				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
 				continue;
 			}
+		} else if (is_zone_device_page(newpage)) {
+			/*
+			 * Other types of ZONE_DEVICE page are not supported.
+			 */
+			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+			continue;
 		}
 
 		r = migrate_page(mapping, newpage, page, MIGRATE_SYNC_NO_COPY);
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

