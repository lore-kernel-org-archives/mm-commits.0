Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5D0E7D0A1
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 00:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjIVAgd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 20:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjIVAgW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 20:36:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011C9CD0
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 17:36:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68340C433C8;
        Fri, 22 Sep 2023 00:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695342973;
        bh=BYW20eqAN6T2xnDPDI12K9v/GIHOYpwE2CP+kqpkqHQ=;
        h=Date:To:From:Subject:From;
        b=dA4ZiQDN0z+lGX9Zoctz7hlWQYOZ4+MZsqVA1XBJ/EAfCJrfZIlyZ9ipGWNxbEFLj
         n/thAORCx7Fnzx8xwy6e9y5EosdDrQTKQWvwdfpxl9rDLsc1W+ZxlpPO4LfFdkj1Vg
         snsLQyDLXF+OMSDlN6KeEjffAKHiggZm7APXwJqo=
Date:   Thu, 21 Sep 2023 17:36:12 -0700
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
Subject: + s390-hugetlb-convert-set_huge_pte_at-to-take-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20230922003613.68340C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390: hugetlb: convert set_huge_pte_at() to take vma
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     s390-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

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
Subject: s390: hugetlb: convert set_huge_pte_at() to take vma
Date: Thu, 21 Sep 2023 17:20:03 +0100

In order to fix a bug, arm64 needs access to the vma inside it's
implementation of set_huge_pte_at(). Provide for this by converting the
mm parameter to be a vma. Any implementations that require the mm can
access it via vma->vm_mm.

This commit makes the required s390 modifications. Separate commits
update the other arches and core code, before the actual bug is fixed in
arm64.

No behavioral changes intended.

Link: https://lkml.kernel.org/r/20230921162007.1630149-5-ryan.roberts@arm.com
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

 arch/s390/include/asm/hugetlb.h |    8 +++++---
 arch/s390/mm/hugetlbpage.c      |    8 +++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/arch/s390/include/asm/hugetlb.h~s390-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/s390/include/asm/hugetlb.h
@@ -15,7 +15,9 @@
 #define hugetlb_free_pgd_range			free_pgd_range
 #define hugepages_supported()			(MACHINE_HAS_EDAT1)
 
-void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
+void set_huge_pte_at(struct vm_area_struct *vma, unsigned long addr,
+		     pte_t *ptep, pte_t pte);
+void __set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t pte);
 pte_t huge_ptep_get(pte_t *ptep);
 pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
@@ -65,7 +67,7 @@ static inline int huge_ptep_set_access_f
 	int changed = !pte_same(huge_ptep_get(ptep), pte);
 	if (changed) {
 		huge_ptep_get_and_clear(vma->vm_mm, addr, ptep);
-		set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
+		__set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
 	}
 	return changed;
 }
@@ -74,7 +76,7 @@ static inline void huge_ptep_set_wrprote
 					   unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = huge_ptep_get_and_clear(mm, addr, ptep);
-	set_huge_pte_at(mm, addr, ptep, pte_wrprotect(pte));
+	__set_huge_pte_at(mm, addr, ptep, pte_wrprotect(pte));
 }
 
 static inline pte_t mk_huge_pte(struct page *page, pgprot_t pgprot)
--- a/arch/s390/mm/hugetlbpage.c~s390-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/s390/mm/hugetlbpage.c
@@ -142,7 +142,7 @@ static void clear_huge_pte_skeys(struct
 		__storage_key_init_range(paddr, paddr + size - 1);
 }
 
-void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
+void __set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t pte)
 {
 	unsigned long rste;
@@ -163,6 +163,12 @@ void set_huge_pte_at(struct mm_struct *m
 	set_pte(ptep, __pte(rste));
 }
 
+void set_huge_pte_at(struct vm_area_struct *vma, unsigned long addr,
+		     pte_t *ptep, pte_t pte)
+{
+	__set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
+}
+
 pte_t huge_ptep_get(pte_t *ptep)
 {
 	return __rste_to_pte(pte_val(*ptep));
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

