Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D97B45039
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298531; cv=none; b=OVh+MOtXoy117B8zeOQ5GuNZgjMntkqNKyRC4Y42d2RqGZUUyQnLaucKCKCBsMk96SmYqac4wZMNPDpltmooTk5U+3lvFvIjtRa9g1WEn5xxWMM9hWsFfOPWxH/byzZ0h/bB92p7jh40WsCG0aw+xhhQgs3RHhBI8s+nqFdw5yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298531; c=relaxed/simple;
	bh=xGB5tfO4wVdEReMzcy5P5EdrBqWTT2+mQe2NTxe2AME=;
	h=Date:To:From:Subject:Message-Id; b=oBPLuBZEQEehOhLg0QYdhDhb5W8eiijliXsHTFOwrm4UCr5CFxMbgol71liJ+tAVOAO/atwuCGplOJ2/dx263XsBlRV1oJQNNAgf5oVVPyJtyx1RKRd5V4DBCTSMlGTe/KYzR3Klopi3+gFuq/sPwG7qJdraQuNxd5cYz8ZoJkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w3lHJDao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w3lHJDao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81BC1F00A3A;
	Wed, 29 Jul 2026 04:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298530;
	bh=7U6GB1DDNaJgzTt6swCtGT3Mo72jrklacaKHjM3MZfA=;
	h=Date:To:From:Subject;
	b=w3lHJDaoYi8FiZDRtKbyZqYP1IJQO7Ht5mwkA6HEt7Soz96ExtG6KmPxMER3k0Lac
	 Mqs+Frr5DhknytjhNYKw+mRjgALBUVnV3y4WRVNDFvjhcE0Y5Tof9Ql2XuU2Gdxunc
	 AUUTagqLQnC+o8+Xbn746u07V/PVER4B0P4iRFFE=
Date: Tue, 28 Jul 2026 21:15:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,davem@davemloft.net,andreas@gaisler.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-pte_clear_not_present_full.patch removed from -mm tree
Message-Id: <20260729041529.E81BC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop pte_clear_not_present_full()
has been removed from the -mm tree.  Its filename was
     mm-drop-pte_clear_not_present_full.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: drop pte_clear_not_present_full()
Date: Mon, 29 Jun 2026 15:49:48 +0200

In general, there is no good reason to do anything special when clearing
non-present PTEs.

In theory, HW that does have to invalidate TLBs for non-present PTEs could
benefit from a "full" parameter, but fortunately
pte_clear_not_present_full() is not wired up anymore ...  and there would
have to be something very convincing for us to care about that to re-add
it.

So, let's just use pte_clear() directly now.  To prevent the compiler
complaining on some configs about "set but not used" addr parameter,
silence that here.

Link: https://lore.kernel.org/20260629-clear_not_present_full_ptes-v2-2-96089871a1e7@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   21 ++++-----------------
 mm/madvise.c            |    4 ++--
 2 files changed, 6 insertions(+), 19 deletions(-)

--- a/include/linux/pgtable.h~mm-drop-pte_clear_not_present_full
+++ a/include/linux/pgtable.h
@@ -988,21 +988,6 @@ static inline void update_mmu_tlb(struct
 	update_mmu_tlb_range(vma, address, ptep, 1);
 }
 
-/*
- * Some architectures may be able to avoid expensive synchronization
- * primitives when modifications are made to PTE's which are already
- * not present, or in the process of an address space destruction.
- */
-#ifndef __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
-static inline void pte_clear_not_present_full(struct mm_struct *mm,
-					      unsigned long address,
-					      pte_t *ptep,
-					      int full)
-{
-	pte_clear(mm, address, ptep);
-}
-#endif
-
 #ifndef clear_not_present_full_ptes
 /**
  * clear_not_present_full_ptes - Clear multiple not present PTEs which are
@@ -1014,7 +999,7 @@ static inline void pte_clear_not_present
  * @full: Whether we are clearing a full mm.
  *
  * May be overridden by the architecture; otherwise, implemented as a simple
- * loop over pte_clear_not_present_full().
+ * loop over pte_clear().
  *
  * Context: The caller holds the page table lock.  The PTEs are all not present.
  * The PTEs are all in the same PMD.
@@ -1022,8 +1007,10 @@ static inline void pte_clear_not_present
 static inline void clear_not_present_full_ptes(struct mm_struct *mm,
 		unsigned long addr, pte_t *ptep, unsigned int nr, int full)
 {
+	(void)addr;
+
 	for (;;) {
-		pte_clear_not_present_full(mm, addr, ptep, full);
+		pte_clear(mm, addr, ptep);
 		if (--nr == 0)
 			break;
 		ptep++;
--- a/mm/madvise.c~mm-drop-pte_clear_not_present_full
+++ a/mm/madvise.c
@@ -697,7 +697,7 @@ static int madvise_free_pte_range(pmd_t
 				clear_not_present_full_ptes(mm, addr, pte, nr, tlb->fullmm);
 			} else if (softleaf_is_hwpoison(entry) ||
 				   softleaf_is_poison_marker(entry)) {
-				pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+				pte_clear(mm, addr, pte);
 			}
 			continue;
 		}
@@ -1233,7 +1233,7 @@ static int guard_remove_pte_entry(pte_t
 
 	if (is_guard_pte_marker(ptent)) {
 		/* Simply clear the PTE marker. */
-		pte_clear_not_present_full(walk->mm, addr, pte, false);
+		pte_clear(walk->mm, addr, pte);
 		update_mmu_cache(walk->vma, addr, pte);
 	}
 
_

Patches currently in -mm which might be from david@kernel.org are

x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

