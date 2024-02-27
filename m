Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648E24D9F4
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709055267; cv=none; b=ciYFmY4MbEJ7QaPt3xxdtRfkTQW0S/PAc0uEONtwBcB5DIj3hn/DIbj1ku3k/fSZ9tGNP/c+HIFJkisFvGW+soloGocYdxuPqyR97pahYnC3QUJ7PswDRz1a7JzwIz/z8jowKpsvOucNId+7K1KJtFL1lx5ybeOBGYhoTUVeHTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709055267; c=relaxed/simple;
	bh=gMgdl9/s9/QEohSkCoHPKNIF+297bW7wLTUA7u0mAOU=;
	h=Date:To:From:Subject:Message-Id; b=Q56CmxEzCKe4KOoyMsyDPDHIyE7BJXHkNlCcriXYTZhQrkyQVh9z8plOKGmmloy8157NYDJHQf68pmHONE9NwM8GirvD6LEiwqRMFs5NxNjZ2B5JcS+J0WZladuGzhLJK7BOctoEVbyMlmy5hJemtmqV0y4uSyDhIrfLbYjTdsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dtAh6E5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dtAh6E5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0FEC433C7;
	Tue, 27 Feb 2024 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709055266;
	bh=gMgdl9/s9/QEohSkCoHPKNIF+297bW7wLTUA7u0mAOU=;
	h=Date:To:From:Subject:From;
	b=dtAh6E5HqBXXuZvB+FrySVSV2tztXCmtNT7nvYnvUluiraNsI3pkvd8XcfELGJJY6
	 XlFCh5nUQp5oZC0EUdg+pQPoxhKOfqhbdo2wfaNr//HkSA7Y3LEbrrViGCaPeynlDW
	 0iQiibnjwzuF5qmNHtfk1PpoD73luns1gWxbeZbk=
Date: Tue, 27 Feb 2024 09:34:25 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,fengwei.yin@intel.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-folio_pte_batch-available-outside-of-mm-memoryc.patch added to mm-unstable branch
Message-Id: <20240227173426.BA0FEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make folio_pte_batch available outside of mm/memory.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-folio_pte_batch-available-outside-of-mm-memoryc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-folio_pte_batch-available-outside-of-mm-memoryc.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: make folio_pte_batch available outside of mm/memory.c
Date: Tue, 27 Feb 2024 23:42:01 +1300

madvise, mprotect and some others might need folio_pte_batch to check if a
range of PTEs are completely mapped to a large folio with contiguous
physical addresses.  Let's make it available in mm/internal.h.

While at it, add proper kernel doc and sanity-check more input parameters
using two additional VM_WARN_ON_FOLIO().

[david@redhat.com: improve the doc for the exported func]
Link: https://lkml.kernel.org/r/20240227104201.337988-1-21cnbao@gmail.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   90 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/memory.c   |   76 ----------------------------------------
 2 files changed, 90 insertions(+), 76 deletions(-)

--- a/mm/internal.h~mm-make-folio_pte_batch-available-outside-of-mm-memoryc
+++ a/mm/internal.h
@@ -83,6 +83,96 @@ static inline void *folio_raw_mapping(st
 	return (void *)(mapping & ~PAGE_MAPPING_FLAGS);
 }
 
+/* Flags for folio_pte_batch(). */
+typedef int __bitwise fpb_t;
+
+/* Compare PTEs after pte_mkclean(), ignoring the dirty bit. */
+#define FPB_IGNORE_DIRTY		((__force fpb_t)BIT(0))
+
+/* Compare PTEs after pte_clear_soft_dirty(), ignoring the soft-dirty bit. */
+#define FPB_IGNORE_SOFT_DIRTY		((__force fpb_t)BIT(1))
+
+static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
+{
+	if (flags & FPB_IGNORE_DIRTY)
+		pte = pte_mkclean(pte);
+	if (likely(flags & FPB_IGNORE_SOFT_DIRTY))
+		pte = pte_clear_soft_dirty(pte);
+	return pte_wrprotect(pte_mkold(pte));
+}
+
+/**
+ * folio_pte_batch - detect a PTE batch for a large folio
+ * @folio: The large folio to detect a PTE batch for.
+ * @addr: The user virtual address the first page is mapped at.
+ * @start_ptep: Page table pointer for the first entry.
+ * @pte: Page table entry for the first page.
+ * @max_nr: The maximum number of table entries to consider.
+ * @flags: Flags to modify the PTE batch semantics.
+ * @any_writable: Optional pointer to indicate whether any entry except the
+ *		  first one is writable.
+ *
+ * Detect a PTE batch: consecutive (present) PTEs that map consecutive
+ * pages of the same large folio.
+ *
+ * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN,
+ * the accessed bit, writable bit, dirty bit (with FPB_IGNORE_DIRTY) and
+ * soft-dirty bit (with FPB_IGNORE_SOFT_DIRTY).
+ *
+ * start_ptep must map any page of the folio. max_nr must be at least one and
+ * must be limited by the caller so scanning cannot exceed a single page table.
+ *
+ * Return: the number of table entries in the batch.
+ */
+static inline int folio_pte_batch(struct folio *folio, unsigned long addr,
+		pte_t *start_ptep, pte_t pte, int max_nr, fpb_t flags,
+		bool *any_writable)
+{
+	unsigned long folio_end_pfn = folio_pfn(folio) + folio_nr_pages(folio);
+	const pte_t *end_ptep = start_ptep + max_nr;
+	pte_t expected_pte, *ptep;
+	bool writable;
+	int nr;
+
+	if (any_writable)
+		*any_writable = false;
+
+	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
+	VM_WARN_ON_FOLIO(!folio_test_large(folio) || max_nr < 1, folio);
+	VM_WARN_ON_FOLIO(page_folio(pfn_to_page(pte_pfn(pte))) != folio, folio);
+
+	nr = pte_batch_hint(start_ptep, pte);
+	expected_pte = __pte_batch_clear_ignored(pte_advance_pfn(pte, nr), flags);
+	ptep = start_ptep + nr;
+
+	while (ptep < end_ptep) {
+		pte = ptep_get(ptep);
+		if (any_writable)
+			writable = !!pte_write(pte);
+		pte = __pte_batch_clear_ignored(pte, flags);
+
+		if (!pte_same(pte, expected_pte))
+			break;
+
+		/*
+		 * Stop immediately once we reached the end of the folio. In
+		 * corner cases the next PFN might fall into a different
+		 * folio.
+		 */
+		if (pte_pfn(pte) >= folio_end_pfn)
+			break;
+
+		if (any_writable)
+			*any_writable |= writable;
+
+		nr = pte_batch_hint(ptep, pte);
+		expected_pte = pte_advance_pfn(expected_pte, nr);
+		ptep += nr;
+	}
+
+	return min(ptep - start_ptep, max_nr);
+}
+
 void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
 						int nr_throttled);
 static inline void acct_reclaim_writeback(struct folio *folio)
--- a/mm/memory.c~mm-make-folio_pte_batch-available-outside-of-mm-memoryc
+++ a/mm/memory.c
@@ -953,82 +953,6 @@ static __always_inline void __copy_prese
 	set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
 }
 
-/* Flags for folio_pte_batch(). */
-typedef int __bitwise fpb_t;
-
-/* Compare PTEs after pte_mkclean(), ignoring the dirty bit. */
-#define FPB_IGNORE_DIRTY		((__force fpb_t)BIT(0))
-
-/* Compare PTEs after pte_clear_soft_dirty(), ignoring the soft-dirty bit. */
-#define FPB_IGNORE_SOFT_DIRTY		((__force fpb_t)BIT(1))
-
-static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
-{
-	if (flags & FPB_IGNORE_DIRTY)
-		pte = pte_mkclean(pte);
-	if (likely(flags & FPB_IGNORE_SOFT_DIRTY))
-		pte = pte_clear_soft_dirty(pte);
-	return pte_wrprotect(pte_mkold(pte));
-}
-
-/*
- * Detect a PTE batch: consecutive (present) PTEs that map consecutive
- * pages of the same folio.
- *
- * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN,
- * the accessed bit, writable bit, dirty bit (with FPB_IGNORE_DIRTY) and
- * soft-dirty bit (with FPB_IGNORE_SOFT_DIRTY).
- *
- * If "any_writable" is set, it will indicate if any other PTE besides the
- * first (given) PTE is writable.
- */
-static inline int folio_pte_batch(struct folio *folio, unsigned long addr,
-		pte_t *start_ptep, pte_t pte, int max_nr, fpb_t flags,
-		bool *any_writable)
-{
-	unsigned long folio_end_pfn = folio_pfn(folio) + folio_nr_pages(folio);
-	const pte_t *end_ptep = start_ptep + max_nr;
-	pte_t expected_pte, *ptep;
-	bool writable;
-	int nr;
-
-	if (any_writable)
-		*any_writable = false;
-
-	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
-
-	nr = pte_batch_hint(start_ptep, pte);
-	expected_pte = __pte_batch_clear_ignored(pte_advance_pfn(pte, nr), flags);
-	ptep = start_ptep + nr;
-
-	while (ptep < end_ptep) {
-		pte = ptep_get(ptep);
-		if (any_writable)
-			writable = !!pte_write(pte);
-		pte = __pte_batch_clear_ignored(pte, flags);
-
-		if (!pte_same(pte, expected_pte))
-			break;
-
-		/*
-		 * Stop immediately once we reached the end of the folio. In
-		 * corner cases the next PFN might fall into a different
-		 * folio.
-		 */
-		if (pte_pfn(pte) >= folio_end_pfn)
-			break;
-
-		if (any_writable)
-			*any_writable |= writable;
-
-		nr = pte_batch_hint(ptep, pte);
-		expected_pte = pte_advance_pfn(expected_pte, nr);
-		ptep += nr;
-	}
-
-	return min(ptep - start_ptep, max_nr);
-}
-
 /*
  * Copy one present PTE, trying to batch-process subsequent PTEs that map
  * consecutive pages of the same folio by copying them as well.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

docs-mm-damon-design-remove-the-details-for-pageout-as-paddr-doesnt-use-madv_pageout.patch
mm-madvise-pageout-ignore-references-rather-than-clearing-young.patch
mm-make-folio_pte_batch-available-outside-of-mm-memoryc.patch

