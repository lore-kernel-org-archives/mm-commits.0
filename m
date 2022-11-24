Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7BCC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 22:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiKXWWl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Nov 2022 17:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKXWWk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Nov 2022 17:22:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B558C2037A
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 14:22:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B43D362274
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 22:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0769EC433B5;
        Thu, 24 Nov 2022 22:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669328557;
        bh=GHYaWkeiROM9Ug1GNZmTJX/9sEcUn5041idyus9C+nk=;
        h=Date:To:From:Subject:From;
        b=cv7UuR2kSts4TdCGRMRURMNPirrftkxuiZJQlyDz3C4jsVJPkC3fzTFTQqzn17PUP
         qWTbGtw/IJo/umwQFS+QDi2htopiCGQdT/Mg32R5c0mIUw+ariOwCbiee4mY+3BmX4
         AklPrtIxuFcNa/zp2zVPDGm2D9X+UccLPMv0RQZU=
Date:   Thu, 24 Nov 2022 14:22:36 -0800
To:     mm-commits@vger.kernel.org, dan.j.williams@intel.com,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-meremap_pages-delete-put_devmap_managed_page_refs-fix.patch added to mm-unstable branch
Message-Id: <20221124222237.0769EC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memremap: delete static key devmap_managed_key
has been added to the -mm mm-unstable branch.  Its filename is
     mm-meremap_pages-delete-put_devmap_managed_page_refs-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-meremap_pages-delete-put_devmap_managed_page_refs-fix.patch

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

mm-meremap_pages-delete-put_devmap_managed_page_refs-fix.patch

