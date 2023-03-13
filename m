Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A033C6FD1F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 01:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCMBCI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 12 Mar 2023 21:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCMBCF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 12 Mar 2023 21:02:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63022BEE1
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 18:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FA05B80DD7
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 01:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235D4C433EF;
        Mon, 13 Mar 2023 01:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678669321;
        bh=AXs3GmLXsDIiRXdDTp/C2BCwV8dJ4KiEkiC+fWIKqKU=;
        h=Date:To:From:Subject:From;
        b=P7tHQdhDYnLJQUyWup9ukNrQOL1D5jxBclSLf+EcNT0yFqi/tfqNO7A7Y+6CMBc3O
         aDCEHydTbJum9Eyb4Qt9WdYh4ZulNumybHSRTgkTwymZ/x4AkTQcN9g1pea5QyBPvE
         ddUePARUR5OYPTgzwBRs9kk8y09AD/3c+Nxo5MVg=
Date:   Sun, 12 Mar 2023 18:02:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        thomas.hellstrom@linux.intel.com, mhocko@suse.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch added to mm-unstable branch
Message-Id: <20230313010201.235D4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch

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
Subject: mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries
Date: Sun, 12 Mar 2023 23:40:14 +0000

This functionality's sole user, the drm ttm module, removed support for it
in commit 0d979509539e ("drm/ttm: remove ttm_bo_vm_insert_huge()") as the
whole approach is currently unworkable without a PMD/PUD special bit and
updates to GUP.

Link: https://lkml.kernel.org/r/604c2ad79659d4b8a6e3e1611c6219d5d3233988.1678661628.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/huge_mm.h~mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries
+++ a/include/linux/huge_mm.h
@@ -39,44 +39,9 @@ bool move_huge_pmd(struct vm_area_struct
 int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		    pmd_t *pmd, unsigned long addr, pgprot_t newprot,
 		    unsigned long cp_flags);
-vm_fault_t vmf_insert_pfn_pmd_prot(struct vm_fault *vmf, pfn_t pfn,
-				   pgprot_t pgprot, bool write);
 
-/**
- * vmf_insert_pfn_pmd - insert a pmd size pfn
- * @vmf: Structure describing the fault
- * @pfn: pfn to insert
- * @pgprot: page protection to use
- * @write: whether it's a write fault
- *
- * Insert a pmd size pfn. See vmf_insert_pfn() for additional info.
- *
- * Return: vm_fault_t value.
- */
-static inline vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn,
-					    bool write)
-{
-	return vmf_insert_pfn_pmd_prot(vmf, pfn, vmf->vma->vm_page_prot, write);
-}
-vm_fault_t vmf_insert_pfn_pud_prot(struct vm_fault *vmf, pfn_t pfn,
-				   pgprot_t pgprot, bool write);
-
-/**
- * vmf_insert_pfn_pud - insert a pud size pfn
- * @vmf: Structure describing the fault
- * @pfn: pfn to insert
- * @pgprot: page protection to use
- * @write: whether it's a write fault
- *
- * Insert a pud size pfn. See vmf_insert_pfn() for additional info.
- *
- * Return: vm_fault_t value.
- */
-static inline vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn,
-					    bool write)
-{
-	return vmf_insert_pfn_pud_prot(vmf, pfn, vmf->vma->vm_page_prot, write);
-}
+vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
+vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_NEVER_DAX,
--- a/mm/huge_memory.c~mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries
+++ a/mm/huge_memory.c
@@ -889,23 +889,20 @@ out_unlock:
 }
 
 /**
- * vmf_insert_pfn_pmd_prot - insert a pmd size pfn
+ * vmf_insert_pfn_pmd - insert a pmd size pfn
  * @vmf: Structure describing the fault
  * @pfn: pfn to insert
- * @pgprot: page protection to use
  * @write: whether it's a write fault
  *
- * Insert a pmd size pfn. See vmf_insert_pfn() for additional info and
- * also consult the vmf_insert_mixed_prot() documentation when
- * @pgprot != @vmf->vma->vm_page_prot.
+ * Insert a pmd size pfn. See vmf_insert_pfn() for additional info.
  *
  * Return: vm_fault_t value.
  */
-vm_fault_t vmf_insert_pfn_pmd_prot(struct vm_fault *vmf, pfn_t pfn,
-				   pgprot_t pgprot, bool write)
+vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
 {
 	unsigned long addr = vmf->address & PMD_MASK;
 	struct vm_area_struct *vma = vmf->vma;
+	pgprot_t pgprot = vma->vm_page_prot;
 	pgtable_t pgtable = NULL;
 
 	/*
@@ -933,7 +930,7 @@ vm_fault_t vmf_insert_pfn_pmd_prot(struc
 	insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write, pgtable);
 	return VM_FAULT_NOPAGE;
 }
-EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd_prot);
+EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd);
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
@@ -944,9 +941,10 @@ static pud_t maybe_pud_mkwrite(pud_t pud
 }
 
 static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
-		pud_t *pud, pfn_t pfn, pgprot_t prot, bool write)
+		pud_t *pud, pfn_t pfn, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	pgprot_t prot = vma->vm_page_prot;
 	pud_t entry;
 	spinlock_t *ptl;
 
@@ -980,23 +978,20 @@ out_unlock:
 }
 
 /**
- * vmf_insert_pfn_pud_prot - insert a pud size pfn
+ * vmf_insert_pfn_pud - insert a pud size pfn
  * @vmf: Structure describing the fault
  * @pfn: pfn to insert
- * @pgprot: page protection to use
  * @write: whether it's a write fault
  *
- * Insert a pud size pfn. See vmf_insert_pfn() for additional info and
- * also consult the vmf_insert_mixed_prot() documentation when
- * @pgprot != @vmf->vma->vm_page_prot.
+ * Insert a pud size pfn. See vmf_insert_pfn() for additional info.
  *
  * Return: vm_fault_t value.
  */
-vm_fault_t vmf_insert_pfn_pud_prot(struct vm_fault *vmf, pfn_t pfn,
-				   pgprot_t pgprot, bool write)
+vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
 {
 	unsigned long addr = vmf->address & PUD_MASK;
 	struct vm_area_struct *vma = vmf->vma;
+	pgprot_t pgprot = vma->vm_page_prot;
 
 	/*
 	 * If we had pud_special, we could avoid all these restrictions,
@@ -1014,10 +1009,10 @@ vm_fault_t vmf_insert_pfn_pud_prot(struc
 
 	track_pfn_insert(vma, &pgprot, pfn);
 
-	insert_pfn_pud(vma, addr, vmf->pud, pfn, pgprot, write);
+	insert_pfn_pud(vma, addr, vmf->pud, pfn, write);
 	return VM_FAULT_NOPAGE;
 }
-EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud_prot);
+EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud);
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
 static void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch

