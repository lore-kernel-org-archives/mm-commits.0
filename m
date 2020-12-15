Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F71C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EF47224BE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgLODNJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727665AbgLODNA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:00 -0500
Date:   Mon, 14 Dec 2020 19:11:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001919;
        bh=otcxKPB0NoZnYRF+CgGc7O7hJyRB5E7aO7OJFDMfo2M=;
        h=From:To:Subject:In-Reply-To:From;
        b=xLsrqddRkESAm5iLSFApDN3P18wjKPYsivEr0y7dS3yaKOhS1ZzPMDB7L0yeRiZwx
         Jj0/geoyDaLH8I0BuMpXtFI+9+1ZQqu7JNGAIkku8KSqigcZz3OJCK509U/ycDtyij
         zBwUnWEZ2Pi63Fe5njHiBhjMFl6Myxdbs6lZ4H9w=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        torvalds@linux-foundation.org
Subject:  [patch 147/200] include/linux/huge_mm.h: remove extern
 keyword
Message-ID: <20201215031158.yAkSqa_u4%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: include/linux/huge_mm.h: remove extern keyword

The external function definitions don't need the "extern" keyword.  Remove
them so future changes don't copy the function definition style.

Link: https://lkml.kernel.org/r/20201106235135.32109-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   93 ++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 52 deletions(-)

--- a/include/linux/huge_mm.h~include-linux-huge_mmh-remove-extern-keyword
+++ a/include/linux/huge_mm.h
@@ -7,43 +7,37 @@
 
 #include <linux/fs.h> /* only for vma_is_dax() */
 
-extern vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
-extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-			 struct vm_area_struct *vma);
-extern void huge_pmd_set_accessed(struct vm_fault *vmf, pmd_t orig_pmd);
-extern int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-			 pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-			 struct vm_area_struct *vma);
+vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
+int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
+		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
+		  struct vm_area_struct *vma);
+void huge_pmd_set_accessed(struct vm_fault *vmf, pmd_t orig_pmd);
+int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
+		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
+		  struct vm_area_struct *vma);
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-extern void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
+void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
 #else
 static inline void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 {
 }
 #endif
 
-extern vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd);
-extern struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
-					  unsigned long addr,
-					  pmd_t *pmd,
-					  unsigned int flags);
-extern bool madvise_free_huge_pmd(struct mmu_gather *tlb,
-			struct vm_area_struct *vma,
-			pmd_t *pmd, unsigned long addr, unsigned long next);
-extern int zap_huge_pmd(struct mmu_gather *tlb,
-			struct vm_area_struct *vma,
-			pmd_t *pmd, unsigned long addr);
-extern int zap_huge_pud(struct mmu_gather *tlb,
-			struct vm_area_struct *vma,
-			pud_t *pud, unsigned long addr);
-extern bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
-			 unsigned long new_addr,
-			 pmd_t *old_pmd, pmd_t *new_pmd);
-extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, pgprot_t newprot,
-			unsigned long cp_flags);
+vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd);
+struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
+				   unsigned long addr, pmd_t *pmd,
+				   unsigned int flags);
+bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+			   pmd_t *pmd, unsigned long addr, unsigned long next);
+int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
+		 unsigned long addr);
+int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma, pud_t *pud,
+		 unsigned long addr);
+bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
+		   unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd);
+int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
+		    pgprot_t newprot, unsigned long cp_flags);
 vm_fault_t vmf_insert_pfn_pmd_prot(struct vm_fault *vmf, pfn_t pfn,
 				   pgprot_t pgprot, bool write);
 
@@ -100,13 +94,13 @@ enum transparent_hugepage_flag {
 struct kobject;
 struct kobj_attribute;
 
-extern ssize_t single_hugepage_flag_store(struct kobject *kobj,
-				 struct kobj_attribute *attr,
-				 const char *buf, size_t count,
-				 enum transparent_hugepage_flag flag);
-extern ssize_t single_hugepage_flag_show(struct kobject *kobj,
-				struct kobj_attribute *attr, char *buf,
-				enum transparent_hugepage_flag flag);
+ssize_t single_hugepage_flag_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count,
+				   enum transparent_hugepage_flag flag);
+ssize_t single_hugepage_flag_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf,
+				  enum transparent_hugepage_flag flag);
 extern struct kobj_attribute shmem_enabled_attr;
 
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
@@ -179,12 +173,11 @@ static inline bool transhuge_vma_suitabl
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
 
-extern unsigned long thp_get_unmapped_area(struct file *filp,
-		unsigned long addr, unsigned long len, unsigned long pgoff,
-		unsigned long flags);
+unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags);
 
-extern void prep_transhuge_page(struct page *page);
-extern void free_transhuge_page(struct page *page);
+void prep_transhuge_page(struct page *page);
+void free_transhuge_page(struct page *page);
 bool is_transparent_hugepage(struct page *page);
 
 bool can_split_huge_page(struct page *page, int *pextra_pins);
@@ -222,16 +215,12 @@ void __split_huge_pud(struct vm_area_str
 			__split_huge_pud(__vma, __pud, __address);	\
 	}  while (0)
 
-extern int hugepage_madvise(struct vm_area_struct *vma,
-			    unsigned long *vm_flags, int advice);
-extern void vma_adjust_trans_huge(struct vm_area_struct *vma,
-				    unsigned long start,
-				    unsigned long end,
-				    long adjust_next);
-extern spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd,
-		struct vm_area_struct *vma);
-extern spinlock_t *__pud_trans_huge_lock(pud_t *pud,
-		struct vm_area_struct *vma);
+int hugepage_madvise(struct vm_area_struct *vma, unsigned long *vm_flags,
+		     int advice);
+void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
+			   unsigned long end, long adjust_next);
+spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
+spinlock_t *__pud_trans_huge_lock(pud_t *pud, struct vm_area_struct *vma);
 
 static inline int is_swap_pmd(pmd_t pmd)
 {
@@ -294,7 +283,7 @@ struct page *follow_devmap_pmd(struct vm
 struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t *pud, int flags, struct dev_pagemap **pgmap);
 
-extern vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd);
+vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd);
 
 extern struct page *huge_zero_page;
 
_
