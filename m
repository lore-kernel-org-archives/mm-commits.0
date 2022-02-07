Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4479C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiBGVAY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiBGVAU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABB4C06173B
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CB8D61559
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE5DC340EE;
        Mon,  7 Feb 2022 21:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267618;
        bh=xPemj4PyJXXNlVSIaykexYMA395mYV26jI1yZY1Qawo=;
        h=Date:To:From:Subject:From;
        b=M99kg5YU1aAlYOJvMZpYsV/GJnceoV9mmSOf6l8KMyop0FeqAX9HnAUEszCs8kSvS
         nXfNovzi66kX1KUah7iG6gNRz7APb2EPzGz+xZRtwdnnAnl/XyG2VqktAIoNEUXNQZ
         Wpa0DgNnaR2QwgLmcB15neOLlt8AtJcmkFVd/Igo=
Date:   Mon, 07 Feb 2022 13:00:18 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vvs@virtuozzo.com,
        urezki@gmail.com, oleksiy.avramchenko@sonymobile.com,
        npiggin@gmail.com, hch@lst.de, uladzislau.rezki@sony.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-adjust_search_size-parameter.patch added to -mm tree
Message-Id: <20220207210018.9DE5DC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: add adjust_search_size parameter
has been added to the -mm tree.  Its filename is
     mm-vmalloc-add-adjust_search_size-parameter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-add-adjust_search_size-parameter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-add-adjust_search_size-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Uladzislau Rezki <uladzislau.rezki@sony.com>
Subject: mm/vmalloc: add adjust_search_size parameter

Extend the find_vmap_lowest_match() function with one more parameter.  It
is "adjust_search_size" boolean variable, so it is possible to control an
accuracy of search block if a specific alignment is required.

With this patch, a search size is always adjusted, to serve a request as
fast as possible because of performance reason.

But there is one exception though, it is short ranges where requested size
corresponds to passed vstart/vend restriction together with a specific
alignment request.  In such scenario an adjustment wold not lead to
success allocation.

Link: https://lkml.kernel.org/r/20220119143540.601149-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-adjust_search_size-parameter
+++ a/mm/vmalloc.c
@@ -1193,22 +1193,28 @@ is_within_this_va(struct vmap_area *va,
 /*
  * Find the first free block(lowest start address) in the tree,
  * that will accomplish the request corresponding to passing
- * parameters.
+ * parameters. Please note, with an alignment bigger than PAGE_SIZE,
+ * a search length is adjusted to account for worst case alignment
+ * overhead.
  */
 static __always_inline struct vmap_area *
-find_vmap_lowest_match(unsigned long size,
-	unsigned long align, unsigned long vstart)
+find_vmap_lowest_match(unsigned long size, unsigned long align,
+	unsigned long vstart, bool adjust_search_size)
 {
 	struct vmap_area *va;
 	struct rb_node *node;
+	unsigned long length;
 
 	/* Start from the root. */
 	node = free_vmap_area_root.rb_node;
 
+	/* Adjust the search size for alignment overhead. */
+	length = adjust_search_size ? size + align - 1 : size;
+
 	while (node) {
 		va = rb_entry(node, struct vmap_area, rb_node);
 
-		if (get_subtree_max_size(node->rb_left) >= size &&
+		if (get_subtree_max_size(node->rb_left) >= length &&
 				vstart < va->va_start) {
 			node = node->rb_left;
 		} else {
@@ -1218,9 +1224,9 @@ find_vmap_lowest_match(unsigned long siz
 			/*
 			 * Does not make sense to go deeper towards the right
 			 * sub-tree if it does not have a free block that is
-			 * equal or bigger to the requested search size.
+			 * equal or bigger to the requested search length.
 			 */
-			if (get_subtree_max_size(node->rb_right) >= size) {
+			if (get_subtree_max_size(node->rb_right) >= length) {
 				node = node->rb_right;
 				continue;
 			}
@@ -1236,7 +1242,7 @@ find_vmap_lowest_match(unsigned long siz
 				if (is_within_this_va(va, size, align, vstart))
 					return va;
 
-				if (get_subtree_max_size(node->rb_right) >= size &&
+				if (get_subtree_max_size(node->rb_right) >= length &&
 						vstart <= va->va_start) {
 					/*
 					 * Shift the vstart forward. Please note, we update it with
@@ -1284,7 +1290,7 @@ find_vmap_lowest_match_check(unsigned lo
 	get_random_bytes(&rnd, sizeof(rnd));
 	vstart = VMALLOC_START + rnd;
 
-	va_1 = find_vmap_lowest_match(size, align, vstart);
+	va_1 = find_vmap_lowest_match(size, align, vstart, false);
 	va_2 = find_vmap_lowest_linear_match(size, align, vstart);
 
 	if (va_1 != va_2)
@@ -1435,12 +1441,25 @@ static __always_inline unsigned long
 __alloc_vmap_area(unsigned long size, unsigned long align,
 	unsigned long vstart, unsigned long vend)
 {
+	bool adjust_search_size = true;
 	unsigned long nva_start_addr;
 	struct vmap_area *va;
 	enum fit_type type;
 	int ret;
 
-	va = find_vmap_lowest_match(size, align, vstart);
+	/*
+	 * Do not adjust when:
+	 *   a) align <= PAGE_SIZE, because it does not make any sense.
+	 *      All blocks(their start addresses) are at least PAGE_SIZE
+	 *      aligned anyway;
+	 *   b) a short range where a requested size corresponds to exactly
+	 *      specified [vstart:vend] interval and an alignment > PAGE_SIZE.
+	 *      With adjusted search length an allocation would not succeed.
+	 */
+	if (align <= PAGE_SIZE || (align > PAGE_SIZE && (vend - vstart) == size))
+		adjust_search_size = false;
+
+	va = find_vmap_lowest_match(size, align, vstart, adjust_search_size);
 	if (unlikely(!va))
 		return vend;
 
_

Patches currently in -mm which might be from uladzislau.rezki@sony.com are

mm-vmalloc-add-adjust_search_size-parameter.patch

