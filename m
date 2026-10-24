Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832484;
	b=RirLr4tBNbwSgA4LaaPbTF+Ha+3PYzpimPMf4zMgDkO5picgvRx3XtlSh+6EKjpZX9uS
	 8iVTansXXXKkE7UmKaYLkm9MFvvvD0kygxwVhcDjeKF28N9wCiH8930pF5a064Gi9cZ4y
	 QIBFor7dhknEC6lwYiIueoLf4zq94/bl2/SlfmzJ8HJFOAfapapaF0HiWz6b7ayp+PT9J
	 ixNDwRok9IA2SaChtEIH6pp2/NNCe2bU4Ie3kozWalVA6jxTiBDoZhVMFjrT7lb9+eqro
	 Z9HDrwAsWLVnX6ddCmUOlKJgWacDqsYKLPI6oUrX7nLoDMYFuBM3MLYwamb3FzusTcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832484;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0CYBHkxSD3etpkIItPNFuXqWHLOTIFfGpJWEjvQiodE=;
	b=qYiotXXHoc/e6BJgxR9sEoU7Jeeh6pkGd1164Y9fCOBy4/0p2QK6KnppLxIee/+ZO0vS
	 JCLgXcz+P8+OFQ7/FyeXskaKlZkzPbzA0bTk8AGy4a2WTAQGvQt30p6SSsMrO6I6BEjJv
	 5yUTfLEJzO+ECXnqZkzm3e0NGM1attqrHtKhCA+/Ee110AMu5iqL7hcni8d02674upRPe
	 swqyp5qitrCO3TaDmNiO2mYdqSkQrT+qe2hB2tGaNlVcFpp4aCtsEiJg8TpiAV79PwfN8
	 W7oqhmAa5fuxRBuadMDQF9xYL65Uu/rkzTridzbvsLSaA0IaocxCjZHf6sN8OgYCexQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=T+iJPlRS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388BC606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=T+iJPlRS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024B21F01825;
	Sat, 24 Oct 2026 09:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832484;
	bh=0CYBHkxSD3etpkIItPNFuXqWHLOTIFfGpJWEjvQiodE=;
	h=Date:To:From:Subject;
	b=T+iJPlRS/wG3RDzUEZA+RrSZhtHoLCsy50VkLy77kLZ8kAIL42Jxj1ICghcm+p1iU
	 QCQcZLcxpTFkyQnlIOJNzEEZpgAprZkSlV4yTMAYjLuV0HaqVmLu0BjsYJgAhHky3t
	 +MeGIgxEuwWQ/fKcyH+gEr3qFmU0IH1GaQgqYVV0=
Date: Sat, 24 Oct 2026 02:01:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch removed from -mm tree
Message-Id: <20261024090124.024B21F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
Date: Wed, 14 Oct 2026 18:11:36 +0100

The name says less than the bit means.  A set bit means not only that the
PTE is present, but also that it passed the other checks: uffd,
lazyfree, anonymity, sharing.  The PTE can be considered a collapse
source.

mthp_collapse() then reads the bitmap starting at the PMD order, so the
bitmap is not specific to mTHP either.

Name it for what a set bit means, and update the comments that named it.

No functional change.

Link: https://lore.kernel.org/20261014171145.3292736-4-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
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


