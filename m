Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2F3C63797
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 21:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbjAPVjX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 16:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbjAPVjU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 16:39:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287592BEDE
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 13:39:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF681B810E0
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 21:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D695C433F1;
        Mon, 16 Jan 2023 21:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673905156;
        bh=t5FFboup23L8XuEsKKQHgE3Cw1xvg0LVIdAH+L6z36E=;
        h=Date:To:From:Subject:From;
        b=Y+KEDvmLphMdNSrcMMUFC+cb6fkFDWZr1XpeWUCMBYyVlncyhAP1PF0HzAkmMNLGh
         /0f6/VAcUOshSfN0LPp90nqjdmm5vaFgmu2X6A19OgHQ4MG3rOW6GS7PnMqQIr2AX/
         sXGnMzJfNRz7rsBQyYojCIftQvyeEol/oOXOGVIk=
Date:   Mon, 16 Jan 2023 13:39:15 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zsmalloc-make-zspage-chain-size-configurable-fix.patch removed from -mm tree
Message-Id: <20230116213916.7D695C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: turn chain size config option into UL constant
has been removed from the -mm tree.  Its filename was
     zsmalloc-make-zspage-chain-size-configurable-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: turn chain size config option into UL constant
Date: Thu, 12 Jan 2023 16:14:43 +0900

This fixes

>> mm/zsmalloc.c:122:59: warning: right shift count >= width of type [-Wshift-count-overflow]

and

>> mm/zsmalloc.c:224:28: error: variably modified 'size_class' at file scope
     224 |         struct size_class *size_class[ZS_SIZE_CLASSES];

Link: https://lkml.kernel.org/r/20230112071443.1933880-1-senozhatsky@chromium.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-make-zspage-chain-size-configurable-fix
+++ a/mm/zsmalloc.c
@@ -133,9 +133,12 @@
 #define MAGIC_VAL_BITS	8
 
 #define MAX(a, b) ((a) >= (b) ? (a) : (b))
+
+#define ZS_MAX_PAGES_PER_ZSPAGE	(_AC(CONFIG_ZSMALLOC_CHAIN_SIZE, UL))
+
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (CONFIG_ZSMALLOC_CHAIN_SIZE << PAGE_SHIFT >> OBJ_INDEX_BITS))
+	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
 /* each chunk includes extra space to keep handle */
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
@@ -1119,7 +1122,7 @@ static struct zspage *alloc_zspage(struc
 					gfp_t gfp)
 {
 	int i;
-	struct page *pages[CONFIG_ZSMALLOC_CHAIN_SIZE];
+	struct page *pages[ZS_MAX_PAGES_PER_ZSPAGE];
 	struct zspage *zspage = cache_alloc_zspage(pool, gfp);
 
 	if (!zspage)
@@ -1986,7 +1989,7 @@ static void replace_sub_page(struct size
 				struct page *newpage, struct page *oldpage)
 {
 	struct page *page;
-	struct page *pages[CONFIG_ZSMALLOC_CHAIN_SIZE] = {NULL, };
+	struct page *pages[ZS_MAX_PAGES_PER_ZSPAGE] = {NULL, };
 	int idx = 0;
 
 	page = get_first_page(zspage);
@@ -2366,7 +2369,7 @@ static int calculate_zspage_chain_size(i
 	if (is_power_of_2(class_size))
 		return chain_size;
 
-	for (i = 1; i <= CONFIG_ZSMALLOC_CHAIN_SIZE; i++) {
+	for (i = 1; i <= ZS_MAX_PAGES_PER_ZSPAGE; i++) {
 		int waste;
 
 		waste = (i * PAGE_SIZE) % class_size;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-correctly-handle-all-next_arg-cases.patch
zsmalloc-set-default-zspage-chain-size-to-8.patch

