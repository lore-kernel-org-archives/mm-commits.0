Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA07C8BF9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560081; cv=none; b=Jbr3uHE3v1y46OMdleEToCDm0PF5fDuX23pOsK/WfsXPX1/wyRRgZsafvYxqxrVGxGvYsWOGyUwQbCofXT67A1TdChOYb3xgkiR0+dmX3Bv1crwmHVQ28AU/HZDqZHp6SwcD2Q2acV3dLc1nIg4kXlhT2cwkrKEiCneGEngaNwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560081; c=relaxed/simple;
	bh=1BiKdNN/pfms+mjCoGdaqrPOc+1rD6yEiVK2Hu1r6/A=;
	h=Date:To:From:Subject:Message-Id; b=eP22k+ZxiG7nC4qYJRNVAxqdfm6RQgLnzexl4P8xk3349eL1oJp4Kr37DypFoX7TQQgOKq7QcCdB4yK4T9MrdouALifn22llMj76Yu34fYoS3l1jSF5wv/JyY34kaUtzihgGGyzvlTg0GP1GKjn8AXk+q1VR8sE4fzuoH9UIz20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I4VAWsgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I4VAWsgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4020C43390;
	Thu, 22 Feb 2024 00:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560080;
	bh=1BiKdNN/pfms+mjCoGdaqrPOc+1rD6yEiVK2Hu1r6/A=;
	h=Date:To:From:Subject:From;
	b=I4VAWsgT9YjsmYJb9IkFvVannD/QTTzKEx/Cb7A3XtjZ65I5YhjVlvtCwsUJyoJqF
	 6/os8SmF9A3SCB4ltsaOMrx834pHW7D5v175sWE6rzyvSSdH7Wfukt1yBzsM7XUI4y
	 6aauWv1FGZhY29Q+mc3P1pVH5kkqU/oehP4fQvTk=
Date: Wed, 21 Feb 2024 16:01:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-mm_counter-to-take-a-folio.patch removed from -mm tree
Message-Id: <20240222000120.B4020C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert mm_counter() to take a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-mm_counter-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: convert mm_counter() to take a folio
Date: Thu, 11 Jan 2024 15:24:28 +0000

Now all callers of mm_counter() have a folio, convert mm_counter() to take
a folio.  Saves a call to compound_head() hidden inside PageAnon().

Link: https://lkml.kernel.org/r/20240111152429.3374566-10-willy@infradead.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgtable.c |    2 +-
 include/linux/mm.h     |    6 +++---
 mm/memory.c            |   10 +++++-----
 mm/rmap.c              |    8 ++++----
 mm/userfaultfd.c       |    2 +-
 5 files changed, 14 insertions(+), 14 deletions(-)

--- a/arch/s390/mm/pgtable.c~mm-convert-mm_counter-to-take-a-folio
+++ a/arch/s390/mm/pgtable.c
@@ -723,7 +723,7 @@ static void ptep_zap_swap_entry(struct m
 	else if (is_migration_entry(entry)) {
 		struct folio *folio = pfn_swap_entry_folio(entry);
 
-		dec_mm_counter(mm, mm_counter(&folio->page));
+		dec_mm_counter(mm, mm_counter(folio));
 	}
 	free_swap_and_cache(entry);
 }
--- a/include/linux/mm.h~mm-convert-mm_counter-to-take-a-folio
+++ a/include/linux/mm.h
@@ -2603,11 +2603,11 @@ static inline int mm_counter_file(struct
 	return MM_FILEPAGES;
 }
 
-static inline int mm_counter(struct page *page)
+static inline int mm_counter(struct folio *folio)
 {
-	if (PageAnon(page))
+	if (folio_test_anon(folio))
 		return MM_ANONPAGES;
-	return mm_counter_file(page);
+	return mm_counter_file(&folio->page);
 }
 
 static inline unsigned long get_mm_rss(struct mm_struct *mm)
--- a/mm/memory.c~mm-convert-mm_counter-to-take-a-folio
+++ a/mm/memory.c
@@ -808,7 +808,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 	} else if (is_migration_entry(entry)) {
 		folio = pfn_swap_entry_folio(entry);
 
-		rss[mm_counter(&folio->page)]++;
+		rss[mm_counter(folio)]++;
 
 		if (!is_readable_migration_entry(entry) &&
 				is_cow_mapping(vm_flags)) {
@@ -840,7 +840,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		 * keep things as they are.
 		 */
 		folio_get(folio);
-		rss[mm_counter(page)]++;
+		rss[mm_counter(folio)]++;
 		/* Cannot fail as these pages cannot get pinned. */
 		folio_try_dup_anon_rmap_pte(folio, page, src_vma);
 
@@ -1476,7 +1476,7 @@ static unsigned long zap_pte_range(struc
 				if (pte_young(ptent) && likely(vma_has_recency(vma)))
 					folio_mark_accessed(folio);
 			}
-			rss[mm_counter(page)]--;
+			rss[mm_counter(folio)]--;
 			if (!delay_rmap) {
 				folio_remove_rmap_pte(folio, page, vma);
 				if (unlikely(page_mapcount(page) < 0))
@@ -1504,7 +1504,7 @@ static unsigned long zap_pte_range(struc
 			 * see zap_install_uffd_wp_if_needed().
 			 */
 			WARN_ON_ONCE(!vma_is_anonymous(vma));
-			rss[mm_counter(page)]--;
+			rss[mm_counter(folio)]--;
 			if (is_device_private_entry(entry))
 				folio_remove_rmap_pte(folio, page, vma);
 			folio_put(folio);
@@ -1519,7 +1519,7 @@ static unsigned long zap_pte_range(struc
 			folio = pfn_swap_entry_folio(entry);
 			if (!should_zap_folio(details, folio))
 				continue;
-			rss[mm_counter(&folio->page)]--;
+			rss[mm_counter(folio)]--;
 		} else if (pte_marker_entry_uffd_wp(entry)) {
 			/*
 			 * For anon: always drop the marker; for file: only
--- a/mm/rmap.c~mm-convert-mm_counter-to-take-a-folio
+++ a/mm/rmap.c
@@ -1780,7 +1780,7 @@ static bool try_to_unmap_one(struct foli
 				set_huge_pte_at(mm, address, pvmw.pte, pteval,
 						hsz);
 			} else {
-				dec_mm_counter(mm, mm_counter(&folio->page));
+				dec_mm_counter(mm, mm_counter(folio));
 				set_pte_at(mm, address, pvmw.pte, pteval);
 			}
 
@@ -1795,7 +1795,7 @@ static bool try_to_unmap_one(struct foli
 			 * migration) will not expect userfaults on already
 			 * copied pages.
 			 */
-			dec_mm_counter(mm, mm_counter(&folio->page));
+			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
 			swp_entry_t entry = page_swap_entry(subpage);
 			pte_t swp_pte;
@@ -2181,7 +2181,7 @@ static bool try_to_migrate_one(struct fo
 				set_huge_pte_at(mm, address, pvmw.pte, pteval,
 						hsz);
 			} else {
-				dec_mm_counter(mm, mm_counter(&folio->page));
+				dec_mm_counter(mm, mm_counter(folio));
 				set_pte_at(mm, address, pvmw.pte, pteval);
 			}
 
@@ -2196,7 +2196,7 @@ static bool try_to_migrate_one(struct fo
 			 * migration) will not expect userfaults on already
 			 * copied pages.
 			 */
-			dec_mm_counter(mm, mm_counter(&folio->page));
+			dec_mm_counter(mm, mm_counter(folio));
 		} else {
 			swp_entry_t entry;
 			pte_t swp_pte;
--- a/mm/userfaultfd.c~mm-convert-mm_counter-to-take-a-folio
+++ a/mm/userfaultfd.c
@@ -124,7 +124,7 @@ int mfill_atomic_install_pte(pmd_t *dst_
 	 * Must happen after rmap, as mm_counter() checks mapping (via
 	 * PageAnon()), which is set by __page_set_anon_rmap().
 	 */
-	inc_mm_counter(dst_mm, mm_counter(page));
+	inc_mm_counter(dst_mm, mm_counter(folio));
 
 	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-compaction-early-termination-in-compact_nodes.patch

