Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A17BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 23:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DA3A610E8
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 23:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhIOXSp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXSp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 19:18:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4320610A4;
        Wed, 15 Sep 2021 23:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631747845;
        bh=3XaNBeEidGaugJ2Nn3LoI//cLoWIPNVEif1Drp0Gl+8=;
        h=Date:From:To:Subject:From;
        b=aFy+TAbs8IZq1Lm0xBhyToHH6GyblXZCPk7ZFpyV1ipFeDd/ZLtbXbPuteeM+rXs4
         MWmRnEX0VmtWBzRj7FMWvpv3VkhfydXLZsrR3S4iHQy6Veilwe311E10l2ANXbZ1cp
         LO/dud4SCYXTVEiXZc01amEZuXE+wHUWsX5+p0h0=
Date:   Wed, 15 Sep 2021 16:17:25 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, urezki@gmail.com,
        vvs@virtuozzo.com
Subject:  +
 mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node.patch added to -mm
 tree
Message-ID: <20210915231725.ZGGGYm78c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: repair warn_alloc()s in __vmalloc_area_node()
has been added to the -mm tree.  Its filename is
     mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node
+++ a/mm/vmalloc.c
@@ -2884,6 +2884,7 @@ static void *__vmalloc_area_node(struct
 				 int node)
 {
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
+	const gfp_t orig_gfp_mask = gfp_mask;
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
@@ -2904,7 +2905,7 @@ static void *__vmalloc_area_node(struct
 	}
 
 	if (!area->pages) {
-		warn_alloc(gfp_mask, NULL,
+		warn_alloc(orig_gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to allocated page array size %lu",
 			nr_small_pages * PAGE_SIZE, array_size);
 		free_vm_area(area);
@@ -2924,7 +2925,7 @@ static void *__vmalloc_area_node(struct
 	 * allocation request, free them via __vfree() if any.
 	 */
 	if (area->nr_pages != nr_small_pages) {
-		warn_alloc(gfp_mask, NULL,
+		warn_alloc(orig_gfp_mask, NULL,
 			"vmalloc error: size %lu, page order %u, failed to allocate pages",
 			area->nr_pages * PAGE_SIZE, page_order);
 		goto fail;
@@ -2932,7 +2933,7 @@ static void *__vmalloc_area_node(struct
 
 	if (vmap_pages_range(addr, addr + size, prot, area->pages,
 			page_shift) < 0) {
-		warn_alloc(gfp_mask, NULL,
+		warn_alloc(orig_gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to map pages",
 			area->nr_pages * PAGE_SIZE);
 		goto fail;
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks.patch
mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node.patch

