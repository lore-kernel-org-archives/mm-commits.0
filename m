Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2763BFE3A
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896712; cv=none; b=lEvEXHhhfLmuvZs3avF0OQL//CWNn93Ywgro965MwofcVsJaigZJ11lzYXY4zH7ELRoFI3DSW+7oqzKPq10ML1+PqWmP9iQKqzJyaVt1gjCoMCROclDBxN0K6DUNyNJpblSAm5McxtEA4KMDXYoPAUUTkgNKeTZx16Kp904sBX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896712; c=relaxed/simple;
	bh=ROI9WwTF2XPep/Z1HG1ge8zgV/BNLzA7R8NX72xlrp8=;
	h=Date:To:From:Subject:Message-Id; b=Tx6G1ni04ohI+u5wYkOMkv/JzO7iEjNP2oz7VV9O4PROObrTAUThMOVGNMNXgtLJSeeitMYy3PBspWlmbhYfOyMgiK24yv64xr9r96/ixdnmWdN7BUZoA3GCaaU9kQo4jQOJF4mwGh1fAeKxlVun0IIO18ZwVCyGfNmBAKFEaNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BsM+Qq5X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BsM+Qq5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2531F000E9;
	Wed,  5 Aug 2026 02:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896710;
	bh=ydZJDQ7Mttamc1Bou8gXOJWTQAWK9uUBYeOv8tUOi1Q=;
	h=Date:To:From:Subject;
	b=BsM+Qq5X63PKtBpn/RtRxfRAenNHokuljFcMdg8hDGnAOvsZMbaolC8P+VSHXdIpd
	 QvXBuJltRl3dGhqT9TFFN0Zk5ecaZlty1r6hrF5vUttI56yUAs9dGFTN6JQ0a8QXmA
	 +HU2hDlGb07dv1NO4t5mbo0ZK7/g4H4DdnocWsqw=
Date: Tue, 04 Aug 2026 19:25:09 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-abs_diff-instead-of-abs.patch removed from -mm tree
Message-Id: <20260805022510.4B2531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use abs_diff() instead of abs()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-abs_diff-instead-of-abs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: use abs_diff() instead of abs()
Date: Fri, 10 Jul 2026 06:46:36 -0700

Use of abs() in damon_merge_regions_of() could cause a silent integer
overflow since the macro casts unsigned int to signed int.  It is unlikely
to have such a large value for nr_accesses.  Even though it happens, the
user impact is just degraded monitoring results.  Users showing bad
monitoring results for weird setup is quite trivial.  But the code is
obviously wrong.  Use abs_diff() instead.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260710134651.18084-8-sj@kernel.org
Link: https://lore.kernel.org/20260705213817.100841-1-sj@kernel.org/ [1]
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-abs_diff-instead-of-abs
+++ a/mm/damon/core.c
@@ -3261,7 +3261,7 @@ static void damon_merge_regions_of(struc
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
-		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
+		if (abs_diff(r->nr_accesses, r->last_nr_accesses) > thres)
 			r->age = 0;
 		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
 			r->age = 0;
@@ -3269,7 +3269,7 @@ static void damon_merge_regions_of(struc
 			r->age++;
 
 		if (prev && prev->ar.end == r->ar.start &&
-		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
+		    abs_diff(prev->nr_accesses, r->nr_accesses) <= thres &&
 		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
 			damon_merge_two_regions(t, prev, r);
 		else
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-lru_sort-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-core-skip-aging-from-repeated-aggressive-merging.patch
mm-damon-core-hide-private-damon_region-fields.patch
mm-damon-core-hide-private-damon_target-fields.patch
mm-damon-core-hide-private-damos_quota_goal-fields.patch
mm-damon-core-hide-private-damos_quota-fields.patch
mm-damon-core-hide-private-damos_filter-fields.patch
mm-damon-core-hide-private-damos-fields.patch
mm-damon-core-hide-private-damon_filter-fields.patch
mm-damon-core-hide-private-damon_probe-fields.patch
mm-damon-sysfs-do-not-directly-access-damon_ctx-ops.patch
mm-damon-core-hide-core-private-damon_ctx-fields.patch
mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop.patch
mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of.patch
mm-damon-vaddr-drop-last-same-folio-access-check-optimization.patch
mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization.patch
mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-core-initialize-damos-last_applied.patch
mm-damon-core-kunit-check-region-count-before-testing-in-split_at.patch
mm-damon-vaddr-kunit-check-region-count-in-three_regions-test.patch
mm-damon-core-kunit-handle-region-split-failure-in-filter_out.patch
mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for.patch
mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals.patch
mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions.patch
mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch
mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch

