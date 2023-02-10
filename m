Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4AEC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjBJAyi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjBJAxy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA15C7095B
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FA51B82395
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E56C433D2;
        Fri, 10 Feb 2023 00:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990395;
        bh=poN5TDDUEK7z0u1rXBCZhtPojNY7tK+FC8WpyBs+/3w=;
        h=Date:To:From:Subject:From;
        b=Y3sM+E/vfUyPnsZaXBkFFdg2XnUjpRmusjwrTaB4bB6E0uUEK1+hStwhTal07R70C
         WtFbgb/HSMgfvk+j/lj4j2bAngdrg+a8UJyHEz4d4WvU613B/TWWD1DLMDwEH6Gu1B
         ZBaGDsRZhCqUZIF+rHAmdUeju0FTcbuRrDwXQoNs=
Date:   Thu, 09 Feb 2023 16:53:14 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-vma-iterator-to-vma_adjust-arguments.patch removed from -mm tree
Message-Id: <20230210005315.14E56C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add vma iterator to vma_adjust() arguments
has been removed from the -mm tree.  Its filename was
     mm-add-vma-iterator-to-vma_adjust-arguments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: add vma iterator to vma_adjust() arguments
Date: Fri, 20 Jan 2023 11:26:37 -0500

Change the vma_adjust() function definition to accept the vma iterator and
pass it through to __vma_adjust().

Update fs/exec to use the new vma_adjust() function parameters.

Update mm/mremap to use the new vma_adjust() function parameters.

Revert the __split_vma() calls back from __vma_adjust() to vma_adjust()
and pass through the vma iterator.

Link: https://lkml.kernel.org/r/20230120162650.984577-37-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |   11 ++++-------
 include/linux/mm.h |    9 ++++-----
 mm/mmap.c          |   10 +++++-----
 mm/mremap.c        |    4 ++--
 4 files changed, 15 insertions(+), 19 deletions(-)

--- a/fs/exec.c~mm-add-vma-iterator-to-vma_adjust-arguments
+++ a/fs/exec.c
@@ -699,7 +699,7 @@ static int shift_arg_pages(struct vm_are
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	if (vma_adjust(vma, new_start, old_end, vma->vm_pgoff, NULL))
+	if (vma_adjust(&vmi, vma, new_start, old_end, vma->vm_pgoff, NULL))
 		return -ENOMEM;
 
 	/*
@@ -731,12 +731,9 @@ static int shift_arg_pages(struct vm_are
 	}
 	tlb_finish_mmu(&tlb);
 
-	/*
-	 * Shrink the vma to just the new range.  Always succeeds.
-	 */
-	vma_adjust(vma, new_start, new_end, vma->vm_pgoff, NULL);
-
-	return 0;
+	vma_prev(&vmi);
+	/* Shrink the vma to just the new range */
+	return vma_adjust(&vmi, vma, new_start, new_end, vma->vm_pgoff, NULL);
 }
 
 /*
--- a/include/linux/mm.h~mm-add-vma-iterator-to-vma_adjust-arguments
+++ a/include/linux/mm.h
@@ -2834,12 +2834,11 @@ extern int __vm_enough_memory(struct mm_
 extern int __vma_adjust(struct vma_iterator *vmi, struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert,
 	struct vm_area_struct *expand);
-static inline int vma_adjust(struct vm_area_struct *vma, unsigned long start,
-	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert)
+static inline int vma_adjust(struct vma_iterator *vmi,
+	struct vm_area_struct *vma, unsigned long start, unsigned long end,
+	pgoff_t pgoff, struct vm_area_struct *insert)
 {
-	VMA_ITERATOR(vmi, vma->vm_mm, start);
-
-	return __vma_adjust(&vmi, vma, start, end, pgoff, insert, NULL);
+	return __vma_adjust(vmi, vma, start, end, pgoff, insert, NULL);
 }
 extern struct vm_area_struct *vma_merge(struct vma_iterator *vmi,
 	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
--- a/mm/mmap.c~mm-add-vma-iterator-to-vma_adjust-arguments
+++ a/mm/mmap.c
@@ -2210,12 +2210,12 @@ int __split_vma(struct vma_iterator *vmi
 		new->vm_ops->open(new);
 
 	if (new_below)
-		err = __vma_adjust(vmi, vma, addr, vma->vm_end,
-		   vma->vm_pgoff + ((addr - new->vm_start) >> PAGE_SHIFT),
-		   new, NULL);
+		err = vma_adjust(vmi, vma, addr, vma->vm_end,
+			vma->vm_pgoff + ((addr - new->vm_start) >> PAGE_SHIFT),
+			new);
 	else
-		err = __vma_adjust(vmi, vma, vma->vm_start, addr, vma->vm_pgoff,
-				 new, NULL);
+		err = vma_adjust(vmi, vma, vma->vm_start, addr, vma->vm_pgoff,
+				 new);
 
 	/* Success. */
 	if (!err) {
--- a/mm/mremap.c~mm-add-vma-iterator-to-vma_adjust-arguments
+++ a/mm/mremap.c
@@ -1047,8 +1047,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 					extension_end, vma->vm_flags, vma->anon_vma,
 					vma->vm_file, extension_pgoff, vma_policy(vma),
 					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
-			} else if (vma_adjust(vma, vma->vm_start, addr + new_len,
-				   vma->vm_pgoff, NULL)) {
+			} else if (vma_adjust(&vmi, vma, vma->vm_start,
+					addr + new_len, vma->vm_pgoff, NULL)) {
 				vma = NULL;
 			}
 			if (!vma) {
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


