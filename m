Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC79C46467
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 21:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbjAPVjS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 16:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjAPVjR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 16:39:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C9D2BED9
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 13:39:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDCA4B81060
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 21:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BF7C433EF;
        Mon, 16 Jan 2023 21:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673905153;
        bh=gZyx+YDXG1TOo1ssvz5X68O9DmhywuCb+KCeYni50u0=;
        h=Date:To:From:Subject:From;
        b=2tqtCFofxY+s+05N9G7BMoyb2vZ9JBGn7Vo7fUJaCFG3TJT4dWHhP388T2h5X478u
         j2012jcIZM8XJHg+NM1zasnLrSOEufljY78gRDovGPf08MOf4ji8h7TZvEh0X4gBYT
         78KW3kl7vbyecc+KSAKxjOiDRfB7xS7adwEQSnpU=
Date:   Mon, 16 Jan 2023 13:39:12 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zsmalloc-rework-zspage-chain-size-selection.patch removed from -mm tree
Message-Id: <20230116213913.81BF7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: rework zspage chain size selection
has been removed from the -mm tree.  Its filename was
     zsmalloc-rework-zspage-chain-size-selection.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: rework zspage chain size selection
Date: Mon, 9 Jan 2023 12:38:35 +0900

Patch series "zsmalloc: make zspage chain size configurable", v2.

This turns the hard coded limit on maximum number of physical pages
per-zspage into a config option.  It also increases the default limit from
4 to 8.  


This patch (of 4):

Computers are bad at division.  We currently decide the best zspage chain
size (max number of physical pages per-zspage) by looking at a `used
percentage` value.  This is not enough as we lose precision during usage
percentage calculations For example, let's look at size class 208:

pages per zspage       wasted bytes         used%
       1                   144               96
       2                    80               99
       3                    16               99
       4                   160               99

Current algorithm will select 2 page per zspage configuration, as it's the
first one to reach 99%.  However, 3 pages per zspage waste less memory.

Change algorithm and select zspage configuration that has lowest wasted
value.

Link: https://lkml.kernel.org/r/20230109033838.2779902-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20230109033838.2779902-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-rework-zspage-chain-size-selection
+++ a/mm/zsmalloc.c
@@ -822,42 +822,6 @@ out:
 	return newfg;
 }
 
-/*
- * We have to decide on how many pages to link together
- * to form a zspage for each size class. This is important
- * to reduce wastage due to unusable space left at end of
- * each zspage which is given as:
- *     wastage = Zp % class_size
- *     usage = Zp - wastage
- * where Zp = zspage size = k * PAGE_SIZE where k = 1, 2, ...
- *
- * For example, for size class of 3/8 * PAGE_SIZE, we should
- * link together 3 PAGE_SIZE sized pages to form a zspage
- * since then we can perfectly fit in 8 such objects.
- */
-static int get_pages_per_zspage(int class_size)
-{
-	int i, max_usedpc = 0;
-	/* zspage order which gives maximum used size per KB */
-	int max_usedpc_order = 1;
-
-	for (i = 1; i <= ZS_MAX_PAGES_PER_ZSPAGE; i++) {
-		int zspage_size;
-		int waste, usedpc;
-
-		zspage_size = i * PAGE_SIZE;
-		waste = zspage_size % class_size;
-		usedpc = (zspage_size - waste) * 100 / zspage_size;
-
-		if (usedpc > max_usedpc) {
-			max_usedpc = usedpc;
-			max_usedpc_order = i;
-		}
-	}
-
-	return max_usedpc_order;
-}
-
 static struct zspage *get_zspage(struct page *page)
 {
 	struct zspage *zspage = (struct zspage *)page_private(page);
@@ -2401,6 +2365,24 @@ static int zs_register_shrinker(struct z
 				 pool->name);
 }
 
+static int calculate_zspage_chain_size(int class_size)
+{
+	int i, min_waste = INT_MAX;
+	int chain_size = 1;
+
+	for (i = 1; i <= ZS_MAX_PAGES_PER_ZSPAGE; i++) {
+		int waste;
+
+		waste = (i * PAGE_SIZE) % class_size;
+		if (waste < min_waste) {
+			min_waste = waste;
+			chain_size = i;
+		}
+	}
+
+	return chain_size;
+}
+
 /**
  * zs_create_pool - Creates an allocation pool to work from.
  * @name: pool name to be created
@@ -2445,7 +2427,7 @@ struct zs_pool *zs_create_pool(const cha
 		size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
 		if (size > ZS_MAX_ALLOC_SIZE)
 			size = ZS_MAX_ALLOC_SIZE;
-		pages_per_zspage = get_pages_per_zspage(size);
+		pages_per_zspage = calculate_zspage_chain_size(size);
 		objs_per_zspage = pages_per_zspage * PAGE_SIZE / size;
 
 		/*
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-correctly-handle-all-next_arg-cases.patch
zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch
zsmalloc-make-zspage-chain-size-configurable.patch
zsmalloc-make-zspage-chain-size-configurable-fix.patch
zsmalloc-set-default-zspage-chain-size-to-8.patch

