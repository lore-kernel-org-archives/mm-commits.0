Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EA623F40C
	for <mm-commits@vger.kernel.org>; Wed,  2 Jul 2025 21:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751493018; cv=none; b=GUkNdzGA2RARtn9KM+oy5xOFU8KbO4wQPoD4Bxy99CRNLZR6h2OJZnfWIAusyR5OeRDtpOVEGh963ZcA9a4M+7npbiwhrCOxKDzjrpwyDNoAKm8JFOLEH5f6sasDuW+nRPap3cj7HSUJ4RmWB4CkquKyyqBd1ogQtxfVoWSBMp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751493018; c=relaxed/simple;
	bh=T4lqWFLtoySYxn+1o5geHR2o04btXOizMJZsVt5Bzfs=;
	h=Date:To:From:Subject:Message-Id; b=Y0JTH4vfJOevS5fEL/telKFNVICxSC06+JiPp+ELf0Wi97wqIiQsIi8rbpXoSBMfNl5p4P6Nyzn+yDNakHbvm3qyJ6ei7OULxOT8auuyGOZrVUOQiMut6NtcOWedU6qfZtx9e12UIh0vtJ7dmXEGC++hM3z3kxRLNbvI9GRHBZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KYmP/9eG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KYmP/9eG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7604C4CEE7;
	Wed,  2 Jul 2025 21:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751493016;
	bh=T4lqWFLtoySYxn+1o5geHR2o04btXOizMJZsVt5Bzfs=;
	h=Date:To:From:Subject:From;
	b=KYmP/9eGjIAuG97iPYKRSxalqVZcw5lkiDtLkIxS+Yr2LX/Kp7ui4AdqeOvev6jOE
	 TuY84twx6rqATrkOHO6SbCL6VWmoebFQkQ+NR5EeICSJtQpIy/W3/R790K7MOh72uv
	 TRAqnA1D9gi2nfX8h1qa7vbp7KL9uNmbjx/YLxg4=
Date: Wed, 02 Jul 2025 14:50:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,osalvador@suse.de,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,byungchul@sk.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-smaller-folio_pte_batch-improvements.patch added to mm-new branch
Message-Id: <20250702215016.B7604C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: smaller folio_pte_batch() improvements
has been added to the -mm mm-new branch.  Its filename is
     mm-smaller-folio_pte_batch-improvements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-smaller-folio_pte_batch-improvements.patch

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
Subject: mm: smaller folio_pte_batch() improvements
Date: Wed, 2 Jul 2025 12:49:24 +0200

Let's clean up a bit:

(1) No need for start_ptep vs. ptep anymore, we can simply use ptep.

(2) Let's switch to "unsigned int" for everything. Negative values do
    not make sense.

(3) We can simplify the code by leaving the pte unchanged after the
    pte_same() check.

(4) Clarify that we should never exceed a single VMA; it indicates a
    problem in the caller.

No functional change intended.

Link: https://lkml.kernel.org/r/20250702104926.212243-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

--- a/mm/internal.h~mm-smaller-folio_pte_batch-improvements
+++ a/mm/internal.h
@@ -221,7 +221,7 @@ static inline pte_t __pte_batch_clear_ig
  * folio_pte_batch - detect a PTE batch for a large folio
  * @folio: The large folio to detect a PTE batch for.
  * @addr: The user virtual address the first page is mapped at.
- * @start_ptep: Page table pointer for the first entry.
+ * @ptep: Page table pointer for the first entry.
  * @pte: Page table entry for the first page.
  * @max_nr: The maximum number of table entries to consider.
  * @flags: Flags to modify the PTE batch semantics.
@@ -233,24 +233,24 @@ static inline pte_t __pte_batch_clear_ig
  *		  first one is dirty.
  *
  * Detect a PTE batch: consecutive (present) PTEs that map consecutive
- * pages of the same large folio.
+ * pages of the same large folio in a single VMA and a single page table.
  *
  * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN,
  * the accessed bit, writable bit, dirty bit (unless FPB_RESPECT_DIRTY is set)
  * and soft-dirty bit (unless FPB_RESPECT_SOFT_DIRTY is set).
  *
- * start_ptep must map any page of the folio. max_nr must be at least one and
- * must be limited by the caller so scanning cannot exceed a single page table.
+ * @ptep must map any page of the folio. max_nr must be at least one and
+ * must be limited by the caller so scanning cannot exceed a single VMA and
+ * a single page table.
  *
  * Return: the number of table entries in the batch.
  */
-static inline int folio_pte_batch(struct folio *folio, unsigned long addr,
-		pte_t *start_ptep, pte_t pte, int max_nr, fpb_t flags,
+static inline unsigned int folio_pte_batch(struct folio *folio, unsigned long addr,
+		pte_t *ptep, pte_t pte, unsigned int max_nr, fpb_t flags,
 		bool *any_writable, bool *any_young, bool *any_dirty)
 {
-	pte_t expected_pte, *ptep;
-	bool writable, young, dirty;
-	int nr, cur_nr;
+	unsigned int nr, cur_nr;
+	pte_t expected_pte;
 
 	if (any_writable)
 		*any_writable = false;
@@ -267,29 +267,22 @@ static inline int folio_pte_batch(struct
 	max_nr = min_t(unsigned long, max_nr,
 		       folio_pfn(folio) + folio_nr_pages(folio) - pte_pfn(pte));
 
-	nr = pte_batch_hint(start_ptep, pte);
+	nr = pte_batch_hint(ptep, pte);
 	expected_pte = __pte_batch_clear_ignored(pte_advance_pfn(pte, nr), flags);
-	ptep = start_ptep + nr;
+	ptep = ptep + nr;
 
 	while (nr < max_nr) {
 		pte = ptep_get(ptep);
-		if (any_writable)
-			writable = !!pte_write(pte);
-		if (any_young)
-			young = !!pte_young(pte);
-		if (any_dirty)
-			dirty = !!pte_dirty(pte);
-		pte = __pte_batch_clear_ignored(pte, flags);
 
-		if (!pte_same(pte, expected_pte))
+		if (!pte_same(__pte_batch_clear_ignored(pte, flags), expected_pte))
 			break;
 
 		if (any_writable)
-			*any_writable |= writable;
+			*any_writable |= pte_write(pte);
 		if (any_young)
-			*any_young |= young;
+			*any_young |= pte_young(pte);
 		if (any_dirty)
-			*any_dirty |= dirty;
+			*any_dirty |= pte_dirty(pte);
 
 		cur_nr = pte_batch_hint(ptep, pte);
 		expected_pte = pte_advance_pfn(expected_pte, cur_nr);
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-remove-vm_bug_ons.patch
mm-gup-remove-vm_bug_ons-fix.patch
mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch
mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch

