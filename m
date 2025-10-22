Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3632797B8
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 21:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761169506; cv=none; b=MNgYNmZf5oXIUHQdI7qnV8dbMY4YS6HEFP+ejiTNZh5oYpczdL+l7N6DTflywT4KpIq5pW1wzrp86gKIS1rUCqvaw7xrjKXGpekNKbd7IEUTHLaWXo4tmEvSsbcjrEpy6Vm08hAYaAfPYE9Dg8R3a8SgEiMijO3oJp9xv5WKwLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761169506; c=relaxed/simple;
	bh=a77LTiPkBcO3R8od4DfYERollptXhvNKcEjagn3CWDY=;
	h=Date:To:From:Subject:Message-Id; b=HYq1NXlTdBeYA1q6zKkElWzk151CZLr4fqPmgKE+6K/8KYJ0o0vYoEJWzSpGn+VdMsTHCizpg2fcdg9CGVODh3avQ1jYi25zMG3/1IpcfJaRlOix2tAbAq9wLxNcB+Jx2FDiWAMaLbS+lI7nOSoueQ25iKI4CcdzUxbBZySwuAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JCGMeXyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JCGMeXyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAC3C4CEE7;
	Wed, 22 Oct 2025 21:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761169505;
	bh=a77LTiPkBcO3R8od4DfYERollptXhvNKcEjagn3CWDY=;
	h=Date:To:From:Subject:From;
	b=JCGMeXyBgQfG63PC+2j7DW5acDEVsBOTCoAaiXECamgTDoQ3e4QCY8lCpW1QN5e2q
	 /pgcMGpiaa6RDRXMG9KAymlaPHRX7jR6cVFrk2IfWl/xIK03vjl2yj2U1dLp9mZ4gr
	 S/4vEbPPeGpRir3nIliIIFJDKyDMK9TAaRtthE7E=
Date: Wed, 22 Oct 2025 14:45:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch added to mm-new branch
Message-Id: <20251022214505.8AAC3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: optimize and simplify folio stat update after split
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch

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
Cc: wang lian <lianux.mm@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split
+++ a/mm/huge_memory.c
@@ -3609,7 +3609,6 @@ static int __split_unmapped_folio(struct
 	const bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
-	struct folio *next;
 	int split_order;
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3621,9 +3620,8 @@ static int __split_unmapped_folio(struct
 	for (split_order = start_order;
 	     split_order >= new_order;
 	     split_order--) {
-		struct folio *end_folio = folio_next(folio);
 		int old_order = folio_order(folio);
-		struct folio *new_folio;
+		int nr_new_folios = 1UL << (old_order - split_order);
 
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
@@ -3652,19 +3650,11 @@ static int __split_unmapped_folio(struct
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

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-avoid-reinvoking-folio_test_anon.patch
mm-huge_memory-update-folio-stat-after-successful-split.patch
mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch
mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch

