Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6685EC46467
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbjAJXI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbjAJXIZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:08:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBF1B05
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:08:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67EB6B81887
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015C6C433EF;
        Tue, 10 Jan 2023 23:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673392101;
        bh=FKu+maVG/DzxHXM+SrpsGNYJqcXNlwveJZr4qEpkGyA=;
        h=Date:To:From:Subject:From;
        b=bYlPBhaAAJ76yF83VH7uhIIzwt48G3JfLGjgFfEw7QLwLNcdZqbRm65uUUBSDJYKg
         mKkHC2STJQD/Gm5mnELcr8hYcjGFduFw6vtGEslW0QI/F5AENBnGBUzTUMacKhVyxM
         1N8ksyqxFhXRh9GwcqzUQD89m5NSx1usu4A7i6fM=
Date:   Tue, 10 Jan 2023 15:08:20 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        liam.howlett@oracle.com, vernon2gm@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch added to mm-unstable branch
Message-Id: <20230110230821.015C6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: remove the parameter entry of mas_preallocate
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch

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
From: Vernon Yang <vernon2gm@gmail.com>
Subject: maple_tree: remove the parameter entry of mas_preallocate
Date: Tue, 10 Jan 2023 23:42:11 +0800

The parameter entry of mas_preallocate is not used, so drop it.

Link: https://lkml.kernel.org/r/20230110154211.1758562-1-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h       |    2 -
 lib/maple_tree.c                 |    3 --
 mm/mmap.c                        |   16 +++++++-------
 mm/nommu.c                       |    8 +++----
 tools/testing/radix-tree/maple.c |   32 ++++++++++++++---------------
 5 files changed, 30 insertions(+), 31 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-remove-the-parameter-entry-of-mas_preallocate
+++ a/include/linux/maple_tree.h
@@ -455,7 +455,7 @@ int mas_store_gfp(struct ma_state *mas,
 void mas_store_prealloc(struct ma_state *mas, void *entry);
 void *mas_find(struct ma_state *mas, unsigned long max);
 void *mas_find_rev(struct ma_state *mas, unsigned long min);
-int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp);
+int mas_preallocate(struct ma_state *mas, gfp_t gfp);
 bool mas_is_err(struct ma_state *mas);
 
 bool mas_nomem(struct ma_state *mas, gfp_t gfp);
--- a/lib/maple_tree.c~maple_tree-remove-the-parameter-entry-of-mas_preallocate
+++ a/lib/maple_tree.c
@@ -5703,12 +5703,11 @@ EXPORT_SYMBOL_GPL(mas_store_prealloc);
 /**
  * mas_preallocate() - Preallocate enough nodes for a store operation
  * @mas: The maple state
- * @entry: The entry that will be stored
  * @gfp: The GFP_FLAGS to use for allocations.
  *
  * Return: 0 on success, -ENOMEM if memory could not be allocated.
  */
-int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
+int mas_preallocate(struct ma_state *mas, gfp_t gfp)
 {
 	int ret;
 
--- a/mm/mmap.c~maple_tree-remove-the-parameter-entry-of-mas_preallocate
+++ a/mm/mmap.c
@@ -472,7 +472,7 @@ static int vma_link(struct mm_struct *mm
 	MA_STATE(mas, &mm->mm_mt, 0, 0);
 	struct address_space *mapping = NULL;
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+	if (mas_preallocate(&mas, GFP_KERNEL))
 		return -ENOMEM;
 
 	if (vma->vm_file) {
@@ -538,7 +538,7 @@ inline int vma_expand(struct ma_state *m
 	/* Only handles expanding */
 	VM_BUG_ON(vma->vm_start < start || vma->vm_end > end);
 
-	if (mas_preallocate(mas, vma, GFP_KERNEL))
+	if (mas_preallocate(mas, GFP_KERNEL))
 		goto nomem;
 
 	vma_adjust_trans_huge(vma, start, end, 0);
@@ -712,7 +712,7 @@ int __vma_adjust(struct vm_area_struct *
 		}
 	}
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+	if (mas_preallocate(&mas, GFP_KERNEL))
 		return -ENOMEM;
 
 	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
@@ -1938,7 +1938,7 @@ int expand_upwards(struct vm_area_struct
 		/* Check that both stack segments have the same anon_vma? */
 	}
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+	if (mas_preallocate(&mas, GFP_KERNEL))
 		return -ENOMEM;
 
 	/* We must make sure the anon_vma is allocated. */
@@ -2019,7 +2019,7 @@ int expand_downwards(struct vm_area_stru
 			return -ENOMEM;
 	}
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+	if (mas_preallocate(&mas, GFP_KERNEL))
 		return -ENOMEM;
 
 	/* We must make sure the anon_vma is allocated. */
@@ -2311,7 +2311,7 @@ do_mas_align_munmap(struct ma_state *mas
 	mt_init_flags(&mt_detach, MT_FLAGS_LOCK_EXTERN);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
 
-	if (mas_preallocate(mas, vma, GFP_KERNEL))
+	if (mas_preallocate(mas, GFP_KERNEL))
 		return -ENOMEM;
 
 	mas->last = end - 1;
@@ -2680,7 +2680,7 @@ cannot_expand:
 			goto free_vma;
 	}
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
+	if (mas_preallocate(&mas, GFP_KERNEL)) {
 		error = -ENOMEM;
 		if (file)
 			goto close_and_free_vma;
@@ -2953,7 +2953,7 @@ static int do_brk_flags(struct ma_state
 	    can_vma_merge_after(vma, flags, NULL, NULL,
 				addr >> PAGE_SHIFT, NULL_VM_UFFD_CTX, NULL)) {
 		mas_set_range(mas, vma->vm_start, addr + len - 1);
-		if (mas_preallocate(mas, vma, GFP_KERNEL))
+		if (mas_preallocate(mas, GFP_KERNEL))
 			goto unacct_fail;
 
 		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
--- a/mm/nommu.c~maple_tree-remove-the-parameter-entry-of-mas_preallocate
+++ a/mm/nommu.c
@@ -602,7 +602,7 @@ static int add_vma_to_mm(struct mm_struc
 {
 	MA_STATE(mas, &mm->mm_mt, vma->vm_start, vma->vm_end);
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
+	if (mas_preallocate(&mas, GFP_KERNEL)) {
 		pr_warn("Allocation of vma tree for process %d failed\n",
 		       current->pid);
 		return -ENOMEM;
@@ -633,7 +633,7 @@ static int delete_vma_from_mm(struct vm_
 {
 	MA_STATE(mas, &vma->vm_mm->mm_mt, 0, 0);
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
+	if (mas_preallocate(&mas, GFP_KERNEL)) {
 		pr_warn("Allocation of vma tree for process %d failed\n",
 		       current->pid);
 		return -ENOMEM;
@@ -1091,7 +1091,7 @@ unsigned long do_mmap(struct file *file,
 	if (!vma)
 		goto error_getting_vma;
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+	if (mas_preallocate(&mas, GFP_KERNEL))
 		goto error_maple_preallocate;
 
 	region->vm_usage = 1;
@@ -1369,7 +1369,7 @@ int split_vma(struct mm_struct *mm, stru
 	if (!new)
 		goto err_vma_dup;
 
-	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
+	if (mas_preallocate(&mas, GFP_KERNEL)) {
 		pr_warn("Allocation of vma tree for process %d failed\n",
 			current->pid);
 		goto err_mas_preallocate;
--- a/tools/testing/radix-tree/maple.c~maple_tree-remove-the-parameter-entry-of-mas_preallocate
+++ a/tools/testing/radix-tree/maple.c
@@ -35342,7 +35342,7 @@ static noinline void check_prealloc(stru
 	for (i = 0; i <= max; i++)
 		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35351,18 +35351,18 @@ static noinline void check_prealloc(stru
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	mas_destroy(&mas);
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35370,25 +35370,25 @@ static noinline void check_prealloc(stru
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
 	ma_free_rcu(mn);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	mas_destroy(&mas);
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	mas_destroy(&mas);
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 	ma_free_rcu(mn);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35397,12 +35397,12 @@ static noinline void check_prealloc(stru
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
 	mas_push_node(&mas, mn);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	mas_destroy(&mas);
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35410,21 +35410,21 @@ static noinline void check_prealloc(stru
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mas_store_prealloc(&mas, ptr);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35432,14 +35432,14 @@ static noinline void check_prealloc(stru
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mt_set_non_kernel(1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL & GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 	mas_destroy(&mas);
 
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated == 0);
@@ -35447,7 +35447,7 @@ static noinline void check_prealloc(stru
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mt_set_non_kernel(1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, GFP_KERNEL & GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-extra-space-and-blank-line.patch
maple_tree-remove-extra-return-statement.patch
maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch
maple_tree-use-macro-ma_root_parent-instead-of-number.patch
maple_tree-remove-the-redundant-code.patch
maple_tree-refine-ma_state-init-from-mas_start.patch
maple_tree-refine-mab_calc_split-function.patch
maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch

