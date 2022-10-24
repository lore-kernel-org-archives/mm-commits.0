Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E88FC67871
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 22:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiJXWUS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 18:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiJXWTt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 18:19:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A2B16A4EB
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 13:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5C2A6158B
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 20:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBBCC433C1;
        Mon, 24 Oct 2022 20:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666643745;
        bh=GSlAQPTsKUwZ/UQo7K1x1PriPC/cwU0XHwG9jwZID/4=;
        h=Date:To:From:Subject:From;
        b=TqFAekHCaQwqRwSE8fFxAiw6N3SuuFKx/gT8tCBKbx5psxJoik4C3CLoDneqmAIm7
         FqlCtOzfh3gYPHLpiwywMYy9yKz9Rb4grN1Z+WxGGkrJco6gbGmXxAagUrFz7vE4y+
         pE2x1LcM0SRB5VphHA6dSVkKcvEumdV9rA34D3oA=
Date:   Mon, 24 Oct 2022 13:35:44 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-make-sure-we-select-best-zspage-size.patch added to mm-unstable branch
Message-Id: <20221024203545.3BBBCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: make sure we select best zspage size
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-make-sure-we-select-best-zspage-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-make-sure-we-select-best-zspage-size.patch

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
zsmalloc-make-sure-we-select-best-zspage-size.patch

