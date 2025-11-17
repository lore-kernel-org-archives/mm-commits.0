Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1FC1A3179
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343229; cv=none; b=T2eERY9BrXA++sUVyhVqEwbOKMb+K9Juwdm6sTEDxIbnFbn6+ySrnrClA6FjqfReilT5zBZ7bPO8rV2F6HRpW1MSwGdFLqrQoW+5I3NzK3YaeEyW3D21OKJv4svE6kEBTckiZhVfpc1UWJS8OrSjgCY9gWBOHdyEaFv8hEboS7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343229; c=relaxed/simple;
	bh=KLzuMXWtbONrgu1Q6k+J439wEkugqgfEbPrhi/2HzLA=;
	h=Date:To:From:Subject:Message-Id; b=mEqB/ohPwPz5zRUzgYJKKucPLqUWOdPvDMFjDgidwaaILlimosDTaGYUeSZY7p5yl9iyyDaU/6hdpmy8+MtqlI2AQ9suc0Lhby+UBb6pLkg28UuhfuMnM0uIN6rNC+HWaRmRTkNijTnw6D71HdyNO0MYRLfLYcfzjSzeXg+sBKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=atg3zVhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="atg3zVhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917E7C19423;
	Mon, 17 Nov 2025 01:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343229;
	bh=KLzuMXWtbONrgu1Q6k+J439wEkugqgfEbPrhi/2HzLA=;
	h=Date:To:From:Subject:From;
	b=atg3zVhZsrDP1qSWVUyGuAQwRfp2SDJDCxH3TYn94yjzFVQmYTmU20Axx+ACcjhlo
	 l8PgTWh874sOXman1pWaUWKUUf4Caxp3MoHqRiNyL73B5bZWDDaAiO6R7nU6tV/h7J
	 9ySfbCneCjUQERe/PsieKek7P7UGzP/SQpgsYcSs=
Date: Sun, 16 Nov 2025 17:33:49 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch removed from -mm tree
Message-Id: <20251117013349.917E7C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: optimize and simplify folio stat update after split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: optimize and simplify folio stat update after split
Date: Tue, 21 Oct 2025 21:21:41 +0000

The loop executed after a successful folio split currently has two
combined responsibilities:

  * updating statistics for the new folios
  * determining the folio for the next split iteration.

This commit refactors the logic to directly calculate and update folio
statistics, eliminating the need for the iteration step.

We can do this because all necessary information is already available:

  * All resulting new folios have the same order, which is @split_order.
  * The exact number of new folios can be calculated directly using
    @old_order and @split_order.
  * The folio for the subsequent split is simply the one containing
    @split_at.

By leveraging this knowledge, we can achieve the stat update more cleanly
and efficiently without the looping logic.

Link: https://lkml.kernel.org/r/20251021212142.25766-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split
+++ a/mm/huge_memory.c
@@ -3404,7 +3404,6 @@ static int __split_unmapped_folio(struct
 	const bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
-	struct folio *next;
 	int split_order;
 
 	/*
@@ -3414,9 +3413,8 @@ static int __split_unmapped_folio(struct
 	for (split_order = start_order;
 	     split_order >= new_order;
 	     split_order--) {
-		struct folio *end_folio = folio_next(folio);
 		int old_order = folio_order(folio);
-		struct folio *new_folio;
+		int nr_new_folios = 1UL << (old_order - split_order);
 
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
@@ -3445,19 +3443,11 @@ static int __split_unmapped_folio(struct
 		pgalloc_tag_split(folio, old_order, split_order);
 		__split_folio_to_order(folio, old_order, split_order);
 
-		if (is_anon)
+		if (is_anon) {
 			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
-		/*
-		 * Iterate through after-split folios and update folio stats.
-		 */
-		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
-			next = folio_next(new_folio);
-			if (new_folio == page_folio(split_at))
-				folio = new_folio;
-			if (is_anon)
-				mod_mthp_stat(folio_order(new_folio),
-					      MTHP_STAT_NR_ANON, 1);
+			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
 		}
+		folio = page_folio(split_at);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-introduce-enum-split_type-for-clarity.patch
mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch
mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch
mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch
mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table.patch

