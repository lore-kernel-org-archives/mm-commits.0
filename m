Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6FCE7D0B8
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 00:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjIVAgX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 20:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjIVAgV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 20:36:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938631AA
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 17:36:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB0FC433D9;
        Fri, 22 Sep 2023 00:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695342968;
        bh=Mp9aj+wOGt/ZCAsbxx3F9Urx9MySYaMEjpnIfhX1uZo=;
        h=Date:To:From:Subject:From;
        b=jGlm7NKNtpXDUTDYML9pKjyyqkklrx3zfrplMILWlZg247KqfeB8GZncBFVIa5Xc3
         jpzPOrTZ9q+IKjKXMnztAaFMNhc91CtewZ/PB9D3sKZY/MIZfqRkYn8U7NBzeWtb08
         0895xpcQU2I3LnnN6eNdQFn3xBOdyNsJtS3cEepY=
Date:   Thu, 21 Sep 2023 17:36:07 -0700
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
Subject: + powerpc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20230922003607.ECB0FC433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: hugetlb: convert set_huge_pte_at() to take vma
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     powerpc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

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
Subject: powerpc: hugetlb: convert set_huge_pte_at() to take vma
Date: Thu, 21 Sep 2023 17:20:01 +0100

In order to fix a bug, arm64 needs access to the vma inside it's
implementation of set_huge_pte_at().  Provide for this by converting the
mm parameter to be a vma.  Any implementations that require the mm can
access it via vma->vm_mm.

This commit makes the required powerpc modifications. Separate commits
update the other arches and core code, before the actual bug is fixed in
arm64.

No behavioral changes intended.

Link: https://lkml.kernel.org/r/20230921162007.1630149-3-ryan.roberts@arm.com
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

 arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h |    3 ++-
 arch/powerpc/mm/book3s64/hugetlbpage.c           |    2 +-
 arch/powerpc/mm/book3s64/radix_hugetlbpage.c     |    2 +-
 arch/powerpc/mm/nohash/8xx.c                     |    2 +-
 arch/powerpc/mm/pgtable.c                        |    7 ++++++-
 5 files changed, 11 insertions(+), 5 deletions(-)

--- a/arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h~powerpc-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h
@@ -46,7 +46,8 @@ static inline int check_and_get_huge_psi
 }
 
 #define __HAVE_ARCH_HUGE_SET_HUGE_PTE_AT
-void set_huge_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte);
+void set_huge_pte_at(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep, pte_t pte);
+void __set_huge_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte);
 
 #define __HAVE_ARCH_HUGE_PTE_CLEAR
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
--- a/arch/powerpc/mm/book3s64/hugetlbpage.c~powerpc-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/powerpc/mm/book3s64/hugetlbpage.c
@@ -147,7 +147,7 @@ void huge_ptep_modify_prot_commit(struct
 	if (radix_enabled())
 		return radix__huge_ptep_modify_prot_commit(vma, addr, ptep,
 							   old_pte, pte);
-	set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
+	set_huge_pte_at(vma, addr, ptep, pte);
 }
 
 void __init hugetlbpage_init_defaultsize(void)
--- a/arch/powerpc/mm/book3s64/radix_hugetlbpage.c~powerpc-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/powerpc/mm/book3s64/radix_hugetlbpage.c
@@ -58,5 +58,5 @@ void radix__huge_ptep_modify_prot_commit
 	    atomic_read(&mm->context.copros) > 0)
 		radix__flush_hugetlb_page(vma, addr);
 
-	set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
+	set_huge_pte_at(vma, addr, ptep, pte);
 }
--- a/arch/powerpc/mm/nohash/8xx.c~powerpc-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/powerpc/mm/nohash/8xx.c
@@ -91,7 +91,7 @@ static int __ref __early_map_kernel_huge
 	if (new && WARN_ON(pte_present(*ptep) && pgprot_val(prot)))
 		return -EINVAL;
 
-	set_huge_pte_at(&init_mm, va, ptep, pte_mkhuge(pfn_pte(pa >> PAGE_SHIFT, prot)));
+	__set_huge_pte_at(&init_mm, va, ptep, pte_mkhuge(pfn_pte(pa >> PAGE_SHIFT, prot)));
 
 	return 0;
 }
--- a/arch/powerpc/mm/pgtable.c~powerpc-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/powerpc/mm/pgtable.c
@@ -288,7 +288,7 @@ int huge_ptep_set_access_flags(struct vm
 }
 
 #if defined(CONFIG_PPC_8xx)
-void set_huge_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
+void __set_huge_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
 {
 	pmd_t *pmd = pmd_off(mm, addr);
 	pte_basic_t val;
@@ -310,6 +310,11 @@ void set_huge_pte_at(struct mm_struct *m
 	for (i = 0; i < num; i++, entry++, val += SZ_4K)
 		*entry = val;
 }
+
+void set_huge_pte_at(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep, pte_t pte)
+{
+	__set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
+}
 #endif
 #endif /* CONFIG_HUGETLB_PAGE */
 
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

