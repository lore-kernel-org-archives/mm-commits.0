Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3AFC41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbjHKXOK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237192AbjHKXNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEAD3AA9
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69C2C63F1F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4023C433C7;
        Fri, 11 Aug 2023 23:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794964;
        bh=DVjo+BHDoG4x2Z7L20SoW3O12O5lLbv5VhOFBtDpy0c=;
        h=Date:To:From:Subject:From;
        b=OvFS0RXSIB1QvKP5SClBkm/M8+PgC+asrj7jZNAA7ZJH35fgTpb41hG5W6XbJf6KU
         xLcgmddKyeshxyvhqvdoMApI/RFcacux99y9PKMbP0U0lb6dsN2ukG83VHQI26gRn0
         tUZjvF6Q/itVPDoJfcp4ckUIjCZA/z3Cb/5NgYW4=
Date:   Fri, 11 Aug 2023 16:02:44 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch removed from -mm tree
Message-Id: <20230811230244.C4023C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: re-introduce entry to mas_preallocate() arguments
has been removed from the -mm tree.  Its filename was
     maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: re-introduce entry to mas_preallocate() arguments
Date: Mon, 24 Jul 2023 14:31:49 -0400

The current preallocation strategy is to preallocate the absolute
worst-case allocation for a tree modification.  The entry (or NULL) is
needed to know how many nodes are needed to write to the tree.  Start by
adding the argument to the mas_preallocate() definition.

Link: https://lkml.kernel.org/r/20230724183157.3939892-8-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h       |    2 -
 lib/maple_tree.c                 |    3 +-
 mm/internal.h                    |    2 -
 mm/mmap.c                        |    4 +--
 tools/testing/radix-tree/maple.c |   32 ++++++++++++++---------------
 5 files changed, 22 insertions(+), 21 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-re-introduce-entry-to-mas_preallocate-arguments
+++ a/include/linux/maple_tree.h
@@ -466,7 +466,7 @@ void *mas_find(struct ma_state *mas, uns
 void *mas_find_range(struct ma_state *mas, unsigned long max);
 void *mas_find_rev(struct ma_state *mas, unsigned long min);
 void *mas_find_range_rev(struct ma_state *mas, unsigned long max);
-int mas_preallocate(struct ma_state *mas, gfp_t gfp);
+int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp);
 bool mas_is_err(struct ma_state *mas);
 
 bool mas_nomem(struct ma_state *mas, gfp_t gfp);
--- a/lib/maple_tree.c~maple_tree-re-introduce-entry-to-mas_preallocate-arguments
+++ a/lib/maple_tree.c
@@ -5529,11 +5529,12 @@ EXPORT_SYMBOL_GPL(mas_store_prealloc);
 /**
  * mas_preallocate() - Preallocate enough nodes for a store operation
  * @mas: The maple state
+ * @entry: The entry that will be stored
  * @gfp: The GFP_FLAGS to use for allocations.
  *
  * Return: 0 on success, -ENOMEM if memory could not be allocated.
  */
-int mas_preallocate(struct ma_state *mas, gfp_t gfp)
+int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 {
 	int ret;
 
--- a/mm/internal.h~maple_tree-re-introduce-entry-to-mas_preallocate-arguments
+++ a/mm/internal.h
@@ -1054,7 +1054,7 @@ static inline void vma_iter_config(struc
  */
 static inline int vma_iter_prealloc(struct vma_iterator *vmi)
 {
-	return mas_preallocate(&vmi->mas, GFP_KERNEL);
+	return mas_preallocate(&vmi->mas, NULL, GFP_KERNEL);
 }
 
 static inline void vma_iter_clear(struct vma_iterator *vmi,
--- a/mm/mmap.c~maple_tree-re-introduce-entry-to-mas_preallocate-arguments
+++ a/mm/mmap.c
@@ -1960,7 +1960,7 @@ static int expand_upwards(struct vm_area
 		/* Check that both stack segments have the same anon_vma? */
 	}
 
-	if (mas_preallocate(&mas, GFP_KERNEL))
+	if (mas_preallocate(&mas, vma, GFP_KERNEL))
 		return -ENOMEM;
 
 	/* We must make sure the anon_vma is allocated. */
@@ -2050,7 +2050,7 @@ int expand_downwards(struct vm_area_stru
 			return -ENOMEM;
 	}
 
-	if (mas_preallocate(&mas, GFP_KERNEL))
+	if (mas_preallocate(&mas, vma, GFP_KERNEL))
 		return -ENOMEM;
 
 	/* We must make sure the anon_vma is allocated. */
--- a/tools/testing/radix-tree/maple.c~maple_tree-re-introduce-entry-to-mas_preallocate-arguments
+++ a/tools/testing/radix-tree/maple.c
@@ -35458,7 +35458,7 @@ static noinline void __init check_preall
 	for (i = 0; i <= max; i++)
 		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35467,18 +35467,18 @@ static noinline void __init check_preall
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	mas_destroy(&mas);
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35487,26 +35487,26 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
 	mn->parent = ma_parent_ptr(mn);
 	ma_free_rcu(mn);
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	mas_destroy(&mas);
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	mas_destroy(&mas);
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 	mn->parent = ma_parent_ptr(mn);
 	ma_free_rcu(mn);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35515,12 +35515,12 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
 	mas_push_node(&mas, mn);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated);
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	mas_destroy(&mas);
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35528,21 +35528,21 @@ static noinline void __init check_preall
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mas_store_prealloc(&mas, ptr);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35550,14 +35550,14 @@ static noinline void __init check_preall
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mt_set_non_kernel(1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 	mas_destroy(&mas);
 
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35565,7 +35565,7 @@ static noinline void __init check_preall
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mt_set_non_kernel(1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

