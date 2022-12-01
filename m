Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6284FC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 23:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiLAXOX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 18:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiLAXOU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 18:14:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38762C6E7B
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 15:14:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A78062190
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 23:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0405C433D6;
        Thu,  1 Dec 2022 23:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669936457;
        bh=Mec/+fYHz21QSwW7QVcMepCb3Y/UVRUeOFHI2vSqWoE=;
        h=Date:To:From:Subject:From;
        b=ZLor0muga92Iq55wbR1Uqd6daRyEPsqTvYkCn6UtBlxUkY54dn0LG3h+ZuimF5PhL
         I4TU95/jLsL4I2KZ8n/8wGFCPZBI5Khz0KXBa4Q9x/WtZYX2NpuPLxFfrrmI2V7q9r
         KHHwiYfrFyGjBocFwzqcZzB2pGuDDqc77PvIPCyM=
Date:   Thu, 01 Dec 2022 15:14:16 -0800
To:     mm-commits@vger.kernel.org, dan.j.williams@intel.com,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-meremap_pages-delete-put_devmap_managed_page_refs-fix.patch removed from -mm tree
Message-Id: <20221201231416.F0405C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memremap: delete static key devmap_managed_key
has been removed from the -mm tree.  Its filename was
     mm-meremap_pages-delete-put_devmap_managed_page_refs-fix.patch

This patch was dropped because it was folded into mm-meremap_pages-delete-put_devmap_managed_page_refs.patch

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memremap: delete static key devmap_managed_key
Date: Thu, 24 Nov 2022 15:39:09 +0800

The static key devmap_managed_key has no users since we deleted
put_devmap_managed_page_refs().  So delete it too.

Link: https://lkml.kernel.org/r/20221124073909.15489-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/mm/memremap.c~mm-meremap_pages-delete-put_devmap_managed_page_refs-fix
+++ a/mm/memremap.c
@@ -38,30 +38,6 @@ unsigned long memremap_compat_align(void
 EXPORT_SYMBOL_GPL(memremap_compat_align);
 #endif
 
-#ifdef CONFIG_FS_DAX
-DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
-EXPORT_SYMBOL(devmap_managed_key);
-
-static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
-{
-	if (pgmap->type == MEMORY_DEVICE_FS_DAX)
-		static_branch_dec(&devmap_managed_key);
-}
-
-static void devmap_managed_enable_get(struct dev_pagemap *pgmap)
-{
-	if (pgmap->type == MEMORY_DEVICE_FS_DAX)
-		static_branch_inc(&devmap_managed_key);
-}
-#else
-static void devmap_managed_enable_get(struct dev_pagemap *pgmap)
-{
-}
-static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
-{
-}
-#endif /* CONFIG_FS_DAX */
-
 static void pgmap_array_delete(struct range *range)
 {
 	xa_store_range(&pgmap_array, PHYS_PFN(range->start), PHYS_PFN(range->end),
@@ -133,7 +109,6 @@ void memunmap_pages(struct dev_pagemap *
 	percpu_ref_exit(&pgmap->ref);
 
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
-	devmap_managed_enable_put(pgmap);
 }
 EXPORT_SYMBOL_GPL(memunmap_pages);
 
@@ -333,8 +308,6 @@ void *memremap_pages(struct dev_pagemap
 	if (error)
 		return ERR_PTR(error);
 
-	devmap_managed_enable_get(pgmap);
-
 	/*
 	 * Clear the pgmap nr_range as it will be incremented for each
 	 * successfully processed range. This communicates how many
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-meremap_pages-delete-put_devmap_managed_page_refs.patch

