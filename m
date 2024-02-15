Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F073F1384B8
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026128; cv=none; b=LNux+gvK+SmG57QgjFk0Jd8nwurOK5Wcs9EqCdtrIv/i1sxU1vNsho/DJEivIQD4bXzQqUu5xCYMHPr3JHdySGq5apr58GunIt1wij9MtfZall58GctlfxFMvYJEuhkU/xAn/XMsrEpPMYdT60yl/EkSSt2Wbu6VXdSfzg0fq6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026128; c=relaxed/simple;
	bh=MGCiz+qfL2DVZbsujLrKQrRjJZjabn41zIVzDNHo7rw=;
	h=Date:To:From:Subject:Message-Id; b=cWHhEmXwBmhaMh8bGwDEi/aIYsWDakZj1/4Dt9GjAn5J2NExjI7qBpXwFqJnZus8v2hGCrTpTndfyycuV2sOZE2T+GN+r+T+Cql6wqEd+GAet/JgyxmI0mHonRwYEPSxPMzum+UGdy0sK/t3/UNaINiSvAAU0ognqcfSg3mdaHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BmPOG3eC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BmPOG3eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D746C433F1;
	Thu, 15 Feb 2024 19:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026127;
	bh=MGCiz+qfL2DVZbsujLrKQrRjJZjabn41zIVzDNHo7rw=;
	h=Date:To:From:Subject:From;
	b=BmPOG3eCoprCMSRsFYUUxHyRt6V+TfiYAnJ86FE0mWYyMhGgQAuROpQxEJoPYsRv5
	 up1ecrH2FYLelMdp329QkcceMLh5XxQ2fd8mFdyQ3hBl3Pys7nz83vQN7IfwAPWju/
	 JTc9BgjN9eYEy6158IwyV8uZsOsd7EK2MDGXPDdI=
Date: Thu, 15 Feb 2024 11:42:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,fengwei.yin@intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,arnd@arndb.de,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-factor-out-zapping-of-present-pte-into-zap_present_pte.patch added to mm-unstable branch
Message-Id: <20240215194207.5D746C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: factor out zapping of present pte into zap_present_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-factor-out-zapping-of-present-pte-into-zap_present_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-factor-out-zapping-of-present-pte-into-zap_present_pte.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: factor out zapping of present pte into zap_present_pte()
Date: Wed, 14 Feb 2024 21:44:26 +0100

Patch series "mm/memory: optimize unmap/zap with PTE-mapped THP", v3.

This series is based on [1].  Similar to what we did with fork(), let's
implement PTE batching during unmap/zap when processing PTE-mapped THPs.

We collect consecutive PTEs that map consecutive pages of the same large
folio, making sure that the other PTE bits are compatible, and (a) adjust
the refcount only once per batch, (b) call rmap handling functions only
once per batch, (c) perform batch PTE setting/updates and (d) perform TLB
entry removal once per batch.

Ryan was previously working on this in the context of cont-pte for arm64,
int latest iteration [2] with a focus on arm6 with cont-pte only.  This
series implements the optimization for all architectures, independent of
such PTE bits, teaches MMU gather/TLB code to be fully aware of such
large-folio-pages batches as well, and amkes use of our new rmap batching
function when removing the rmap.

To achieve that, we have to enlighten MMU gather / page freeing code
(i.e., everything that consumes encoded_page) to process unmapping of
consecutive pages that all belong to the same large folio.  I'm being very
careful to not degrade order-0 performance, and it looks like I managed to
achieve that.

While this series should -- similar to [1] -- be beneficial for adding
cont-pte support on arm64[2], it's one of the requirements for maintaining
a total mapcount[3] for large folios with minimal added overhead and
further changes[4] that build up on top of the total mapcount.

Independent of all that, this series results in a speedup during munmap()
and similar unmapping (process teardown, MADV_DONTNEED on larger ranges)
with PTE-mapped THP, which is the default with THPs that are smaller than
a PMD (for example, 16KiB to 1024KiB mTHPs for anonymous memory[5]).

On an Intel Xeon Silver 4210R CPU, munmap'ing a 1GiB VMA backed by
PTE-mapped folios of the same size (stddev < 1%) results in the following
runtimes for munmap() in seconds (shorter is better):

Folio Size | mm-unstable |      New | Change
---------------------------------------------
      4KiB |    0.058110 | 0.057715 |   - 1%
     16KiB |    0.044198 | 0.035469 |   -20%
     32KiB |    0.034216 | 0.023522 |   -31%
     64KiB |    0.029207 | 0.018434 |   -37%
    128KiB |    0.026579 | 0.014026 |   -47%
    256KiB |    0.025130 | 0.011756 |   -53%
    512KiB |    0.024292 | 0.010703 |   -56%
   1024KiB |    0.023812 | 0.010294 |   -57%
   2048KiB |    0.023785 | 0.009910 |   -58%

[1] https://lkml.kernel.org/r/20240129124649.189745-1-david@redhat.com
[2] https://lkml.kernel.org/r/20231218105100.172635-1-ryan.roberts@arm.com
[3] https://lkml.kernel.org/r/20230809083256.699513-1-david@redhat.com
[4] https://lkml.kernel.org/r/20231124132626.235350-1-david@redhat.com
[5] https://lkml.kernel.org/r/20231207161211.2374093-1-ryan.roberts@arm.com


This patch (of 10):

Let's prepare for further changes by factoring out processing of present
PTEs.

Link: https://lkml.kernel.org/r/20240214204435.167852-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240214204435.167852-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   94 ++++++++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 41 deletions(-)

--- a/mm/memory.c~mm-memory-factor-out-zapping-of-present-pte-into-zap_present_pte
+++ a/mm/memory.c
@@ -1532,13 +1532,61 @@ zap_install_uffd_wp_if_needed(struct vm_
 	pte_install_uffd_wp_if_needed(vma, addr, pte, pteval);
 }
 
+static inline void zap_present_pte(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
+		unsigned long addr, struct zap_details *details,
+		int *rss, bool *force_flush, bool *force_break)
+{
+	struct mm_struct *mm = tlb->mm;
+	struct folio *folio = NULL;
+	bool delay_rmap = false;
+	struct page *page;
+
+	page = vm_normal_page(vma, addr, ptent);
+	if (page)
+		folio = page_folio(page);
+
+	if (unlikely(!should_zap_folio(details, folio)))
+		return;
+	ptent = ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
+	arch_check_zapped_pte(vma, ptent);
+	tlb_remove_tlb_entry(tlb, pte, addr);
+	zap_install_uffd_wp_if_needed(vma, addr, pte, details, ptent);
+	if (unlikely(!page)) {
+		ksm_might_unmap_zero_page(mm, ptent);
+		return;
+	}
+
+	if (!folio_test_anon(folio)) {
+		if (pte_dirty(ptent)) {
+			folio_mark_dirty(folio);
+			if (tlb_delay_rmap(tlb)) {
+				delay_rmap = true;
+				*force_flush = true;
+			}
+		}
+		if (pte_young(ptent) && likely(vma_has_recency(vma)))
+			folio_mark_accessed(folio);
+	}
+	rss[mm_counter(folio)]--;
+	if (!delay_rmap) {
+		folio_remove_rmap_pte(folio, page, vma);
+		if (unlikely(page_mapcount(page) < 0))
+			print_bad_pte(vma, addr, ptent, page);
+	}
+	if (unlikely(__tlb_remove_page(tlb, page, delay_rmap))) {
+		*force_flush = true;
+		*force_break = true;
+	}
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct zap_details *details)
 {
+	bool force_flush = false, force_break = false;
 	struct mm_struct *mm = tlb->mm;
-	int force_flush = 0;
 	int rss[NR_MM_COUNTERS];
 	spinlock_t *ptl;
 	pte_t *start_pte;
@@ -1555,7 +1603,7 @@ static unsigned long zap_pte_range(struc
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = ptep_get(pte);
-		struct folio *folio = NULL;
+		struct folio *folio;
 		struct page *page;
 
 		if (pte_none(ptent))
@@ -1565,45 +1613,9 @@ static unsigned long zap_pte_range(struc
 			break;
 
 		if (pte_present(ptent)) {
-			unsigned int delay_rmap;
-
-			page = vm_normal_page(vma, addr, ptent);
-			if (page)
-				folio = page_folio(page);
-
-			if (unlikely(!should_zap_folio(details, folio)))
-				continue;
-			ptent = ptep_get_and_clear_full(mm, addr, pte,
-							tlb->fullmm);
-			arch_check_zapped_pte(vma, ptent);
-			tlb_remove_tlb_entry(tlb, pte, addr);
-			zap_install_uffd_wp_if_needed(vma, addr, pte, details,
-						      ptent);
-			if (unlikely(!page)) {
-				ksm_might_unmap_zero_page(mm, ptent);
-				continue;
-			}
-
-			delay_rmap = 0;
-			if (!folio_test_anon(folio)) {
-				if (pte_dirty(ptent)) {
-					folio_mark_dirty(folio);
-					if (tlb_delay_rmap(tlb)) {
-						delay_rmap = 1;
-						force_flush = 1;
-					}
-				}
-				if (pte_young(ptent) && likely(vma_has_recency(vma)))
-					folio_mark_accessed(folio);
-			}
-			rss[mm_counter(folio)]--;
-			if (!delay_rmap) {
-				folio_remove_rmap_pte(folio, page, vma);
-				if (unlikely(page_mapcount(page) < 0))
-					print_bad_pte(vma, addr, ptent, page);
-			}
-			if (unlikely(__tlb_remove_page(tlb, page, delay_rmap))) {
-				force_flush = 1;
+			zap_present_pte(tlb, vma, pte, ptent, addr, details,
+					rss, &force_flush, &force_break);
+			if (unlikely(force_break)) {
 				addr += PAGE_SIZE;
 				break;
 			}
_

Patches currently in -mm which might be from david@redhat.com are

arm-pgtable-define-pfn_pte_shift.patch
nios2-pgtable-define-pfn_pte_shift.patch
powerpc-pgtable-define-pfn_pte_shift.patch
riscv-pgtable-define-pfn_pte_shift.patch
s390-pgtable-define-pfn_pte_shift.patch
sparc-pgtable-define-pfn_pte_shift.patch
mm-pgtable-make-pte_next_pfn-independent-of-set_ptes.patch
arm-mm-use-pte_next_pfn-in-set_ptes.patch
powerpc-mm-use-pte_next_pfn-in-set_ptes.patch
mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch
mm-memory-pass-pte-to-copy_present_pte.patch
mm-memory-optimize-fork-with-pte-mapped-thp.patch
mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch
mm-memory-ignore-writable-bit-in-folio_pte_batch.patch
mm-memory-factor-out-zapping-of-present-pte-into-zap_present_pte.patch
mm-memory-handle-page-case-in-zap_present_pte-separately.patch
mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte.patch
mm-memory-factor-out-zapping-folio-pte-into-zap_present_folio_pte.patch
mm-mmu_gather-pass-delay_rmap-instead-of-encoded-page-to-__tlb_remove_page_size.patch
mm-mmu_gather-define-encoded_page_flag_delay_rmap.patch
mm-mmu_gather-add-tlb_remove_tlb_entries.patch
mm-mmu_gather-add-__tlb_remove_folio_pages.patch
mm-mmu_gather-improve-cond_resched-handling-with-large-folios-and-expensive-page-freeing.patch
mm-memory-optimize-unmap-zap-with-pte-mapped-thp.patch

