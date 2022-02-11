Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5B0C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241836AbiBKUtB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:49:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352252AbiBKUtA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:49:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D73DCFA
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAF62620A2
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F28C340ED;
        Fri, 11 Feb 2022 20:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612538;
        bh=MRtYpXFTHK6KSexzi+A0hKz7bk0Z/Gqi9KbvU0Lwkd8=;
        h=Date:To:From:Subject:From;
        b=zk9oFRGdGxUTc2+alJ33iCnBlIl6henQJFqW4oP1w1MicRVWGcjjMEFgv88XmqPtJ
         mEcTWJ5CMm0HNy76KATOjMsw+deLi0g8WxH1vRtWQA9c/HzdkREUaN5AsN9wJAy+2j
         qAW/ldRG3U9HUFflw6Wjax/yw1zlcsmTEfBi/+mM=
Date:   Fri, 11 Feb 2022 12:48:57 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alex.sierra@amd.com,
        alexander.deucher@amd.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-free_devmap_managed_page-to-memremapc.patch added to -mm tree
Message-Id: <20220211204858.06F28C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move free_devmap_managed_page to memremap.c
has been added to the -mm tree.  Its filename is
     mm-move-free_devmap_managed_page-to-memremapc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-free_devmap_managed_page-to-memremapc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-free_devmap_managed_page-to-memremapc.patch

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
Subject: mm: move free_devmap_managed_page to memremap.c

free_devmap_managed_page has nothing to do with the code in swap.c,
move it to live with the rest of the code for devmap handling.

Link: https://lkml.kernel.org/r/20220210072828.2930359-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
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
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-move-free_devmap_managed_page-to-memremapc
+++ a/include/linux/mm.h
@@ -1087,7 +1087,6 @@ static inline bool is_zone_movable_page(
 }
 
 #ifdef CONFIG_DEV_PAGEMAP_OPS
-void free_devmap_managed_page(struct page *page);
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 
 static inline bool page_is_devmap_managed(struct page *page)
--- a/mm/memremap.c~mm-move-free_devmap_managed_page-to-memremapc
+++ a/mm/memremap.c
@@ -522,4 +522,25 @@ void free_devmap_managed_page(struct pag
 	page->mapping = NULL;
 	page->pgmap->ops->page_free(page);
 }
+
+void put_devmap_managed_page(struct page *page)
+{
+	int count;
+
+	if (WARN_ON_ONCE(!page_is_devmap_managed(page)))
+		return;
+
+	count = page_ref_dec_return(page);
+
+	/*
+	 * devmap page refcounts are 1-based, rather than 0-based: if
+	 * refcount is 1, then the page is free and the refcount is
+	 * stable because nobody holds a reference on the page.
+	 */
+	if (count == 1)
+		free_devmap_managed_page(page);
+	else if (!count)
+		__put_page(page);
+}
+EXPORT_SYMBOL(put_devmap_managed_page);
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
--- a/mm/swap.c~mm-move-free_devmap_managed_page-to-memremapc
+++ a/mm/swap.c
@@ -1154,26 +1154,3 @@ void __init swap_setup(void)
 	 * _really_ don't want to cluster much more
 	 */
 }
-
-#ifdef CONFIG_DEV_PAGEMAP_OPS
-void put_devmap_managed_page(struct page *page)
-{
-	int count;
-
-	if (WARN_ON_ONCE(!page_is_devmap_managed(page)))
-		return;
-
-	count = page_ref_dec_return(page);
-
-	/*
-	 * devmap page refcounts are 1-based, rather than 0-based: if
-	 * refcount is 1, then the page is free and the refcount is
-	 * stable because nobody holds a reference on the page.
-	 */
-	if (count == 1)
-		free_devmap_managed_page(page);
-	else if (!count)
-		__put_page(page);
-}
-EXPORT_SYMBOL(put_devmap_managed_page);
-#endif
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

