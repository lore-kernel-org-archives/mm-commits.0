Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DAD1C636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjBJAxC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjBJAwu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE066D8FD
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B7C2B82272
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E85C433EF;
        Fri, 10 Feb 2023 00:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990366;
        bh=71Gsku+XsibiHpprYOeP4kegRzPetPSI/d2vKZLshBA=;
        h=Date:To:From:Subject:From;
        b=y4zalAevZx95hp6x/VcbPqTgeYOTDMj04cC6sZq7blMwhFSr2Fv4y0vqaTDlA+Ojv
         FqnKNlvGuim+nSs7Cd6sxYtN/0Rpcr5BgHU0zAECW/2QsAwX3yY5Uz1es3LcgoC6GD
         3WK5Xc7nriNngZtFeMmespom8/zryWGBdgseaj90=
Date:   Thu, 09 Feb 2023 16:52:46 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-mprotect_fixup-to-vma-iterator.patch removed from -mm tree
Message-Id: <20230210005246.A2E85C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: change mprotect_fixup to vma iterator
has been removed from the -mm tree.  Its filename was
     mm-change-mprotect_fixup-to-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: change mprotect_fixup to vma iterator
Date: Fri, 20 Jan 2023 11:26:18 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230120162650.984577-18-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    5 +++-
 include/linux/mm.h |    6 ++---
 mm/mprotect.c      |   47 ++++++++++++++++++++-----------------------
 3 files changed, 29 insertions(+), 29 deletions(-)

--- a/fs/exec.c~mm-change-mprotect_fixup-to-vma-iterator
+++ a/fs/exec.c
@@ -758,6 +758,7 @@ int setup_arg_pages(struct linux_binprm
 	unsigned long stack_expand;
 	unsigned long rlim_stack;
 	struct mmu_gather tlb;
+	struct vma_iterator vmi;
 
 #ifdef CONFIG_STACK_GROWSUP
 	/* Limit stack size */
@@ -812,8 +813,10 @@ int setup_arg_pages(struct linux_binprm
 	vm_flags |= mm->def_flags;
 	vm_flags |= VM_STACK_INCOMPLETE_SETUP;
 
+	vma_iter_init(&vmi, mm, vma->vm_start);
+
 	tlb_gather_mmu(&tlb, mm);
-	ret = mprotect_fixup(&tlb, vma, &prev, vma->vm_start, vma->vm_end,
+	ret = mprotect_fixup(&vmi, &tlb, vma, &prev, vma->vm_start, vma->vm_end,
 			vm_flags);
 	tlb_finish_mmu(&tlb);
 
--- a/include/linux/mm.h~mm-change-mprotect_fixup-to-vma-iterator
+++ a/include/linux/mm.h
@@ -2197,9 +2197,9 @@ bool can_change_pte_writable(struct vm_a
 extern long change_protection(struct mmu_gather *tlb,
 			      struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, unsigned long cp_flags);
-extern int mprotect_fixup(struct mmu_gather *tlb, struct vm_area_struct *vma,
-			  struct vm_area_struct **pprev, unsigned long start,
-			  unsigned long end, unsigned long newflags);
+extern int mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
+	  struct vm_area_struct *vma, struct vm_area_struct **pprev,
+	  unsigned long start, unsigned long end, unsigned long newflags);
 
 /*
  * doesn't attempt to fault and will return short.
--- a/mm/mprotect.c~mm-change-mprotect_fixup-to-vma-iterator
+++ a/mm/mprotect.c
@@ -585,9 +585,9 @@ static const struct mm_walk_ops prot_non
 };
 
 int
-mprotect_fixup(struct mmu_gather *tlb, struct vm_area_struct *vma,
-	       struct vm_area_struct **pprev, unsigned long start,
-	       unsigned long end, unsigned long newflags)
+mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
+	       struct vm_area_struct *vma, struct vm_area_struct **pprev,
+	       unsigned long start, unsigned long end, unsigned long newflags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long oldflags = vma->vm_flags;
@@ -642,7 +642,7 @@ mprotect_fixup(struct mmu_gather *tlb, s
 	 * First try to merge with previous and/or next vma.
 	 */
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
-	*pprev = vma_merge(mm, *pprev, start, end, newflags,
+	*pprev = vmi_vma_merge(vmi, mm, *pprev, start, end, newflags,
 			   vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
 			   vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 	if (*pprev) {
@@ -654,13 +654,13 @@ mprotect_fixup(struct mmu_gather *tlb, s
 	*pprev = vma;
 
 	if (start != vma->vm_start) {
-		error = split_vma(mm, vma, start, 1);
+		error = vmi_split_vma(vmi, mm, vma, start, 1);
 		if (error)
 			goto fail;
 	}
 
 	if (end != vma->vm_end) {
-		error = split_vma(mm, vma, end, 0);
+		error = vmi_split_vma(vmi, mm, vma, end, 0);
 		if (error)
 			goto fail;
 	}
@@ -709,7 +709,7 @@ static int do_mprotect_pkey(unsigned lon
 	const bool rier = (current->personality & READ_IMPLIES_EXEC) &&
 				(prot & PROT_READ);
 	struct mmu_gather tlb;
-	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
+	struct vma_iterator vmi;
 
 	start = untagged_addr(start);
 
@@ -741,8 +741,8 @@ static int do_mprotect_pkey(unsigned lon
 	if ((pkey != -1) && !mm_pkey_is_allocated(current->mm, pkey))
 		goto out;
 
-	mas_set(&mas, start);
-	vma = mas_find(&mas, ULONG_MAX);
+	vma_iter_init(&vmi, current->mm, start);
+	vma = vma_find(&vmi, end);
 	error = -ENOMEM;
 	if (!vma)
 		goto out;
@@ -765,18 +765,22 @@ static int do_mprotect_pkey(unsigned lon
 		}
 	}
 
+	prev = vma_prev(&vmi);
 	if (start > vma->vm_start)
 		prev = vma;
-	else
-		prev = mas_prev(&mas, 0);
 
 	tlb_gather_mmu(&tlb, current->mm);
-	for (nstart = start ; ; ) {
+	nstart = start;
+	tmp = vma->vm_start;
+	for_each_vma_range(vmi, vma, end) {
 		unsigned long mask_off_old_flags;
 		unsigned long newflags;
 		int new_vma_pkey;
 
-		/* Here we know that vma->vm_start <= nstart < vma->vm_end. */
+		if (vma->vm_start != tmp) {
+			error = -ENOMEM;
+			break;
+		}
 
 		/* Does the application expect PROT_READ to imply PROT_EXEC */
 		if (rier && (vma->vm_flags & VM_MAYEXEC))
@@ -824,25 +828,18 @@ static int do_mprotect_pkey(unsigned lon
 				break;
 		}
 
-		error = mprotect_fixup(&tlb, vma, &prev, nstart, tmp, newflags);
+		error = mprotect_fixup(&vmi, &tlb, vma, &prev, nstart, tmp, newflags);
 		if (error)
 			break;
 
 		nstart = tmp;
-
-		if (nstart < prev->vm_end)
-			nstart = prev->vm_end;
-		if (nstart >= end)
-			break;
-
-		vma = find_vma(current->mm, prev->vm_end);
-		if (!vma || vma->vm_start != nstart) {
-			error = -ENOMEM;
-			break;
-		}
 		prot = reqprot;
 	}
 	tlb_finish_mmu(&tlb);
+
+	if (vma_iter_end(&vmi) < end)
+		error = -ENOMEM;
+
 out:
 	mmap_write_unlock(current->mm);
 	return error;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


