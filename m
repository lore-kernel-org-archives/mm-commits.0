Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924C1C43217
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbiCVVog (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236326AbiCVVo2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9771A3
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D171BB81D9E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C278C340EE;
        Tue, 22 Mar 2022 21:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985374;
        bh=KVSn9jTSoszg9gbPFpx4VwZWDw0TuKwpm8ilMnj4JSc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=oEsB1BeI79JnLOVpRj0s63nZxHyo+vP8XMdck8Ye7uyjd1aj94jUcQskcfBbfg09y
         +tnVGdsxvl7tKpYNcaUt7sUQCcKHXQCdoAYnbd1QKEnQw7gIvfXOrLNUeAslz/YyVf
         B1TBAr9MYGONmbDXmSyHEdBAMmxzV4S+BRD6K3VU=
Date:   Tue, 22 Mar 2022 14:42:53 -0700
To:     willy@infradead.org, vvs@virtuozzo.com, urezki@gmail.com,
        oleksiy.avramchenko@sonymobile.com, npiggin@gmail.com, hch@lst.de,
        uladzislau.rezki@sony.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 086/227] mm/vmalloc: add adjust_search_size parameter
Message-Id: <20220322214254.7C278C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1189,22 +1189,28 @@ is_within_this_va(struct vmap_area *va,
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
@@ -1214,9 +1220,9 @@ find_vmap_lowest_match(unsigned long siz
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
@@ -1232,7 +1238,7 @@ find_vmap_lowest_match(unsigned long siz
 				if (is_within_this_va(va, size, align, vstart))
 					return va;
 
-				if (get_subtree_max_size(node->rb_right) >= size &&
+				if (get_subtree_max_size(node->rb_right) >= length &&
 						vstart <= va->va_start) {
 					/*
 					 * Shift the vstart forward. Please note, we update it with
@@ -1280,7 +1286,7 @@ find_vmap_lowest_match_check(unsigned lo
 	get_random_bytes(&rnd, sizeof(rnd));
 	vstart = VMALLOC_START + rnd;
 
-	va_1 = find_vmap_lowest_match(size, align, vstart);
+	va_1 = find_vmap_lowest_match(size, align, vstart, false);
 	va_2 = find_vmap_lowest_linear_match(size, align, vstart);
 
 	if (va_1 != va_2)
@@ -1431,12 +1437,25 @@ static __always_inline unsigned long
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
