Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA97C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiBGVAY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiBGVAV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6D3C061A73
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32DF96150C
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CC8C004E1;
        Mon,  7 Feb 2022 21:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267619;
        bh=A63RcHYMjdjxfECTDXdOEXTRdFmHTVSNziDOdBUkYAQ=;
        h=Date:To:From:Subject:From;
        b=aasugdwo/yZzjkv0Uf6hKjguNluIXPZGZRptQXKPT1uFB0CQjg0I7u3ILW7ZPMGB3
         vn01zzqDC2SH1Ymlz2ikwwxHnGzu9RTXg1cq6RgOr36BE5TGQk84TrcxZNKvSDRDE1
         sPweYjHMVE19KCzB6pffE4ALCtd4gji7vObay8zE=
Date:   Mon, 07 Feb 2022 13:00:19 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vvs@virtuozzo.com,
        uladzislau.rezki@sony.com, oleksiy.avramchenko@sonymobile.com,
        npiggin@gmail.com, hch@lst.de, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-eliminate-an-extra-orig_gfp_mask.patch added to -mm tree
Message-Id: <20220207210019.83CC8C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: eliminate an extra orig_gfp_mask
has been added to the -mm tree.  Its filename is
     mm-vmalloc-eliminate-an-extra-orig_gfp_mask.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-eliminate-an-extra-orig_gfp_mask.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-eliminate-an-extra-orig_gfp_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2965,7 +2965,6 @@ static void *__vmalloc_area_node(struct
 				 int node)
 {
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
-	const gfp_t orig_gfp_mask = gfp_mask;
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
@@ -2989,7 +2988,7 @@ static void *__vmalloc_area_node(struct
 	}
 
 	if (!area->pages) {
-		warn_alloc(orig_gfp_mask, NULL,
+		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to allocated page array size %lu",
 			nr_small_pages * PAGE_SIZE, array_size);
 		free_vm_area(area);
@@ -2999,8 +2998,8 @@ static void *__vmalloc_area_node(struct
 	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
 	page_order = vm_area_page_order(area);
 
-	area->nr_pages = vm_area_alloc_pages(gfp_mask, node,
-		page_order, nr_small_pages, area->pages);
+	area->nr_pages = vm_area_alloc_pages(gfp_mask | __GFP_NOWARN,
+		node, page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 	if (gfp_mask & __GFP_ACCOUNT) {
@@ -3016,7 +3015,7 @@ static void *__vmalloc_area_node(struct
 	 * allocation request, free them via __vfree() if any.
 	 */
 	if (area->nr_pages != nr_small_pages) {
-		warn_alloc(orig_gfp_mask, NULL,
+		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, page order %u, failed to allocate pages",
 			area->nr_pages * PAGE_SIZE, page_order);
 		goto fail;
@@ -3044,7 +3043,7 @@ static void *__vmalloc_area_node(struct
 		memalloc_noio_restore(flags);
 
 	if (ret < 0) {
-		warn_alloc(orig_gfp_mask, NULL,
+		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to map pages",
 			area->nr_pages * PAGE_SIZE);
 		goto fail;
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-move-draining-areas-out-of-caller-context.patch
mm-vmalloc-eliminate-an-extra-orig_gfp_mask.patch

