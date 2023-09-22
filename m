Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0F2E7D0A1
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 00:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjIVAgj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 20:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjIVAgY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 20:36:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A7919E
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 17:36:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D063CC433BB;
        Fri, 22 Sep 2023 00:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695342975;
        bh=mVWy56GDiUF7MbuwQaMlfdVZ3gqJOUHDp7pntcfUx3A=;
        h=Date:To:From:Subject:From;
        b=SLHYGWJzJ1Xow1xhKCea0C5bF7roO5q6/abrimGiu6130iA1NTjOlxQ1URvyjUGBW
         4a7HY7ziuu6ANh/rhS/D9ufT98pHqva3SOLHcsNZRQ7eoXRjpkXx+/8hd30UGstu5C
         y4nuioNqRc2txBTesoghqTuPo6xvpEQ7wOnOAMVM=
Date:   Thu, 21 Sep 2023 17:36:15 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        will@kernel.org, urezki@gmail.com, svens@linux.ibm.com,
        sj@kernel.org, peterx@redhat.com, paul.walmsley@sifive.com,
        palmer@dabbelt.com, npiggin@gmail.com, muchun.song@linux.dev,
        mike.kravetz@oracle.com, lstoakes@gmail.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, deller@gmx.de, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, axelrasmussen@google.com, arnd@arndb.de,
        aou@eecs.berkeley.edu, anshuman.khandual@arm.com,
        agordeev@linux.ibm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20230922003615.D063CC433BB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: hugetlb: convert set_huge_pte_at() to take vma
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     sparc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: sparc: hugetlb: convert set_huge_pte_at() to take vma
Date: Thu, 21 Sep 2023 17:20:04 +0100

In order to fix a bug, arm64 needs access to the vma inside it's
implementation of set_huge_pte_at(). Provide for this by converting the
mm parameter to be a vma. Any implementations that require the mm can
access it via vma->vm_mm.

This commit makes the required sparc modifications. Separate commits
update the other arches and core code, before the actual bug is fixed in
arm64.

No behavioral changes intended.

Link: https://lkml.kernel.org/r/20230921162007.1630149-6-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/hugetlb.h |    8 +++++---
 arch/sparc/mm/hugetlbpage.c      |    8 +++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/arch/sparc/include/asm/hugetlb.h~sparc-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/sparc/include/asm/hugetlb.h
@@ -13,7 +13,9 @@ extern struct pud_huge_patch_entry __pud
 #endif
 
 #define __HAVE_ARCH_HUGE_SET_HUGE_PTE_AT
-void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
+void set_huge_pte_at(struct vm_area_struct *vma, unsigned long addr,
+		     pte_t *ptep, pte_t pte);
+void __set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t pte);
 
 #define __HAVE_ARCH_HUGE_PTEP_GET_AND_CLEAR
@@ -32,7 +34,7 @@ static inline void huge_ptep_set_wrprote
 					   unsigned long addr, pte_t *ptep)
 {
 	pte_t old_pte = *ptep;
-	set_huge_pte_at(mm, addr, ptep, pte_wrprotect(old_pte));
+	__set_huge_pte_at(mm, addr, ptep, pte_wrprotect(old_pte));
 }
 
 #define __HAVE_ARCH_HUGE_PTEP_SET_ACCESS_FLAGS
@@ -42,7 +44,7 @@ static inline int huge_ptep_set_access_f
 {
 	int changed = !pte_same(*ptep, pte);
 	if (changed) {
-		set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
+		__set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
 		flush_tlb_page(vma, addr);
 	}
 	return changed;
--- a/arch/sparc/mm/hugetlbpage.c~sparc-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -328,7 +328,7 @@ pte_t *huge_pte_offset(struct mm_struct
 	return pte_offset_huge(pmd, addr);
 }
 
-void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
+void __set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t entry)
 {
 	unsigned int nptes, orig_shift, shift;
@@ -364,6 +364,12 @@ void set_huge_pte_at(struct mm_struct *m
 				    orig_shift);
 }
 
+void set_huge_pte_at(struct vm_area_struct *vma, unsigned long addr,
+		     pte_t *ptep, pte_t entry)
+{
+	__set_huge_pte_at(vma->vm_mm, addr, ptep, entry);
+}
+
 pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep)
 {
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

parisc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
powerpc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
riscv-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
s390-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
sparc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
mm-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
arm64-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch

