Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CE62DF3F2
	for <mm-commits@vger.kernel.org>; Thu, 16 Oct 2025 21:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760649264; cv=none; b=N9rOTUD4CEs4mHvY8nH7xlvsfuuqwX3xFx6nbxRvcR6fZfOi+Igtd8HoHaQ8C60dbig/wOtiZZjYPHet5+ePeJnyO859hiq5sgGKD4ZOPMCkqY/PrE+Dk87wgoc53EOjFHOGT/CHGX43gjWLY9kM59GvWiDyOuahDQBeyC57fgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760649264; c=relaxed/simple;
	bh=Vc3/vNAM3jscMdl6XWWmVZIWxlv+sbO/1oMRM22zcYk=;
	h=Date:To:From:Subject:Message-Id; b=GR1FP+cBXU7WczSOu3inxc2Dl2dJ8gkjPswdvnmtGCUMmWIn8lA3edRMN01JTqqrPM5wj9hXafcVhrjTe5ElrSHM4LpfGnVWcYNJYAc6xB+3yEAWeZuPbl2R5JM2vZ7CBIBP6HD/myXM7xoseSViFOGAJUoH9gjPaCLGH2Qvhhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vzWW0QeN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vzWW0QeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254D6C4CEF9;
	Thu, 16 Oct 2025 21:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760649264;
	bh=Vc3/vNAM3jscMdl6XWWmVZIWxlv+sbO/1oMRM22zcYk=;
	h=Date:To:From:Subject:From;
	b=vzWW0QeNeWV+TuSIp6xH/SiC+Ra3Yn5UOh+trNsSUoZW5AonNITmWjvgHOZM0QCUE
	 uXlAz65A3JSBTy4cpq+4Qo1C9rYwz63xbo7j5KUH5VFjfyQweJio5GQlhU6vXzXrH+
	 45vMMPBc4jliQJrcnIM2VKZ6iM0QDATx+XOzeg6U=
Date: Thu, 16 Oct 2025 14:14:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-optimize-and-simplify-__split_unmapped_folio-logic.patch added to mm-new branch
Message-Id: <20251016211424.254D6C4CEF9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: optimize and simplify __split_unmapped_folio() logic
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-optimize-and-simplify-__split_unmapped_folio-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-optimize-and-simplify-__split_unmapped_folio-logic.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: optimize and simplify __split_unmapped_folio() logic
Date: Thu, 16 Oct 2025 00:46:13 +0000

Existing __split_unmapped_folio() code splits the given folio and update
stats, but it is complicated to understand.

After simplification, __split_unmapped_folio() directly calculate and
update the folio statistics upon a successful split:

* All resulting folios are @split_order.

* The number of new folios are calculated directly from @old_order
  and @split_order.

* The folio for the next split is identified as the one containing
  @split_at.

* An xas_try_split() error is returned directly without worrying
  about stats updates.

Link: https://lkml.kernel.org/r/20251016004613.514-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   68 +++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 48 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-optimize-and-simplify-__split_unmapped_folio-logic
+++ a/mm/huge_memory.c
@@ -3596,15 +3596,9 @@ static int __split_unmapped_folio(struct
 		struct address_space *mapping, bool uniform_split)
 {
 	bool is_anon = folio_test_anon(folio);
-	int order = folio_order(folio);
-	int start_order = uniform_split ? new_order : order - 1;
-	bool stop_split = false;
-	struct folio *next;
+	int old_order = folio_order(folio);
+	int start_order = uniform_split ? new_order : old_order - 1;
 	int split_order;
-	int ret = 0;
-
-	if (is_anon)
-		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
 	folio_clear_has_hwpoisoned(folio);
 
@@ -3613,17 +3607,13 @@ static int __split_unmapped_folio(struct
 	 * folio is split to new_order directly.
 	 */
 	for (split_order = start_order;
-	     split_order >= new_order && !stop_split;
+	     split_order >= new_order;
 	     split_order--) {
-		struct folio *end_folio = folio_next(folio);
-		int old_order = folio_order(folio);
-		struct folio *new_folio;
+		int nr_new_folios = 1UL << (old_order - split_order);
 
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
 			continue;
-		if (uniform_split && split_order != new_order)
-			continue;
 
 		if (mapping) {
 			/*
@@ -3636,49 +3626,31 @@ static int __split_unmapped_folio(struct
 			else {
 				xas_set_order(xas, folio->index, split_order);
 				xas_try_split(xas, folio, old_order);
-				if (xas_error(xas)) {
-					ret = xas_error(xas);
-					stop_split = true;
-				}
+				if (xas_error(xas))
+					return xas_error(xas);
 			}
 		}
 
-		if (!stop_split) {
-			folio_split_memcg_refs(folio, old_order, split_order);
-			split_page_owner(&folio->page, old_order, split_order);
-			pgalloc_tag_split(folio, old_order, split_order);
-
-			__split_folio_to_order(folio, old_order, split_order);
+		folio_split_memcg_refs(folio, old_order, split_order);
+		split_page_owner(&folio->page, old_order, split_order);
+		pgalloc_tag_split(folio, old_order, split_order);
+		__split_folio_to_order(folio, old_order, split_order);
+
+		if (is_anon) {
+			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
+			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
 		}
 
 		/*
-		 * Iterate through after-split folios and update folio stats.
-		 * But in buddy allocator like split, the folio
-		 * containing the specified page is skipped until its order
-		 * is new_order, since the folio will be worked on in next
-		 * iteration.
+		 * For uniform split, we have finished the job.
+		 * For non-uniform split, we assign folio to the one the one
+		 * containing @split_at and assign @old_order to @split_order.
 		 */
-		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
-			next = folio_next(new_folio);
-			/*
-			 * for buddy allocator like split, new_folio containing
-			 * @split_at page could be split again, thus do not
-			 * change stats yet. Wait until new_folio's order is
-			 * @new_order or stop_split is set to true by the above
-			 * xas_split() failure.
-			 */
-			if (new_folio == page_folio(split_at)) {
-				folio = new_folio;
-				if (split_order != new_order && !stop_split)
-					continue;
-			}
-			if (is_anon)
-				mod_mthp_stat(folio_order(new_folio),
-					      MTHP_STAT_NR_ANON, 1);
-		}
+		folio = page_folio(split_at);
+		old_order = split_order;
 	}
 
-	return ret;
+	return 0;
 }
 
 bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-cache-folio-attribute-in-__split_unmapped_folio.patch
mm-huge_memory-optimize-and-simplify-__split_unmapped_folio-logic.patch

