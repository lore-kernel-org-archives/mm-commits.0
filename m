Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DC7C43334
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 02:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239944AbiFHCQF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 22:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444682AbiFHCLQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 22:11:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8C8C8BCA
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 15:42:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6723F616A0
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 22:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8477C3411C;
        Tue,  7 Jun 2022 22:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654641723;
        bh=qWWQNatQCKWEOiNl57Dl0VYCV9w0Ox6CI7MUQL6Ur18=;
        h=Date:To:From:Subject:From;
        b=ZRppqHv4W4cFwe0HvYqLW0ZXhsR7sMKzvbKpdqUFEEVKXZ2nQoUI+DWess9hdepbW
         OYNcDepDuBN2xzt/kHN3dDbNh6pD1nYfSdnhs8HFh3Spw+35c7N/RC9jmgyub0owiI
         WtoTaMd8AfqTQS6/bzOoiTjEEkHYNI+3nUAw2vJs=
Date:   Tue, 07 Jun 2022 15:42:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, npiggin@gmail.com, hch@infradead.org,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-extend-__alloc_vmap_area-with-extra-arguments.patch added to mm-unstable branch
Message-Id: <20220607224203.B8477C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: extend __alloc_vmap_area() with extra arguments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-extend-__alloc_vmap_area-with-extra-arguments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-extend-__alloc_vmap_area-with-extra-arguments.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: extend __alloc_vmap_area() with extra arguments
Date: Tue, 7 Jun 2022 11:34:46 +0200

It implies that __alloc_vmap_area() allocates only from the global vmap
space, therefore a list-head and rb-tree, which represent a free vmap
space, are not passed as parameters to this function and are accessed
directly from this function.

Extend the __alloc_vmap_area() and other dependent functions to have a
possibility to allocate from different trees making an interface common
and not specific.

There is no functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20220607093449.3100-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extend-__alloc_vmap_area-with-extra-arguments
+++ a/mm/vmalloc.c
@@ -1233,15 +1233,15 @@ is_within_this_va(struct vmap_area *va,
  * overhead.
  */
 static __always_inline struct vmap_area *
-find_vmap_lowest_match(unsigned long size, unsigned long align,
-	unsigned long vstart, bool adjust_search_size)
+find_vmap_lowest_match(struct rb_root *root, unsigned long size,
+	unsigned long align, unsigned long vstart, bool adjust_search_size)
 {
 	struct vmap_area *va;
 	struct rb_node *node;
 	unsigned long length;
 
 	/* Start from the root. */
-	node = free_vmap_area_root.rb_node;
+	node = root->rb_node;
 
 	/* Adjust the search size for alignment overhead. */
 	length = adjust_search_size ? size + align - 1 : size;
@@ -1369,8 +1369,9 @@ classify_va_fit_type(struct vmap_area *v
 }
 
 static __always_inline int
-adjust_va_to_fit_type(struct vmap_area *va,
-	unsigned long nva_start_addr, unsigned long size)
+adjust_va_to_fit_type(struct rb_root *root, struct list_head *head,
+		      struct vmap_area *va, unsigned long nva_start_addr,
+		      unsigned long size)
 {
 	struct vmap_area *lva = NULL;
 	enum fit_type type = classify_va_fit_type(va, nva_start_addr, size);
@@ -1383,7 +1384,7 @@ adjust_va_to_fit_type(struct vmap_area *
 		 * V      NVA      V
 		 * |---------------|
 		 */
-		unlink_va_augment(va, &free_vmap_area_root);
+		unlink_va_augment(va, root);
 		kmem_cache_free(vmap_area_cachep, va);
 	} else if (type == LE_FIT_TYPE) {
 		/*
@@ -1461,8 +1462,7 @@ adjust_va_to_fit_type(struct vmap_area *
 		augment_tree_propagate_from(va);
 
 		if (lva)	/* type == NE_FIT_TYPE */
-			insert_vmap_area_augment(lva, &va->rb_node,
-				&free_vmap_area_root, &free_vmap_area_list);
+			insert_vmap_area_augment(lva, &va->rb_node, root, head);
 	}
 
 	return 0;
@@ -1473,7 +1473,8 @@ adjust_va_to_fit_type(struct vmap_area *
  * Otherwise a vend is returned that indicates failure.
  */
 static __always_inline unsigned long
-__alloc_vmap_area(unsigned long size, unsigned long align,
+__alloc_vmap_area(struct rb_root *root, struct list_head *head,
+	unsigned long size, unsigned long align,
 	unsigned long vstart, unsigned long vend)
 {
 	bool adjust_search_size = true;
@@ -1493,7 +1494,7 @@ __alloc_vmap_area(unsigned long size, un
 	if (align <= PAGE_SIZE || (align > PAGE_SIZE && (vend - vstart) == size))
 		adjust_search_size = false;
 
-	va = find_vmap_lowest_match(size, align, vstart, adjust_search_size);
+	va = find_vmap_lowest_match(root, size, align, vstart, adjust_search_size);
 	if (unlikely(!va))
 		return vend;
 
@@ -1507,7 +1508,7 @@ __alloc_vmap_area(unsigned long size, un
 		return vend;
 
 	/* Update the free vmap_area. */
-	ret = adjust_va_to_fit_type(va, nva_start_addr, size);
+	ret = adjust_va_to_fit_type(root, head, va, nva_start_addr, size);
 	if (WARN_ON_ONCE(ret))
 		return vend;
 
@@ -1598,7 +1599,8 @@ static struct vmap_area *alloc_vmap_area
 
 retry:
 	preload_this_cpu_lock(&free_vmap_area_lock, gfp_mask, node);
-	addr = __alloc_vmap_area(size, align, vstart, vend);
+	addr = __alloc_vmap_area(&free_vmap_area_root, &free_vmap_area_list,
+		size, align, vstart, vend);
 	spin_unlock(&free_vmap_area_lock);
 
 	/*
@@ -3873,7 +3875,9 @@ retry:
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;
 
-		ret = adjust_va_to_fit_type(va, start, size);
+		ret = adjust_va_to_fit_type(&free_vmap_area_root,
+					    &free_vmap_area_list,
+					    va, start, size);
 		if (WARN_ON_ONCE(unlikely(ret)))
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-make-link_va-unlink_va-common-to-different-rb_root.patch
mm-vmalloc-extend-__alloc_vmap_area-with-extra-arguments.patch
mm-vmalloc-initialize-vas-list-node-after-unlink.patch
mm-vmalloc-extend-__find_vmap_area-with-one-more-argument.patch
lib-test_vmalloc-switch-to-prandom_u32.patch

