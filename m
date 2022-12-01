Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03289C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 23:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiLAXN4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 18:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLAXNz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 18:13:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B51E24D
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 15:13:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 358956219D
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 23:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCC0C433C1;
        Thu,  1 Dec 2022 23:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669936433;
        bh=kqyexjVyO3XrpKibwFZHV/p7uAO0eAovIhQTKjvKw6E=;
        h=Date:To:From:Subject:From;
        b=Z/ce+vovPiGu7nIU+ZxcWR9QIOIMJoGDE1oc5qW10nGCyKCRuFbYFKc56cr6u2lH+
         OabLvKhRfLkunxw9TCm+OSNAVniPLqO1K/iOar1KyhRoYp8nYp+yr2XmVWV3NlTfVL
         upGgEJx9PdG/YsgKs8CBqoJEJj2H+ixIwJjGZlbE=
Date:   Thu, 01 Dec 2022 15:13:52 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        dan.j.williams@intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch removed from -mm tree
Message-Id: <20221201231353.8BCC0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix
has been removed from the -mm tree.  Its filename was
     mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch

This patch was dropped because it was folded into mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix
Date: Wed Oct 19 04:28:52 PM PDT 2022

restore removal of zone_device_page_init

Reported-by: kernel test robot <lkp@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/mm/memremap.c~mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix
+++ a/mm/memremap.c
@@ -519,18 +519,6 @@ void free_zone_device_page(struct page *
 		put_dev_pagemap(page->pgmap);
 }
 
-void zone_device_page_init(struct page *page)
-{
-	/*
-	 * Drivers shouldn't be allocating pages after calling
-	 * memunmap_pages().
-	 */
-	WARN_ON_ONCE(!percpu_ref_tryget_live(&page->pgmap->ref));
-	set_page_count(page, 1);
-	lock_page(page);
-}
-EXPORT_SYMBOL_GPL(zone_device_page_init);
-
 static __maybe_unused bool folio_span_valid(struct dev_pagemap *pgmap,
 					    struct folio *folio,
 					    int nr_folios)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-align-larger-anonymous-mappings-on-thp-boundaries.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch

