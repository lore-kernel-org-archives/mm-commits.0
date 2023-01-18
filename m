Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CF1C00A5A
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 01:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjARBKY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 20:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjARBJl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 20:09:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5BC3D914
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 17:04:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36BA7B81A3D
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 01:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7C5C433D2;
        Wed, 18 Jan 2023 01:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674003853;
        bh=b4Fv5yz6/SHaXyCgXyceUq0eT1eSb2ivn7B5R3+406w=;
        h=Date:To:From:Subject:From;
        b=L+JDrz403CUT6/bzCWMvxID327vY13t+7shzrLQGxMwCU5z8exvRZuFZN/yHm8sUi
         10wPTSSnoMHMQOOBhNczlXEp+cVU/ojYNg7HPOLXtaKOYlFtaa49J/7CNojVWojBI0
         r3qnvoGLJm99QYdPnF3NDvH+iIbTPbYWLvjxYcSM=
Date:   Tue, 17 Jan 2023 17:04:13 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        mike.kravetz@oracle.com, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-rework-zspage-chain-size-selection.patch added to mm-unstable branch
Message-Id: <20230118010413.CF7C5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: rework zspage chain size selection
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-rework-zspage-chain-size-selection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-rework-zspage-chain-size-selection.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: rework zspage chain size selection
Date: Wed, 18 Jan 2023 09:52:07 +0900

Patch series "zsmalloc: make zspage chain size configurable".

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

Link: https://lkml.kernel.org/r/20230118005210.2814763-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20230118005210.2814763-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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
zsmalloc-rework-zspage-chain-size-selection.patch
zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch
zsmalloc-make-zspage-chain-size-configurable.patch
zsmalloc-set-default-zspage-chain-size-to-8.patch

