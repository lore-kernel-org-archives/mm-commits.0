Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0F4C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjBJAzF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjBJAyM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEA2721CB
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB7F5B822D1
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59894C433D2;
        Fri, 10 Feb 2023 00:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990404;
        bh=+lf37vDCq1z9AosyCY6d5BhDN49qSlFpG8/9muAfess=;
        h=Date:To:From:Subject:From;
        b=l8yE15aDttFS8Vpqmjwwf13Cb1vk2iB0AYVnRwkIXUasiXCnzJtFrpEQhBGK30oio
         A5cheQqCRuu74x8nFPFCSaiQFtUU0bqgPLlEAPkw7gQu7G+T5tW3cVctx3mu6Fcuj+
         Rwm1kNBZVCgD6Rq2PRADHJ/gg/qHZ7pBfeWnKdg4=
Date:   Thu, 09 Feb 2023 16:53:23 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep.patch removed from -mm tree
Message-Id: <20230210005324.59894C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: introduce init_vma_prep() and init_multi_vma_prep()
has been removed from the -mm tree.  Its filename was
     mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: introduce init_vma_prep() and init_multi_vma_prep()
Date: Fri, 20 Jan 2023 11:26:43 -0500

Add init_vma_prep() and init_multi_vma_prep() to set up the struct
vma_prepare.  This is to abstract the locking when adjusting the VMAs.

Also change __vma_adjust() variable remove_next int in favour of a pointer
to the VMA to remove.  Rename next_next to remove2 since this better
reflects its use.

Link: https://lkml.kernel.org/r/20230120162650.984577-43-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |  108 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 61 insertions(+), 47 deletions(-)

--- a/mm/mmap.c~mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep
+++ a/mm/mmap.c
@@ -458,6 +458,45 @@ static int vma_link(struct mm_struct *mm
 }
 
 /*
+ * init_multi_vma_prep() - Initializer for struct vma_prepare
+ * @vp: The vma_prepare struct
+ * @vma: The vma that will be altered once locked
+ * @next: The next vma if it is to be adjusted
+ * @remove: The first vma to be removed
+ * @remove2: The second vma to be removed
+ */
+static inline void init_multi_vma_prep(struct vma_prepare *vp,
+		struct vm_area_struct *vma, struct vm_area_struct *next,
+		struct vm_area_struct *remove, struct vm_area_struct *remove2)
+{
+	memset(vp, 0, sizeof(struct vma_prepare));
+	vp->vma = vma;
+	vp->anon_vma = vma->anon_vma;
+	vp->remove = remove;
+	vp->remove2 = remove2;
+	vp->adj_next = next;
+	if (!vp->anon_vma && next)
+		vp->anon_vma = next->anon_vma;
+
+	vp->file = vma->vm_file;
+	if (vp->file)
+		vp->mapping = vma->vm_file->f_mapping;
+
+}
+
+/*
+ * init_vma_prep() - Initializer wrapper for vma_prepare struct
+ * @vp: The vma_prepare struct
+ * @vma: The vma that will be altered once locked
+ */
+static inline void init_vma_prep(struct vma_prepare *vp,
+				 struct vm_area_struct *vma)
+{
+	init_multi_vma_prep(vp, vma, NULL, NULL, NULL);
+}
+
+
+/*
  * vma_prepare() - Helper function for handling locking VMAs prior to altering
  * @vp: The initialized vma_prepare struct
  */
@@ -566,7 +605,7 @@ again:
 
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
-		 * we must remove next_next too.
+		 * we must remove the one after next as well.
 		 */
 		if (vp->remove2) {
 			vp->remove = vp->remove2;
@@ -599,17 +638,14 @@ inline int vma_expand(struct vma_iterato
 		      unsigned long start, unsigned long end, pgoff_t pgoff,
 		      struct vm_area_struct *next)
 {
+	bool remove_next = false;
 	struct vma_prepare vp;
 
-	memset(&vp, 0, sizeof(vp));
-	vp.vma = vma;
-	vp.anon_vma = vma->anon_vma;
 	if (next && (vma != next) && (end == next->vm_end)) {
-		vp.remove = next;
+		remove_next = true;
 		if (next->anon_vma && !vma->anon_vma) {
 			int error;
 
-			vp.anon_vma = next->anon_vma;
 			vma->anon_vma = next->anon_vma;
 			error = anon_vma_clone(vma, next);
 			if (error)
@@ -617,6 +653,7 @@ inline int vma_expand(struct vma_iterato
 		}
 	}
 
+	init_multi_vma_prep(&vp, vma, NULL, remove_next ? next : NULL, NULL);
 	/* Not merging but overwriting any part of next is not handled. */
 	VM_WARN_ON(next && !vp.remove &&
 		  next != vma && end > next->vm_start);
@@ -627,11 +664,6 @@ inline int vma_expand(struct vma_iterato
 		goto nomem;
 
 	vma_adjust_trans_huge(vma, start, end, 0);
-
-	vp.file = vma->vm_file;
-	if (vp.file)
-		vp.mapping = vp.file->f_mapping;
-
 	/* VMA iterator points to previous, so set to start if necessary */
 	if (vma_iter_addr(vmi) != start)
 		vma_iter_set(vmi, start);
@@ -662,14 +694,13 @@ int __vma_adjust(struct vma_iterator *vm
 	struct vm_area_struct *insert, struct vm_area_struct *expand)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct vm_area_struct *next_next = NULL;	/* uninit var warning */
+	struct vm_area_struct *remove2 = NULL;
+	struct vm_area_struct *remove = NULL;
 	struct vm_area_struct *next = find_vma(mm, vma->vm_end);
 	struct vm_area_struct *orig_vma = vma;
-	struct anon_vma *anon_vma = NULL;
 	struct file *file = vma->vm_file;
 	bool vma_changed = false;
 	long adjust_next = 0;
-	int remove_next = 0;
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
 	struct vma_prepare vma_prep;
 
@@ -688,25 +719,24 @@ int __vma_adjust(struct vma_iterator *vm
 				 */
 				VM_WARN_ON(end != next->vm_end);
 				/*
-				 * remove_next == 3 means we're
-				 * removing "vma" and that to do so we
+				 * we're removing "vma" and that to do so we
 				 * swapped "vma" and "next".
 				 */
-				remove_next = 3;
 				VM_WARN_ON(file != next->vm_file);
 				swap(vma, next);
+				remove = next;
 			} else {
 				VM_WARN_ON(expand != vma);
 				/*
-				 * case 1, 6, 7, remove_next == 2 is case 6,
-				 * remove_next == 1 is case 1 or 7.
+				 * case 1, 6, 7, remove next.
+				 * case 6 also removes the one beyond next
 				 */
-				remove_next = 1 + (end > next->vm_end);
-				if (remove_next == 2)
-					next_next = find_vma(mm, next->vm_end);
+				remove = next;
+				if (end > next->vm_end)
+					remove2 = find_vma(mm, next->vm_end);
 
-				VM_WARN_ON(remove_next == 2 &&
-					   end != next_next->vm_end);
+				VM_WARN_ON(remove2 != NULL &&
+					   end != remove2->vm_end);
 			}
 
 			exporter = next;
@@ -716,8 +746,8 @@ int __vma_adjust(struct vma_iterator *vm
 			 * If next doesn't have anon_vma, import from vma after
 			 * next, if the vma overlaps with it.
 			 */
-			if (remove_next == 2 && !next->anon_vma)
-				exporter = next_next;
+			if (remove2 != NULL && !next->anon_vma)
+				exporter = remove2;
 
 		} else if (end > next->vm_start) {
 			/*
@@ -758,30 +788,14 @@ int __vma_adjust(struct vma_iterator *vm
 	if (vma_iter_prealloc(vmi))
 		return -ENOMEM;
 
-	anon_vma = vma->anon_vma;
-	if (!anon_vma && adjust_next)
-		anon_vma = next->anon_vma;
-
-	if (anon_vma)
-		VM_WARN_ON(adjust_next && next->anon_vma &&
-			   anon_vma != next->anon_vma);
-
 	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
 
-	memset(&vma_prep, 0, sizeof(vma_prep));
-	vma_prep.vma = vma;
-	vma_prep.anon_vma = anon_vma;
-	vma_prep.file = file;
-	if (adjust_next)
-		vma_prep.adj_next = next;
-	if (file)
-		vma_prep.mapping = file->f_mapping;
-	vma_prep.insert = insert;
-	if (remove_next) {
-		vma_prep.remove = next;
-		vma_prep.remove2 = next_next;
-	}
+	init_multi_vma_prep(&vma_prep, vma, adjust_next ? next : NULL, remove,
+			    remove2);
+	VM_WARN_ON(vma_prep.anon_vma && adjust_next && next->anon_vma &&
+		   vma_prep.anon_vma != next->anon_vma);
 
+	vma_prep.insert = insert;
 	vma_prepare(&vma_prep);
 
 	if (start != vma->vm_start) {
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


