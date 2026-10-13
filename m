Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D785187EC
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 18:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791915966; cv=none; b=XQta9U2attawSjgZ5L4rKyX9mCnHL4sCRrwPi0BMahSRA4+yric+VvXK9Mx5yFLU/VunzkcvxKmWeg3b1uqDgeEbeo2CwvWYukwT/Tibub3RL4S4kJh43I1h5QcVMltAhGYeQ6zIFMpt87XqCuc9FleF4SdhWMJFBdnVF1TgJuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791915966; c=relaxed/simple;
	bh=1MaDke0kVrUNC/dmgL4Edno5vpT8X0TTI+9rsplFWD8=;
	h=Date:To:From:Subject:Message-Id; b=jngyE04g7wy3wyIo/xQBYAMfcukHxiweubjScq/2IdLB/rM6M5G9MGHNbueaZBUPSihqWM4ZsxpO6mhcdun42Lk6Bbo0oILEDNer2GOgplX0gGBrG9IxiXF4v79wimuFc2pBt1wML6MuZMV3NC6ZWEuiPegmTcJPd9RTPNL/u/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jk2q03yx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jk2q03yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE191F000FF;
	Tue, 13 Oct 2026 18:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791915964;
	bh=yC58r0YqIkhT9xBU+Vr78dyTZHUSPREKkGd3jsHWk7c=;
	h=Date:To:From:Subject;
	b=Jk2q03yxwf5JTDSZrNLYNDU4l/q3gvKjAIMMMRKRGiAvQzBKtHpj4DD0zfrpZC+xn
	 fhCYQUz9hEcBo84cTUUNFvmu5mxfdfS+5VFqYdZZAnsSohp7GPcB9o8VbPKnjQ+T/y
	 xycYXIFowI7f0r2RhVbaasJj80mxxPEBwEFGjDTg=
Date: Tue, 13 Oct 2026 11:26:04 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch removed from -mm tree
Message-Id: <20261013182604.8DE191F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
Date: Mon, 28 Sep 2026 11:06:17 +0100

The name says less than the bit means.  A set bit means not only that the
PTE is present, but also that it passed the other checks: uffd,
lazyfree, anonymity, sharing.  The PTE can be considered a collapse
source.

mthp_collapse() then reads the bitmap starting at the PMD order, so the
bitmap is not specific to mTHP either.

Name it for what a set bit means, and update the comments that named it.

No functional change.

Link: https://lore.kernel.org/20260928100630.21870-4-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
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
@@ -1512,15 +1512,15 @@ static unsigned int max_order_from_offse
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
@@ -1529,7 +1529,7 @@ static enum scan_result mthp_collapse(st
 		unsigned long address, int referenced, int unmapped,
 		struct collapse_control *cc, unsigned long enabled_orders)
 {
-	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
+	unsigned int nr_eligible_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
 	int collapsed = 0;
 	bool alloc_failed = false;
@@ -1544,18 +1544,18 @@ static enum scan_result mthp_collapse(st
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
@@ -1761,8 +1761,8 @@ static enum scan_result collapse_scan_pm
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

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

