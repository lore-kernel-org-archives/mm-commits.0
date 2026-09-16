Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973784B4864
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 22:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789598940; cv=none; b=lojwpc/qBcMG+ppFaEdA06/8yUe9iXo67RrWEG/IF9XDjsZsAD2jECCRRnh5NDeNchku7WV0GmN0Tq/5dvy3U5v1TiD5SPnEdWSJAhIQySMQWt4+fbQeUA4KO1h87drfqRFGs3ySdGyIiAtOf6Trmak5bhw5GQs/4KNChXvVAYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789598940; c=relaxed/simple;
	bh=73Nb1VTdf3hVEVQPK4VaYNsVpRKM8sb1jRchVjuVhsc=;
	h=Date:To:From:Subject:Message-Id; b=tKjzyzVCMJ0rKxH/g3dvtkftDBw0/Am9mmrJ89FpYxwbtTLETU6ZHKRAGK/Hrl0ojo7md00TYlAHfcKL4QMysBGIGFq1l6lDulMkEQ64IXoQVwsalBpeHpGOIdJiBp3lV2/23SafDUKncRLt4mXdyRlTH120Gzkub5Ul2uscI5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zFrSFTSz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zFrSFTSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E314F1F00899;
	Wed, 16 Sep 2026 22:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789598929;
	bh=ZKCG2MJv2FXOm4aGaD0LdiVBF48c+FzfgT/joYuf4lQ=;
	h=Date:To:From:Subject;
	b=zFrSFTSznkZ0tHzR7oRIgeLM7DYX4xb6tgEU2ZGH2bjZTOMQo5XQVldJogFCC9Fv4
	 KciTh/ZwzxovzuCyFV+2BV6n8++VRko+/enodVSOhx2WfpGbEvZLq8DewzjPvTG4Vq
	 JzK/JD6rcOhzYz6ebuyojnp9VjZhwo0l4OR4XyHU=
Date: Wed, 16 Sep 2026 15:48:48 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch added to mm-unstable branch
Message-Id: <20260916224848.E314F1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
Date: Wed, 16 Sep 2026 10:31:30 +0100

The name says less than the bit means.  A set bit means not only that the
PTE is present, but also that it passed the other checks: uffd, lazyfree,
anonymity, sharing.  The PTE can be considered a collapse source.

mthp_collapse() then reads the bitmap starting at the PMD order, so the
bitmap is not specific to mTHP either.

Name it for what a set bit means, and update the comments that named it.

No functional change.

Assisted-by: LLM
Link: https://lore.kernel.org/20260916093145.4022188-4-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/khugepaged.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes
+++ a/mm/khugepaged.c
@@ -115,8 +115,8 @@ struct collapse_control {
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
 
-	/* Each bit represents a single occupied (!none/zero) page. */
-	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
+	/* Each bit marks a PTE the scan accepted as a collapse source */
+	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
 };
 
 /**
@@ -627,7 +627,7 @@ static void collapse_control_init_scan(s
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
-	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
+	bitmap_zero(cc->eligible_ptes, MAX_PTRS_PER_PTE);
 }
 
 static void release_pte_folio(struct folio *folio)
@@ -1482,15 +1482,15 @@ static unsigned int max_order_from_offse
  * mthp_collapse() consumes the bitmap that is generated during
  * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
  *
- * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
- * page. We start at the PMD order and check if it is eligible for collapse;
+ * Each bit in cc->eligible_ptes marks a PTE the scan accepted as a collapse
+ * source. We start at the PMD order and check if it is eligible for collapse;
  * if not, we check the left and right halves of the PTE page table we are
  * examining at a lower order.
  *
- * For each of these, we determine how many PTE entries are occupied in the
- * range of PTE entries we propose to collapse, then we compare this to a
- * threshold number of PTE entries which would need to be occupied for a
- * collapse to be permitted at that order (accounting for max_ptes_none).
+ * For each of these, we count the eligible PTEs in the range we propose to
+ * collapse, then we compare this to the number of eligible PTEs the range
+ * would need for a collapse to be permitted at that order (accounting for
+ * max_ptes_none).
  *
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
@@ -1499,7 +1499,7 @@ static enum scan_result mthp_collapse(st
 		unsigned long address, int referenced, int unmapped,
 		struct collapse_control *cc, unsigned long enabled_orders)
 {
-	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
+	unsigned int nr_eligible_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
 	int collapsed = 0;
 	bool alloc_failed = false;
@@ -1514,18 +1514,18 @@ static enum scan_result mthp_collapse(st
 			goto next_order;
 
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
-		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
+		nr_eligible_ptes = bitmap_weight_from(cc->eligible_ptes, offset,
 						      offset + nr_ptes);
 
 		/*
 		 * Swap PTEs accepted during the scan are counted in @unmapped,
-		 * not in the present-PTE bitmap. Account them for the PMD-order
+		 * not in cc->eligible_ptes. Account them for the PMD-order
 		 * candidate.
 		 */
 		if (is_pmd_order(order))
-			nr_occupied_ptes += unmapped;
+			nr_eligible_ptes += unmapped;
 
-		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
+		if (nr_eligible_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
 
 			collapse_address = address + offset * PAGE_SIZE;
@@ -1731,8 +1731,8 @@ static enum scan_result collapse_scan_pm
 			}
 		}
 
-		/* Set bit for occupied pages */
-		__set_bit(i, cc->mthp_present_ptes);
+		/* The scan accepted this PTE as a collapse source */
+		__set_bit(i, cc->eligible_ptes);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

