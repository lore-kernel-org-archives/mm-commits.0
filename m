Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE5C9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346918AbiBKUsy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:48:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241836AbiBKUsx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:48:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8E5CFA
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBB4762097
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E3CC340E9;
        Fri, 11 Feb 2022 20:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612531;
        bh=whpYXNB+Ef1eq9XCof1EC0HmdpAQTe+H4QiY0ZzwtAo=;
        h=Date:To:From:Subject:From;
        b=rFKx87u7BOxVewCMZvIhUz9hQBxzn9eWkQ/gejrbSI3qPuUzKqXG2RQ1kEsLIujun
         L9CHb0Faj/45xXyrmJdCofMmorjpjgaxN/fbI4AJboGeowrakb1ZcmY2rFvFNduv5B
         FvFPxmTtwLVpvA+7SDoatMUKouDBUx2C+YGj5qZc=
Date:   Fri, 11 Feb 2022 12:48:50 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alex.sierra@amd.com,
        alexander.deucher@amd.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-a-pointless-config_zone_device-check-in-memremap_pages.patch added to -mm tree
Message-Id: <20220211204851.05E3CC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove a pointless CONFIG_ZONE_DEVICE check in memremap_pages
has been added to the -mm tree.  Its filename is
     mm-remove-a-pointless-config_zone_device-check-in-memremap_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-a-pointless-config_zone_device-check-in-memremap_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-a-pointless-config_zone_device-check-in-memremap_pages.patch

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
Subject: mm: remove a pointless CONFIG_ZONE_DEVICE check in memremap_pages

Patch series "start sorting out the ZONE_DEVICE refcount mess", v2.

This series removes the offset by one refcount for ZONE_DEVICE pages that
are freed back to the driver owning them, which is just device private
ones for now, but also the planned device coherent pages and the ehanced
p2p ones pending.

It does not address the fsdax pages yet, which will be attacked in a
follow on series.


This patch (of 27):

memremap.c is only built when CONFIG_ZONE_DEVICE is set, so remove
the superflous extra check.

Link: https://lkml.kernel.org/r/20220210072828.2930359-1-hch@lst.de
Link: https://lkml.kernel.org/r/20220210072828.2930359-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memremap.c~mm-remove-a-pointless-config_zone_device-check-in-memremap_pages
+++ a/mm/memremap.c
@@ -349,8 +349,7 @@ void *memremap_pages(struct dev_pagemap
 		}
 		break;
 	case MEMORY_DEVICE_FS_DAX:
-		if (!IS_ENABLED(CONFIG_ZONE_DEVICE) ||
-		    IS_ENABLED(CONFIG_FS_DAX_LIMITED)) {
+		if (IS_ENABLED(CONFIG_FS_DAX_LIMITED)) {
 			WARN(1, "File system DAX not supported\n");
 			return ERR_PTR(-EINVAL);
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

