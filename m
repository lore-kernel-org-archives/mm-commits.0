Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BB3CCA481
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiGDBKM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbiGDBJu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307E962F8
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2EE7611FA
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216C5C341C7;
        Mon,  4 Jul 2022 01:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896988;
        bh=YdD8Tlz/Cha3uUr2E+wPaEGPFp8TT58kIOoYnEAh4qo=;
        h=Date:To:From:Subject:From;
        b=jEnyscoWuApVIp8VLJubIRDqp2+sDih4t4SCX8zzcSKXVkRaJw4riIprF5bBd2CXD
         MNyo59Ac+53LC/gtLudvsFv6nrNiZCZxq6YD20lMBMVd0rhb+TOjgIc+5mFwYLdHij
         u1NVFdZ6UTQSS4R40ZXD7dWV3XnWmA3ZuPzHxR28=
Date:   Sun, 03 Jul 2022 18:09:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, npiggin@gmail.com, hch@infradead.org,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-make-link_va-unlink_va-common-to-different-rb_root.patch removed from -mm tree
Message-Id: <20220704010948.216C5C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: make link_va()/unlink_va() common to different rb_root
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-make-link_va-unlink_va-common-to-different-rb_root.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: make link_va()/unlink_va() common to different rb_root
Date: Tue, 7 Jun 2022 11:34:45 +0200

Patch series "Reduce a vmalloc internal lock contention preparation work".

This small serias is preparation work to implement per-cpu vmalloc
allocation in order to reduce a high internal lock contention.  This
series does not introduce any functional changes, it is only about
preparation.


This patch (of 5):

Currently link_va() and unlik_va(), in order to figure out a tree type,
compares a passed root value with a global free_vmap_area_root variable to
distinguish the augmented rb-tree from a regular one.  It is hard coded
since such functions can manipulate only with specific
"free_vmap_area_root" tree that represents a global free vmap space.

Make it common by introducing "_augment" versions of both internal
functions, so it is possible to deal with different trees.

There is no functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20220607093449.3100-1-urezki@gmail.com
Link: https://lkml.kernel.org/r/20220607093449.3100-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   60 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 12 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-make-link_va-unlink_va-common-to-different-rb_root
+++ a/mm/vmalloc.c
@@ -910,8 +910,9 @@ get_va_next_sibling(struct rb_node *pare
 }
 
 static __always_inline void
-link_va(struct vmap_area *va, struct rb_root *root,
-	struct rb_node *parent, struct rb_node **link, struct list_head *head)
+__link_va(struct vmap_area *va, struct rb_root *root,
+	struct rb_node *parent, struct rb_node **link,
+	struct list_head *head, bool augment)
 {
 	/*
 	 * VA is still not in the list, but we can
@@ -925,7 +926,7 @@ link_va(struct vmap_area *va, struct rb_
 
 	/* Insert to the rb-tree */
 	rb_link_node(&va->rb_node, parent, link);
-	if (root == &free_vmap_area_root) {
+	if (augment) {
 		/*
 		 * Some explanation here. Just perform simple insertion
 		 * to the tree. We do not set va->subtree_max_size to
@@ -949,12 +950,28 @@ link_va(struct vmap_area *va, struct rb_
 }
 
 static __always_inline void
-unlink_va(struct vmap_area *va, struct rb_root *root)
+link_va(struct vmap_area *va, struct rb_root *root,
+	struct rb_node *parent, struct rb_node **link,
+	struct list_head *head)
+{
+	__link_va(va, root, parent, link, head, false);
+}
+
+static __always_inline void
+link_va_augment(struct vmap_area *va, struct rb_root *root,
+	struct rb_node *parent, struct rb_node **link,
+	struct list_head *head)
+{
+	__link_va(va, root, parent, link, head, true);
+}
+
+static __always_inline void
+__unlink_va(struct vmap_area *va, struct rb_root *root, bool augment)
 {
 	if (WARN_ON(RB_EMPTY_NODE(&va->rb_node)))
 		return;
 
-	if (root == &free_vmap_area_root)
+	if (augment)
 		rb_erase_augmented(&va->rb_node,
 			root, &free_vmap_area_rb_augment_cb);
 	else
@@ -964,6 +981,18 @@ unlink_va(struct vmap_area *va, struct r
 	RB_CLEAR_NODE(&va->rb_node);
 }
 
+static __always_inline void
+unlink_va(struct vmap_area *va, struct rb_root *root)
+{
+	__unlink_va(va, root, false);
+}
+
+static __always_inline void
+unlink_va_augment(struct vmap_area *va, struct rb_root *root)
+{
+	__unlink_va(va, root, true);
+}
+
 #if DEBUG_AUGMENT_PROPAGATE_CHECK
 /*
  * Gets called when remove the node and rotate.
@@ -1059,7 +1088,7 @@ insert_vmap_area_augment(struct vmap_are
 		link = find_va_links(va, root, NULL, &parent);
 
 	if (link) {
-		link_va(va, root, parent, link, head);
+		link_va_augment(va, root, parent, link, head);
 		augment_tree_propagate_from(va);
 	}
 }
@@ -1076,8 +1105,8 @@ insert_vmap_area_augment(struct vmap_are
  * ongoing.
  */
 static __always_inline struct vmap_area *
-merge_or_add_vmap_area(struct vmap_area *va,
-	struct rb_root *root, struct list_head *head)
+__merge_or_add_vmap_area(struct vmap_area *va,
+	struct rb_root *root, struct list_head *head, bool augment)
 {
 	struct vmap_area *sibling;
 	struct list_head *next;
@@ -1139,7 +1168,7 @@ merge_or_add_vmap_area(struct vmap_area
 			 * "normalized" because of rotation operations.
 			 */
 			if (merged)
-				unlink_va(va, root);
+				__unlink_va(va, root, augment);
 
 			sibling->va_end = va->va_end;
 
@@ -1154,16 +1183,23 @@ merge_or_add_vmap_area(struct vmap_area
 
 insert:
 	if (!merged)
-		link_va(va, root, parent, link, head);
+		__link_va(va, root, parent, link, head, augment);
 
 	return va;
 }
 
 static __always_inline struct vmap_area *
+merge_or_add_vmap_area(struct vmap_area *va,
+	struct rb_root *root, struct list_head *head)
+{
+	return __merge_or_add_vmap_area(va, root, head, false);
+}
+
+static __always_inline struct vmap_area *
 merge_or_add_vmap_area_augment(struct vmap_area *va,
 	struct rb_root *root, struct list_head *head)
 {
-	va = merge_or_add_vmap_area(va, root, head);
+	va = __merge_or_add_vmap_area(va, root, head, true);
 	if (va)
 		augment_tree_propagate_from(va);
 
@@ -1347,7 +1383,7 @@ adjust_va_to_fit_type(struct vmap_area *
 		 * V      NVA      V
 		 * |---------------|
 		 */
-		unlink_va(va, &free_vmap_area_root);
+		unlink_va_augment(va, &free_vmap_area_root);
 		kmem_cache_free(vmap_area_cachep, va);
 	} else if (type == LE_FIT_TYPE) {
 		/*
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-extend-__alloc_vmap_area-with-extra-arguments.patch
mm-vmalloc-initialize-vas-list-node-after-unlink.patch
mm-vmalloc-extend-__find_vmap_area-with-one-more-argument.patch
lib-test_vmalloc-switch-to-prandom_u32.patch

