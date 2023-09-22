Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A0FE7D0B8
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 00:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjIVAgy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 20:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjIVAgl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 20:36:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF00E65
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 17:36:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF92C433C8;
        Fri, 22 Sep 2023 00:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695342984;
        bh=X5DP+3XfZsvaRjmkUdUyX7fPIYUuWF54ibgKAQDVvSo=;
        h=Date:To:From:Subject:From;
        b=u6KbxervPGXcnfZ6ReIOf3NBsYPVBFpPgZsO2pel+bEyDG0hnKP8GCXFi1qLzNh7P
         4KsNfxbCQ6lszxQqRgcpKSkJHilP6nHZxlw7BLQyiAGjrqFODGUo+l5m4/Wir1tF/c
         lt2m4DpJLFqAdeLWTjlwMkoTqowsBYC/azYzkkwQ=
Date:   Thu, 21 Sep 2023 17:36:23 -0700
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
Subject: + arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch added to mm-hotfixes-unstable branch
Message-Id: <20230922003624.6AF92C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: hugetlb: fix set_huge_pte_at() to work with all swap entries
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch

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
Subject: arm64: hugetlb: fix set_huge_pte_at() to work with all swap entries
Date: Thu, 21 Sep 2023 17:20:07 +0100

When called with a swap entry that does not embed a PFN (e.g. 
PTE_MARKER_POISONED or PTE_MARKER_UFFD_WP), the previous implementation of
set_huge_pte_at() would either cause a BUG() to fire (if CONFIG_DEBUG_VM
is enabled) or cause a dereference of an invalid address and subsequent
panic.

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

So the root cause is due to commit 18f3962953e4 ("mm: hugetlb: kill
set_huge_swap_pte_at()"), which aimed to simplify the interface to the
core code by removing set_huge_swap_pte_at() (which took a page size
parameter) and replacing it with calls to set_huge_swap_pte_at() where the
size was inferred from the folio, as descibed above.  While that commit
didn't break anything at the time, it did break the interface because it
couldn't handle swap entries without PFNs.  And since then new callers
have come along which rely on this working.

Now that we have modified the set_huge_pte_at() interface to pass the vma,
we can extract the huge page size from it and fix this issue.

I'm tagging the commit that added the uffd poison feature, since that is
what exposed the problem, as well as the original change that broke the
interface.  Hopefully this is valuable for people doing bisect.

Link: https://lkml.kernel.org/r/20230921162007.1630149-9-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Fixes: 18f3962953e4 ("mm: hugetlb: kill set_huge_swap_pte_at()")
Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
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

 arch/arm64/mm/hugetlbpage.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -241,13 +241,6 @@ static void clear_flush(struct mm_struct
 	flush_tlb_range(&vma, saddr, addr);
 }
 
-static inline struct folio *hugetlb_swap_entry_to_folio(swp_entry_t entry)
-{
-	VM_BUG_ON(!is_migration_entry(entry) && !is_hwpoison_entry(entry));
-
-	return page_folio(pfn_to_page(swp_offset_pfn(entry)));
-}
-
 void set_huge_pte_at(struct vm_area_struct *vma, unsigned long addr,
 			    pte_t *ptep, pte_t pte)
 {
@@ -258,13 +251,10 @@ void set_huge_pte_at(struct vm_area_stru
 	unsigned long pfn, dpfn;
 	pgprot_t hugeprot;
 
-	if (!pte_present(pte)) {
-		struct folio *folio;
-
-		folio = hugetlb_swap_entry_to_folio(pte_to_swp_entry(pte));
-		ncontig = num_contig_ptes(folio_size(folio), &pgsize);
+	ncontig = num_contig_ptes(huge_page_size(hstate_vma(vma)), &pgsize);
 
-		for (i = 0; i < ncontig; i++, ptep++)
+	if (!pte_present(pte)) {
+		for (i = 0; i < ncontig; i++, ptep++, addr += pgsize)
 			set_pte_at(mm, addr, ptep, pte);
 		return;
 	}
@@ -274,7 +264,6 @@ void set_huge_pte_at(struct vm_area_stru
 		return;
 	}
 
-	ncontig = find_num_contig(mm, addr, ptep, &pgsize);
 	pfn = pte_pfn(pte);
 	dpfn = pgsize >> PAGE_SHIFT;
 	hugeprot = pte_pgprot(pte);
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

