Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F22C47095
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0DF461090
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhFGWix (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhFGWiw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 18:38:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9594761090;
        Mon,  7 Jun 2021 22:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623105409;
        bh=OePmHvn11AIhNy10rT7eMME9YVQcOHjuZ6af+U1CAJs=;
        h=Date:From:To:Subject:From;
        b=UmC6hsWdfXdUCBHeJWD+U65+EYb8u8LuasLkBFzK6AUe/0oH4GHIl7lkT7DrKNi92
         NjJKuRZJXAdh7g88ycn2AbGZ7PGnT0aaAAheaUTLbtLmufJ2oTysxOLh4gdDemkNyp
         PVAZRC427KDz4MnYq4mYlmTmC18kITZBKp61rnqM=
Date:   Mon, 07 Jun 2021 15:36:49 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject:  [to-be-updated]
 =?US-ASCII?Q?powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page?=
 =?US-ASCII?Q?-walk-cache-flush-argument.patch?= removed from -mm tree
Message-ID: <20210607223649.47Rt_ZDox%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm/book3s64: update tlb flush routines to take a page walk cache flush argument
has been removed from the -mm tree.  Its filename was
     powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mm/book3s64: update tlb flush routines to take a page walk cache flush argument

No functional change in this patch

Link: https://lkml.kernel.org/r/20210422054323.150993-6-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/tlbflush-radix.h |   19 +++---
 arch/powerpc/include/asm/book3s/64/tlbflush.h       |   23 ++++++-
 arch/powerpc/mm/book3s64/radix_hugetlbpage.c        |    4 -
 arch/powerpc/mm/book3s64/radix_tlb.c                |   29 +++-------
 4 files changed, 42 insertions(+), 33 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/tlbflush.h~powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument
+++ a/arch/powerpc/include/asm/book3s/64/tlbflush.h
@@ -45,13 +45,30 @@ static inline void tlbiel_all_lpid(bool
 		hash__tlbiel_all(TLB_INVAL_SCOPE_LPID);
 }
 
+static inline void flush_pmd_tlb_pwc_range(struct vm_area_struct *vma,
+					   unsigned long start,
+					   unsigned long end,
+					   bool flush_pwc)
+{
+	if (radix_enabled())
+		return radix__flush_pmd_tlb_range(vma, start, end, flush_pwc);
+	return hash__flush_tlb_range(vma, start, end);
+}
 
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 static inline void flush_pmd_tlb_range(struct vm_area_struct *vma,
 				       unsigned long start, unsigned long end)
 {
+	return flush_pmd_tlb_pwc_range(vma, start, end, false);
+}
+
+static inline void flush_hugetlb_tlb_pwc_range(struct vm_area_struct *vma,
+					       unsigned long start,
+					       unsigned long end,
+					       bool flush_pwc)
+{
 	if (radix_enabled())
-		return radix__flush_pmd_tlb_range(vma, start, end);
+		return radix__flush_hugetlb_tlb_range(vma, start, end, flush_pwc);
 	return hash__flush_tlb_range(vma, start, end);
 }
 
@@ -60,9 +77,7 @@ static inline void flush_hugetlb_tlb_ran
 					   unsigned long start,
 					   unsigned long end)
 {
-	if (radix_enabled())
-		return radix__flush_hugetlb_tlb_range(vma, start, end);
-	return hash__flush_tlb_range(vma, start, end);
+	return flush_hugetlb_tlb_pwc_range(vma, start, end, false);
 }
 
 static inline void flush_tlb_range(struct vm_area_struct *vma,
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h~powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument
+++ a/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h
@@ -56,15 +56,18 @@ static inline void radix__flush_all_lpid
 }
 #endif
 
-extern void radix__flush_hugetlb_tlb_range(struct vm_area_struct *vma,
-					   unsigned long start, unsigned long end);
-extern void radix__flush_tlb_range_psize(struct mm_struct *mm, unsigned long start,
-					 unsigned long end, int psize);
-extern void radix__flush_pmd_tlb_range(struct vm_area_struct *vma,
-				       unsigned long start, unsigned long end);
-extern void radix__flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
+void radix__flush_hugetlb_tlb_range(struct vm_area_struct *vma,
+				    unsigned long start, unsigned long end,
+				    bool flush_pwc);
+void radix__flush_pmd_tlb_range(struct vm_area_struct *vma,
+				unsigned long start, unsigned long end,
+				bool flush_pwc);
+void radix__flush_tlb_pwc_range_psize(struct mm_struct *mm, unsigned long start,
+				      unsigned long end, int psize, bool flush_pwc);
+void radix__flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 			    unsigned long end);
-extern void radix__flush_tlb_kernel_range(unsigned long start, unsigned long end);
+void radix__flush_tlb_kernel_range(unsigned long start, unsigned long end);
+
 
 extern void radix__local_flush_tlb_mm(struct mm_struct *mm);
 extern void radix__local_flush_all_mm(struct mm_struct *mm);
--- a/arch/powerpc/mm/book3s64/radix_hugetlbpage.c~powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument
+++ a/arch/powerpc/mm/book3s64/radix_hugetlbpage.c
@@ -26,13 +26,13 @@ void radix__local_flush_hugetlb_page(str
 }
 
 void radix__flush_hugetlb_tlb_range(struct vm_area_struct *vma, unsigned long start,
-				   unsigned long end)
+				    unsigned long end, bool flush_pwc)
 {
 	int psize;
 	struct hstate *hstate = hstate_file(vma->vm_file);
 
 	psize = hstate_get_psize(hstate);
-	radix__flush_tlb_range_psize(vma->vm_mm, start, end, psize);
+	radix__flush_tlb_pwc_range_psize(vma->vm_mm, start, end, psize, flush_pwc);
 }
 
 /*
--- a/arch/powerpc/mm/book3s64/radix_tlb.c~powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument
+++ a/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -1090,7 +1090,7 @@ void radix__flush_tlb_range(struct vm_ar
 {
 #ifdef CONFIG_HUGETLB_PAGE
 	if (is_vm_hugetlb_page(vma))
-		return radix__flush_hugetlb_tlb_range(vma, start, end);
+		return radix__flush_hugetlb_tlb_range(vma, start, end, false);
 #endif
 
 	__radix__flush_tlb_range(vma->vm_mm, start, end);
@@ -1151,9 +1151,6 @@ void radix__flush_all_lpid_guest(unsigne
 	_tlbie_lpid_guest(lpid, RIC_FLUSH_ALL);
 }
 
-static void radix__flush_tlb_pwc_range_psize(struct mm_struct *mm, unsigned long start,
-				  unsigned long end, int psize);
-
 void radix__tlb_flush(struct mmu_gather *tlb)
 {
 	int psize = 0;
@@ -1177,10 +1174,8 @@ void radix__tlb_flush(struct mmu_gather
 		else
 			radix__flush_all_mm(mm);
 	} else {
-		if (!tlb->freed_tables)
-			radix__flush_tlb_range_psize(mm, start, end, psize);
-		else
-			radix__flush_tlb_pwc_range_psize(mm, start, end, psize);
+		radix__flush_tlb_pwc_range_psize(mm, start,
+						 end, psize, tlb->freed_tables);
 	}
 }
 
@@ -1254,16 +1249,10 @@ out:
 	preempt_enable();
 }
 
-void radix__flush_tlb_range_psize(struct mm_struct *mm, unsigned long start,
-				  unsigned long end, int psize)
+void radix__flush_tlb_pwc_range_psize(struct mm_struct *mm, unsigned long start,
+				      unsigned long end, int psize, bool flush_pwc)
 {
-	return __radix__flush_tlb_range_psize(mm, start, end, psize, false);
-}
-
-static void radix__flush_tlb_pwc_range_psize(struct mm_struct *mm, unsigned long start,
-				  unsigned long end, int psize)
-{
-	__radix__flush_tlb_range_psize(mm, start, end, psize, true);
+	__radix__flush_tlb_range_psize(mm, start, end, psize, flush_pwc);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -1315,9 +1304,11 @@ void radix__flush_tlb_collapsed_pmd(stru
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 void radix__flush_pmd_tlb_range(struct vm_area_struct *vma,
-				unsigned long start, unsigned long end)
+				unsigned long start, unsigned long end,
+				bool flush_pwc)
 {
-	radix__flush_tlb_range_psize(vma->vm_mm, start, end, MMU_PAGE_2M);
+	__radix__flush_tlb_range_psize(vma->vm_mm, start,
+				       end, MMU_PAGE_2M, flush_pwc);
 }
 EXPORT_SYMBOL(radix__flush_pmd_tlb_range);
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch
mm-mremap-move-tlb-flush-outside-page-table-lock.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-mm-enable-move-pmd-pud.patch

