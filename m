Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D878C001B0
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 18:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjGXS7c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 14:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjGXS7b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 14:59:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026F5188
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 11:59:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CB3A613DC
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 18:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DBFC433C9;
        Mon, 24 Jul 2023 18:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225168;
        bh=VbcdAB878hwmpeOKvMdptK6oWhirsS0bqKHNK/+/13Y=;
        h=Date:To:From:Subject:From;
        b=LpFccLeZKnQ5m50nAGlOouBT7RbEC7XZp4x8LgJXc46gEGfxkKFW4bd7sPBg1O9tJ
         BNuHEMhetcDJXqijGRvGiEFxkgNQM2uWq7BepjNeL5hDHJLuavE14QkDnHWDwohHxO
         FW0NtYeSCOiOWGo3STjybt2u3ViwFGo9M1KGLFEo=
Date:   Mon, 24 Jul 2023 11:59:27 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch added to mm-unstable branch
Message-Id: <20230724185928.83DBFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: re-introduce entry to mas_preallocate() arguments
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch

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

mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
maple_tree-adjust-node-allocation-on-mas_rebalance.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
maple_tree-reduce-resets-during-store-setup.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

