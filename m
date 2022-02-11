Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B82C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353331AbiBKUtB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:49:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241836AbiBKUs7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:48:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1965CEC
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:48:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 722B5B82CF6
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067CEC340E9;
        Fri, 11 Feb 2022 20:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612535;
        bh=G/zdaewz4oObTK5OLl2sBPbzDyZaD1VVRsT4HCsB3ek=;
        h=Date:To:From:Subject:From;
        b=PVg0EinouW1ys4mbCtXTIU5WQbxkk0hFOqmVPasReCU0Q+eVAxVV5EwXJFxIP/nSi
         BctlGls+b/iViksKqfEpQdVyqg7x9jUiRulIeZmVPqlhipGsnqKjphrng1VizV/3K8
         zFTbogZxxH4GoXwFbkx0RYi8iQdTleUfruSix1p0=
Date:   Fri, 11 Feb 2022 12:48:54 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alex.sierra@amd.com,
        alexander.deucher@amd.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pointless-includes-from-linux-hmmh.patch added to -mm tree
Message-Id: <20220211204855.067CEC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove pointless includes from <linux/hmm.h>
has been added to the -mm tree.  Its filename is
     mm-remove-pointless-includes-from-linux-hmmh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-pointless-includes-from-linux-hmmh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-pointless-includes-from-linux-hmmh.patch

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
Subject: mm: remove pointless includes from <linux/hmm.h>

hmm.h pulls in the world for no good reason at all.  Remove the
includes and push a few ones into the users instead.

Link: https://lkml.kernel.org/r/20220210072828.2930359-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Tested-by: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-remove-pointless-includes-from-linux-hmmh
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -24,6 +24,7 @@
 #include <linux/hmm.h>
 #include <linux/dma-direction.h>
 #include <linux/dma-mapping.h>
+#include <linux/migrate.h>
 #include "amdgpu_sync.h"
 #include "amdgpu_object.h"
 #include "amdgpu_vm.h"
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-remove-pointless-includes-from-linux-hmmh
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -39,6 +39,7 @@
 
 #include <linux/sched/mm.h>
 #include <linux/hmm.h>
+#include <linux/migrate.h>
 
 /*
  * FIXME: this is ugly right now we are using TTM to allocate vram and we pin
--- a/include/linux/hmm.h~mm-remove-pointless-includes-from-linux-hmmh
+++ a/include/linux/hmm.h
@@ -9,14 +9,9 @@
 #ifndef LINUX_HMM_H
 #define LINUX_HMM_H
 
-#include <linux/kconfig.h>
-#include <linux/pgtable.h>
+#include <linux/mm.h>
 
-#include <linux/device.h>
-#include <linux/migrate.h>
-#include <linux/memremap.h>
-#include <linux/completion.h>
-#include <linux/mmu_notifier.h>
+struct mmu_interval_notifier;
 
 /*
  * On output:
--- a/lib/test_hmm.c~mm-remove-pointless-includes-from-linux-hmmh
+++ a/lib/test_hmm.c
@@ -26,6 +26,8 @@
 #include <linux/sched/mm.h>
 #include <linux/platform_device.h>
 #include <linux/rmap.h>
+#include <linux/mmu_notifier.h>
+#include <linux/migrate.h>
 
 #include "test_hmm_uapi.h"
 
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

