Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9B8C6FD1D
	for <mm-commits@archiver.kernel.org>; Fri, 17 Mar 2023 23:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCQXmG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Mar 2023 19:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCQXmB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2023 19:42:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960F71CBCA
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 16:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30E6960B5C
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 23:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D70DC433D2;
        Fri, 17 Mar 2023 23:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679096513;
        bh=8judls+G2wZyeqV1Y7AfQOrRGVSetnGO6sIMM3aM0SE=;
        h=Date:To:From:Subject:From;
        b=WZldIja9Sjfv9LFiS5gO6HcVpCxSIoxVmTpBX6d4GNR56MyF7bFKaLLBvnmCLKhZF
         oGRZDKRsi4q+Mz5J55zARRuuO4X+Tva4m1tYF0RK/S4FV/bGh/MF22mHDOAWfxf7SD
         y03M7BCx7VWTusy5yx8eudWY1KZWu/Ai74jwhnQY=
Date:   Fri, 17 Mar 2023 16:41:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-do_fault_around.patch added to mm-unstable branch
Message-Id: <20230317234153.7D70DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor do_fault_around()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-refactor-do_fault_around.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-do_fault_around.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: refactor do_fault_around()
Date: Fri, 17 Mar 2023 21:58:25 +0000

Patch series "Refactor do_fault_around()"

Refactor do_fault_around() to avoid bitwise tricks and rather difficult to
follow logic.  Additionally, prefer fault_around_pages to
fault_around_bytes as the operations are performed at a base page
granularity.


This patch (of 2):

The existing logic is confusing and fails to abstract a number of bitwise
tricks.

Use ALIGN_DOWN() to perform alignment, pte_index() to obtain a PTE index
and represent the address range using PTE offsets, which naturally make it
clear that the operation is intended to occur within only a single PTE and
prevent spanning of more than one page table.

We rely on the fact that fault_around_bytes will always be page-aligned,
at least one page in size, a power of two and that it will not exceed
PAGE_SIZE * PTRS_PER_PTE in size (i.e.  the address space mapped by a
PTE).  These are all guaranteed by fault_around_bytes_set().

Link: https://lkml.kernel.org/r/cover.1679089214.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/d125db1c3665a63b80cea29d56407825482e2262.1679089214.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-refactor-do_fault_around
+++ a/mm/memory.c
@@ -4437,8 +4437,8 @@ late_initcall(fault_around_debugfs);
  * It uses vm_ops->map_pages() to map the pages, which skips the page if it's
  * not ready to be mapped: not up-to-date, locked, etc.
  *
- * This function doesn't cross the VMA boundaries, in order to call map_pages()
- * only once.
+ * This function doesn't cross VMA or page table boundaries, in order to call
+ * map_pages() and acquire a PTE lock only once.
  *
  * fault_around_bytes defines how many bytes we'll try to map.
  * do_fault_around() expects it to be set to a power of two less than or equal
@@ -4451,27 +4451,19 @@ late_initcall(fault_around_debugfs);
  */
 static vm_fault_t do_fault_around(struct vm_fault *vmf)
 {
-	unsigned long address = vmf->address, nr_pages, mask;
-	pgoff_t start_pgoff = vmf->pgoff;
-	pgoff_t end_pgoff;
-	int off;
-
-	nr_pages = READ_ONCE(fault_around_bytes) >> PAGE_SHIFT;
-	mask = ~(nr_pages * PAGE_SIZE - 1) & PAGE_MASK;
-
-	address = max(address & mask, vmf->vma->vm_start);
-	off = ((vmf->address - address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
-	start_pgoff -= off;
-
-	/*
-	 *  end_pgoff is either the end of the page table, the end of
-	 *  the vma or nr_pages from start_pgoff, depending what is nearest.
-	 */
-	end_pgoff = start_pgoff -
-		((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)) +
-		PTRS_PER_PTE - 1;
-	end_pgoff = min3(end_pgoff, vma_pages(vmf->vma) + vmf->vma->vm_pgoff - 1,
-			start_pgoff + nr_pages - 1);
+	pgoff_t nr_pages = READ_ONCE(fault_around_bytes) >> PAGE_SHIFT;
+	pgoff_t pte_off = pte_index(vmf->address);
+	/* The page offset of vmf->address within the VMA. */
+	pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
+	pgoff_t from_pte, to_pte;
+
+	/* The PTE offset of the start address, clamped to the VMA. */
+	from_pte = max(ALIGN_DOWN(pte_off, nr_pages),
+		       pte_off - min(pte_off, vma_off));
+
+	/* The PTE offset of the end address, clamped to the VMA and PTE. */
+	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
+		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
 
 	if (pmd_none(*vmf->pmd)) {
 		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
@@ -4479,7 +4471,9 @@ static vm_fault_t do_fault_around(struct
 			return VM_FAULT_OOM;
 	}
 
-	return vmf->vma->vm_ops->map_pages(vmf, start_pgoff, end_pgoff);
+	return vmf->vma->vm_ops->map_pages(vmf,
+		vmf->pgoff + from_pte - pte_off,
+		vmf->pgoff + to_pte - pte_off);
 }
 
 /* Return true if we should do read fault-around, false otherwise */
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch
mm-refactor-do_fault_around.patch
mm-pefer-fault_around_pages-to-fault_around_bytes.patch

