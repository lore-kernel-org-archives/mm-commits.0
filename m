Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951953C0608
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896722; cv=none; b=KHSFAAdHv/t/IZ7hVCYjgLBnfR0Vl7sCzbqQOwX5l5qjIsfwI5vKgHUwFHpZG5jyoRn/JfdJDG5J19WdJfWpHsYBbG+WnfgCrvVSo0PIURX1Xz7q9KlWU0/mo4c6irIwqJ3BQ4dJZWJ+gJ//Tu76Cd3LpNKFTu/BvFtmJvoWvzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896722; c=relaxed/simple;
	bh=zKvW19tDTA4VHBAM1vFxXrQEvoBeF33PfQPrPPwoYEk=;
	h=Date:To:From:Subject:Message-Id; b=sljkxY3NSNhB/v3G2bUoeo/Xx/Rl0nUOxbqdaZcNoB+vS2lk1vnRBuhW6Y6wv6tv8UOE6Fyx0lEs1BIqMX0i+2TIemfOzfgke4My+kCEMXMNpoNpGyJ3TuS3q6cKHxEH7GZqcPt2itbzwKOItMNl35+KmDvluoy9Kh5yzTNNY+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XwQ3n03t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XwQ3n03t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E341F000E9;
	Wed,  5 Aug 2026 02:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896721;
	bh=XInxsWm232fHEFro+S0pNmIBPXln96nSNv+ogBYgjRQ=;
	h=Date:To:From:Subject;
	b=XwQ3n03ta23UAB5zTdRKyyW/YJYSkH8/Q8b1XJYUOB3WKsPeyHZ0y2ePndQOz7gk0
	 19FGDaOsq8TDiDLhoylx3Rvt8EegVjYOK0bKrhTxoETjbTC9vExjfBJ3ajXcHSdGHi
	 LsbGf1mWSyGxWnVkoC8Y6EtyuUPFcgLsFrDq+CGo=
Date: Tue, 04 Aug 2026 19:25:20 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-implement-damon_has_probe_weight.patch removed from -mm tree
Message-Id: <20260805022521.57E341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: implement damon_has_probe_weight()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-implement-damon_has_probe_weight.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: implement damon_has_probe_weight()
Date: Fri, 10 Jul 2026 06:46:44 -0700

DAMON monitors only data attributes when probe weights are set.  However,
the function for detecting it is intentionally returning false always. 
The intention was to make changes for complete support of the mode in a
safe and incremental way.  Now all the building blocks are made.  Complete
the mode detection function so that the mode can really start working.

Link: https://lore.kernel.org/20260710134651.18084-16-sj@kernel.org
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

 mm/damon/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-implement-damon_has_probe_weight
+++ a/mm/damon/core.c
@@ -211,6 +211,12 @@ static struct damon_probe *damon_nth_pro
 
 static bool damon_has_probe_weights(struct damon_ctx *c)
 {
+	struct damon_probe *p;
+
+	damon_for_each_probe(p, c) {
+		if (p->weight)
+			return true;
+	}
 	return false;
 }
 
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

