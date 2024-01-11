Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F44951007
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QUd5r6Sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900FEC433C7;
	Thu, 11 Jan 2024 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705005161;
	bh=jpsVYb3fUrsxAaiIpPDRyUeOABj3+zWACvsMtCX4Zuo=;
	h=Date:To:From:Subject:From;
	b=QUd5r6SjDGtQWdIxZfj+eLpJkyorNXEhZbVrPV5zsrqOZZr2RAmUcA2HhX14PgI0p
	 ynUGRZ0G6IJvQsGn0O2GKAsDviXQ+ML07HbL2alz162dnTcj1/bRP24Sp4kkap6YKU
	 /VtW8+7dQ2/Q+LO+MTHB9Qxx+7VoXdgt7rHMSSwg=
Date: Thu, 11 Jan 2024 12:32:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-to-should_zap_page-to-should_zap_folio.patch added to mm-unstable branch
Message-Id: <20240111203241.900FEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert to should_zap_page() to should_zap_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-to-should_zap_page-to-should_zap_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-to-should_zap_page-to-should_zap_folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: convert to should_zap_page() to should_zap_folio()
Date: Thu, 11 Jan 2024 15:24:27 +0000

Make should_zap_page() take a folio and rename it to should_zap_folio() as
preparation for converting mm counter functions to take a folio.  Saves a
call to compound_head() hidden inside PageAnon().

Link: https://lkml.kernel.org/r/20240111152429.3374566-9-willy@infradead.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

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

mm-memory-use-nth_page-in-clear-copy_subpage.patch
s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry.patch
mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch
mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch
mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte.patch
mm-convert-to-should_zap_page-to-should_zap_folio.patch
mm-convert-mm_counter-to-take-a-folio.patch
mm-convert-mm_counter_file-to-take-a-folio.patch

