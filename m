Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAF6C433DB
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 20:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 707F760234
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 20:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381291AbhCBUxE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Mar 2021 15:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240248AbhCBA0r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Mar 2021 19:26:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9971F6023B;
        Tue,  2 Mar 2021 00:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614644766;
        bh=K30hfsxtn4nvJrjq53q57Aag+LNvco26UqykVtbBlL0=;
        h=Date:From:To:Subject:From;
        b=Lu8K4oCQoNWFMuGMm7+8iVj4+mseZ/o2W02SdEWya93DOnNtY/tYHsj2koL5bseGj
         IARGZlJdRdpgSpYM5GcnY7Cq2YC2C1k9eG8DB46t5XAzT1wzsA1t1yZ0nXrcOr77aH
         w34HQHHGpqSqwnBn8zaEFyUz/jbN/3dWazJqRKG8=
Date:   Mon, 01 Mar 2021 16:26:05 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, adobriyan@gmail.com, almasrymina@google.com,
        anshuman.khandual@arm.com, axelrasmussen@google.com,
        cannonmatthews@google.com, catalin.marinas@arm.com,
        chinwen.chang@mediatek.com, dgilbert@redhat.com, jannh@google.com,
        jglisse@redhat.com, kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mingo@redhat.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        oupton@google.com, peterx@redhat.com, rientjes@google.com,
        rostedt@goodmis.org, rppt@linux.vnet.ibm.com, ruprecht@google.com,
        shawn@anastas.io, shli@fb.com, steven.price@arm.com,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, walken@google.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  +
 hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch added to -mm
 tree
Message-ID: <20210302002605.anEpaLzsC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: pass vma into huge_pte_alloc() and huge_pmd_share()
has been added to the -mm tree.  Its filename is
     hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: hugetlb: pass vma into huge_pte_alloc() and huge_pmd_share()

Patch series "hugetlb: Disable huge pmd unshare for uffd-wp", v4.

This series tries to disable huge pmd unshare of hugetlbfs backed memory
for uffd-wp.  Although uffd-wp of hugetlbfs is still during rfc stage, the
idea of this series may be needed for multiple tasks (Axel's uffd minor
fault series, and Mike's soft dirty series), so I picked it out from the
larger series.


This patch (of 4):

It is a preparation work to be able to behave differently in the per
architecture huge_pte_alloc() according to different VMA attributes.

Pass it deeper into huge_pmd_share() so that we can avoid the find_vma() call.

Link: https://lkml.kernel.org/r/20210218230633.15028-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20210218230633.15028-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Adam Ruprecht <ruprecht@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Cannon Matthews <cannonmatthews@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michal Koutn" <mkoutny@suse.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shawn Anastasio <shawn@anastas.io>
Cc: Steven Price <steven.price@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c   |    4 ++--
 arch/ia64/mm/hugetlbpage.c    |    3 ++-
 arch/mips/mm/hugetlbpage.c    |    4 ++--
 arch/parisc/mm/hugetlbpage.c  |    2 +-
 arch/powerpc/mm/hugetlbpage.c |    3 ++-
 arch/s390/mm/hugetlbpage.c    |    2 +-
 arch/sh/mm/hugetlbpage.c      |    2 +-
 arch/sparc/mm/hugetlbpage.c   |    2 +-
 include/linux/hugetlb.h       |    5 +++--
 mm/hugetlb.c                  |   15 ++++++++-------
 mm/userfaultfd.c              |    2 +-
 11 files changed, 24 insertions(+), 20 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -252,7 +252,7 @@ void set_huge_swap_pte_at(struct mm_stru
 		set_pte(ptep, pte);
 }
 
-pte_t *huge_pte_alloc(struct mm_struct *mm,
+pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgdp;
@@ -286,7 +286,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	} else if (sz == PMD_SIZE) {
 		if (IS_ENABLED(CONFIG_ARCH_WANT_HUGE_PMD_SHARE) &&
 		    pud_none(READ_ONCE(*pudp)))
-			ptep = huge_pmd_share(mm, addr, pudp);
+			ptep = huge_pmd_share(mm, vma, addr, pudp);
 		else
 			ptep = (pte_t *)pmd_alloc(mm, pudp, addr);
 	} else if (sz == (CONT_PMD_SIZE)) {
--- a/arch/ia64/mm/hugetlbpage.c~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -25,7 +25,8 @@ unsigned int hpage_shift = HPAGE_SHIFT_D
 EXPORT_SYMBOL(hpage_shift);
 
 pte_t *
-huge_pte_alloc(struct mm_struct *mm, unsigned long addr, unsigned long sz)
+huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
+	       unsigned long addr, unsigned long sz)
 {
 	unsigned long taddr = htlbpage_to_page(addr);
 	pgd_t *pgd;
--- a/arch/mips/mm/hugetlbpage.c~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share
+++ a/arch/mips/mm/hugetlbpage.c
@@ -21,8 +21,8 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
-pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr,
-		      unsigned long sz)
+pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
+		      unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
--- a/arch/parisc/mm/hugetlbpage.c~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share
+++ a/arch/parisc/mm/hugetlbpage.c
@@ -44,7 +44,7 @@ hugetlb_get_unmapped_area(struct file *f
 }
 
 
-pte_t *huge_pte_alloc(struct mm_struct *mm,
+pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
--- a/arch/powerpc/mm/hugetlbpage.c~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -106,7 +106,8 @@ static int __hugepte_alloc(struct mm_str
  * At this point we do the placement change only for BOOK3S 64. This would
  * possibly work on other subarchs.
  */
-pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr, unsigned long sz)
+pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
+		      unsigned long addr, unsigned long sz)
 {
 	pgd_t *pg;
 	p4d_t *p4;
--- a/arch/s390/mm/hugetlbpage.c~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share
+++ a/arch/s390/mm/hugetlbpage.c
@@ -189,7 +189,7 @@ pte_t huge_ptep_get_and_clear(struct mm_
 	return pte;
 }
 
-pte_t *huge_pte_alloc(struct mm_struct *mm,
+pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgdp;
--- a/arch/sh/mm/hugetlbpage.c~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share
+++ a/arch/sh/mm/hugetlbpage.c
@@ -21,7 +21,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
-pte_t *huge_pte_alloc(struct mm_struct *mm,
+pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
--- a/arch/sparc/mm/hugetlbpage.c~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -279,7 +279,7 @@ unsigned long pud_leaf_size(pud_t pud) {
 unsigned long pmd_leaf_size(pmd_t pmd) { return 1UL << tte_to_shift(*(pte_t *)&pmd); }
 unsigned long pte_leaf_size(pte_t pte) { return 1UL << tte_to_shift(pte); }
 
-pte_t *huge_pte_alloc(struct mm_struct *mm,
+pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
--- a/include/linux/hugetlb.h~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share
+++ a/include/linux/hugetlb.h
@@ -152,7 +152,8 @@ void hugetlb_fix_reserve_counts(struct i
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
 
-pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
+pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
+		      unsigned long addr, pud_t *pud);
 
 struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage);
 
@@ -161,7 +162,7 @@ extern struct list_head huge_boot_pages;
 
 /* arch callbacks */
 
-pte_t *huge_pte_alloc(struct mm_struct *mm,
+pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz);
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz);
--- a/mm/hugetlb.c~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share
+++ a/mm/hugetlb.c
@@ -3760,7 +3760,7 @@ int copy_hugetlb_page_range(struct mm_st
 		src_pte = huge_pte_offset(src, addr, sz);
 		if (!src_pte)
 			continue;
-		dst_pte = huge_pte_alloc(dst, addr, sz);
+		dst_pte = huge_pte_alloc(dst, vma, addr, sz);
 		if (!dst_pte) {
 			ret = -ENOMEM;
 			break;
@@ -4483,7 +4483,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 */
 	mapping = vma->vm_file->f_mapping;
 	i_mmap_lock_read(mapping);
-	ptep = huge_pte_alloc(mm, haddr, huge_page_size(h));
+	ptep = huge_pte_alloc(mm, vma, haddr, huge_page_size(h));
 	if (!ptep) {
 		i_mmap_unlock_read(mapping);
 		return VM_FAULT_OOM;
@@ -5278,9 +5278,9 @@ void adjust_range_if_pmd_sharing_possibl
  * if !vma_shareable check at the beginning of the routine. i_mmap_rwsem is
  * only required for subsequent processing.
  */
-pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
+pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
+		      unsigned long addr, pud_t *pud)
 {
-	struct vm_area_struct *vma = find_vma(mm, addr);
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	pgoff_t idx = ((addr - vma->vm_start) >> PAGE_SHIFT) +
 			vma->vm_pgoff;
@@ -5358,7 +5358,8 @@ int huge_pmd_unshare(struct mm_struct *m
 }
 #define want_pmd_share()	(1)
 #else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
-pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
+pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct vma,
+		      unsigned long addr, pud_t *pud)
 {
 	return NULL;
 }
@@ -5377,7 +5378,7 @@ void adjust_range_if_pmd_sharing_possibl
 #endif /* CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
 
 #ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
-pte_t *huge_pte_alloc(struct mm_struct *mm,
+pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
@@ -5396,7 +5397,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 		} else {
 			BUG_ON(sz != PMD_SIZE);
 			if (want_pmd_share() && pud_none(*pud))
-				pte = huge_pmd_share(mm, addr, pud);
+				pte = huge_pmd_share(mm, vma, addr, pud);
 			else
 				pte = (pte_t *)pmd_alloc(mm, pud, addr);
 		}
--- a/mm/userfaultfd.c~hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share
+++ a/mm/userfaultfd.c
@@ -290,7 +290,7 @@ retry:
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		err = -ENOMEM;
-		dst_pte = huge_pte_alloc(dst_mm, dst_addr, vma_hpagesize);
+		dst_pte = huge_pte_alloc(dst_mm, dst_vma, dst_addr, vma_hpagesize);
 		if (!dst_pte) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			i_mmap_unlock_read(mapping);
_

Patches currently in -mm which might be from peterx@redhat.com are

hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch

