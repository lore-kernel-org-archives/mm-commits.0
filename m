Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85A5C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjBJAzN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjBJAyV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1FC721E1
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3795B8239A
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE0CC433EF;
        Fri, 10 Feb 2023 00:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990408;
        bh=kLqg86kWqvShLyn4U3gxgUsvp160d4aLe76q8pR6SHU=;
        h=Date:To:From:Subject:From;
        b=NliiBqSlCtx9V3WT1YPrBNq/SSlajEJrizd/7nRHf5V+IW4Pc/+BSlOA11SCQgLXA
         4Axc/vdGZAsoJHBOxfrzXp7SzsQZQ5odn81QzZhObUMWr8mLd6IOqdhABFnL8mhAXn
         krHORZ/JDnOBcsijxV8f/3uwrQFrpKOlg+p8wvWY=
Date:   Thu, 09 Feb 2023 16:53:28 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages.patch removed from -mm tree
Message-Id: <20230210005328.AAE0CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: don't use __vma_adjust() in shift_arg_pages()
has been removed from the -mm tree.  Its filename was
     mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: don't use __vma_adjust() in shift_arg_pages()
Date: Fri, 20 Jan 2023 11:26:46 -0500

Introduce shrink_vma() which uses the vma_prepare() and vma_complete()
functions to reduce the vma coverage.

Convert shift_arg_pages() to use expand_vma() and the new shrink_vma()
function.  Remove support from __vma_adjust() to reduce a vma size since
shift_arg_pages() is the only user that shrinks a VMA in this way.

Link: https://lkml.kernel.org/r/20230120162650.984577-46-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    4 +--
 include/linux/mm.h |   10 +-------
 mm/mmap.c          |   52 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 47 insertions(+), 19 deletions(-)

--- a/fs/exec.c~mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages
+++ a/fs/exec.c
@@ -699,7 +699,7 @@ static int shift_arg_pages(struct vm_are
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	if (vma_adjust(&vmi, vma, new_start, old_end, vma->vm_pgoff))
+	if (vma_expand(&vmi, vma, new_start, old_end, vma->vm_pgoff, NULL))
 		return -ENOMEM;
 
 	/*
@@ -733,7 +733,7 @@ static int shift_arg_pages(struct vm_are
 
 	vma_prev(&vmi);
 	/* Shrink the vma to just the new range */
-	return vma_adjust(&vmi, vma, new_start, new_end, vma->vm_pgoff);
+	return vma_shrink(&vmi, vma, new_start, new_end, vma->vm_pgoff);
 }
 
 /*
--- a/include/linux/mm.h~mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages
+++ a/include/linux/mm.h
@@ -2831,17 +2831,11 @@ void anon_vma_interval_tree_verify(struc
 
 /* mmap.c */
 extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
-extern int __vma_adjust(struct vma_iterator *vmi, struct vm_area_struct *vma, unsigned long start,
-	unsigned long end, pgoff_t pgoff, struct vm_area_struct *expand);
-static inline int vma_adjust(struct vma_iterator *vmi,
-	struct vm_area_struct *vma, unsigned long start, unsigned long end,
-	pgoff_t pgoff)
-{
-	return __vma_adjust(vmi, vma, start, end, pgoff, NULL);
-}
 extern int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		      unsigned long start, unsigned long end, pgoff_t pgoff,
 		      struct vm_area_struct *next);
+extern int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		       unsigned long start, unsigned long end, pgoff_t pgoff);
 extern struct vm_area_struct *vma_merge(struct vma_iterator *vmi,
 	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
 	unsigned long end, unsigned long vm_flags, struct anon_vma *,
--- a/mm/mmap.c~mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages
+++ a/mm/mmap.c
@@ -682,6 +682,44 @@ int vma_expand(struct vma_iterator *vmi,
 nomem:
 	return -ENOMEM;
 }
+
+/*
+ * vma_shrink() - Reduce an existing VMAs memory area
+ * @vmi: The vma iterator
+ * @vma: The VMA to modify
+ * @start: The new start
+ * @end: The new end
+ *
+ * Returns: 0 on success, -ENOMEM otherwise
+ */
+int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	       unsigned long start, unsigned long end, pgoff_t pgoff)
+{
+	struct vma_prepare vp;
+
+	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
+
+	if (vma_iter_prealloc(vmi))
+		return -ENOMEM;
+
+	init_vma_prep(&vp, vma);
+	vma_adjust_trans_huge(vma, start, end, 0);
+	vma_prepare(&vp);
+
+	if (vma->vm_start < start)
+		vma_iter_clear(vmi, vma->vm_start, start);
+
+	if (vma->vm_end > end)
+		vma_iter_clear(vmi, end, vma->vm_end);
+
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+	vma_complete(&vp, vmi, vma->vm_mm);
+	validate_mm(vma->vm_mm);
+	return 0;
+}
+
 /*
  * We cannot adjust vm_start, vm_end, vm_pgoff fields of a vma that
  * is already present in an i_mmap tree without adjusting the tree.
@@ -797,14 +835,7 @@ int __vma_adjust(struct vma_iterator *vm
 
 	vma_prepare(&vma_prep);
 
-	if (vma->vm_start < start)
-		vma_iter_clear(vmi, vma->vm_start, start);
-	else if (start != vma->vm_start)
-		vma_changed = true;
-
-	if (vma->vm_end > end)
-		vma_iter_clear(vmi, end, vma->vm_end);
-	else if (end != vma->vm_end)
+	if (start < vma->vm_start || end > vma->vm_end)
 		vma_changed = true;
 
 	vma->vm_start = start;
@@ -817,7 +848,10 @@ int __vma_adjust(struct vma_iterator *vm
 	if (adjust_next) {
 		next->vm_start += adjust_next;
 		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
-		vma_iter_store(vmi, next);
+		if (adjust_next < 0) {
+			WARN_ON_ONCE(vma_changed);
+			vma_iter_store(vmi, next);
+		}
 	}
 
 	vma_complete(&vma_prep, vmi, mm);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


