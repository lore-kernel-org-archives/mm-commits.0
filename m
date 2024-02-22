Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746611CD10
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644477; cv=none; b=FV8Xi6iR/4ct2ccJMoUagEAziL7dGaYgyVWLzQ0g1nRbTQ4hZhtfRyXO/oIz1ON0CgfOieymQyfeV4NxRsFhxPb/K0YKK7oxCLqa05WPm9mcdcXbH9NgcOzFpAQiE7r1Z01c6FzJSYWBEm0hfSVUCaKuo9XhVRemmZXbbEZw8Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644477; c=relaxed/simple;
	bh=AJOg6cOwNljNUpW1ETDGPKbUc9vQkPqko3M+TxtVdxY=;
	h=Date:To:From:Subject:Message-Id; b=Wfpix6pwS8nzDzf28VuWTX7sZbQxSPyLEkBSyMb5rpPeqsslISKWnm1lEbMlVlIPq9Z6fTIe6I/VVri1cpbUSo4Rg9nZlAyX+48U8WuRPSvmgOT53G9DepeU2OK0mbmQQ8ker+Zt9foBbDDm1AOUjnyb+kUAQ9Mnoz57QhKRAaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MSsiJHRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MSsiJHRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43DDC433C7;
	Thu, 22 Feb 2024 23:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644477;
	bh=AJOg6cOwNljNUpW1ETDGPKbUc9vQkPqko3M+TxtVdxY=;
	h=Date:To:From:Subject:From;
	b=MSsiJHRtsE7rxfRGdNGYCaiunXg4CcTceDV+7k4MXbZnd4eqiLvoV4ewUDcNT7hCS
	 q0FQ9qm2rXvvnWDjgl0wMtlh6/h3cgtz5CUye7mN9mMkBt+lYFESgoUj5HdVKUqEhy
	 /0fY3Hm6zg9OqkRu2PJ6uJHHLQYhfgHrJy96WXm0=
Date: Thu, 22 Feb 2024 15:27:56 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,fengwei.yin@intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,arnd@arndb.de,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-factor-out-zapping-folio-pte-into-zap_present_folio_pte.patch removed from -mm tree
Message-Id: <20240222232756.E43DDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: factor out zapping folio pte into zap_present_folio_pte()
has been removed from the -mm tree.  Its filename was
     mm-memory-factor-out-zapping-folio-pte-into-zap_present_folio_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: factor out zapping folio pte into zap_present_folio_pte()
Date: Wed, 14 Feb 2024 21:44:29 +0100

Let's prepare for further changes by factoring it out into a separate
function.

Link: https://lkml.kernel.org/r/20240214204435.167852-5-david@redhat.com
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

 mm/memory.c |   53 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

--- a/mm/memory.c~mm-memory-factor-out-zapping-folio-pte-into-zap_present_folio_pte
+++ a/mm/memory.c
@@ -1530,30 +1530,14 @@ zap_install_uffd_wp_if_needed(struct vm_
 	pte_install_uffd_wp_if_needed(vma, addr, pte, pteval);
 }
 
-static inline void zap_present_pte(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
-		unsigned long addr, struct zap_details *details,
-		int *rss, bool *force_flush, bool *force_break)
+static inline void zap_present_folio_pte(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, struct folio *folio,
+		struct page *page, pte_t *pte, pte_t ptent, unsigned long addr,
+		struct zap_details *details, int *rss, bool *force_flush,
+		bool *force_break)
 {
 	struct mm_struct *mm = tlb->mm;
 	bool delay_rmap = false;
-	struct folio *folio;
-	struct page *page;
-
-	page = vm_normal_page(vma, addr, ptent);
-	if (!page) {
-		/* We don't need up-to-date accessed/dirty bits. */
-		ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
-		arch_check_zapped_pte(vma, ptent);
-		tlb_remove_tlb_entry(tlb, pte, addr);
-		VM_WARN_ON_ONCE(userfaultfd_wp(vma));
-		ksm_might_unmap_zero_page(mm, ptent);
-		return;
-	}
-
-	folio = page_folio(page);
-	if (unlikely(!should_zap_folio(details, folio)))
-		return;
 
 	if (!folio_test_anon(folio)) {
 		ptent = ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
@@ -1588,6 +1572,33 @@ static inline void zap_present_pte(struc
 	}
 }
 
+static inline void zap_present_pte(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
+		unsigned long addr, struct zap_details *details,
+		int *rss, bool *force_flush, bool *force_break)
+{
+	struct mm_struct *mm = tlb->mm;
+	struct folio *folio;
+	struct page *page;
+
+	page = vm_normal_page(vma, addr, ptent);
+	if (!page) {
+		/* We don't need up-to-date accessed/dirty bits. */
+		ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
+		arch_check_zapped_pte(vma, ptent);
+		tlb_remove_tlb_entry(tlb, pte, addr);
+		VM_WARN_ON_ONCE(userfaultfd_wp(vma));
+		ksm_might_unmap_zero_page(mm, ptent);
+		return;
+	}
+
+	folio = page_folio(page);
+	if (unlikely(!should_zap_folio(details, folio)))
+		return;
+	zap_present_folio_pte(tlb, vma, folio, page, pte, ptent, addr, details,
+			      rss, force_flush, force_break);
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from david@redhat.com are


