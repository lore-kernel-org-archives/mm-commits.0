Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DB5C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 04:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 613CB64F66
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 04:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhCMEY2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 23:24:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhCMEX5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 23:23:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BF0964F4F;
        Sat, 13 Mar 2021 04:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615609436;
        bh=MoiGlJSL0MJvu256kscL+imBiMgDx+KbxhxR2rIvz3o=;
        h=Date:From:To:Subject:From;
        b=PWkcGWrH1g+CVnIS6R7QeyiCpHbDt1VALoRSpE1TeM6ipi7wbdFi4biEP0p+NMMFt
         rQY49QobmRyyVjX5/FaOCXUYsFY4PVPYUOseGyWfe4RLhjTUaCI6Ll5ocVe7Z99YVD
         nsq4/yii8mvXofEQDL1v7YQ5ZJjQcoWZSON+l3Y4=
Date:   Fri, 12 Mar 2021 20:23:56 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-page=5Fallocc-refactor-initialization-of-struct-page-for-?=
 =?US-ASCII?Q?holes-in-memory-layout-fix.patch?= removed from -mm tree
Message-ID: <20210313042356._Eiw7fXgi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch

This patch was dropped because it was folded into mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix

don't initialize static to zero, use %llu for u64

Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix
+++ a/mm/page_alloc.c
@@ -6315,7 +6315,7 @@ void __meminit __weak memmap_init_zone(s
 	unsigned long zone_start_pfn = zone->zone_start_pfn;
 	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
 	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
-	static unsigned long hole_pfn = 0;
+	static unsigned long hole_pfn;
 	unsigned long start_pfn, end_pfn;
 	u64 pgcnt = 0;
 
@@ -6348,7 +6348,7 @@ void __meminit __weak memmap_init_zone(s
 #endif
 
 	if (pgcnt)
-		pr_info("  %s zone: %lld pages in unavailable ranges\n",
+		pr_info("  %s zone: %llu pages in unavailable ranges\n",
 			zone->name, pgcnt);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

