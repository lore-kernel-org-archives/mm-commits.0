Return-Path: <SRS0=9IPz=EN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADBBC2D0A3
	for <mm-commits@archiver.kernel.org>; Sat,  7 Nov 2020 01:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B9F20825
	for <mm-commits@archiver.kernel.org>; Sat,  7 Nov 2020 01:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604712057;
	bh=vU9MsjaYnFBb8zZLzjRphDUhK/3YtAzGOOeIq62zFUQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tcZPycIxpebfIVG8R9/VIL3dDLTaG/9RwjTSUBhUkh+utv+ayVPM5+Jkm4J1h1CRE
	 O8ZwutOx4TqDvCITDU2HM/yGw4l4uYbNeUkvTRIQPy94lT+w80b7Nk+0MSbwlqWxdd
	 iJWLwNU793KqqXuA8Ng2iYmGkiC8enZ+/aYvXv8A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgKGBU5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Nov 2020 20:20:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgKGBU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Nov 2020 20:20:57 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C44E020704;
        Sat,  7 Nov 2020 01:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604712055;
        bh=vU9MsjaYnFBb8zZLzjRphDUhK/3YtAzGOOeIq62zFUQ=;
        h=Date:From:To:Subject:From;
        b=r/riQgbquLKys6ciQxl83FVqxGG/+s6zz8BtYbfRMnHFq5YKAQuxoXR+HNmthM8C2
         jazugqajh/xwNWf0SLxvIni7P/mYN5Gzf1FJ//jbgeNeigFKwLL8X5GUNzA69j3LcV
         vEr8XvkZsdW4ZflFqb1mW9iqvsfvQupCn4y9COVw=
Date:   Fri, 06 Nov 2020 17:20:55 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com
Subject:  + include-linux-huge_mmh-remove-extern-keyword.patch
 added to -mm tree
Message-ID: <20201107012055.TO64KSZWR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/huge_mm.h: remove extern keyword
has been added to the -mm tree.  Its filename is
     include-linux-huge_mmh-remove-extern-keyword.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-linux-huge_mmh-remove-extern-keyword.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-huge_mmh-remove-extern-keyword.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: include/linux/huge_mm.h: remove extern keyword

The external function definitions don't need the "extern" keyword.  Remove
them so future changes don't copy the function definition style.

Link: https://lkml.kernel.org/r/20201106235135.32109-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
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

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-handle-zone-device-pages-in-release_pages.patch
include-linux-huge_mmh-remove-extern-keyword.patch
mm-optimize-migrate_vma_pages-mmu-notifier.patch

