Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B8C3E7734E
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbjI3AV0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbjI3AVY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:21:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5371B2;
        Fri, 29 Sep 2023 17:21:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791BDC433C8;
        Sat, 30 Sep 2023 00:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033281;
        bh=jecVQqkIDaJF/QtgKa8Za6FzuiLTKhOEK1ybeSyyu1Q=;
        h=Date:To:From:Subject:From;
        b=pnrofHH91QvLNEn2kQ6MNiu4jV8SYHqb9s3CtqP3Vrl1l8kwJgalqhsAFyhEAfAV0
         MC8JdtaZWIWXZiRQLjfHkOi9rIGGoi22Fm9Mv0fWQCaiqFWUXFlKN/AYpSZfD/9YUl
         xTGHMqbUx8K3mPEWNfoedNYOVpBGjboLKPQAfMj0=
Date:   Fri, 29 Sep 2023 17:21:20 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        will@kernel.org, urezki@gmail.com, svens@linux.ibm.com,
        stable@vger.kernel.org, sj@kernel.org, peterx@redhat.com,
        paul.walmsley@sifive.com, palmer@dabbelt.com, npiggin@gmail.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com, lstoakes@gmail.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, deller@gmx.de, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, axelrasmussen@google.com, arnd@arndb.de,
        aou@eecs.berkeley.edu, anshuman.khandual@arm.com, alex@ghiti.fr,
        agordeev@linux.ibm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch removed from -mm tree
Message-Id: <20230930002121.791BDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: hugetlb: fix set_huge_pte_at() to work with all swap entries
has been removed from the -mm tree.  Its filename was
     arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64: hugetlb: fix set_huge_pte_at() to work with all swap entries
Date: Fri, 22 Sep 2023 12:58:04 +0100

When called with a swap entry that does not embed a PFN (e.g. 
PTE_MARKER_POISONED or PTE_MARKER_UFFD_WP), the previous implementation of
set_huge_pte_at() would either cause a BUG() to fire (if CONFIG_DEBUG_VM
is enabled) or cause a dereference of an invalid address and subsequent
panic.

arm64's huge pte implementation supports multiple huge page sizes, some of
which are implemented in the page table with multiple contiguous entries. 
So set_huge_pte_at() needs to work out how big the logical pte is, so that
it can also work out how many physical ptes (or pmds) need to be written. 
It previously did this by grabbing the folio out of the pte and querying
its size.

However, there are cases when the pte being set is actually a swap entry. 
But this also used to work fine, because for huge ptes, we only ever saw
migration entries and hwpoison entries.  And both of these types of swap
entries have a PFN embedded, so the code would grab that and everything
still worked out.

But over time, more calls to set_huge_pte_at() have been added that set
swap entry types that do not embed a PFN.  And this causes the code to go
bang.  The triggering case is for the uffd poison test, commit
99aa77215ad0 ("selftests/mm: add uffd unit test for UFFDIO_POISON"), which
causes a PTE_MARKER_POISONED swap entry to be set, coutesey of commit
8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs") -
added in v6.5-rc7.  Although review shows that there are other call sites
that set PTE_MARKER_UFFD_WP (which also has no PFN), these don't trigger
on arm64 because arm64 doesn't support UFFD WP.

Arguably, the root cause is really due to commit 18f3962953e4 ("mm:
hugetlb: kill set_huge_swap_pte_at()"), which aimed to simplify the
interface to the core code by removing set_huge_swap_pte_at() (which took
a page size parameter) and replacing it with calls to set_huge_pte_at()
where the size was inferred from the folio, as descibed above.  While that
commit didn't break anything at the time, it did break the interface
because it couldn't handle swap entries without PFNs.  And since then new
callers have come along which rely on this working.  But given the
brokeness is only observable after commit 8a13897fb0da ("mm: userfaultfd:
support UFFDIO_POISON for hugetlbfs"), that one gets the Fixes tag.

Now that we have modified the set_huge_pte_at() interface to pass the huge
page size in the previous patch, we can trivially fix this issue.

Link: https://lkml.kernel.org/r/20230922115804.2043771-3-ryan.roberts@arm.com
Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
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
Cc: <stable@vger.kernel.org>	[6.5+]
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
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 			    pte_t *ptep, pte_t pte, unsigned long sz)
 {
@@ -257,13 +250,10 @@ void set_huge_pte_at(struct mm_struct *m
 	unsigned long pfn, dpfn;
 	pgprot_t hugeprot;
 
-	if (!pte_present(pte)) {
-		struct folio *folio;
-
-		folio = hugetlb_swap_entry_to_folio(pte_to_swp_entry(pte));
-		ncontig = num_contig_ptes(folio_size(folio), &pgsize);
+	ncontig = num_contig_ptes(sz, &pgsize);
 
-		for (i = 0; i < ncontig; i++, ptep++)
+	if (!pte_present(pte)) {
+		for (i = 0; i < ncontig; i++, ptep++, addr += pgsize)
 			set_pte_at(mm, addr, ptep, pte);
 		return;
 	}
@@ -273,7 +263,6 @@ void set_huge_pte_at(struct mm_struct *m
 		return;
 	}
 
-	ncontig = find_num_contig(mm, addr, ptep, &pgsize);
 	pfn = pte_pfn(pte);
 	dpfn = pgsize >> PAGE_SHIFT;
 	hugeprot = pte_pgprot(pte);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-account-pte-mapped-anonymous-thp-usage.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files.patch
mm-thp-extend-thp-to-allocate-anonymous-large-folios.patch
mm-thp-add-recommend-option-for-anon_orders.patch
arm64-mm-override-arch_wants_pte_order.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-small-order-anon-thp.patch

