Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECA3C11F66
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C97FC61107
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhGFTRD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231727AbhGFTRD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:17:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81C1C61107;
        Tue,  6 Jul 2021 19:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598863;
        bh=f2vQMZ/PuVqpuQOc2AVqfdAVxR8x++w0ztW7pJleCCU=;
        h=Date:From:To:Subject:From;
        b=kavHFwcL3uw2XKTIjrbASA+ioCtK3qSCBW681QEw+FA7bly+zPLP9rW+c1X+6Mbvd
         r4BbiO6Wf/xOkjz3ahRRtDok07oT9nsNSvmzz+ji/j11hELdv4xcc5bstCUHBCEOg0
         GDrU5CYcoBDwMQBF8d1j+a+dVsfsgMQnZFUGhyYk=
Date:   Tue, 06 Jul 2021 12:14:23 -0700
From:   akpm@linux-foundation.org
To:     hkallweit1@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged] mm-page_alloc-switch-to-pr_debug.patch removed
 from -mm tree
Message-ID: <20210706191423.MVkPHvF2t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: switch to pr_debug
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-switch-to-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from hkallweit1@gmail.com are


