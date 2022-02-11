Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BD2C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbiBKUtK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:49:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240805AbiBKUtI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:49:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5816CFA
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:49:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7607FB82CF7
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24706C340E9;
        Fri, 11 Feb 2022 20:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612544;
        bh=ya2PVoc9YqVdc+x3npk2tUPp3gt3rr6Aep42xd6PKfQ=;
        h=Date:To:From:Subject:From;
        b=oKTFkhfD2PUOfUDn3AI6pDYztBa+WHQaIlHi8ZmXqLtBfuWtVeb4eZTcR2TUCBq1Z
         BAtWOZzOAFuVHbY8VBqNQnAlvJd3hx+JIfm+voA5yyWiGFqyqnydVSFabSlGttf+Il
         uNBOJYVAwN9wyWDHY3EK6SfTH+lYSiXR/Uc4DhJM=
Date:   Fri, 11 Feb 2022 12:49:03 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alex.sierra@amd.com,
        alexander.deucher@amd.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-include-linux-memremaph-in-linux-mmh.patch added to -mm tree
Message-Id: <20220211204904.24706C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't include <linux/memremap.h> in <linux/mm.h>
has been added to the -mm tree.  Its filename is
     mm-dont-include-linux-memremaph-in-linux-mmh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-include-linux-memremaph-in-linux-mmh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-include-linux-memremaph-in-linux-mmh.patch

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
Subject: mm: don't include <linux/memremap.h> in <linux/mm.h>

Move the check for the actual pgmap types that need the free at refcount
one behavior into the out of line helper, and thus avoid the need to
pull memremap.h into mm.h.

Link: https://lkml.kernel.org/r/20220210072828.2930359-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/arm64/mm/mmu.c~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/arch/arm64/mm/mmu.c
@@ -17,6 +17,7 @@
 #include <linux/mman.h>
 #include <linux/nodemask.h>
 #include <linux/memblock.h>
+#include <linux/memremap.h>
 #include <linux/memory.h>
 #include <linux/fs.h>
 #include <linux/io.h>
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -25,6 +25,7 @@
 
 #include <linux/hashtable.h>
 #include <linux/mmu_notifier.h>
+#include <linux/memremap.h>
 #include <linux/mutex.h>
 #include <linux/types.h>
 #include <linux/atomic.h>
--- a/drivers/gpu/drm/drm_cache.c~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/drivers/gpu/drm/drm_cache.c
@@ -27,11 +27,11 @@
 /*
  * Authors: Thomas Hellström <thomas-at-tungstengraphics-dot-com>
  */
-
 #include <linux/dma-buf-map.h>
 #include <linux/export.h>
 #include <linux/highmem.h>
 #include <linux/cc_platform.h>
+#include <linux/ioport.h>
 #include <xen/xen.h>
 
 #include <drm/drm_cache.h>
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -39,6 +39,7 @@
 
 #include <linux/sched/mm.h>
 #include <linux/hmm.h>
+#include <linux/memremap.h>
 #include <linux/migrate.h>
 
 /*
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -35,6 +35,7 @@
 #include <linux/sched/mm.h>
 #include <linux/sort.h>
 #include <linux/hmm.h>
+#include <linux/memremap.h>
 #include <linux/rmap.h>
 
 struct nouveau_svm {
--- a/drivers/infiniband/core/rw.c~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/drivers/infiniband/core/rw.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (c) 2016 HGST, a Western Digital Company.
  */
+#include <linux/memremap.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
 #include <linux/pci-p2pdma.h>
--- a/drivers/nvdimm/pmem.h~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/drivers/nvdimm/pmem.h
@@ -3,6 +3,7 @@
 #define __NVDIMM_PMEM_H__
 #include <linux/page-flags.h>
 #include <linux/badblocks.h>
+#include <linux/memremap.h>
 #include <linux/types.h>
 #include <linux/pfn_t.h>
 #include <linux/fs.h>
--- a/drivers/nvme/host/pci.c~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/drivers/nvme/host/pci.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/memremap.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
--- a/drivers/nvme/target/io-cmd-bdev.c~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/drivers/nvme/target/io-cmd-bdev.c
@@ -6,6 +6,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/blkdev.h>
 #include <linux/blk-integrity.h>
+#include <linux/memremap.h>
 #include <linux/module.h>
 #include "nvmet.h"
 
--- a/fs/fuse/virtio_fs.c~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/fs/fuse/virtio_fs.c
@@ -8,6 +8,7 @@
 #include <linux/dax.h>
 #include <linux/pci.h>
 #include <linux/pfn_t.h>
+#include <linux/memremap.h>
 #include <linux/module.h>
 #include <linux/virtio.h>
 #include <linux/virtio_fs.h>
--- a/include/linux/memremap.h~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/include/linux/memremap.h
@@ -1,6 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_MEMREMAP_H_
 #define _LINUX_MEMREMAP_H_
+
+#include <linux/mm.h>
 #include <linux/range.h>
 #include <linux/ioport.h>
 #include <linux/percpu-refcount.h>
@@ -129,6 +131,22 @@ static inline unsigned long pgmap_vmemma
 	return 1 << pgmap->vmemmap_shift;
 }
 
+static inline bool is_device_private_page(const struct page *page)
+{
+	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
+		IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
+		is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
+}
+
+static inline bool is_pci_p2pdma_page(const struct page *page)
+{
+	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
+		IS_ENABLED(CONFIG_PCI_P2PDMA) &&
+		is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 bool pfn_zone_device_reserved(unsigned long pfn);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
--- a/include/linux/mm.h~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/include/linux/mm.h
@@ -23,7 +23,6 @@
 #include <linux/err.h>
 #include <linux/page-flags.h>
 #include <linux/page_ref.h>
-#include <linux/memremap.h>
 #include <linux/overflow.h>
 #include <linux/sizes.h>
 #include <linux/sched.h>
@@ -1096,9 +1095,6 @@ static inline bool put_devmap_managed_pa
 		return false;
 	if (!is_zone_device_page(page))
 		return false;
-	if (page->pgmap->type != MEMORY_DEVICE_PRIVATE &&
-	    page->pgmap->type != MEMORY_DEVICE_FS_DAX)
-		return false;
 	return __put_devmap_managed_page(page);
 }
 
@@ -1109,22 +1105,6 @@ static inline bool put_devmap_managed_pa
 }
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
 
-static inline bool is_device_private_page(const struct page *page)
-{
-	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
-		IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
-		is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
-}
-
-static inline bool is_pci_p2pdma_page(const struct page *page)
-{
-	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
-		IS_ENABLED(CONFIG_PCI_P2PDMA) &&
-		is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
-}
-
 /* 127: arbitrary random number, small enough to assemble well */
 #define folio_ref_zero_or_close_to_overflow(folio) \
 	((unsigned int) folio_ref_count(folio) + 127u <= 127u)
--- a/lib/test_hmm.c~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/lib/test_hmm.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/cdev.h>
 #include <linux/device.h>
+#include <linux/memremap.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/sched.h>
--- a/mm/memcontrol.c~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/mm/memcontrol.c
@@ -53,6 +53,7 @@
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/vmpressure.h>
+#include <linux/memremap.h>
 #include <linux/mm_inline.h>
 #include <linux/swap_cgroup.h>
 #include <linux/cpu.h>
--- a/mm/memremap.c~mm-dont-include-linux-memremaph-in-linux-mmh
+++ a/mm/memremap.c
@@ -4,7 +4,7 @@
 #include <linux/io.h>
 #include <linux/kasan.h>
 #include <linux/memory_hotplug.h>
-#include <linux/mm.h>
+#include <linux/memremap.h>
 #include <linux/pfn_t.h>
 #include <linux/swap.h>
 #include <linux/mmzone.h>
@@ -525,6 +525,10 @@ void free_devmap_managed_page(struct pag
 
 bool __put_devmap_managed_page(struct page *page)
 {
+	if (page->pgmap->type != MEMORY_DEVICE_PRIVATE &&
+	    page->pgmap->type != MEMORY_DEVICE_FS_DAX)
+		return false;
+
 	/*
 	 * devmap page refcounts are 1-based, rather than 0-based: if
 	 * refcount is 1, then the page is free and the refcount is
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

