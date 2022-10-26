Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C41C38A02
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 01:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiJZBkN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 21:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiJZBkN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 21:40:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEED928E1B
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 18:40:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEE37B81F88
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 01:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E686C433D6;
        Wed, 26 Oct 2022 01:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666748407;
        bh=59Ymwl0L2MoTu8c/Gu1X1xkeGMyQldn/RrgNSeKxgLI=;
        h=Date:To:From:Subject:From;
        b=YIA2mTlhQPGJ4ShBjjO9sw0anyoTujn9a8I573ePUQhZ5i1+4VC5FYcM/Mvq7Zwta
         onaxhDM+5RurdG6HupFk30+43i8TRPZmHgdj5IiYBzcgFVU60GxGFI1Ygzzh3lsuTs
         pusK52WG6c4MCCeI2cmY4t/cAijWJQBP+hKIAk+M=
Date:   Tue, 25 Oct 2022 18:40:05 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] zsmalloc-make-sure-we-select-best-zspage-size.patch removed from -mm tree
Message-Id: <20221026014007.2E686C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: make sure we select best zspage size
has been removed from the -mm tree.  Its filename was
     zsmalloc-make-sure-we-select-best-zspage-size.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: make sure we select best zspage size
Date: Tue, 25 Oct 2022 01:12:13 +0900

We currently decide the best zspage size by looking at used percentage
value.  This is not exactly enough as zspage usage percentage calculation
is not accurate.

For example, let's look at size class 208

pages per zspage       wasted bytes         used%
       1                   144               96
       2                    80               99
       3                    16               99
       4                   160               99

We will select 2 page per zspage configuration, as it is the first one to
reach 99%.  However, 3 pages per zspage wastes less memory.  Hence we need
to also consider wasted space metrics when device zspage size.

Additionally, rename max_usedpc_order because it does not hold zspage
order, it holds maximum pages per-zspage value.

Link: https://lkml.kernel.org/r/20221024161213.3221725-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-make-sure-we-select-best-zspage-size
+++ a/mm/zsmalloc.c
@@ -775,8 +775,9 @@ out:
 static int get_pages_per_zspage(struct zs_pool *pool, int class_size)
 {
 	int i, max_usedpc = 0;
-	/* zspage order which gives maximum used size per KB */
-	int max_usedpc_order = 1;
+	/* zspage size which gives maximum used size per KB */
+	int pages_per_zspage = 1;
+	int min_waste = INT_MAX;
 
 	for (i = 1; i <= pool->max_pages_per_zspage; i++) {
 		int zspage_size;
@@ -788,14 +789,19 @@ static int get_pages_per_zspage(struct z
 
 		if (usedpc > max_usedpc) {
 			max_usedpc = usedpc;
-			max_usedpc_order = i;
+			pages_per_zspage = i;
 		}
 
 		if (usedpc == 100)
 			break;
+
+		if (waste < min_waste) {
+			min_waste = waste;
+			pages_per_zspage = i;
+		}
 	}
 
-	return max_usedpc_order;
+	return pages_per_zspage;
 }
 
 static struct zspage *get_zspage(struct page *page)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
documentation-add-recompression-documentation.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zsmalloc-turn-zspage-order-into-runtime-variable.patch
zsmalloc-zram-pass-zspage-order-to-zs_create_pool.patch
zram-add-pool_page_order-device-attribute.patch
documentation-document-zram-pool_page_order-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch

