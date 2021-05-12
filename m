Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681D1C43600
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46DC0613C0
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbhELXdy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 19:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238214AbhELXZc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 19:25:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD4E3613DA;
        Wed, 12 May 2021 23:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620861863;
        bh=ICaPhOw2PzNRCapA4TL/H+ycdoD80zkJEo117W3aKvU=;
        h=Date:From:To:Subject:From;
        b=cmdmmU1Ur1plC0f9IgUmVBnQhZeddLMnxjoSd2ph7LWyGKUO/cp28CuBY/Fp2ZMlE
         R5mTXNOQWAdE5TvjsceOregMh/9D4vBtgb//kTRxYBaRHWvWQGBfxtCbB2vRtL9xYY
         8UZbgT79a8HI6uGhG30D6bwLYPcEUPJR01hm/z5I=
Date:   Wed, 12 May 2021 16:24:22 -0700
From:   akpm@linux-foundation.org
To:     hkallweit1@gmail.com, mm-commits@vger.kernel.org
Subject:  + mm-page_alloc-switch-to-pr_debug.patch added to -mm
 tree
Message-ID: <20210512232422.e1VUPH6as%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: switch to pr_debug
has been added to the -mm tree.  Its filename is
     mm-page_alloc-switch-to-pr_debug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-switch-to-pr_debug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-switch-to-pr_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: mm/page_alloc: switch to pr_debug

Having such debug messages in the dmesg log may confuse users.  Therefore
restrict debug output to cases where DEBUG is defined or dynamic debugging
is enabled for the respective code piece.

Link: https://lkml.kernel.org/r/976adb93-3041-ce63-48fc-55a6096a51c1@gmail.com
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-switch-to-pr_debug
+++ a/mm/page_alloc.c
@@ -6742,9 +6742,8 @@ static __meminit void zone_pcp_init(stru
 	zone->pageset_batch = BOOT_PAGESET_BATCH;
 
 	if (populated_zone(zone))
-		printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%u\n",
-			zone->name, zone->present_pages,
-					 zone_batchsize(zone));
+		pr_debug("  %s zone: %lu pages, LIFO batch:%u\n", zone->name,
+			 zone->present_pages, zone_batchsize(zone));
 }
 
 void __meminit init_currently_empty_zone(struct zone *zone,
@@ -7014,8 +7013,7 @@ static void __init calculate_node_totalp
 
 	pgdat->node_spanned_pages = totalpages;
 	pgdat->node_present_pages = realtotalpages;
-	printk(KERN_DEBUG "On node %d totalpages: %lu\n", pgdat->node_id,
-							realtotalpages);
+	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
 }
 
 #ifndef CONFIG_SPARSEMEM
@@ -7215,9 +7213,8 @@ static void __init free_area_init_core(s
 			if (freesize >= memmap_pages) {
 				freesize -= memmap_pages;
 				if (memmap_pages)
-					printk(KERN_DEBUG
-					       "  %s zone: %lu pages used for memmap\n",
-					       zone_names[j], memmap_pages);
+					pr_debug("  %s zone: %lu pages used for memmap\n",
+						 zone_names[j], memmap_pages);
 			} else
 				pr_warn("  %s zone: %lu pages exceeds freesize %lu\n",
 					zone_names[j], memmap_pages, freesize);
@@ -7226,8 +7223,7 @@ static void __init free_area_init_core(s
 		/* Account for reserved pages */
 		if (j == 0 && freesize > dma_reserve) {
 			freesize -= dma_reserve;
-			printk(KERN_DEBUG "  %s zone: %lu pages reserved\n",
-					zone_names[0], dma_reserve);
+			pr_debug("  %s zone: %lu pages reserved\n", zone_names[0], dma_reserve);
 		}
 
 		if (!is_highmem_idx(j))
_

Patches currently in -mm which might be from hkallweit1@gmail.com are

mm-page_alloc-switch-to-pr_debug.patch

