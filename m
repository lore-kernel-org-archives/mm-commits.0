Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED78A41A81
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026192; cv=none; b=URZthReAp1qL49/QSv7eE6+oz23461cquFTqh8rZ0/DD6JSvFgo0Fj9R06602xOPvNinOVpLCF/iuCfeoRhHMsKgZnvHxgg3jaKsd3cCh1rufkmOj4v4ISdZDCzlg4EVzQIzc6gBqmjWrIVPJXJSxFfU+bvVXx7G98lG0+tdeWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026192; c=relaxed/simple;
	bh=oumVgJhR9O8tJ2M7HDaCndosb+Dtw3FKPbijJbZ/1ww=;
	h=Date:To:From:Subject:Message-Id; b=pT3rNecdQ532DsoEL8LDDVMyJfRAT5DmI0WsX9tX/pv5mwN6I7zvrbDtpC/+fkPXKvYIOLyXo4lVhFa9CoU//gHPEJTaO9l3IUSwbO/vNQhCei2xBQHJMMS3yXwPaQgFgZREYulSkwHYPXf07AJ0/JzrO5fkadx1ikBF9r1QmUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WNXZTCWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WNXZTCWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0B4C433F1;
	Thu, 15 Feb 2024 19:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026191;
	bh=oumVgJhR9O8tJ2M7HDaCndosb+Dtw3FKPbijJbZ/1ww=;
	h=Date:To:From:Subject:From;
	b=WNXZTCWVodX1IgjDrRkI8fm4CTXh8D7/hcgMYh1riojQ/dD7z1njncvUmIdhUSjGI
	 oOlBx0WJA7Cw1taORboWE58kcP+OQyHkTax57MHvfexiSACqkNifAT4fz7pSQn9yfZ
	 jOYoC51jjhV9BahNH4utETAG+L/l2KJ+nVZPqPjc=
Date: Thu, 15 Feb 2024 11:43:11 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pte_batch_hint-to-reduce-scanning-in-folio_pte_batch.patch added to mm-unstable branch
Message-Id: <20240215194311.BA0B4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add pte_batch_hint() to reduce scanning in folio_pte_batch()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pte_batch_hint-to-reduce-scanning-in-folio_pte_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pte_batch_hint-to-reduce-scanning-in-folio_pte_batch.patch

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
Subject: mm: add pte_batch_hint() to reduce scanning in folio_pte_batch()
Date: Thu, 15 Feb 2024 10:32:02 +0000

Some architectures (e.g.  arm64) can tell from looking at a pte, if some
follow-on ptes also map contiguous physical memory with the same pgprot. 
(for arm64, these are contpte mappings).

Take advantage of this knowledge to optimize folio_pte_batch() so that it
can skip these ptes when scanning to create a batch.  By default, if an
arch does not opt-in, folio_pte_batch() returns a compile-time 1, so the
changes are optimized out and the behaviour is as before.

arm64 will opt-in to providing this hint in the next patch, which will
greatly reduce the cost of ptep_get() when scanning a range of contptes.

Link: https://lkml.kernel.org/r/20240215103205.2607016-16-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
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

 include/linux/pgtable.h |   21 +++++++++++++++++++++
 mm/memory.c             |   19 ++++++++++++-------
 2 files changed, 33 insertions(+), 7 deletions(-)

--- a/include/linux/pgtable.h~mm-add-pte_batch_hint-to-reduce-scanning-in-folio_pte_batch
+++ a/include/linux/pgtable.h
@@ -212,6 +212,27 @@ static inline int pmd_dirty(pmd_t pmd)
 #define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
+#ifndef pte_batch_hint
+/**
+ * pte_batch_hint - Number of pages that can be added to batch without scanning.
+ * @ptep: Page table pointer for the entry.
+ * @pte: Page table entry.
+ *
+ * Some architectures know that a set of contiguous ptes all map the same
+ * contiguous memory with the same permissions. In this case, it can provide a
+ * hint to aid pte batching without the core code needing to scan every pte.
+ *
+ * An architecture implementation may ignore the PTE accessed state. Further,
+ * the dirty state must apply atomically to all the PTEs described by the hint.
+ *
+ * May be overridden by the architecture, else pte_batch_hint is always 1.
+ */
+static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
+{
+	return 1;
+}
+#endif
+
 #ifndef pte_advance_pfn
 static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
 {
--- a/mm/memory.c~mm-add-pte_batch_hint-to-reduce-scanning-in-folio_pte_batch
+++ a/mm/memory.c
@@ -988,16 +988,20 @@ static inline int folio_pte_batch(struct
 {
 	unsigned long folio_end_pfn = folio_pfn(folio) + folio_nr_pages(folio);
 	const pte_t *end_ptep = start_ptep + max_nr;
-	pte_t expected_pte = __pte_batch_clear_ignored(pte_next_pfn(pte), flags);
-	pte_t *ptep = start_ptep + 1;
+	pte_t expected_pte, *ptep;
 	bool writable;
+	int nr;
 
 	if (any_writable)
 		*any_writable = false;
 
 	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
 
-	while (ptep != end_ptep) {
+	nr = pte_batch_hint(start_ptep, pte);
+	expected_pte = __pte_batch_clear_ignored(pte_advance_pfn(pte, nr), flags);
+	ptep = start_ptep + nr;
+
+	while (ptep < end_ptep) {
 		pte = ptep_get(ptep);
 		if (any_writable)
 			writable = !!pte_write(pte);
@@ -1011,17 +1015,18 @@ static inline int folio_pte_batch(struct
 		 * corner cases the next PFN might fall into a different
 		 * folio.
 		 */
-		if (pte_pfn(pte) == folio_end_pfn)
+		if (pte_pfn(pte) >= folio_end_pfn)
 			break;
 
 		if (any_writable)
 			*any_writable |= writable;
 
-		expected_pte = pte_next_pfn(expected_pte);
-		ptep++;
+		nr = pte_batch_hint(ptep, pte);
+		expected_pte = pte_advance_pfn(expected_pte, nr);
+		ptep += nr;
 	}
 
-	return ptep - start_ptep;
+	return min(ptep - start_ptep, max_nr);
 }
 
 /*
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

