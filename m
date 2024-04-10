Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9F31E877
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712783331; cv=none; b=t/oTGFNqYlVSRyIx1JH+A4zkNrp3ZmUKwGy8wOjHaHwuHx0uEn5/nIM86xjePCcSy6TqMgHl5xWS6O+UvLYIswM/0qc3nNCJZfS0BRr8noxfEq9RN7QDpYLm6yKBd5ypGalvP57R0+ZlObHnPzKnEeOGZ3JZnAvBjJ/ryON70Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712783331; c=relaxed/simple;
	bh=8t8Jivesw6dMunC7q7/GedLaRBpelkMzkku33/wgwsY=;
	h=Date:To:From:Subject:Message-Id; b=F9CfHIEvuNcv8S76uPbRVnteBSO8ZnDgrdBHwj/18y1MowEXKVZtTGefNiTki79fKToozzayergQZ7Qye/JRqHtXbsmt70SDNWFyEUknRyCKgC139rRO2x2um+J6oL1sIY5AD6BtRCKw1mUGhwsTk8HZiQ5/kPSDhEXrthLAdVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mo9ZXhhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mo9ZXhhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BC2C433C7;
	Wed, 10 Apr 2024 21:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712783331;
	bh=8t8Jivesw6dMunC7q7/GedLaRBpelkMzkku33/wgwsY=;
	h=Date:To:From:Subject:From;
	b=Mo9ZXhhKBSTTMGfq0pbwR7lVn8mCv0lSNe7FRbNR7ORW+ilouz+siK6In028QZcX3
	 L0+oF4LAjnbeSECWhpx48s7pR8N40hn2T592EFDREy4DylqxIadyNedVGYt9M8PbCC
	 RCAHUFsTj8BkyxQwGtLg1CAxvUJ0E4gPigw8GXeI=
Date: Wed, 10 Apr 2024 14:08:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,ryan.roberts@arm.com,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_pte_batch-add-an-output-argument-to-reture-if-all-swap-entries-are-exclusive.patch added to mm-unstable branch
Message-Id: <20240410210851.05BC2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap_pte_batch: add an output argument to reture if all swap entries are exclusive
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap_pte_batch-add-an-output-argument-to-reture-if-all-swap-entries-are-exclusive.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_pte_batch-add-an-output-argument-to-reture-if-all-swap-entries-are-exclusive.patch

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
Subject: mm: swap_pte_batch: add an output argument to reture if all swap entries are exclusive
Date: Tue, 9 Apr 2024 20:26:29 +1200

Add a boolean argument named any_shared.  If any of the swap entries are
non-exclusive, set any_shared to true.  The function do_swap_page() can
then utilize this information to determine whether the entire large folio
can be reused.

Link: https://lkml.kernel.org/r/20240409082631.187483-4-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    9 ++++++++-
 mm/madvise.c  |    2 +-
 mm/memory.c   |    2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/mm/internal.h~mm-swap_pte_batch-add-an-output-argument-to-reture-if-all-swap-entries-are-exclusive
+++ a/mm/internal.h
@@ -241,7 +241,8 @@ static inline pte_t pte_next_swp_offset(
  *
  * Return: the number of table entries in the batch.
  */
-static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
+static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte,
+				bool *any_shared)
 {
 	pte_t expected_pte = pte_next_swp_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
@@ -251,12 +252,18 @@ static inline int swap_pte_batch(pte_t *
 	VM_WARN_ON(!is_swap_pte(pte));
 	VM_WARN_ON(non_swap_entry(pte_to_swp_entry(pte)));
 
+	if (any_shared)
+		*any_shared |= !pte_swp_exclusive(pte);
+
 	while (ptep < end_ptep) {
 		pte = ptep_get(ptep);
 
 		if (!pte_same(pte, expected_pte))
 			break;
 
+		if (any_shared)
+			*any_shared |= !pte_swp_exclusive(pte);
+
 		expected_pte = pte_next_swp_offset(expected_pte);
 		ptep++;
 	}
--- a/mm/madvise.c~mm-swap_pte_batch-add-an-output-argument-to-reture-if-all-swap-entries-are-exclusive
+++ a/mm/madvise.c
@@ -671,7 +671,7 @@ static int madvise_free_pte_range(pmd_t
 			entry = pte_to_swp_entry(ptent);
 			if (!non_swap_entry(entry)) {
 				max_nr = (end - addr) / PAGE_SIZE;
-				nr = swap_pte_batch(pte, max_nr, ptent);
+				nr = swap_pte_batch(pte, max_nr, ptent, NULL);
 				nr_swap -= nr;
 				free_swap_and_cache_nr(entry, nr);
 				clear_not_present_full_ptes(mm, addr, pte, nr, tlb->fullmm);
--- a/mm/memory.c~mm-swap_pte_batch-add-an-output-argument-to-reture-if-all-swap-entries-are-exclusive
+++ a/mm/memory.c
@@ -1637,7 +1637,7 @@ static unsigned long zap_pte_range(struc
 			folio_put(folio);
 		} else if (!non_swap_entry(entry)) {
 			max_nr = (end - addr) / PAGE_SIZE;
-			nr = swap_pte_batch(pte, max_nr, ptent);
+			nr = swap_pte_batch(pte, max_nr, ptent, NULL);
 			/* Genuine swap entries, hence a private anon pages */
 			if (!should_zap_cows(details))
 				continue;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch
mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters.patch
mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters-fix.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch
mm-swap_pte_batch-add-an-output-argument-to-reture-if-all-swap-entries-are-exclusive.patch
mm-add-per-order-mthp-swpin_refault-counter.patch

