Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB6113A266
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026154; cv=none; b=tUnYEB9G+gQXtYF79YKYkY6jeFnGXyXHQBoX1g773NLDAvw6roYJ58+ugUverk9aN62KUkbrPDoNsRMs6y4JjRc/IxtvGjM2HS+H73jtSh33Pg/7JXS/YmH7QZH4VsmjzEAPJvkcAYtQQwrZIFWyWEKDZv9yTKJ2CRYLcOG3s5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026154; c=relaxed/simple;
	bh=aq4rvjEEIZb7HPgdT8QW2W1oYR3VHb4m7bsESTaRKsk=;
	h=Date:To:From:Subject:Message-Id; b=cEDrr7O2dk2EnS2AoaL8jpemYEW4gpf8QRFXpJBmlt028x/Ji/AeMkBXEURHG6fC4+DrJMEiYpRXbuUg5S0DZX2y0gWJz50As/1j3gFaEO4chtc0kcIe2FIvO7rU6WE/DMOpu8KPuYu11pJo1d2FG6WT/zQkeH8EsvramX9pL3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B0b2lymp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B0b2lymp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A281C433F1;
	Thu, 15 Feb 2024 19:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026154;
	bh=aq4rvjEEIZb7HPgdT8QW2W1oYR3VHb4m7bsESTaRKsk=;
	h=Date:To:From:Subject:From;
	b=B0b2lympF7VYBb+/tk70duBpj9hoL2TkNVks3IkZ6XFq9i10VxYS1bDf4Kik9B9z2
	 wpdl1fcNY27yq69OvrHsiZwVssJQu5h6IXwY67lf7AE6qLWlP/MDWRUcg9dhKfRvRH
	 l0Ido5F5sAat+8GeKcStC0Wn9H644TcR3b09rwv0=
Date: Thu, 15 Feb 2024 11:42:33 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-batch-collapse-pmd-with-set_ptes.patch added to mm-unstable branch
Message-Id: <20240215194234.4A281C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: thp: batch-collapse PMD with set_ptes()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-batch-collapse-pmd-with-set_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-batch-collapse-pmd-with-set_ptes.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: thp: batch-collapse PMD with set_ptes()
Date: Thu, 15 Feb 2024 10:31:49 +0000

Refactor __split_huge_pmd_locked() so that a present PMD can be collapsed
to PTEs in a single batch using set_ptes().

This should improve performance a little bit, but the real motivation is
to remove the need for the arm64 backend to have to fold the contpte
entries.  Instead, since the ptes are set as a batch, the contpte blocks
can be initially set up pre-folded (once the arm64 contpte support is
added in the next few patches).  This leads to noticeable performance
improvement during split.

Link: https://lkml.kernel.org/r/20240215103205.2607016-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   58 +++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

--- a/mm/huge_memory.c~mm-thp-batch-collapse-pmd-with-set_ptes
+++ a/mm/huge_memory.c
@@ -2579,15 +2579,16 @@ static void __split_huge_pmd_locked(stru
 
 	pte = pte_offset_map(&_pmd, haddr);
 	VM_BUG_ON(!pte);
-	for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-		pte_t entry;
-		/*
-		 * Note that NUMA hinting access restrictions are not
-		 * transferred to avoid any possibility of altering
-		 * permissions across VMAs.
-		 */
-		if (freeze || pmd_migration) {
+
+	/*
+	 * Note that NUMA hinting access restrictions are not transferred to
+	 * avoid any possibility of altering permissions across VMAs.
+	 */
+	if (freeze || pmd_migration) {
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
+			pte_t entry;
 			swp_entry_t swp_entry;
+
 			if (write)
 				swp_entry = make_writable_migration_entry(
 							page_to_pfn(page + i));
@@ -2606,25 +2607,32 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_swp_mksoft_dirty(entry);
 			if (uffd_wp)
 				entry = pte_swp_mkuffd_wp(entry);
-		} else {
-			entry = mk_pte(page + i, READ_ONCE(vma->vm_page_prot));
-			if (write)
-				entry = pte_mkwrite(entry, vma);
-			if (!young)
-				entry = pte_mkold(entry);
-			/* NOTE: this may set soft-dirty too on some archs */
-			if (dirty)
-				entry = pte_mkdirty(entry);
-			if (soft_dirty)
-				entry = pte_mksoft_dirty(entry);
-			if (uffd_wp)
-				entry = pte_mkuffd_wp(entry);
+
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+			set_pte_at(mm, addr, pte + i, entry);
 		}
-		VM_BUG_ON(!pte_none(ptep_get(pte)));
-		set_pte_at(mm, addr, pte, entry);
-		pte++;
+	} else {
+		pte_t entry;
+
+		entry = mk_pte(page, READ_ONCE(vma->vm_page_prot));
+		if (write)
+			entry = pte_mkwrite(entry, vma);
+		if (!young)
+			entry = pte_mkold(entry);
+		/* NOTE: this may set soft-dirty too on some archs */
+		if (dirty)
+			entry = pte_mkdirty(entry);
+		if (soft_dirty)
+			entry = pte_mksoft_dirty(entry);
+		if (uffd_wp)
+			entry = pte_mkuffd_wp(entry);
+
+		for (i = 0; i < HPAGE_PMD_NR; i++)
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+
+		set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
 	}
-	pte_unmap(pte - 1);
+	pte_unmap(pte);
 
 	if (!pmd_migration)
 		folio_remove_rmap_pmd(folio, page, vma);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

tools-mm-add-thpmaps-script-to-dump-thp-usage-info.patch
arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch
mm-clarify-the-spec-for-set_ptes.patch
mm-thp-batch-collapse-pmd-with-set_ptes.patch
mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn.patch
arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch
x86-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch
mm-tidy-up-pte_next_pfn-definition.patch
arm64-mm-convert-read_onceptep-to-ptep_getptep.patch
arm64-mm-convert-set_pte_at-to-set_ptes-1.patch
arm64-mm-convert-ptep_clear-to-ptep_get_and_clear.patch
arm64-mm-new-ptep-layer-to-manage-contig-bit.patch
arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch
arm64-mm-wire-up-pte_cont-for-user-mappings.patch
arm64-mm-implement-new-wrprotect_ptes-batch-api.patch
arm64-mm-implement-new-clear_full_ptes-batch-apis.patch
mm-add-pte_batch_hint-to-reduce-scanning-in-folio_pte_batch.patch
arm64-mm-implement-pte_batch_hint.patch
arm64-mm-__always_inline-to-improve-fork-perf.patch
arm64-mm-automatically-fold-contpte-mappings.patch

