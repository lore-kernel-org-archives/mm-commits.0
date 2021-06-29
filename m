Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73A7C11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A27D361D10
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhF2CoA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:44:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhF2Cn7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F5EF61D0D;
        Tue, 29 Jun 2021 02:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934492;
        bh=Wo7Z/J6aA4TA2vqeWPyyDIyH4nrXw46aIotdRMevQ5A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bXKx/6GOAdLhwwWhrwTSRXt7hBy5zHep9yJAnGlrm5wMHcgwm9L5PAqbqDRxe+ySX
         xHYlfpR4kpvjjSsJG/G0GjHDhDcYdUpyx5nzsA076+Hqo6lMwjqWU+W2LFFa+Ey04S
         QsV9BzDGqL7SBKZ8jZJUAg9zil4xjMHJoes7Yr1U=
Date:   Mon, 28 Jun 2021 19:41:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hkallweit1@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 158/192] mm/page_alloc: switch to pr_debug
Message-ID: <20210629024131.GaiLz20S_%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -6770,9 +6770,8 @@ static __meminit void zone_pcp_init(stru
 	zone->pageset_batch = BOOT_PAGESET_BATCH;
 
 	if (populated_zone(zone))
-		printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%u\n",
-			zone->name, zone->present_pages,
-					 zone_batchsize(zone));
+		pr_debug("  %s zone: %lu pages, LIFO batch:%u\n", zone->name,
+			 zone->present_pages, zone_batchsize(zone));
 }
 
 void __meminit init_currently_empty_zone(struct zone *zone,
@@ -7042,8 +7041,7 @@ static void __init calculate_node_totalp
 
 	pgdat->node_spanned_pages = totalpages;
 	pgdat->node_present_pages = realtotalpages;
-	printk(KERN_DEBUG "On node %d totalpages: %lu\n", pgdat->node_id,
-							realtotalpages);
+	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
 }
 
 #ifndef CONFIG_SPARSEMEM
@@ -7243,9 +7241,8 @@ static void __init free_area_init_core(s
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
@@ -7254,8 +7251,7 @@ static void __init free_area_init_core(s
 		/* Account for reserved pages */
 		if (j == 0 && freesize > dma_reserve) {
 			freesize -= dma_reserve;
-			printk(KERN_DEBUG "  %s zone: %lu pages reserved\n",
-					zone_names[0], dma_reserve);
+			pr_debug("  %s zone: %lu pages reserved\n", zone_names[0], dma_reserve);
 		}
 
 		if (!is_highmem_idx(j))
_
