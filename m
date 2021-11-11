Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D0BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D47761284
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhKKCqF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234200AbhKKCqC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 865C06113B;
        Thu, 11 Nov 2021 02:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598593;
        bh=mwV1cc536yfQNH/EACmsGMHxyW+wYmhJCzSp/lP21Ss=;
        h=Date:From:To:Subject:From;
        b=pHnMDSDSNqgcem7EcTdr92rAkQ1nobRMMDy2W2JLmpXkWNU+Etm1qk2nY7V6TsR3b
         TBCXkKiJT/0OK/cqF9xjq1kIVnt2XwG1FHt4ASIUi1VAW4xfhNO7zzCtZOE4VetB8t
         bqx2ne0yGc/z4gYF/Z1zyXRiQPZ4ZeBrrsBLieEE=
Date:   Wed, 10 Nov 2021 18:43:13 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        urezki@gmail.com, vvs@virtuozzo.com
Subject:  [merged]
 mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node.patch removed from -mm
 tree
Message-ID: <20211111024313.G13iOI2lM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: repair warn_alloc()s in __vmalloc_area_node()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vvs@virtuozzo.com are


