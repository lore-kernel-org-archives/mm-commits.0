Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EC62153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188256; cv=none; b=NEha+DUfN+dPkBZZp1pmTEMO0UnBXZnQizTRDV7I0g8enuh4MyajNOnWGUQ15zW/gD244b/hdsy7+eOorDezIyy+2u5aeCn6lQ5qaqiE/VZP2QORZE+ohVoUMT/pmKVg5/EluIRXHkWnihEkT3J+heAIktqiiRDFuL2R9COsxkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188256; c=relaxed/simple;
	bh=mtZXjDQQsLlfzBKL82IG6/4lRbArhcrz9ZUPQKdccuc=;
	h=Date:To:From:Subject:Message-Id; b=YS09zyhjpqQOwy0DjqFIf8Pw+18P8kRpy1KPeVbBRPOaHxVNiUH15yncldp6qnaoIzZDsrTh6b59sBUjn6hOsHf0sdQudYT95nX/1lKifl9nK8B/7mcVUg7Yaym1MRLPoSN4M4yxGpAWOoN1l4Ic+ZGqUSj1t0Rljat4U6k03fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qnRvUIdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qnRvUIdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AED9C4CEEC;
	Mon, 17 Mar 2025 05:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188256;
	bh=mtZXjDQQsLlfzBKL82IG6/4lRbArhcrz9ZUPQKdccuc=;
	h=Date:To:From:Subject:From;
	b=qnRvUIdPb6yXOWI0dU0NLxF8BM0QVBoNKuIQ3d8FcnDuDi5oJagX6PFuJ0e1uyw0f
	 c2ziUQV75ZbebzJnMyegqiNgP00EiFNBF1v0VULwAIjR1qTD6Q2BKvgP6/dnr8d8hq
	 bCiNgjJYnTnKs57V545Tm7f/1F/vhajekqYwtBXg=
Date: Sun, 16 Mar 2025 22:10:56 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,anshuman.khandual@arm.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-use-round_up-to-align-movable-range.patch removed from -mm tree
Message-Id: <20250317051056.8AED9C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: use round_up() to align movable range
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-use-round_up-to-align-movable-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: use round_up() to align movable range
Date: Fri, 7 Feb 2025 10:04:53 +0000

Since MAX_ORDER_NR_PAGES is power of 2, let's use a faster version.

Link: https://lkml.kernel.org/r/20250207100453.9989-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-use-round_up-to-align-movable-range
+++ a/mm/mm_init.c
@@ -438,7 +438,7 @@ static void __init find_zone_movable_pfn
 		 * was requested by the user
 		 */
 		required_movablecore =
-			roundup(required_movablecore, MAX_ORDER_NR_PAGES);
+			round_up(required_movablecore, MAX_ORDER_NR_PAGES);
 		required_movablecore = min(totalpages, required_movablecore);
 		corepages = totalpages - required_movablecore;
 
@@ -549,7 +549,7 @@ out2:
 		unsigned long start_pfn, end_pfn;
 
 		zone_movable_pfn[nid] =
-			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
+			round_up(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
 
 		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 		if (zone_movable_pfn[nid] >= end_pfn)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure.patch
lib-rbtree-split-tests.patch
lib-rbtree-add-random-seed.patch
lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers.patch
lib-interval_tree-add-test-case-for-span-iteration.patch
lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch
lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap.patch

