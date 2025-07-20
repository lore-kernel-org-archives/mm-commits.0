Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3382878F34
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976880; cv=none; b=OWroC5orxQI+Oe2wODO3NbJOGoJANCz75e/1kT9NCW+qJIwNJNA3QEKkKCy6uxn+BVPZCc3JZFQvQRNSTQq6csm2MgYfSLYWBkj+b4pQocpxNfHIT63N8x6Bj5eko+wPT4JEk/Wg2OcRb/6GYMWTFruSlDeRlqWCd6jv36AiXe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976880; c=relaxed/simple;
	bh=2KMlHWeUC814d14aS5De3l3vBQwZD5L3xf/nhXJoCms=;
	h=Date:To:From:Subject:Message-Id; b=AduCPOIR4pBAbxQf2bBE+szkO/vaFrGcETNLE8GT03wKzPCsCa9gj4sTNt2kyyVsnkfwbQXHQGJ3VVMyl6Q3Vg9cTpVgegXPGcM7RX84YF1L7xopUewHZA3bLUEKWixofuiP9QDdXqQ4JNdwitiSTYbXTzonVL7qMeoc5gLJ9nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DaMZhKb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DaMZhKb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A580AC4CEE3;
	Sun, 20 Jul 2025 02:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976878;
	bh=2KMlHWeUC814d14aS5De3l3vBQwZD5L3xf/nhXJoCms=;
	h=Date:To:From:Subject:From;
	b=DaMZhKb7kqDMf+E61zrpnRRM6J4+TVNMYzMF3N/+8cwun9FJQ3woQ/Ez/L9PkF70I
	 VN2vrOwjdWXfs6kOmgNS13mKDVoy/+YwKb6WrJzgdU+qpWTBAn8kQGCSiVFHzY2NMV
	 PAVVTty5vTFlEsM1s9ueIipKIIESWR89HrnU9aIA=
Date: Sat, 19 Jul 2025 19:01:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,osalvador@suse.de,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,dev.jain@arm.com,byungchul@sk.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-smaller-folio_pte_batch-improvements.patch removed from -mm tree
Message-Id: <20250720020118.A580AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: smaller folio_pte_batch() improvements
has been removed from the -mm tree.  Its filename was
     mm-smaller-folio_pte_batch-improvements.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Dev Jain <dev.jain@arm.com>
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

mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

