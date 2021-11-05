Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6FCC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E90BE6126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhKEUmA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233429AbhKEUl7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8686C611C0;
        Fri,  5 Nov 2021 20:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144759;
        bh=aBcUhrqpaJfBMDAJwgABLlQ6kUsrlKOTpt0nhKo1fx0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Y0MQvbuGHcRN6vld3QDLCbDu1mu3cq2sDehCX0Y7bZbjkklgJtlhWwxPn60laXbBn
         1FaxwcRTa3T0xvm+OY4fTmHbIQk8aZKnYjT381aJrMjNjvSEFmdux6oiTDsQpJyeS2
         6c3cRPxEOYYygiXcKOoOKO996oXhPb92vHVI40C4=
Date:   Fri, 05 Nov 2021 13:39:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, urezki@gmail.com, vvs@virtuozzo.com
Subject:  [patch 089/262] mm/vmalloc: repair warn_alloc()s in
 __vmalloc_area_node()
Message-ID: <20211105203919.fOpfiPRMV%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Subject: mm/vmalloc: repair warn_alloc()s in __vmalloc_area_node()

Commit f255935b9767 ("mm: cleanup the gfp_mask handling in
__vmalloc_area_node") added __GFP_NOWARN to gfp_mask unconditionally
however it disabled all output inside warn_alloc() call.  This patch saves
original gfp_mask and provides it to all warn_alloc() calls.

Link: https://lkml.kernel.org/r/f4f3187b-9684-e426-565d-827c2a9bbb0e@virtuozzo.com
Fixes: f255935b9767 ("mm: cleanup the gfp_mask handling in __vmalloc_area_node")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node
+++ a/mm/vmalloc.c
@@ -2887,6 +2887,7 @@ static void *__vmalloc_area_node(struct
 				 int node)
 {
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
+	const gfp_t orig_gfp_mask = gfp_mask;
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
@@ -2907,7 +2908,7 @@ static void *__vmalloc_area_node(struct
 	}
 
 	if (!area->pages) {
-		warn_alloc(gfp_mask, NULL,
+		warn_alloc(orig_gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to allocated page array size %lu",
 			nr_small_pages * PAGE_SIZE, array_size);
 		free_vm_area(area);
@@ -2927,7 +2928,7 @@ static void *__vmalloc_area_node(struct
 	 * allocation request, free them via __vfree() if any.
 	 */
 	if (area->nr_pages != nr_small_pages) {
-		warn_alloc(gfp_mask, NULL,
+		warn_alloc(orig_gfp_mask, NULL,
 			"vmalloc error: size %lu, page order %u, failed to allocate pages",
 			area->nr_pages * PAGE_SIZE, page_order);
 		goto fail;
@@ -2935,7 +2936,7 @@ static void *__vmalloc_area_node(struct
 
 	if (vmap_pages_range(addr, addr + size, prot, area->pages,
 			page_shift) < 0) {
-		warn_alloc(gfp_mask, NULL,
+		warn_alloc(orig_gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to map pages",
 			area->nr_pages * PAGE_SIZE);
 		goto fail;
_
