Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB78C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 21:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiEJVci (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 17:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiEJVch (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 17:32:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5135B3F5
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 14:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0688461129
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 21:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518C2C385CA;
        Tue, 10 May 2022 21:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652218355;
        bh=4vEA1yrOqu8s0soIcbycRCXotE03W53BMqfPdJq+HkI=;
        h=Date:To:From:Subject:From;
        b=HZSc2MV1CGQ+OcCnFNCsyYASdU8AVSBt8ACwiDkN6nqOH3b/87EMfeVOAo6sX01hW
         r9TDYQhf5gg0s6Daax4zlw+N39f0vZw7+35v2vCVb8WUQtStUeNx0Qs+++8hhDU0lw
         0jakO9P2z57qwGiPV5BZNFYSPfORcjzdVbuVTqXs=
Date:   Tue, 10 May 2022 14:32:34 -0700
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        tsbogend@alpha.franken.de, svens@linux.ibm.com,
        songmuchun@bytedance.com, paulus@samba.org, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, James.Bottomley@HansenPartnership.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, deller@gmx.de, davem@davemloft.net,
        dalias@libc.org, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, benh@kernel.crashing.org, arnd@arndb.de,
        agordeev@linux.ibm.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-huge_ptep_clear_flush-to-return-the-original-pte.patch added to mm-unstable branch
Message-Id: <20220510213235.518C2C385CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change huge_ptep_clear_flush() to return the original pte
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-huge_ptep_clear_flush-to-return-the-original-pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-huge_ptep_clear_flush-to-return-the-original-pte.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: change huge_ptep_clear_flush() to return the original pte

Patch series "Fix CONT-PTE/PMD size hugetlb issue when unmapping or migrating", v3.

presently, migrating a hugetlb page or unmapping a poisoned hugetlb page,
we'll use ptep_clear_flush() and set_pte_at() to nuke the page table entry
and remap it, and this is incorrect for CONT-PTE or CONT-PMD size hugetlb
page, which will cause potential data consistent issue.  This patch set
will change to use hugetlb related APIs to fix this issue.

Note: Mike pointed out the huge_ptep_get() will only return the one
specific value, and it would not take into account the dirty or young bits
of CONT-PTE/PMDs like the huge_ptep_get_and_clear() [1].  This
inconsistent issue is not introduced by this patch set, and this issue
will be addressed in another thread [2].  Meanwhile the uffd for hugetlb
case [3] pointed out by Gerald also needs another patch to address.

[1] https://lore.kernel.org/linux-mm/85bd80b4-b4fd-0d3f-a2e5-149559f2f387@oracle.com/
[2] https://lore.kernel.org/all/cover.1651998586.git.baolin.wang@linux.alibaba.com/
[3] https://lore.kernel.org/linux-mm/20220503120343.6264e126@thinkpad/






It is incorrect to use ptep_clear_flush() to nuke a hugetlb page table
when unmapping or migrating a hugetlb page, and will change to use
huge_ptep_clear_flush() instead in the following patches.

So this is a preparation patch, which changes the huge_ptep_clear_flush()
to return the original pte to help to nuke a hugetlb page table.

Link: https://lkml.kernel.org/r/cover.1652147571.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/dcf065868cce35bceaf138613ad27f17bb7c0c19.1652147571.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Cc: Rich Felker <dalias@libc.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/hugetlb.h   |    4 ++--
 arch/arm64/mm/hugetlbpage.c        |   12 +++++-------
 arch/ia64/include/asm/hugetlb.h    |    4 ++--
 arch/mips/include/asm/hugetlb.h    |    9 ++++++---
 arch/parisc/include/asm/hugetlb.h  |    4 ++--
 arch/powerpc/include/asm/hugetlb.h |    9 ++++++---
 arch/s390/include/asm/hugetlb.h    |    6 +++---
 arch/sh/include/asm/hugetlb.h      |    4 ++--
 arch/sparc/include/asm/hugetlb.h   |    4 ++--
 include/asm-generic/hugetlb.h      |    4 ++--
 10 files changed, 32 insertions(+), 28 deletions(-)

--- a/arch/arm64/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -39,8 +39,8 @@ extern pte_t huge_ptep_get_and_clear(str
 extern void huge_ptep_set_wrprotect(struct mm_struct *mm,
 				    unsigned long addr, pte_t *ptep);
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
-extern void huge_ptep_clear_flush(struct vm_area_struct *vma,
-				  unsigned long addr, pte_t *ptep);
+extern pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
+				   unsigned long addr, pte_t *ptep);
 #define __HAVE_ARCH_HUGE_PTE_CLEAR
 extern void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
 			   pte_t *ptep, unsigned long sz);
--- a/arch/arm64/mm/hugetlbpage.c~mm-change-huge_ptep_clear_flush-to-return-the-original-pte
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -486,19 +486,17 @@ void huge_ptep_set_wrprotect(struct mm_s
 		set_pte_at(mm, addr, ptep, pfn_pte(pfn, hugeprot));
 }
 
-void huge_ptep_clear_flush(struct vm_area_struct *vma,
-			   unsigned long addr, pte_t *ptep)
+pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
+			    unsigned long addr, pte_t *ptep)
 {
 	size_t pgsize;
 	int ncontig;
 
-	if (!pte_cont(READ_ONCE(*ptep))) {
-		ptep_clear_flush(vma, addr, ptep);
-		return;
-	}
+	if (!pte_cont(READ_ONCE(*ptep)))
+		return ptep_clear_flush(vma, addr, ptep);
 
 	ncontig = find_num_contig(vma->vm_mm, addr, ptep, &pgsize);
-	clear_flush(vma->vm_mm, addr, ptep, pgsize, ncontig);
+	return get_clear_flush(vma->vm_mm, addr, ptep, pgsize, ncontig);
 }
 
 static int __init hugetlbpage_init(void)
--- a/arch/ia64/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte
+++ a/arch/ia64/include/asm/hugetlb.h
@@ -23,8 +23,8 @@ static inline int is_hugepage_only_range
 #define is_hugepage_only_range is_hugepage_only_range
 
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
-static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
-					 unsigned long addr, pte_t *ptep)
+static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep)
 {
 }
 
--- a/arch/mips/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte
+++ a/arch/mips/include/asm/hugetlb.h
@@ -43,16 +43,19 @@ static inline pte_t huge_ptep_get_and_cl
 }
 
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
-static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
-					 unsigned long addr, pte_t *ptep)
+static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep)
 {
+	pte_t pte;
+
 	/*
 	 * clear the huge pte entry firstly, so that the other smp threads will
 	 * not get old pte entry after finishing flush_tlb_page and before
 	 * setting new huge pte entry
 	 */
-	huge_ptep_get_and_clear(vma->vm_mm, addr, ptep);
+	pte = huge_ptep_get_and_clear(vma->vm_mm, addr, ptep);
 	flush_tlb_page(vma, addr);
+	return pte;
 }
 
 #define __HAVE_ARCH_HUGE_PTE_NONE
--- a/arch/parisc/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte
+++ a/arch/parisc/include/asm/hugetlb.h
@@ -28,8 +28,8 @@ static inline int prepare_hugepage_range
 }
 
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
-static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
-					 unsigned long addr, pte_t *ptep)
+static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep)
 {
 }
 
--- a/arch/powerpc/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte
+++ a/arch/powerpc/include/asm/hugetlb.h
@@ -43,11 +43,14 @@ static inline pte_t huge_ptep_get_and_cl
 }
 
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
-static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
-					 unsigned long addr, pte_t *ptep)
+static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep)
 {
-	huge_ptep_get_and_clear(vma->vm_mm, addr, ptep);
+	pte_t pte;
+
+	pte = huge_ptep_get_and_clear(vma->vm_mm, addr, ptep);
 	flush_hugetlb_page(vma, addr);
+	return pte;
 }
 
 #define __HAVE_ARCH_HUGE_PTEP_SET_ACCESS_FLAGS
--- a/arch/s390/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte
+++ a/arch/s390/include/asm/hugetlb.h
@@ -50,10 +50,10 @@ static inline void huge_pte_clear(struct
 		set_pte(ptep, __pte(_SEGMENT_ENTRY_EMPTY));
 }
 
-static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
-					 unsigned long address, pte_t *ptep)
+static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
+					  unsigned long address, pte_t *ptep)
 {
-	huge_ptep_get_and_clear(vma->vm_mm, address, ptep);
+	return huge_ptep_get_and_clear(vma->vm_mm, address, ptep);
 }
 
 static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
--- a/arch/sh/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte
+++ a/arch/sh/include/asm/hugetlb.h
@@ -21,8 +21,8 @@ static inline int prepare_hugepage_range
 }
 
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
-static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
-					 unsigned long addr, pte_t *ptep)
+static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep)
 {
 }
 
--- a/arch/sparc/include/asm/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte
+++ a/arch/sparc/include/asm/hugetlb.h
@@ -21,8 +21,8 @@ pte_t huge_ptep_get_and_clear(struct mm_
 			      pte_t *ptep);
 
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
-static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
-					 unsigned long addr, pte_t *ptep)
+static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep)
 {
 }
 
--- a/include/asm-generic/hugetlb.h~mm-change-huge_ptep_clear_flush-to-return-the-original-pte
+++ a/include/asm-generic/hugetlb.h
@@ -84,10 +84,10 @@ static inline pte_t huge_ptep_get_and_cl
 #endif
 
 #ifndef __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
-static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep)
 {
-	ptep_clear_flush(vma, addr, ptep);
+	return ptep_clear_flush(vma, addr, ptep);
 }
 #endif
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-change-huge_ptep_clear_flush-to-return-the-original-pte.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping.patch

