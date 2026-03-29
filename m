Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BBB2C86D
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744794; cv=none; b=S/9Y2A4ugF/nLB0tb+hrZ5vMsASylYTqm9PrKB7OgXgxxgh+nyrKfT76IgxOu1yYqcBe2c2EUK4lsjhJ1VyZDwYsxIu6xXzyKL5rc23m7gQF9ZuZNWU+JZ+X6NSNNV6B6TuJwcQtSpDIHoPfAtp6YRlF/vOr+lvdbBnfjDpoLrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744794; c=relaxed/simple;
	bh=pSedPseL7x43t6BVD3mNl7b1UQFnaYJp/2we5iAPnA4=;
	h=Date:To:From:Subject:Message-Id; b=XXTb6rT2R8YulCuGToWXXUvKeZ+svR2hf2ErPiD+dtJZkBlayl9LaNxCckR640gXmwfQ04UlHvdUZ+IOeob/wya1roXNugB9wQ5+ukVy8GqGfss184vvLMf2h3E0LJlT3hqV+xABfTGVQPbomwvORnwRZLFAxJNmoGLueP7auIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HE6Ct9rh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HE6Ct9rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BAAC4CEF7;
	Sun, 29 Mar 2026 00:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744794;
	bh=pSedPseL7x43t6BVD3mNl7b1UQFnaYJp/2we5iAPnA4=;
	h=Date:To:From:Subject:From;
	b=HE6Ct9rhZ8y8jJ7jSLWvgcOLNBvNagMJgN1UuehDzYoy6WhpBa8wH8kfgZGXMTdau
	 6pUJPWen/XeQm/ce+w7VXjtz8awC4gwihFxy2skpTnB0CANZ618zsyFKD+1IurnAMt
	 MTtpk2dqzBWdaP/aGPTs2RUf8Gn7YxnY5SzhCfo4=
Date: Sat, 28 Mar 2026 17:39:53 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,bingjiao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-fix-unintended-mtc-nmask-mutation-in-alloc_demote_folio.patch removed from -mm tree
Message-Id: <20260329003954.38BAAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: fix unintended mtc->nmask mutation in alloc_demote_folio()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-unintended-mtc-nmask-mutation-in-alloc_demote_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bing Jiao <bingjiao@google.com>
Subject: mm/vmscan: fix unintended mtc->nmask mutation in alloc_demote_folio()
Date: Tue, 3 Mar 2026 05:25:17 +0000

In alloc_demote_folio(), mtc->nmask is set to NULL for the first
allocation.  If that succeeds, it returns without restoring mtc->nmask to
allowed_mask.  For subsequent allocations from the migrate_pages() batch,
mtc->nmask will be NULL.  If the target node then becomes full, the
fallback allocation will use nmask = NULL, allocating from any node
allowed by the task cpuset, which for kswapd is all nodes.

To address this issue, use a local copy of the mtc structure with nmask =
NULL for the first allocation attempt specifically, ensuring the original
mtc remains unmodified.

Link: https://lkml.kernel.org/r/20260303052519.109244-1-bingjiao@google.com
Fixes: 320080272892 ("mm/demotion: demote pages according to allocation fallback order")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-unintended-mtc-nmask-mutation-in-alloc_demote_folio
+++ a/mm/vmscan.c
@@ -985,13 +985,11 @@ static void folio_check_dirty_writeback(
 static struct folio *alloc_demote_folio(struct folio *src,
 		unsigned long private)
 {
+	struct migration_target_control *mtc, target_nid_mtc;
 	struct folio *dst;
-	nodemask_t *allowed_mask;
-	struct migration_target_control *mtc;
 
 	mtc = (struct migration_target_control *)private;
 
-	allowed_mask = mtc->nmask;
 	/*
 	 * make sure we allocate from the target node first also trying to
 	 * demote or reclaim pages from the target node via kswapd if we are
@@ -1001,15 +999,13 @@ static struct folio *alloc_demote_folio(
 	 * a demotion of cold pages from the target memtier. This can result
 	 * in the kernel placing hot pages in slower(lower) memory tiers.
 	 */
-	mtc->nmask = NULL;
-	mtc->gfp_mask |= __GFP_THISNODE;
-	dst = alloc_migration_target(src, (unsigned long)mtc);
+	target_nid_mtc = *mtc;
+	target_nid_mtc.nmask = NULL;
+	target_nid_mtc.gfp_mask |= __GFP_THISNODE;
+	dst = alloc_migration_target(src, (unsigned long)&target_nid_mtc);
 	if (dst)
 		return dst;
 
-	mtc->gfp_mask &= ~__GFP_THISNODE;
-	mtc->nmask = allowed_mask;
-
 	return alloc_migration_target(src, (unsigned long)mtc);
 }
 
_

Patches currently in -mm which might be from bingjiao@google.com are


