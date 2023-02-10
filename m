Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4579FC636D6
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjBJAyj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjBJAxy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A28570961
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DBD361C36
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0575BC433EF;
        Fri, 10 Feb 2023 00:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990398;
        bh=gKty2xMCOXoUAvLYtyMzpVNoovQXCUmQlo0UHEO6bbA=;
        h=Date:To:From:Subject:From;
        b=YbT3YCV/NZgjpmGhf9gbvgj0KVI0iXOUBD26L3j99roVf5wrhNGdQZXHxpfhgxemT
         iLHT96rJA5QAVUSl5FaLLtQ8Xfd7xAjfzCux/kBu3PywN8yxBb5Mx4wxkNRh9iihfQ
         plXhUZOSqO+t4hl3YWVAhpdbGOKY95rLOLRqievM=
Date:   Thu, 09 Feb 2023 16:53:17 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-munmap-splitting-order-and-move_vma.patch removed from -mm tree
Message-Id: <20230210005318.0575BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: change munmap splitting order and move_vma()
has been removed from the -mm tree.  Its filename was
     mm-change-munmap-splitting-order-and-move_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: change munmap splitting order and move_vma()
Date: Fri, 20 Jan 2023 11:26:39 -0500

Splitting can be more efficient when the order is not of concern.  Change
do_vmi_align_munmap() to reduce walking of the tree during split
operations.

move_vma() must also be altered to remove the dependency of keeping the
original VMA as the active part of the split.  Transition to using vma
iterator to look up the prev and/or next vma after munmap.

[Liam.Howlett@oracle.com: fix vma iterator initialization]
  Link: https://lkml.kernel.org/r/20230126212011.980350-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230120162650.984577-39-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c   |   18 ++----------------
 mm/mremap.c |   28 +++++++++++++++++-----------
 2 files changed, 19 insertions(+), 27 deletions(-)

--- a/mm/mmap.c~mm-change-munmap-splitting-order-and-move_vma
+++ a/mm/mmap.c
@@ -2329,21 +2329,9 @@ do_vmi_align_munmap(struct vma_iterator
 	for_each_vma_range(*vmi, next, end) {
 		/* Does it split the end? */
 		if (next->vm_end > end) {
-			struct vm_area_struct *split;
-
-			error = __split_vma(vmi, next, end, 1);
+			error = __split_vma(vmi, next, end, 0);
 			if (error)
 				goto end_split_failed;
-
-			split = vma_prev(vmi);
-			error = munmap_sidetree(split, &mas_detach);
-			if (error)
-				goto munmap_sidetree_failed;
-
-			count++;
-			if (vma == next)
-				vma = split;
-			break;
 		}
 		error = munmap_sidetree(next, &mas_detach);
 		if (error)
@@ -2356,9 +2344,7 @@ do_vmi_align_munmap(struct vma_iterator
 #endif
 	}
 
-	if (!next)
-		next = vma_next(vmi);
-
+	next = vma_next(vmi);
 	if (unlikely(uf)) {
 		/*
 		 * If userfaultfd_unmap_prep returns an error the vmas
--- a/mm/mremap.c~mm-change-munmap-splitting-order-and-move_vma
+++ a/mm/mremap.c
@@ -580,11 +580,12 @@ static unsigned long move_vma(struct vm_
 	unsigned long vm_flags = vma->vm_flags;
 	unsigned long new_pgoff;
 	unsigned long moved_len;
-	unsigned long excess = 0;
+	unsigned long account_start = 0;
+	unsigned long account_end = 0;
 	unsigned long hiwater_vm;
-	int split = 0;
 	int err = 0;
 	bool need_rmap_locks;
+	struct vma_iterator vmi;
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
@@ -662,10 +663,10 @@ static unsigned long move_vma(struct vm_
 	/* Conceal VM_ACCOUNT so old reservation is not undone */
 	if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP)) {
 		vma->vm_flags &= ~VM_ACCOUNT;
-		excess = vma->vm_end - vma->vm_start - old_len;
-		if (old_addr > vma->vm_start &&
-		    old_addr + old_len < vma->vm_end)
-			split = 1;
+		if (vma->vm_start < old_addr)
+			account_start = vma->vm_start;
+		if (vma->vm_end > old_addr + old_len)
+			account_end = vma->vm_end;
 	}
 
 	/*
@@ -700,11 +701,12 @@ static unsigned long move_vma(struct vm_
 		return new_addr;
 	}
 
-	if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
+	vma_iter_init(&vmi, mm, old_addr);
+	if (do_vmi_munmap(&vmi, mm, old_addr, old_len, uf_unmap, false) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
 		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
 			vm_acct_memory(old_len >> PAGE_SHIFT);
-		excess = 0;
+		account_start = account_end = 0;
 	}
 
 	if (vm_flags & VM_LOCKED) {
@@ -715,10 +717,14 @@ static unsigned long move_vma(struct vm_
 	mm->hiwater_vm = hiwater_vm;
 
 	/* Restore VM_ACCOUNT if one or two pieces of vma left */
-	if (excess) {
+	if (account_start) {
+		vma = vma_prev(&vmi);
+		vma->vm_flags |= VM_ACCOUNT;
+	}
+
+	if (account_end) {
+		vma = vma_next(&vmi);
 		vma->vm_flags |= VM_ACCOUNT;
-		if (split)
-			find_vma(mm, vma->vm_end)->vm_flags |= VM_ACCOUNT;
 	}
 
 	return new_addr;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


