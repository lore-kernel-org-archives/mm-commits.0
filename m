Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2487C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbjDFCpr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbjDFCpF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460818A5A
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8352642A2
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D24EC4339E;
        Thu,  6 Apr 2023 02:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749103;
        bh=q3lO5sSbuMYZ1xX9uSTcrNACIRJp+hJ+wUmK02OvF0E=;
        h=Date:To:From:Subject:From;
        b=vV90ljhwfv7Km7BFo3xCQ4u8B6lqFRSSDdhVyzsL+VgyygVNcUiuKDAyYiamQvXjK
         68bukLZDkMPFn+DesYdKl/smCp3J6Gpm/cnIEbb6TbSdQsf4N5+YVavNF+6TcFJcU6
         uJR4TKoYdv581RRe+3Rva/wKBkQzZYQcTpxe6wB4=
Date:   Wed, 05 Apr 2023 19:45:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-refactor-do_fault_around.patch removed from -mm tree
Message-Id: <20230406024503.3D24EC4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: refactor do_fault_around()
has been removed from the -mm tree.  Its filename was
     mm-refactor-do_fault_around.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 mm/memory.c |   42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

--- a/mm/memory.c~mm-refactor-do_fault_around
+++ a/mm/memory.c
@@ -4449,8 +4449,8 @@ late_initcall(fault_around_debugfs);
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
@@ -4463,27 +4463,19 @@ late_initcall(fault_around_debugfs);
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
@@ -4491,7 +4483,9 @@ static vm_fault_t do_fault_around(struct
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


