Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728F5346797
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 20:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773002172; cv=none; b=uZKLQuO54SWQKslqKHhFkPvyL/g6SMYbZM/jAEs+FJceJ3q3fVnkyJYseajwcB0QWfLSUb43Li1STpeRK4bD+nvJwXkIYi0bhtHEmeEhXNWBhTNqRNE0ep6k6/PgFYix+4GY7ObvnPHF2ZRzihZWF8Me5osszeuneLeLLxZcDvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773002172; c=relaxed/simple;
	bh=cv66RjqixZ6YABqWyOJ7Op7ZQdrT71QtiRGkEWL8A5Q=;
	h=Date:To:From:Subject:Message-Id; b=QEDuZTHeOMKgxqZpuzdt5+W+2VlWftxD6eSUhQDkxiCkeV5udrVGLI0iSf5OXS01CEgNTXK5lCNBOo3CgGUkIRjbDpnlb5bwT/MJTKiK/q7+5QBOeIwMWC97YnamXbD0qi6NIbW/4EsD1JiDcHk6UbX0weyEEfS3oUdU9jiC5zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yHCdunEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yHCdunEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA29C116C6;
	Sun,  8 Mar 2026 20:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773002172;
	bh=cv66RjqixZ6YABqWyOJ7Op7ZQdrT71QtiRGkEWL8A5Q=;
	h=Date:To:From:Subject:From;
	b=yHCdunEGH7KIyIGySTJz21oTt+YuykAsz3Ay/pTpH6bANY5L0M1sjTtZroVhfZMkT
	 REqU/Qq9vl2Bpniwt2kDlix9+gJtR7nuGG/gh8mG+qh5Jl58lFWD8rWbnD5bSDqQUG
	 fo5lU+UNvNdHh7Ej6BuBH1i8t4VzujhgwcsYx5zI=
Date: Sun, 08 Mar 2026 13:36:11 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-time_after_eq-in-kdamond_fn.patch added to mm-new branch
Message-Id: <20260308203611.EBA29C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: use time_after_eq() in kdamond_fn()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-use-time_after_eq-in-kdamond_fn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-time_after_eq-in-kdamond_fn.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: use time_after_eq() in kdamond_fn()
Date: Sat, 7 Mar 2026 11:49:14 -0800

damon_ctx->passed_sample_intervals and damon_ctx->next_*_sis are unsigned
long.  Those are compared in kdamond_fn() using normal comparison
operators.  It is unsafe from overflow.  Use time_after_eq(), which is
safe from overflows when correctly used, instead.

Link: https://lkml.kernel.org/r/20260307194915.203169-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-time_after_eq-in-kdamond_fn
+++ a/mm/damon/core.c
@@ -2915,7 +2915,8 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
-		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
+		if (time_after_eq(ctx->passed_sample_intervals,
+					next_aggregation_sis)) {
 			kdamond_merge_regions(ctx,
 					max_nr_accesses / 10,
 					sz_limit);
@@ -2935,10 +2936,12 @@ static int kdamond_fn(void *data)
 
 		sample_interval = ctx->attrs.sample_interval ?
 			ctx->attrs.sample_interval : 1;
-		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
+		if (time_after_eq(ctx->passed_sample_intervals,
+					next_aggregation_sis)) {
 			if (ctx->attrs.intervals_goal.aggrs &&
-					ctx->passed_sample_intervals >=
-					ctx->next_intervals_tune_sis) {
+					time_after_eq(
+						ctx->passed_sample_intervals,
+						ctx->next_intervals_tune_sis)) {
 				/*
 				 * ctx->next_aggregation_sis might be updated
 				 * from kdamond_call().  In the case,
@@ -2972,7 +2975,8 @@ static int kdamond_fn(void *data)
 			kdamond_split_regions(ctx);
 		}
 
-		if (ctx->passed_sample_intervals >= next_ops_update_sis) {
+		if (time_after_eq(ctx->passed_sample_intervals,
+					next_ops_update_sis)) {
 			ctx->next_ops_update_sis = next_ops_update_sis +
 				ctx->attrs.ops_update_interval /
 				sample_interval;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch

