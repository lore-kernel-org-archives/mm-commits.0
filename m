Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E785C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 377D2227BF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbhAXByC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbhAXBx4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:53:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EDA022CF6;
        Sun, 24 Jan 2021 01:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611453195;
        bh=+aIwSqZuxU6aKXlVcFpI7RrTRWC+rJIXMDNo015dl/I=;
        h=Date:From:To:Subject:From;
        b=XyT14bCalv7XXI+Bf9pL+Dzk7Wh+J8OjXDeGIyiA82IXgwCeMWwfZf50pB9k2PrZD
         we8i76vPjf2Hw6uuLInaVWAstypx6SAcigDV2E3H0tA5Yim4SyeTTkQvlpoUZMrfwL
         /4q0zJhV4WlV9UgKN/LetCaunMlO3dGTcNMOryHI=
Date:   Sat, 23 Jan 2021 17:53:14 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  +
 mm-remove-unneeded-local-variable-in-free_area_init_core.patch added to -mm
 tree
Message-ID: <20210124015314.NL3c_swjG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unneeded local variable in free_area_init_core
has been added to the -mm tree.  Its filename is
     mm-remove-unneeded-local-variable-in-free_area_init_core.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unneeded-local-variable-in-free_area_init_core.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unneeded-local-variable-in-free_area_init_core.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -6925,7 +6925,6 @@ static void __init free_area_init_core(s
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, freesize, memmap_pages;
-		unsigned long zone_start_pfn = zone->zone_start_pfn;
 
 		size = zone->spanned_pages;
 		freesize = zone->present_pages;
@@ -6974,7 +6973,7 @@ static void __init free_area_init_core(s
 
 		set_pageblock_order();
 		setup_usemap(zone);
-		init_currently_empty_zone(zone, zone_start_pfn, size);
+		init_currently_empty_zone(zone, zone->zone_start_pfn, size);
 		memmap_init_zone(zone);
 	}
 }
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-fix-prototype-warning-from-kernel-test-robot.patch
mm-rename-memmap_init-and-memmap_init_zone.patch
mm-simplify-parater-of-function-memmap_init_zone.patch
mm-simplify-parameter-of-setup_usemap.patch
mm-remove-unneeded-local-variable-in-free_area_init_core.patch

