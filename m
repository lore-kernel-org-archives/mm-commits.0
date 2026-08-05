Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CD63BF68F
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896669; cv=none; b=F2LEyYjcuJhCaucIe4zLHxkBF8XuBPqL3jWwsJ4fz2H4FIZiajneVHOpLrxxIJYesYHbwzHl1uM07Dv8ppASSoGMnt017Vry0ucHGyxLSReIRD34hCkQmbXLJvHZ0xe/BS6oURcS4evuOOZ25CIkhF2QJyLJ97Sv0DlXYLZBG2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896669; c=relaxed/simple;
	bh=l6S/v+g9FdEq8A+JkdP+qWqPGKP8L2rq0oKHlwo3svY=;
	h=Date:To:From:Subject:Message-Id; b=aZq8GYSbzcJwqWM9aJb+Avrb+p8GcgJVUUCOgBZgmnVgsPOPVLm/tTHxgMyEseEjAKueJKvy6qJr3gcaU5u4dH8+6+PCsAwnKMzZT4KKtNliGL4ipF0RcOaxGeqAnS7F3jp+S8WZWPspbhcy8EUPfrlyZvgBNsjNalK4dlE7uUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WWydoMOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WWydoMOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C141F000E9;
	Wed,  5 Aug 2026 02:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896666;
	bh=6thfwH42c4uAhwD/kVj1qoHbmuqnx02MnbpO5RlRAm4=;
	h=Date:To:From:Subject;
	b=WWydoMOuK5gxJQ1Idut3cjj6pwN7PAn0gCzkwBQ9lJj4S6sB/xkUUZ6fDjmbaMDJH
	 aJRwXABjtXnltefyiVoJkOUziBkC6MrAccvcxaGsH2+N5yMvTEhXn91KnT+H6g5fnp
	 jmCKIVRPKYt5LvZiFoUTP8Dt+fhpmGN9aoVNl2lk=
Date: Tue, 04 Aug 2026 19:24:25 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr.patch removed from -mm tree
Message-Id: <20260805022426.74C141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
has been removed from the -mm tree.  Its filename was
     mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
Date: Wed, 8 Jul 2026 06:53:52 -0700

damon_max_nr_accesses() actually returns the number of samples DAMON
checks for each region per each aggregation interval.  Rename it to better
describe what it really does and not confusing for more general uses.

Link: https://lore.kernel.org/20260708135359.122587-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   10 ++++++----
 mm/damon/core.c       |    4 ++--
 mm/damon/lru_sort.c   |    2 +-
 mm/damon/ops-common.c |    2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr
+++ a/include/linux/damon.h
@@ -1056,15 +1056,17 @@ static inline bool damon_target_has_pid(
 	return ctx->ops.id == DAMON_OPS_VADDR || ctx->ops.id == DAMON_OPS_FVADDR;
 }
 
-static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
+/* Returns number of samples per aggregation interval */
+static inline unsigned int damon_nr_samples_per_aggr(
+		const struct damon_attrs *attrs)
 {
 	unsigned long sample_interval;
-	unsigned long max_nr_accesses;
+	unsigned long nr_samples;
 
 	sample_interval = attrs->sample_interval ? : 1;
-	max_nr_accesses = min(attrs->aggr_interval / sample_interval,
+	nr_samples = min(attrs->aggr_interval / sample_interval,
 			(unsigned long)UINT_MAX);
-	return max_nr_accesses ? : 1;
+	return nr_samples ? : 1;
 }
 
 
--- a/mm/damon/core.c~mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr
+++ a/mm/damon/core.c
@@ -880,14 +880,14 @@ static unsigned int damon_age_for_new_at
 static unsigned int damon_accesses_bp_to_nr_accesses(
 		unsigned int accesses_bp, struct damon_attrs *attrs)
 {
-	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
+	return accesses_bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
 /* Convert nr_accesses to access ratio in bp (per 10,000) */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
-	return mult_frac(nr_accesses, 10000, damon_max_nr_accesses(attrs));
+	return mult_frac(nr_accesses, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
--- a/mm/damon/lru_sort.c~mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr
+++ a/mm/damon/lru_sort.c
@@ -303,7 +303,7 @@ static int damon_lru_sort_apply_paramete
 		goto out;
 
 	err = -ENOMEM;
-	hot_thres = damon_max_nr_accesses(&attrs) *
+	hot_thres = damon_nr_samples_per_aggr(&attrs) *
 		hot_thres_access_freq / 1000;
 	hot_scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!hot_scheme)
--- a/mm/damon/ops-common.c~mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr
+++ a/mm/damon/ops-common.c
@@ -112,7 +112,7 @@ int damon_hot_score(struct damon_ctx *c,
 	int hotness;
 
 	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE /
-		damon_max_nr_accesses(&c->attrs);
+		damon_nr_samples_per_aggr(&c->attrs);
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	if (age_in_sec)
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

