Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E69E7D0B7
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 00:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjIVAgX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 20:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjIVAgV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 20:36:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBAB1B7
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 17:36:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E726C433C7;
        Fri, 22 Sep 2023 00:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695342971;
        bh=ULutbzYEJSQbkhnEzItjC9ve1hUXFLq5bN6puzkwrdc=;
        h=Date:To:From:Subject:From;
        b=WpbJ9J2E4wMxAt5RA/TjFe9L7KvncAtLD3po6e4BOmDgiEZM5gatXK84JSzPJpxKh
         hxkTEczdalmiYnXs6TfTQWYr6rycUO30KwVwh3nDOf1ZdiUXN47s3tblSovJ8K9SFG
         kmZqfio0bBgXBqKdzMjpgaoJ52dAoegdiKWdWchw=
Date:   Thu, 21 Sep 2023 17:36:10 -0700
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
Subject: + riscv-hugetlb-convert-set_huge_pte_at-to-take-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20230922003611.1E726C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: hugetlb: convert set_huge_pte_at() to take vma
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     riscv-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

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
Subject: riscv: hugetlb: convert set_huge_pte_at() to take vma
Date: Thu, 21 Sep 2023 17:20:02 +0100

In order to fix a bug, arm64 needs access to the vma inside it's
implementation of set_huge_pte_at(). Provide for this by converting the
mm parameter to be a vma. Any implementations that require the mm can
access it via vma->vm_mm.

This commit makes the required riscv modifications. Separate commits
update the other arches and core code, before the actual bug is fixed in
arm64.

No behavioral changes intended.

Link: https://lkml.kernel.org/r/20230921162007.1630149-4-ryan.roberts@arm.com
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

 arch/riscv/include/asm/hugetlb.h |    2 +-
 arch/riscv/mm/hugetlbpage.c      |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/hugetlb.h~riscv-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/riscv/include/asm/hugetlb.h
@@ -17,7 +17,7 @@ void huge_pte_clear(struct mm_struct *mm
 		    pte_t *ptep, unsigned long sz);
 
 #define __HAVE_ARCH_HUGE_SET_HUGE_PTE_AT
-void set_huge_pte_at(struct mm_struct *mm,
+void set_huge_pte_at(struct vm_area_struct *vma,
 		     unsigned long addr, pte_t *ptep, pte_t pte);
 
 #define __HAVE_ARCH_HUGE_PTEP_GET_AND_CLEAR
--- a/arch/riscv/mm/hugetlbpage.c~riscv-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/riscv/mm/hugetlbpage.c
@@ -177,11 +177,12 @@ pte_t arch_make_huge_pte(pte_t entry, un
 	return entry;
 }
 
-void set_huge_pte_at(struct mm_struct *mm,
+void set_huge_pte_at(struct vm_area_struct *vma,
 		     unsigned long addr,
 		     pte_t *ptep,
 		     pte_t pte)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	int i, pte_num;
 
 	if (!pte_napot(pte)) {
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

