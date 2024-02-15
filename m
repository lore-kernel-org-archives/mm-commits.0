Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E5B1384B8
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026132; cv=none; b=uty16S73FrEcodY3LKKuTwXB4Saw+nY4vUTn+SKt8af2EMHnLWQA6EUODJjKNtfOylorZYNWmK/ndOXUBEMJOt1DGOeE0eVuacBIuQWgy70221TrhCWqDOTMgmkucewU/ghHOZuJq/1yJb7Sccg3nyTc7mdK1FZziIrRHuxKHCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026132; c=relaxed/simple;
	bh=+ureLHt2f6bWcrkt97rqRC8ZIkEZ+pb7qoQt2u/T+Ss=;
	h=Date:To:From:Subject:Message-Id; b=eO1XTpsRtn2LfoxhI+Mz31Hk7mFm+rnbByezRwVQe01/1T+fQ2g1/1EE0SgFmAkMC3wvs5vwGncnzei4nLDLhmIQlD99LYvvhXaOySVHagYWq2+hW3MDeRFxPj9QWuvFBSgImNqINlNnRNVue970suwJBWXOwls7MfzeVGU4b90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qveIlPuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qveIlPuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82342C433F1;
	Thu, 15 Feb 2024 19:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026131;
	bh=+ureLHt2f6bWcrkt97rqRC8ZIkEZ+pb7qoQt2u/T+Ss=;
	h=Date:To:From:Subject:From;
	b=qveIlPuVx1xMHZbpuKmGFPJA7h8l0r02SQNsONcZeYqT3FjAD/GFIJsi1oo/XAbxj
	 zGOem/BmwnIWgDau3Gec3ntP8La17xarocA8aHnca8zPzriRGpIbVioZ/dtUgHFkta
	 HR9q52SyUiGYnwgBJUJI6yWCOZMSrclxmS1p/Llg=
Date: Thu, 15 Feb 2024 11:42:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,fengwei.yin@intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,arnd@arndb.de,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte.patch added to mm-unstable branch
Message-Id: <20240215194211.82342C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: further separate anon and pagecache folio handling in zap_present_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte.patch

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
Subject: mm/memory: further separate anon and pagecache folio handling in zap_present_pte()
Date: Wed, 14 Feb 2024 21:44:28 +0100

We don't need up-to-date accessed-dirty information for anon folios and
can simply work with the ptent we already have.  Also, we know the RSS
counter we want to update.

We can safely move arch_check_zapped_pte() + tlb_remove_tlb_entry() +
zap_install_uffd_wp_if_needed() after updating the folio and RSS.

While at it, only call zap_install_uffd_wp_if_needed() if there is even
any chance that pte_install_uffd_wp_if_needed() would do *something*. 
That is, just don't bother if uffd-wp does not apply.

Link: https://lkml.kernel.org/r/20240214204435.167852-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Heiko Carstens <hca@linux.ibm.com>
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

 mm/memory.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte
+++ a/mm/memory.c
@@ -1552,12 +1552,9 @@ static inline void zap_present_pte(struc
 	folio = page_folio(page);
 	if (unlikely(!should_zap_folio(details, folio)))
 		return;
-	ptent = ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
-	arch_check_zapped_pte(vma, ptent);
-	tlb_remove_tlb_entry(tlb, pte, addr);
-	zap_install_uffd_wp_if_needed(vma, addr, pte, details, ptent);
 
 	if (!folio_test_anon(folio)) {
+		ptent = ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
 		if (pte_dirty(ptent)) {
 			folio_mark_dirty(folio);
 			if (tlb_delay_rmap(tlb)) {
@@ -1567,8 +1564,17 @@ static inline void zap_present_pte(struc
 		}
 		if (pte_young(ptent) && likely(vma_has_recency(vma)))
 			folio_mark_accessed(folio);
+		rss[mm_counter(folio)]--;
+	} else {
+		/* We don't need up-to-date accessed/dirty bits. */
+		ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
+		rss[MM_ANONPAGES]--;
 	}
-	rss[mm_counter(folio)]--;
+	arch_check_zapped_pte(vma, ptent);
+	tlb_remove_tlb_entry(tlb, pte, addr);
+	if (unlikely(userfaultfd_pte_wp(vma, ptent)))
+		zap_install_uffd_wp_if_needed(vma, addr, pte, details, ptent);
+
 	if (!delay_rmap) {
 		folio_remove_rmap_pte(folio, page, vma);
 		if (unlikely(page_mapcount(page) < 0))
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

