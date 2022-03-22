Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9F3C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbiCVVof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbiCVVo3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB2E8D
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:43:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9DB6B81D77
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B129C340EC;
        Tue, 22 Mar 2022 21:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985377;
        bh=RuagpvtIP+q3zKI8V0gZFyAfB4Nt0+fKY1JfMjH+53s=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=qEdu+fuQEkdO56qTxG5x/hvSbxA5kph5RRcRwirOvz0k+6dI7D1FBkSmIc4GmNfb7
         iA8EfwO0xMoRZ4pMC2Akb8flGQ9FUbC85efVKxJSPntBZUkavv+nnE4ZkDa+hI15qo
         uKEWBZYXsTocrt0QbxYvAVE9qWw8th6vKtf/5zKQ=
Date:   Tue, 22 Mar 2022 14:42:56 -0700
To:     willy@infradead.org, vvs@virtuozzo.com, uladzislau.rezki@sony.com,
        oleksiy.avramchenko@sonymobile.com, npiggin@gmail.com, hch@lst.de,
        urezki@gmail.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 087/227] mm/vmalloc: eliminate an extra orig_gfp_mask
Message-Id: <20220322214257.7B129C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: eliminate an extra orig_gfp_mask

That extra variable has been introduced just for keeping an original
passed gfp_mask because it is updated with __GFP_NOWARN on entry, thus
error handling messages were broken.

Instead we can keep an original gfp_mask without modifying it and add an
extra __GFP_NOWARN flag together with gfp_mask as a parameter to the
vm_area_alloc_pages() function.  It will make it less confused.

Link: https://lkml.kernel.org/r/20220119143540.601149-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-eliminate-an-extra-orig_gfp_mask
+++ a/mm/vmalloc.c
@@ -2946,7 +2946,6 @@ static void *__vmalloc_area_node(struct
 				 int node)
 {
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
-	const gfp_t orig_gfp_mask = gfp_mask;
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
@@ -2970,7 +2969,7 @@ static void *__vmalloc_area_node(struct
 	}
 
 	if (!area->pages) {
-		warn_alloc(orig_gfp_mask, NULL,
+		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to allocated page array size %lu",
 			nr_small_pages * PAGE_SIZE, array_size);
 		free_vm_area(area);
@@ -2980,8 +2979,8 @@ static void *__vmalloc_area_node(struct
 	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
 	page_order = vm_area_page_order(area);
 
-	area->nr_pages = vm_area_alloc_pages(gfp_mask, node,
-		page_order, nr_small_pages, area->pages);
+	area->nr_pages = vm_area_alloc_pages(gfp_mask | __GFP_NOWARN,
+		node, page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 	if (gfp_mask & __GFP_ACCOUNT) {
@@ -2997,7 +2996,7 @@ static void *__vmalloc_area_node(struct
 	 * allocation request, free them via __vfree() if any.
 	 */
 	if (area->nr_pages != nr_small_pages) {
-		warn_alloc(orig_gfp_mask, NULL,
+		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, page order %u, failed to allocate pages",
 			area->nr_pages * PAGE_SIZE, page_order);
 		goto fail;
@@ -3025,7 +3024,7 @@ static void *__vmalloc_area_node(struct
 		memalloc_noio_restore(flags);
 
 	if (ret < 0) {
-		warn_alloc(orig_gfp_mask, NULL,
+		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to map pages",
 			area->nr_pages * PAGE_SIZE);
 		goto fail;
_
