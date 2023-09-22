Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4568E7D0A1
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 00:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjIVAgV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 20:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjIVAgU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 20:36:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139D319A
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 17:36:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B4EC433C8;
        Fri, 22 Sep 2023 00:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695342965;
        bh=XtXlsX+hj7shHuU0ttrUaIJY+e+2upZSECjZQUOa6Rk=;
        h=Date:To:From:Subject:From;
        b=qsa6+budAoyXJhBT5t8zmd1JYINmteVPxzrR270gcFMeondrKuT2dM7RQ6OCA4v3j
         wLiCeamTvCDFPrvFPa5DhZxW0uDN55JKFoUy2r79ifaWRSq3d5MxPgbaqiZARhZmoR
         Xmdb8hIDgm2hhVygWyGvDvLgmdVf4J7k8M06R18o=
Date:   Thu, 21 Sep 2023 17:36:04 -0700
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
Subject: + parisc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20230922003605.88B4EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: hugetlb: convert set_huge_pte_at() to take vma
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     parisc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/parisc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

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
Subject: parisc: hugetlb: convert set_huge_pte_at() to take vma
Date: Thu, 21 Sep 2023 17:20:00 +0100

Patch series "Fix set_huge_pte_at() panic on arm64".

This series fixes a bug in arm64's implementation of set_huge_pte_at(),
which can result in an unprivileged user causing a kernel panic.  The
problem was triggered when running the new uffd poison mm selftest for
HUGETLB memory.  This test (and the uffd poison feature) was merged for
v6.6-rc1.  However, upon inspection there are multiple other pre-existing
paths that can trigger this bug.

Ideally, I'd like to get this fix in for v6.6 if possible?  And I guess it
should be backported too, given there are call sites where this can
theoretically happen that pre-date v6.6-rc1 (I've cc'ed
stable@vger.kernel.org).


Description of Bug
------------------

arm64's huge pte implementation supports multiple huge page sizes, some of
which are implemented in the page table with contiguous mappings.  So
set_huge_pte_at() needs to work out how big the logical pte is, so that it
can also work out how many physical ptes (or pmds) need to be written.  It
does this by grabbing the folio out of the pte and querying its size.

However, there are cases when the pte being set is actually a swap entry. 
But this also used to work fine, because for huge ptes, we only ever saw
migration entries and hwpoison entries.  And both of these types of swap
entries have a PFN embedded, so the code would grab that and everything
still worked out.

But over time, more calls to set_huge_pte_at() have been added that set
swap entry types that do not embed a PFN.  And this causes the code to go
bang.  The triggering case is for the uffd poison test, commit
99aa77215ad0 ("selftests/mm: add uffd unit test for UFFDIO_POISON"), which
sets a PTE_MARKER_POISONED swap entry.  But review shows there are other
places too (PTE_MARKER_UFFD_WP).

If CONFIG_DEBUG_VM is enabled, we do at least get a BUG(), but otherwise,
it will dereference a bad pointer in page_folio():

    static inline struct folio *hugetlb_swap_entry_to_folio(swp_entry_t entry)
    {
        VM_BUG_ON(!is_migration_entry(entry) && !is_hwpoison_entry(entry));

        return page_folio(pfn_to_page(swp_offset_pfn(entry)));
    }

So the root cause is due to commit 18f3962953e4 ("mm: hugetlb: kill
set_huge_swap_pte_at()"), which aimed to simplify the interface to the
core code by removing set_huge_swap_pte_at() (which took a page size
parameter) and replacing it with calls to set_huge_swap_pte_at() where the
size was inferred from the folio, as descibed above.  While that commit
didn't break anything at the time, it did break the interface because it
couldn't handle swap entries without PFNs.  And since then new callers
have come along which rely on this working.


Fix
---

The simplest fix would have been to revert the dodgy cleanup commit, but
since things have moved on, this would have required an audit of all the
new set_huge_pte_at() call sites to see if they should be converted to
set_huge_swap_pte_at().  As per the original intent of the change, it
would also leave us open to future bugs when people invariably get it
wrong and call the wrong helper.

So instead, I've converted the first parameter of set_huge_pte_at() to be
a vma rather than an mm.  This means that the arm64 code can easily
recover the huge page size in all cases.  It's a bigger change, due to
needing to touch the arches that implement the function, but it is
entirely mechanical, so in my view, low risk.

I've compile-tested all touched arches; arm64, parisc, powerpc, riscv,
s390 (and additionally x86_64).  I've additionally booted and run mm
selftests against arm64, where I observe the uffd poison test is fixed,
and there are no other regressions.


This patch (of 8):

In order to fix a bug, arm64 needs access to the vma inside it's
implementation of set_huge_pte_at().  Provide for this by converting the
mm parameter to be a vma.  Any implementations that require the mm can
access it via vma->vm_mm.

This commit makes the required parisc modifications. Separate commits
update the other arches and core code, before the actual bug is fixed in
arm64.

No behavioral changes intended.

Link: https://lkml.kernel.org/r/20230921162007.1630149-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20230921162007.1630149-2-ryan.roberts@arm.com
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

 arch/parisc/include/asm/hugetlb.h |    2 +-
 arch/parisc/mm/hugetlbpage.c      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/parisc/include/asm/hugetlb.h~parisc-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/parisc/include/asm/hugetlb.h
@@ -5,7 +5,7 @@
 #include <asm/page.h>
 
 #define __HAVE_ARCH_HUGE_SET_HUGE_PTE_AT
-void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
+void set_huge_pte_at(struct vm_area_struct *vma, unsigned long addr,
 		     pte_t *ptep, pte_t pte);
 
 #define __HAVE_ARCH_HUGE_PTEP_GET_AND_CLEAR
--- a/arch/parisc/mm/hugetlbpage.c~parisc-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/arch/parisc/mm/hugetlbpage.c
@@ -139,10 +139,10 @@ static void __set_huge_pte_at(struct mm_
 	purge_tlb_entries_huge(mm, addr_start);
 }
 
-void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
+void set_huge_pte_at(struct vm_area_struct *vma, unsigned long addr,
 		     pte_t *ptep, pte_t entry)
 {
-	__set_huge_pte_at(mm, addr, ptep, entry);
+	__set_huge_pte_at(vma->vm_mm, addr, ptep, entry);
 }
 
 
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

