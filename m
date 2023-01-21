Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93289C27C76
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjAUBHM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjAUBGy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:06:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F944672E
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:06:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B34B8B81C9E
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566C7C433D2;
        Sat, 21 Jan 2023 01:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263210;
        bh=ahDuGPdgtY16qM+ln02M8Si5gad8rWSz6gGh7WXuZ2c=;
        h=Date:To:From:Subject:From;
        b=qQJiWqjyIFurtaSEidhI6qL+NE5oE5kqqo5LGOl5x7za6kIeD1ui5ZM+WVvW928Ky
         Jbo0Ee6baPrA3H9jRRdDSh9zZwTLO9n4mGESpcSSFzW75o9HRhumdp5I1Jny1WpfoW
         7dRRuB5jW8+k2aEv4arLs7yewIu9S/LHu1sTBYzc=
Date:   Fri, 20 Jan 2023 17:06:49 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nommu-pass-through-vma-iterator-to-shrink_vma.patch added to mm-unstable branch
Message-Id: <20230121010650.566C7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nommu: pass through vma iterator to shrink_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     nommu-pass-through-vma-iterator-to-shrink_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nommu-pass-through-vma-iterator-to-shrink_vma.patch

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
Subject: nommu: pass through vma iterator to shrink_vma()
Date: Fri, 20 Jan 2023 11:26:29 -0500

Rename the function to vmi_shrink_vma() indicate it takes the vma
iterator.  Use the iterator to preallocate and drop the delete function. 
The maple tree is able to do the modification easier than the linked list
and rbtree, so just clear the necessary area in the tree.

add_vma_to_mm() is no longer used, so drop this function.

vmi_add_vma_to_mm() is now only used once, so inline this function into
do_mmap().

Link: https://lkml.kernel.org/r/20230120162650.984577-29-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/nommu.c~nommu-pass-through-vma-iterator-to-shrink_vma
+++ a/mm/nommu.c
@@ -560,44 +560,6 @@ static void setup_vma_to_mm(struct vm_ar
 	}
 }
 
-/*
- * vmi_add_vma_to_mm() - VMA Iterator variant of add_vmi_to_mm().
- * @vmi: The VMA iterator
- * @mm: The mm_struct
- * @vma: The vma to add
- *
- */
-static void vmi_add_vma_to_mm(struct vma_iterator *vmi, struct mm_struct *mm,
-			      struct vm_area_struct *vma)
-{
-	BUG_ON(!vma->vm_region);
-
-	setup_vma_to_mm(vma, mm);
-	mm->map_count++;
-
-	/* add the VMA to the tree */
-	vma_iter_store(vmi, vma);
-}
-
-/*
- * add a VMA into a process's mm_struct in the appropriate place in the list
- * and tree and add to the address space's page tree also if not an anonymous
- * page
- * - should be called with mm->mmap_lock held writelocked
- */
-static int add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
-{
-	VMA_ITERATOR(vmi, mm, vma->vm_start);
-
-	if (vma_iter_prealloc(&vmi)) {
-		pr_warn("Allocation of vma tree for process %d failed\n",
-		       current->pid);
-		return -ENOMEM;
-	}
-	vmi_add_vma_to_mm(&vmi, mm, vma);
-	return 0;
-}
-
 static void cleanup_vma_from_mm(struct vm_area_struct *vma)
 {
 	vma->vm_mm->map_count--;
@@ -1221,7 +1183,11 @@ unsigned long do_mmap(struct file *file,
 	current->mm->total_vm += len >> PAGE_SHIFT;
 
 share:
-	vmi_add_vma_to_mm(&vmi, current->mm, vma);
+	BUG_ON(!vma->vm_region);
+	setup_vma_to_mm(vma, current->mm);
+	current->mm->map_count++;
+	/* add the VMA to the tree */
+	vma_iter_store(&vmi, vma);
 
 	/* we flush the region from the icache only when the first executable
 	 * mapping of it is made  */
@@ -1406,7 +1372,7 @@ err_vma_dup:
  * shrink a VMA by removing the specified chunk from either the beginning or
  * the end
  */
-static int shrink_vma(struct mm_struct *mm,
+static int vmi_shrink_vma(struct vma_iterator *vmi,
 		      struct vm_area_struct *vma,
 		      unsigned long from, unsigned long to)
 {
@@ -1414,14 +1380,19 @@ static int shrink_vma(struct mm_struct *
 
 	/* adjust the VMA's pointers, which may reposition it in the MM's tree
 	 * and list */
-	if (delete_vma_from_mm(vma))
+	if (vma_iter_prealloc(vmi)) {
+		pr_warn("Allocation of vma tree for process %d failed\n",
+		       current->pid);
 		return -ENOMEM;
-	if (from > vma->vm_start)
+	}
+
+	if (from > vma->vm_start) {
+		vma_iter_clear(vmi, from, vma->vm_end);
 		vma->vm_end = from;
-	else
+	} else {
+		vma_iter_clear(vmi, vma->vm_start, to);
 		vma->vm_start = to;
-	if (add_vma_to_mm(mm, vma))
-		return -ENOMEM;
+	}
 
 	/* cut the backing region down to size */
 	region = vma->vm_region;
@@ -1498,7 +1469,7 @@ int do_munmap(struct mm_struct *mm, unsi
 			if (ret < 0)
 				return ret;
 		}
-		return shrink_vma(mm, vma, start, end);
+		return vmi_shrink_vma(&vmi, vma, start, end);
 	}
 
 erase_whole_vma:
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch
maple_tree-fix-mas_prev-and-mas_find-state-handling.patch
nommu-pass-through-vma-iterator-to-shrink_vma.patch
mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch
mm-mremap-convert-vma_adjust-to-vma_expand.patch

