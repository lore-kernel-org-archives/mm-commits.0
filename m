Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCCEC433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 798F364F1A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhBYTau (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234550AbhBYT1z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:27:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F3D464F90;
        Thu, 25 Feb 2021 19:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280575;
        bh=CGKBfOVVwB3WYaoSiFto8vTwH2GeUuy4KcGHryiNqc8=;
        h=Date:From:To:Subject:From;
        b=F/iFS3MrLyc4QHmpOeXk1u0sl+MQlWXE7kWryZ4k9nwROhKtFU4OrXUIl8zOr7xID
         l2xeQxlFNeuo20mYYRs8NGUW0uAZlnLh/ifqJ4H5QpeJPjz+ELHnEZphZyHsLosPca
         +wfJPaQfQR1StJlT9f4WX1+e0xj7DQEMRaJWGnvI=
Date:   Thu, 25 Feb 2021 11:16:15 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  [merged]
 mm-remove-unneeded-local-variable-in-free_area_init_core.patch removed from
 -mm tree
Message-ID: <20210225191615.phtIaY_8x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unneeded local variable in free_area_init_core
has been removed from the -mm tree.  Its filename was
     mm-remove-unneeded-local-variable-in-free_area_init_core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm: remove unneeded local variable in free_area_init_core

Local variable 'zone_start_pfn' is not needed since there's only one call
site in free_area_init_core().  Let's remove it and pass
zone->zone_start_pfn directly to init_currently_empty_zone().

Link: https://lkml.kernel.org/r/20210122135956.5946-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-remove-unneeded-local-variable-in-free_area_init_core
+++ a/mm/page_alloc.c
@@ -6927,7 +6927,6 @@ static void __init free_area_init_core(s
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, freesize, memmap_pages;
-		unsigned long zone_start_pfn = zone->zone_start_pfn;
 
 		size = zone->spanned_pages;
 		freesize = zone->present_pages;
@@ -6976,7 +6975,7 @@ static void __init free_area_init_core(s
 
 		set_pageblock_order();
 		setup_usemap(zone);
-		init_currently_empty_zone(zone, zone_start_pfn, size);
+		init_currently_empty_zone(zone, zone->zone_start_pfn, size);
 		memmap_init_zone(zone);
 	}
 }
_

Patches currently in -mm which might be from bhe@redhat.com are


