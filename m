Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D820BC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjBJAyU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjBJAxp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057886F8D9
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99B52B82272
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FEFC4339C;
        Fri, 10 Feb 2023 00:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990387;
        bh=F6E/PXmIagcOj6n+yttTlZhfNpdL6Ui1j1zkIce7/jk=;
        h=Date:To:From:Subject:From;
        b=obDEmBUm5wNSloZfvIegulYkuML/ZvRlBXBl614HEVw1rnKFEOn29TCAO6XCqDvws
         BDOV+5Iv0BrqjT0CkXyNNl7MLcBSN6v+9z5ulpsr/rC9lyArjx2+ww3ygFSHy0ZMLT
         pcBFI2rsnbmfJprr1QFIDaG5a251pIM+zAuFe604=
Date:   Thu, 09 Feb 2023 16:53:06 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmap-convert-__vma_adjust-to-use-vma-iterator.patch removed from -mm tree
Message-Id: <20230210005307.31FEFC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: convert __vma_adjust() to use vma iterator
has been removed from the -mm tree.  Its filename was
     mmap-convert-__vma_adjust-to-use-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mmap: convert __vma_adjust() to use vma iterator
Date: Fri, 20 Jan 2023 11:26:32 -0500

Use the vma iterator internally for __vma_adjust().  Avoid using the maple
tree interface directly for type safety.

Link: https://lkml.kernel.org/r/20230120162650.984577-32-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 -
 mm/mmap.c          |   75 +++++++------------------------------------
 2 files changed, 13 insertions(+), 65 deletions(-)

--- a/include/linux/mm.h~mmap-convert-__vma_adjust-to-use-vma-iterator
+++ a/include/linux/mm.h
@@ -2856,9 +2856,6 @@ extern struct vm_area_struct *copy_vma(s
 	bool *need_rmap_locks);
 extern void exit_mmap(struct mm_struct *);
 
-void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas);
-void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas);
-
 static inline int check_data_rlimit(unsigned long rlim,
 				    unsigned long new,
 				    unsigned long start,
--- a/mm/mmap.c~mmap-convert-__vma_adjust-to-use-vma-iterator
+++ a/mm/mmap.c
@@ -432,56 +432,6 @@ static void __vma_link_file(struct vm_ar
 	flush_dcache_mmap_unlock(mapping);
 }
 
-/*
- * vma_mas_store() - Store a VMA in the maple tree.
- * @vma: The vm_area_struct
- * @mas: The maple state
- *
- * Efficient way to store a VMA in the maple tree when the @mas has already
- * walked to the correct location.
- *
- * Note: the end address is inclusive in the maple tree.
- */
-void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas)
-{
-	trace_vma_store(mas->tree, vma);
-	mas_set_range(mas, vma->vm_start, vma->vm_end - 1);
-	mas_store_prealloc(mas, vma);
-}
-
-/*
- * vma_mas_remove() - Remove a VMA from the maple tree.
- * @vma: The vm_area_struct
- * @mas: The maple state
- *
- * Efficient way to remove a VMA from the maple tree when the @mas has already
- * been established and points to the correct location.
- * Note: the end address is inclusive in the maple tree.
- */
-void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas)
-{
-	trace_vma_mas_szero(mas->tree, vma->vm_start, vma->vm_end - 1);
-	mas->index = vma->vm_start;
-	mas->last = vma->vm_end - 1;
-	mas_store_prealloc(mas, NULL);
-}
-
-/*
- * vma_mas_szero() - Set a given range to zero.  Used when modifying a
- * vm_area_struct start or end.
- *
- * @mas: The maple tree ma_state
- * @start: The start address to zero
- * @end: The end address to zero.
- */
-static inline void vma_mas_szero(struct ma_state *mas, unsigned long start,
-				unsigned long end)
-{
-	trace_vma_mas_szero(mas->tree, start, end - 1);
-	mas_set_range(mas, start, end - 1);
-	mas_store_prealloc(mas, NULL);
-}
-
 static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	VMA_ITERATOR(vmi, mm, 0);
@@ -641,7 +591,7 @@ int __vma_adjust(struct vm_area_struct *
 	bool vma_changed = false;
 	long adjust_next = 0;
 	int remove_next = 0;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
 
 	if (next && !insert) {
@@ -726,7 +676,7 @@ int __vma_adjust(struct vm_area_struct *
 		}
 	}
 
-	if (mas_preallocate(&mas, GFP_KERNEL))
+	if (vma_iter_prealloc(&vmi))
 		return -ENOMEM;
 
 	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
@@ -772,7 +722,7 @@ int __vma_adjust(struct vm_area_struct *
 	if (start != vma->vm_start) {
 		if ((vma->vm_start < start) &&
 		    (!insert || (insert->vm_end != start))) {
-			vma_mas_szero(&mas, vma->vm_start, start);
+			vma_iter_clear(&vmi, vma->vm_start, start);
 			VM_WARN_ON(insert && insert->vm_start > vma->vm_start);
 		} else {
 			vma_changed = true;
@@ -782,8 +732,8 @@ int __vma_adjust(struct vm_area_struct *
 	if (end != vma->vm_end) {
 		if (vma->vm_end > end) {
 			if (!insert || (insert->vm_start != end)) {
-				vma_mas_szero(&mas, end, vma->vm_end);
-				mas_reset(&mas);
+				vma_iter_clear(&vmi, end, vma->vm_end);
+				vma_iter_set(&vmi, vma->vm_end);
 				VM_WARN_ON(insert &&
 					   insert->vm_end < vma->vm_end);
 			}
@@ -794,13 +744,13 @@ int __vma_adjust(struct vm_area_struct *
 	}
 
 	if (vma_changed)
-		vma_mas_store(vma, &mas);
+		vma_iter_store(&vmi, vma);
 
 	vma->vm_pgoff = pgoff;
 	if (adjust_next) {
 		next->vm_start += adjust_next;
 		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
-		vma_mas_store(next, &mas);
+		vma_iter_store(&vmi, next);
 	}
 
 	if (file) {
@@ -820,8 +770,7 @@ int __vma_adjust(struct vm_area_struct *
 		 * us to insert it before dropping the locks
 		 * (it may either follow vma or precede it).
 		 */
-		mas_reset(&mas);
-		vma_mas_store(insert, &mas);
+		vma_iter_store(&vmi, insert);
 		mm->map_count++;
 	}
 
@@ -867,7 +816,7 @@ again:
 	if (insert && file)
 		uprobe_mmap(insert);
 
-	mas_destroy(&mas);
+	vma_iter_free(&vmi);
 	validate_mm(mm);
 
 	return 0;
@@ -1999,7 +1948,8 @@ int expand_upwards(struct vm_area_struct
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				/* Overwrite old entry in mtree. */
-				vma_mas_store(vma, &mas);
+				mas_set_range(&mas, vma->vm_start, address - 1);
+				mas_store_prealloc(&mas, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
 				spin_unlock(&mm->page_table_lock);
 
@@ -2081,7 +2031,8 @@ int expand_downwards(struct vm_area_stru
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				/* Overwrite old entry in mtree. */
-				vma_mas_store(vma, &mas);
+				mas_set_range(&mas, address, vma->vm_end - 1);
+				mas_store_prealloc(&mas, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
 				spin_unlock(&mm->page_table_lock);
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


