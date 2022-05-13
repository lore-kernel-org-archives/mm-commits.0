Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9C6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383716AbiEMTWc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383798AbiEMTWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93D936691
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70C71B8315C
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D52C34100;
        Fri, 13 May 2022 19:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469702;
        bh=eQMR9YdZYS1TQMtoCi/L8O92M7Fd3gZacUbDn46fSfQ=;
        h=Date:To:From:Subject:From;
        b=q6B13fwLkOR+GGCEelrPQZFVJ5q9gBKNxrYzVZEnM//UrW4erGyZNiDOczNvwK/3S
         Vj2qgwhpcrWrD/eVudDKdPyVhODKEj/Q5mWMm6VfCYMG9RbCg7H6eKjSmVknVQyefI
         4n4j1kuO4R9NiGJHgKwSuZ1jctlPlCbqotJnNy60=
Date:   Fri, 13 May 2022 12:21:41 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch removed from -mm tree
Message-Id: <20220513192142.14D52C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: convert do_huge_pmd_anonymous_page() to use  vma_alloc_folio()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/huge_memory: convert do_huge_pmd_anonymous_page() to use  vma_alloc_folio()

Remove the use of this old API, eliminating a call to
prep_transhuge_page().

Link: https://lkml.kernel.org/r/20220504182857.4013401-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio
+++ a/mm/huge_memory.c
@@ -726,7 +726,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 {
 	struct vm_area_struct *vma = vmf->vma;
 	gfp_t gfp;
-	struct page *page;
+	struct folio *folio;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 
 	if (!transhuge_vma_suitable(vma, haddr))
@@ -775,13 +775,12 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 		return ret;
 	}
 	gfp = vma_thp_gfp_mask(vma);
-	page = alloc_hugepage_vma(gfp, vma, haddr, HPAGE_PMD_ORDER);
-	if (unlikely(!page)) {
+	folio = vma_alloc_folio(gfp, HPAGE_PMD_ORDER, vma, haddr, true);
+	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	prep_transhuge_page(page);
-	return __do_huge_pmd_anonymous_page(vmf, page, gfp);
+	return __do_huge_pmd_anonymous_page(vmf, &folio->page, gfp);
 }
 
 static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

