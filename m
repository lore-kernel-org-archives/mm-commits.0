Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AEBC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB28206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027133;
	bh=b/D/yGxVcB95hm9hjDZzkUfIrfMhIfoJKOR1+np2i8A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qrs9C7mLXhB6RFLoHmXfxiOnwL8I8y3y1gS7+2CC39nnTXyciCo5ZO2X6ssmow3u5
	 wX8ScKnerCMu3Wq+4WrutTMF5V2K02B/qu2WFBZAUpkAWHhHMOVSRyFgkA87pU+XIQ
	 m0b7xHCZ5bDi3BIfaEmg7dUkrfAAjW0A/fzb2wKg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgHJCix (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgHJCiw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:52 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72311206C3;
        Mon, 10 Aug 2020 02:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027131;
        bh=b/D/yGxVcB95hm9hjDZzkUfIrfMhIfoJKOR1+np2i8A=;
        h=Date:From:To:Subject:From;
        b=f/ZukW8g4emIiyomqm1KjKgU0rM5pZGUja3TQGpWO4D3grsOoSdOJQcDKIUo8wSH9
         g30kBNSOxpNX2d8D6p2FYOvCBD78Gu1QYFWuWKo6fmeNRETFDC6mI2u8czxqzuqmaq
         njYDH7QUZb47oA93oXs1XUnEdUKvdfEMcn/cIDg0=
Date:   Sun, 09 Aug 2020 19:38:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, urezki@gmail.com
Subject:  [merged]
 mm-vmalloc-simplify-merge_or_add_vmap_area-func.patch removed from -mm tree
Message-ID: <20200810023851.advu5L0Yz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: simplify merge_or_add_vmap_area()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-simplify-merge_or_add_vmap_area-func.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: simplify merge_or_add_vmap_area()

Currently when a VA is deallocated and is about to be placed back to the
tree, it can be either: merged with next/prev neighbors or inserted if not
coalesced.

On those steps the tree can be populated several times.  For example when
both neighbors are merged.  It can be avoided and simplified in fact.

Therefore do it only once when VA points to final merged area, after all
manipulations: merging/removing/inserting.

Link: http://lkml.kernel.org/r/20200527205054.1696-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-simplify-merge_or_add_vmap_area-func
+++ a/mm/vmalloc.c
@@ -797,9 +797,6 @@ merge_or_add_vmap_area(struct vmap_area
 		if (sibling->va_start == va->va_end) {
 			sibling->va_start = va->va_start;
 
-			/* Check and update the tree if needed. */
-			augment_tree_propagate_from(sibling);
-
 			/* Free vmap_area object. */
 			kmem_cache_free(vmap_area_cachep, va);
 
@@ -819,14 +816,18 @@ merge_or_add_vmap_area(struct vmap_area
 	if (next->prev != head) {
 		sibling = list_entry(next->prev, struct vmap_area, list);
 		if (sibling->va_end == va->va_start) {
-			sibling->va_end = va->va_end;
-
-			/* Check and update the tree if needed. */
-			augment_tree_propagate_from(sibling);
-
+			/*
+			 * If both neighbors are coalesced, it is important
+			 * to unlink the "next" node first, followed by merging
+			 * with "previous" one. Otherwise the tree might not be
+			 * fully populated if a sibling's augmented value is
+			 * "normalized" because of rotation operations.
+			 */
 			if (merged)
 				unlink_va(va, root);
 
+			sibling->va_end = va->va_end;
+
 			/* Free vmap_area object. */
 			kmem_cache_free(vmap_area_cachep, va);
 
@@ -837,11 +838,13 @@ merge_or_add_vmap_area(struct vmap_area
 	}
 
 insert:
-	if (!merged) {
+	if (!merged)
 		link_va(va, root, parent, link, head);
-		augment_tree_propagate_from(va);
-	}
 
+	/*
+	 * Last step is to check and update the tree.
+	 */
+	augment_tree_propagate_from(va);
 	return va;
 }
 
_

Patches currently in -mm which might be from urezki@gmail.com are


