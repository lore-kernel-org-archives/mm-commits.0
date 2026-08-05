Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFC03BFAED
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896668; cv=none; b=ItTSAkLoCYS/Wz+X/Wwu1EqMe53J2spPJcyRP9DPuOpzbdrpX0koyH3YtFZCyfdSHhwABisTVId1pGvE/lxiifg8o/PfnG+dVGtrpys9JAvltMQq4dXiX0R+rJEWB6WD/DDujPs7no0byX5KHAqlpvx90w4UJEmWwriljwZtNEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896668; c=relaxed/simple;
	bh=SOJEi+1qQ1I3AbQ/G8A4GuwaeoaP9wHzknLVZDl/Qv4=;
	h=Date:To:From:Subject:Message-Id; b=hCdDrurW2D4lsU1JpR2eF62t8ujeOK5tVb4wMkIUGAeQru4pifStUirik4cKTm/nzYTNRv7eGTdQKdWJ3P/I3Y3k3NbjWyRxu4UZvk1svBLWEg65C1F/UpHOuPJLsVxVXDEEaFo+T0I6g+u/sa4H2lsmNoa7Sj54yfw6mkZo9zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mpooKARL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mpooKARL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339C41F00A3A;
	Wed,  5 Aug 2026 02:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896665;
	bh=oc3CGFVte/0qTC3U4XMy2WgPgu7g3w2hDqQL/P9u7P0=;
	h=Date:To:From:Subject;
	b=mpooKARLkISk3GdO2FM0YbSULDKZTmw5t8HoEr/upy5msxD4E7tJo+Vi7iMWZHo2Z
	 i3CtqquPdXxZ7eNi/+BP/QJFN85XpjyCanYHi/zgRvB+G4HnLTLzXXtB59I43G6J/N
	 yKIdR1lp0mJ1vkJknGSzMIg+qFAiAiJ2VYW6W3lE=
Date: Tue, 04 Aug 2026 19:24:24 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-comment-and-test-for-nr_to_bp-divide-by-zero.patch removed from -mm tree
Message-Id: <20260805022425.339C41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove comment and test for nr_to_bp() divide-by-zero
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-comment-and-test-for-nr_to_bp-divide-by-zero.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: remove comment and test for nr_to_bp() divide-by-zero
Date: Wed, 8 Jul 2026 06:53:51 -0700

Patch series "mm/damon: update probe hits for runtime parameter commits".

DAMON users can update DAMON parameters such as sampling and aggregation
intervals at runtime.  For such changes, monitoring results that depend on
the intervals should be properly updated for better accuracy.  For
example, the access frequency counter (nr_accesses) is updated.  The data
attribute monitoring counter (probe_hits) is not being updated, though. 
Do the updates for new parameters.

Patch 1 removes obsolete comments and test code for a function that this
series will touch.  Patches 2-5 rename functions that are being used for
nr_accesses update, to be able to be used for probe_hits without
confusion.  Patch 6 does the probe_hits update.  Patch 7 update
damon_probe_hits_mvsum() to cover a corner case from the update for better
accuracy.


This patch (of 7):

The comments on damon_nr_accesses_to_accesses_bp() and its unit test warn
it can trigger division-by-zero when the aggregation interval is zero. 
Commit 35d4a3cf70a8 ("mm/damon/ops-common: handle extreme intervals in
damon_hot_score()") modified damon_max_nr_accesses() to always return
non-zero.  Hence no division-by-zero of the note can happen.  Remove the
obsolete comment on the function.  The test code was written to test the
division-by-zero case, which cannot happen anymore.  Having it makes no
sense.  Entirely remove the test code and its comment.

Link: https://lore.kernel.org/20260708135359.122587-1-sj@kernel.org
Link: https://lore.kernel.org/20260708135359.122587-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |    8 +-------
 mm/damon/tests/core-kunit.h |   23 -----------------------
 2 files changed, 1 insertion(+), 30 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-comment-and-test-for-nr_to_bp-divide-by-zero
+++ a/mm/damon/core.c
@@ -883,13 +883,7 @@ static unsigned int damon_accesses_bp_to
 	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
 }
 
-/*
- * Convert nr_accesses to access ratio in bp (per 10,000).
- *
- * Callers should ensure attrs.aggr_interval is not zero, like
- * damon_update_monitoring_results() does .  Otherwise, divide-by-zero would
- * happen.
- */
+/* Convert nr_accesses to access ratio in bp (per 10,000) */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-remove-comment-and-test-for-nr_to_bp-divide-by-zero
+++ a/mm/damon/tests/core-kunit.h
@@ -575,28 +575,6 @@ static void damon_test_set_regions(struc
 			}, 3);
 }
 
-static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
-{
-	struct damon_attrs attrs = {
-		.sample_interval = 10,
-		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
-	};
-
-	/*
-	 * In some cases such as 32bit architectures where UINT_MAX is
-	 * ULONG_MAX, attrs.aggr_interval becomes zero.  Calling
-	 * damon_nr_accesses_to_accesses_bp() in the case will cause
-	 * divide-by-zero.  Such case is prohibited in normal execution since
-	 * the caution is documented on the comment for the function, and
-	 * damon_update_monitoring_results() does the check.  Skip the test in
-	 * the case.
-	 */
-	if (!attrs.aggr_interval)
-		kunit_skip(test, "aggr_interval is zero.");
-
-	KUNIT_EXPECT_EQ(test, damon_nr_accesses_to_accesses_bp(123, &attrs), 0);
-}
-
 static void damon_test_update_monitoring_result(struct kunit *test)
 {
 	struct damon_attrs old_attrs = {
@@ -1572,7 +1550,6 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
-	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
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

