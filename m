Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA233A95C
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 20:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753217322; cv=none; b=jR4WJJyLudjcEjoKq5jDGcqWyesSpsDet/zZ0+EldmNEJBgjTEk+iaBN19fbX9QsqyU61bXhG/dnRNQzMbkV6LRfYIO7ui1YxCfpcLgbV8N+KEZwSMB8nSi2WgksJhol22MJlYq64AZcFmzFOK9uI95xzLJ77iA/JEi82QgjUu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753217322; c=relaxed/simple;
	bh=oCiIW6IfJ7JFu3CLcftjaH1JO8c28SN6Ny/TpshJbDI=;
	h=Date:To:From:Subject:Message-Id; b=Cd+B7dPhVNKyVT5sYWdICC3RbjS5rlCS2AS4fqQigq8RXBlAdFaqS69BYT+j1MkBjLh4cp5kCoRXJHW4+X/MUcDNtBvlsAVONCKNCbgitktTt8M+0uJf7a3QB+tW4yI/ic9wkfdxb2SEQWqaq9Qy9WdpC3j+nHA3h269JIU9fKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jD811uT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jD811uT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23673C4CEEB;
	Tue, 22 Jul 2025 20:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753217321;
	bh=oCiIW6IfJ7JFu3CLcftjaH1JO8c28SN6Ny/TpshJbDI=;
	h=Date:To:From:Subject:From;
	b=jD811uT1TYEUy5uCF8Nkzkmxtt7L17fng3GSUT4xlEcRuOM0GGoKqcdmLJdqsGtny
	 5RKH2V0B+q613WpwfnEE+0vMSbUogePZ0HGHhm6tZKTJvPXALBn0RVC5RibB12iohw
	 Cx8hsQ11uhP4oei6q7WCsoKG/HrqBaw6avHc7E44=
Date: Tue, 22 Jul 2025 13:48:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-get_and_clear_ptes-and-clear_ptes.patch added to mm-new branch
Message-Id: <20250722204841.23673C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add get_and_clear_ptes() and clear_ptes()
has been added to the -mm mm-new branch.  Its filename is
     mm-add-get_and_clear_ptes-and-clear_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-get_and_clear_ptes-and-clear_ptes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm: add get_and_clear_ptes() and clear_ptes()
Date: Tue, 22 Jul 2025 20:35:57 +0530

Patch series "Optimizations for khugepaged", v3.

If the underlying folio mapped by the ptes is large, we can process those
ptes in a batch using folio_pte_batch().

For arm64 specifically, this results in a 16x reduction in the number of
ptep_get() calls, since on a contig block, ptep_get() on arm64 will
iterate through all 16 entries to collect a/d bits.  Next, ptep_clear()
will cause a TLBI for every contig block in the range via
contpte_try_unfold().  Instead, use clear_ptes() to only do the TLBI at
the first and last contig block of the range.

For split folios, there will be no pte batching; the batch size returned
by folio_pte_batch() will be 1.  For pagetable split folios, the ptes will
still point to the same large folio; for arm64, this results in the
optimization described above, and for other arches, a minor improvement is
expected due to a reduction in the number of function calls and batching
atomic operations.


This patch (of 3):

Let's add variants to be used where "full" does not apply -- which will be
the majority of cases in the future.  "full" really only applies if we are
about to tear down a full MM.

Use get_and_clear_ptes() in existing code, clear_ptes() users will be
added next.

Should we make these inline functions instead and add separate docs? 
Probably not worth it for now.

Link: https://lkml.kernel.org/r/20250722150559.96465-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20250722150559.96465-2-dev.jain@arm.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c     |    2 +-
 include/linux/pgtable.h |    6 ++++++
 mm/mremap.c             |    2 +-
 mm/rmap.c               |    2 +-
 4 files changed, 9 insertions(+), 3 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-add-get_and_clear_ptes-and-clear_ptes
+++ a/arch/arm64/mm/mmu.c
@@ -1528,7 +1528,7 @@ early_initcall(prevent_bootmem_remove_in
 pte_t modify_prot_start_ptes(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t *ptep, unsigned int nr)
 {
-	pte_t pte = get_and_clear_full_ptes(vma->vm_mm, addr, ptep, nr, /* full = */ 0);
+	pte_t pte = get_and_clear_ptes(vma->vm_mm, addr, ptep, nr);
 
 	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_2645198)) {
 		/*
--- a/include/linux/pgtable.h~mm-add-get_and_clear_ptes-and-clear_ptes
+++ a/include/linux/pgtable.h
@@ -736,6 +736,9 @@ static inline pte_t get_and_clear_full_p
 }
 #endif
 
+#define get_and_clear_ptes(_mm, _addr, _ptep, _nr) \
+	get_and_clear_full_ptes(_mm, _addr, _ptep, _nr, 0)
+
 #ifndef clear_full_ptes
 /**
  * clear_full_ptes - Clear present PTEs that map consecutive pages of the same
@@ -768,6 +771,9 @@ static inline void clear_full_ptes(struc
 }
 #endif
 
+#define clear_ptes(_mm, _addr, _ptep, _nr) \
+	clear_full_ptes(_mm, _addr, _ptep, _nr, 0)
+
 /*
  * If two threads concurrently fault at the same page, the thread that
  * won the race updates the PTE and its local TLB/Cache. The other thread
--- a/mm/mremap.c~mm-add-get_and_clear_ptes-and-clear_ptes
+++ a/mm/mremap.c
@@ -280,7 +280,7 @@ static int move_ptes(struct pagetable_mo
 							 old_pte, max_nr_ptes);
 			force_flush = true;
 		}
-		pte = get_and_clear_full_ptes(mm, old_addr, old_ptep, nr_ptes, 0);
+		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
 		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
 
--- a/mm/rmap.c~mm-add-get_and_clear_ptes-and-clear_ptes
+++ a/mm/rmap.c
@@ -2036,7 +2036,7 @@ static bool try_to_unmap_one(struct foli
 			flush_cache_range(vma, address, end_addr);
 
 			/* Nuke the page table entry. */
-			pteval = get_and_clear_full_ptes(mm, address, pvmw.pte, nr_pages, 0);
+			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
 			/*
 			 * We clear the PTE but do not flush so potentially
 			 * a remote CPU could still be writing to the folio.
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch
mm-add-get_and_clear_ptes-and-clear_ptes.patch

