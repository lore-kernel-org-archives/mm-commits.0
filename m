Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4150C636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjBJAzB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjBJAyI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AFB721C5
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31C31B82399
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E042AC4339B;
        Fri, 10 Feb 2023 00:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990403;
        bh=EbleIdKQ5OPJTBuXag02tDElZEGYDb5Ct9ks2Nu4esM=;
        h=Date:To:From:Subject:From;
        b=IGKly9fAa/3VXJkwl1ad6WwFqasp7nV+BbwjFMUyEWSIXjpiV+i/yvfwqxNmwkDXO
         8Zjz2xm6SxurwiPPC85MM8OEPyoy4uXsErZFhnsOLXwIxpU/t6MvMfI3iiGcpBgTd2
         iojHcbTu8t78sRy0SFf6cTos7Yw9sViPQH3nHFs4=
Date:   Thu, 09 Feb 2023 16:53:22 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-use-vma_prepare-and-vma_complete-in-vma_expand.patch removed from -mm tree
Message-Id: <20230210005322.E042AC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: use vma_prepare() and vma_complete() in vma_expand()
has been removed from the -mm tree.  Its filename was
     mm-mmap-use-vma_prepare-and-vma_complete-in-vma_expand.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: use vma_prepare() and vma_complete() in vma_expand()
Date: Fri, 20 Jan 2023 11:26:42 -0500

Use the new locking functions for vma_expand().  This reduces code
duplication.

At the same time change VM_BUG_ON() to VM_WARN_ON()

Link: https://lkml.kernel.org/r/20230120162650.984577-42-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |  188 +++++++++++++++++++---------------------------------
 1 file changed, 72 insertions(+), 116 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-vma_prepare-and-vma_complete-in-vma_expand
+++ a/mm/mmap.c
@@ -458,122 +458,6 @@ static int vma_link(struct mm_struct *mm
 }
 
 /*
- * vma_expand - Expand an existing VMA
- *
- * @mas: The maple state
- * @vma: The vma to expand
- * @start: The start of the vma
- * @end: The exclusive end of the vma
- * @pgoff: The page offset of vma
- * @next: The current of next vma.
- *
- * Expand @vma to @start and @end.  Can expand off the start and end.  Will
- * expand over @next if it's different from @vma and @end == @next->vm_end.
- * Checking if the @vma can expand and merge with @next needs to be handled by
- * the caller.
- *
- * Returns: 0 on success
- */
-inline int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		      unsigned long start, unsigned long end, pgoff_t pgoff,
-		      struct vm_area_struct *next)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	struct address_space *mapping = NULL;
-	struct rb_root_cached *root = NULL;
-	struct anon_vma *anon_vma = vma->anon_vma;
-	struct file *file = vma->vm_file;
-	bool remove_next = false;
-
-	if (next && (vma != next) && (end == next->vm_end)) {
-		remove_next = true;
-		if (next->anon_vma && !vma->anon_vma) {
-			int error;
-
-			anon_vma = next->anon_vma;
-			vma->anon_vma = anon_vma;
-			error = anon_vma_clone(vma, next);
-			if (error)
-				return error;
-		}
-	}
-
-	/* Not merging but overwriting any part of next is not handled. */
-	VM_BUG_ON(next && !remove_next && next != vma && end > next->vm_start);
-	/* Only handles expanding */
-	VM_BUG_ON(vma->vm_start < start || vma->vm_end > end);
-
-	if (vma_iter_prealloc(vmi))
-		goto nomem;
-
-	vma_adjust_trans_huge(vma, start, end, 0);
-
-	if (file) {
-		mapping = file->f_mapping;
-		root = &mapping->i_mmap;
-		uprobe_munmap(vma, vma->vm_start, vma->vm_end);
-		i_mmap_lock_write(mapping);
-	}
-
-	if (anon_vma) {
-		anon_vma_lock_write(anon_vma);
-		anon_vma_interval_tree_pre_update_vma(vma);
-	}
-
-	if (file) {
-		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_remove(vma, root);
-	}
-
-	/* VMA iterator points to previous, so set to start if necessary */
-	if (vma_iter_addr(vmi) != start)
-		vma_iter_set(vmi, start);
-
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
-	vma_iter_store(vmi, vma);
-
-	if (file) {
-		vma_interval_tree_insert(vma, root);
-		flush_dcache_mmap_unlock(mapping);
-	}
-
-	/* Expanding over the next vma */
-	if (remove_next && file) {
-		__remove_shared_vm_struct(next, file, mapping);
-	}
-
-	if (anon_vma) {
-		anon_vma_interval_tree_post_update_vma(vma);
-		anon_vma_unlock_write(anon_vma);
-	}
-
-	if (file) {
-		i_mmap_unlock_write(mapping);
-		uprobe_mmap(vma);
-	}
-
-	if (remove_next) {
-		if (file) {
-			uprobe_munmap(next, next->vm_start, next->vm_end);
-			fput(file);
-		}
-		if (next->anon_vma)
-			anon_vma_merge(vma, next);
-		mm->map_count--;
-		mpol_put(vma_policy(next));
-		vm_area_free(next);
-	}
-
-	validate_mm(mm);
-	return 0;
-
-nomem:
-	return -ENOMEM;
-}
-
-/*
  * vma_prepare() - Helper function for handling locking VMAs prior to altering
  * @vp: The initialized vma_prepare struct
  */
@@ -695,6 +579,78 @@ again:
 }
 
 /*
+ * vma_expand - Expand an existing VMA
+ *
+ * @vmi: The vma iterator
+ * @vma: The vma to expand
+ * @start: The start of the vma
+ * @end: The exclusive end of the vma
+ * @pgoff: The page offset of vma
+ * @next: The current of next vma.
+ *
+ * Expand @vma to @start and @end.  Can expand off the start and end.  Will
+ * expand over @next if it's different from @vma and @end == @next->vm_end.
+ * Checking if the @vma can expand and merge with @next needs to be handled by
+ * the caller.
+ *
+ * Returns: 0 on success
+ */
+inline int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		      unsigned long start, unsigned long end, pgoff_t pgoff,
+		      struct vm_area_struct *next)
+{
+	struct vma_prepare vp;
+
+	memset(&vp, 0, sizeof(vp));
+	vp.vma = vma;
+	vp.anon_vma = vma->anon_vma;
+	if (next && (vma != next) && (end == next->vm_end)) {
+		vp.remove = next;
+		if (next->anon_vma && !vma->anon_vma) {
+			int error;
+
+			vp.anon_vma = next->anon_vma;
+			vma->anon_vma = next->anon_vma;
+			error = anon_vma_clone(vma, next);
+			if (error)
+				return error;
+		}
+	}
+
+	/* Not merging but overwriting any part of next is not handled. */
+	VM_WARN_ON(next && !vp.remove &&
+		  next != vma && end > next->vm_start);
+	/* Only handles expanding */
+	VM_WARN_ON(vma->vm_start < start || vma->vm_end > end);
+
+	if (vma_iter_prealloc(vmi))
+		goto nomem;
+
+	vma_adjust_trans_huge(vma, start, end, 0);
+
+	vp.file = vma->vm_file;
+	if (vp.file)
+		vp.mapping = vp.file->f_mapping;
+
+	/* VMA iterator points to previous, so set to start if necessary */
+	if (vma_iter_addr(vmi) != start)
+		vma_iter_set(vmi, start);
+
+	vma_prepare(&vp);
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+	/* Note: mas must be pointing to the expanding VMA */
+	vma_iter_store(vmi, vma);
+
+	vma_complete(&vp, vmi, vma->vm_mm);
+	validate_mm(vma->vm_mm);
+	return 0;
+
+nomem:
+	return -ENOMEM;
+}
+/*
  * We cannot adjust vm_start, vm_end, vm_pgoff fields of a vma that
  * is already present in an i_mmap tree without adjusting the tree.
  * The following helper function should be used when such adjustments
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


