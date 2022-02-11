Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30017C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbiBKUtG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:49:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238208AbiBKUtF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:49:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA69BCFD
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:49:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BB0FB82CDE
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05958C340E9;
        Fri, 11 Feb 2022 20:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612541;
        bh=lLGyEsVkqQUQa8aTKbKszhTIgzHQs3tRLmmlFsBV/xk=;
        h=Date:To:From:Subject:From;
        b=lM98HjYM4b2sW24KzN/RQAerGtmBeQvB5VwPtoXBvbYwPZBGS2Sz/k03OqXMwL+am
         2ADf5X04gRkA8ULIVY2emhO4V6pX+qTrCsTSDYjMRbj1+PUG9MJWYnv7XUzwiDQ/DY
         vDXPYiexHjBenDdzx3DrsARY1jX55g4CEXh6m+Sk=
Date:   Fri, 11 Feb 2022 12:49:00 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alex.sierra@amd.com,
        alexander.deucher@amd.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-simplify-freeing-of-devmap-managed-pages.patch added to -mm tree
Message-Id: <20220211204901.05958C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify freeing of devmap managed pages
has been added to the -mm tree.  Its filename is
     mm-simplify-freeing-of-devmap-managed-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-freeing-of-devmap-managed-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-freeing-of-devmap-managed-pages.patch

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
Subject: mm: simplify freeing of devmap managed pages

Make put_devmap_managed_page return if it took charge of the page
or not and remove the separate page_is_devmap_managed helper.

Link: https://lkml.kernel.org/r/20220210072828.2930359-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-simplify-freeing-of-devmap-managed-pages
+++ a/include/linux/mm.h
@@ -1089,33 +1089,24 @@ static inline bool is_zone_movable_page(
 #ifdef CONFIG_DEV_PAGEMAP_OPS
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 
-static inline bool page_is_devmap_managed(struct page *page)
+bool __put_devmap_managed_page(struct page *page);
+static inline bool put_devmap_managed_page(struct page *page)
 {
 	if (!static_branch_unlikely(&devmap_managed_key))
 		return false;
 	if (!is_zone_device_page(page))
 		return false;
-	switch (page->pgmap->type) {
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_FS_DAX:
-		return true;
-	default:
-		break;
-	}
-	return false;
+	if (page->pgmap->type != MEMORY_DEVICE_PRIVATE &&
+	    page->pgmap->type != MEMORY_DEVICE_FS_DAX)
+		return false;
+	return __put_devmap_managed_page(page);
 }
 
-void put_devmap_managed_page(struct page *page);
-
 #else /* CONFIG_DEV_PAGEMAP_OPS */
-static inline bool page_is_devmap_managed(struct page *page)
+static inline bool put_devmap_managed_page(struct page *page)
 {
 	return false;
 }
-
-static inline void put_devmap_managed_page(struct page *page)
-{
-}
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
 
 static inline bool is_device_private_page(const struct page *page)
@@ -1215,16 +1206,11 @@ static inline void put_page(struct page
 	struct folio *folio = page_folio(page);
 
 	/*
-	 * For devmap managed pages we need to catch refcount transition from
-	 * 2 to 1, when refcount reach one it means the page is free and we
-	 * need to inform the device driver through callback. See
-	 * include/linux/memremap.h and HMM for details.
+	 * For some devmap managed pages we need to catch refcount transition
+	 * from 2 to 1:
 	 */
-	if (page_is_devmap_managed(&folio->page)) {
-		put_devmap_managed_page(&folio->page);
+	if (put_devmap_managed_page(&folio->page))
 		return;
-	}
-
 	folio_put(folio);
 }
 
--- a/mm/memremap.c~mm-simplify-freeing-of-devmap-managed-pages
+++ a/mm/memremap.c
@@ -523,24 +523,22 @@ void free_devmap_managed_page(struct pag
 	page->pgmap->ops->page_free(page);
 }
 
-void put_devmap_managed_page(struct page *page)
+bool __put_devmap_managed_page(struct page *page)
 {
-	int count;
-
-	if (WARN_ON_ONCE(!page_is_devmap_managed(page)))
-		return;
-
-	count = page_ref_dec_return(page);
-
 	/*
 	 * devmap page refcounts are 1-based, rather than 0-based: if
 	 * refcount is 1, then the page is free and the refcount is
 	 * stable because nobody holds a reference on the page.
 	 */
-	if (count == 1)
+	switch (page_ref_dec_return(page)) {
+	case 1:
 		free_devmap_managed_page(page);
-	else if (!count)
+		break;
+	case 0:
 		__put_page(page);
+		break;
+	}
+	return true;
 }
-EXPORT_SYMBOL(put_devmap_managed_page);
+EXPORT_SYMBOL(__put_devmap_managed_page);
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
--- a/mm/swap.c~mm-simplify-freeing-of-devmap-managed-pages
+++ a/mm/swap.c
@@ -930,16 +930,8 @@ void release_pages(struct page **pages,
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			/*
-			 * ZONE_DEVICE pages that return 'false' from
-			 * page_is_devmap_managed() do not require special
-			 * processing, and instead, expect a call to
-			 * put_page_testzero().
-			 */
-			if (page_is_devmap_managed(page)) {
-				put_devmap_managed_page(page);
+			if (put_devmap_managed_page(page))
 				continue;
-			}
 			if (put_page_testzero(page))
 				put_dev_pagemap(page->pgmap);
 			continue;
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

