Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7762328504F
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 21:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761169507; cv=none; b=W0Dosgq6jrVQEPg1iJvKgmqseoa7VSELWNdBZKhDJ6M+D3VwvJiUxcbD9b8LpRM3/BtVsfGHxPD4bhnoWBSq6zWxGFzQ5RLJ0N0unQ5vC9hJ1FXIA1+kdR74nHAuNU9sjSK0TbelEgcXB4u4ZB6xfy1p3D5U8TJdphmYcdALMXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761169507; c=relaxed/simple;
	bh=/BETeeZ17OllUQOSH2okiAwTkNxHVZUD7Rr+Auchkxo=;
	h=Date:To:From:Subject:Message-Id; b=YrsWmvgBxzq80ULVDLRve0rYiIBq1SG+n+U6ygTOabA+nYG01pFhobtpC+3gb6nQdc3CBRhKLGSyy83HdbweEG7a/rrWOnGSKGrVa5Wu1MkdYFPmlO8mRaxs3z3SCg3ICR6WcS+4tuiU7X+8nf4lOPvl3wnbovn+Kf34rfz/EdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GdnB7mit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GdnB7mit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0770C4CEE7;
	Wed, 22 Oct 2025 21:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761169507;
	bh=/BETeeZ17OllUQOSH2okiAwTkNxHVZUD7Rr+Auchkxo=;
	h=Date:To:From:Subject:From;
	b=GdnB7mitCSAV5RHmQf0p7gpgOb+aoieCMinALdI8iPWLY7rRlgNlFN/IZzgHYw0yb
	 KTM7PwnuSDifdB0hQMi1MG60kMvnSJoJYSEpilDg+kOOOVd6gXbgY1cx02E+pZ+pL9
	 pgBDln/wa0018JQ3rlEmgVoDsfjcZGn9+LmijPXc=
Date: Wed, 22 Oct 2025 14:45:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch added to mm-new branch
Message-Id: <20251022214506.F0770C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: optimize old_order derivation during folio splitting
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch

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
Subject: mm/huge_memory: optimize old_order derivation during folio splitting
Date: Tue, 21 Oct 2025 21:21:42 +0000

Folio splitting requires both the folio's original order (@old_order) and
the new target order (@split_order).

In the current implementation, @old_order is repeatedly retrieved using
folio_order().

However, for every iteration after the first, the folio being split is the
result of the previous split, meaning its order is already known to be
equal to the previous iteration's @split_order.

This commit optimizes the logic:

  * Instead of calling folio_order(), we now set @old_order directly to
    the value of @split_order from the previous iteration.

This change avoids unnecessary function calls and simplifies the loop
setup.

Also it removes a check for non-existent case, since for uniform splitting
we only do split when @split_order == @new_order.

Link: https://lkml.kernel.org/r/20251021212142.25766-5-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
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

 mm/huge_memory.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-optimize-old_order-derivation-during-folio-splitting
+++ a/mm/huge_memory.c
@@ -3607,8 +3607,8 @@ static int __split_unmapped_folio(struct
 		struct address_space *mapping, bool uniform_split)
 {
 	const bool is_anon = folio_test_anon(folio);
-	int order = folio_order(folio);
-	int start_order = uniform_split ? new_order : order - 1;
+	int old_order = folio_order(folio);
+	int start_order = uniform_split ? new_order : old_order - 1;
 	int split_order;
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3620,14 +3620,11 @@ static int __split_unmapped_folio(struct
 	for (split_order = start_order;
 	     split_order >= new_order;
 	     split_order--) {
-		int old_order = folio_order(folio);
 		int nr_new_folios = 1UL << (old_order - split_order);
 
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
 			continue;
-		if (uniform_split && split_order != new_order)
-			continue;
 
 		if (mapping) {
 			/*
@@ -3654,7 +3651,13 @@ static int __split_unmapped_folio(struct
 			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
 			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
 		}
+		/*
+		 * If uniform split, the process is complete.
+		 * If non-uniform, continue splitting the folio at @split_at
+		 * as long as the next @split_order is >= @new_order.
+		 */
 		folio = page_folio(split_at);
+		old_order = split_order;
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

