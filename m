Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635F98BF9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560080; cv=none; b=pJgft5HjU8NjPim0eI38qiD/3mf4e404bIQLP10vFyLwVjUW46A0eVb03SdkkH7NWmvxsVMV8UqxgnDoSNr+9HziQu21ueJVV7ufhY7hjbdf9thx9d740jNB9vSkPtDnLw5dlX9MmISO3yCHVsTQI3krP1irPeUP/5DfEE1XFSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560080; c=relaxed/simple;
	bh=Z45+tvVsmDwHiNsptWw+KWiwnx6nwb0vk3IHcvkWyZw=;
	h=Date:To:From:Subject:Message-Id; b=f8/BYqN6qqyv8PXBMuF7BacM8imFsYfhXYyFMGSPDXFTtzT3xK3w/fSuSlWGbtGcLpszIocryLvTbw6gc/mfqCN99IYKwRnBAaUNcSWFI4T3igQChfxdcim4enUKzF7xltaD0GPmXr7AVLfS2QDb6HpBjUAsSCO/PNNahZoEukI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cutGCKpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cutGCKpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB480C43399;
	Thu, 22 Feb 2024 00:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560079;
	bh=Z45+tvVsmDwHiNsptWw+KWiwnx6nwb0vk3IHcvkWyZw=;
	h=Date:To:From:Subject:From;
	b=cutGCKpiA0hUpKnejf31I5Hy0wHIhz2rhM/SX6uQFXjIuguOhxXk+tIno+0aMuwMT
	 EqNidIl65k1EFtnPCwFz/zpJUBgySGaHQtkFvkuxymqN4zR0iipaQnHqtKdskSEyqt
	 ZtqZoGEVewUyeur4RlH+AmGKRbAjNOArIGznzEPQ=
Date: Wed, 21 Feb 2024 16:01:19 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-to-should_zap_page-to-should_zap_folio.patch removed from -mm tree
Message-Id: <20240222000119.CB480C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert to should_zap_page() to should_zap_folio()
has been removed from the -mm tree.  Its filename was
     mm-convert-to-should_zap_page-to-should_zap_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: convert to should_zap_page() to should_zap_folio()
Date: Thu, 11 Jan 2024 15:24:27 +0000

Make should_zap_page() take a folio and rename it to should_zap_folio() as
preparation for converting mm counter functions to take a folio.  Saves a
call to compound_head() hidden inside PageAnon().

[wangkefeng.wang@huawei.com: fix used-uninitialized warning]
  Link: https://lkml.kernel.org/r/962a7993-fce9-4de8-85cd-25e290f25736@huawei.com
Link: https://lkml.kernel.org/r/20240111152429.3374566-9-willy@infradead.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/mm/memory.c~mm-convert-to-should_zap_page-to-should_zap_folio
+++ a/mm/memory.c
@@ -1369,19 +1369,20 @@ static inline bool should_zap_cows(struc
 	return details->even_cows;
 }
 
-/* Decides whether we should zap this page with the page pointer specified */
-static inline bool should_zap_page(struct zap_details *details, struct page *page)
+/* Decides whether we should zap this folio with the folio pointer specified */
+static inline bool should_zap_folio(struct zap_details *details,
+				    struct folio *folio)
 {
-	/* If we can make a decision without *page.. */
+	/* If we can make a decision without *folio.. */
 	if (should_zap_cows(details))
 		return true;
 
-	/* E.g. the caller passes NULL for the case of a zero page */
-	if (!page)
+	/* E.g. the caller passes NULL for the case of a zero folio */
+	if (!folio)
 		return true;
 
-	/* Otherwise we should only zap non-anon pages */
-	return !PageAnon(page);
+	/* Otherwise we should only zap non-anon folios */
+	return !folio_test_anon(folio);
 }
 
 static inline bool zap_drop_file_uffd_wp(struct zap_details *details)
@@ -1434,7 +1435,7 @@ static unsigned long zap_pte_range(struc
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = ptep_get(pte);
-		struct folio *folio;
+		struct folio *folio = NULL;
 		struct page *page;
 
 		if (pte_none(ptent))
@@ -1447,7 +1448,10 @@ static unsigned long zap_pte_range(struc
 			unsigned int delay_rmap;
 
 			page = vm_normal_page(vma, addr, ptent);
-			if (unlikely(!should_zap_page(details, page)))
+			if (page)
+				folio = page_folio(page);
+
+			if (unlikely(!should_zap_folio(details, folio)))
 				continue;
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
 							tlb->fullmm);
@@ -1460,7 +1464,6 @@ static unsigned long zap_pte_range(struc
 				continue;
 			}
 
-			folio = page_folio(page);
 			delay_rmap = 0;
 			if (!folio_test_anon(folio)) {
 				if (pte_dirty(ptent)) {
@@ -1492,7 +1495,7 @@ static unsigned long zap_pte_range(struc
 		    is_device_exclusive_entry(entry)) {
 			page = pfn_swap_entry_to_page(entry);
 			folio = page_folio(page);
-			if (unlikely(!should_zap_page(details, page)))
+			if (unlikely(!should_zap_folio(details, folio)))
 				continue;
 			/*
 			 * Both device private/exclusive mappings should only
@@ -1513,10 +1516,10 @@ static unsigned long zap_pte_range(struc
 			if (unlikely(!free_swap_and_cache(entry)))
 				print_bad_pte(vma, addr, ptent, NULL);
 		} else if (is_migration_entry(entry)) {
-			page = pfn_swap_entry_to_page(entry);
-			if (!should_zap_page(details, page))
+			folio = pfn_swap_entry_folio(entry);
+			if (!should_zap_folio(details, folio))
 				continue;
-			rss[mm_counter(page)]--;
+			rss[mm_counter(&folio->page)]--;
 		} else if (pte_marker_entry_uffd_wp(entry)) {
 			/*
 			 * For anon: always drop the marker; for file: only
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-compaction-early-termination-in-compact_nodes.patch

