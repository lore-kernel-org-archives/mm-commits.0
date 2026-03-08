Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CC1346797
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 20:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773002168; cv=none; b=CzwSUlXY2Dk6aZs3QAXRCLTv8snT3G/gnerLozgbBQFAbyBni4+B2ADOx0+ejZ1aM1mOlYfG5fkzCA9j8SG8eCf+e7/fQ3w2poHZ5uFvpNiu0tFGgACb0cwuHaMl9PusL3XB7PiPVTL8vxOhZcGwbqDtyAdt+kSlQYTQmdPgWN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773002168; c=relaxed/simple;
	bh=q9LTsFTTiAh9mn5ZeWNaKBVVCrzaHJCCMllds5JaBhA=;
	h=Date:To:From:Subject:Message-Id; b=OTemX9mppvomSr3taXyZH3ouq64Rbk2dHmJcBVZ05JB7b4fwh1kysQgcYagXT2KbyH3lXa0+MHdAD+ucOG0UVl8sigQPqSJab1pD4H4tKeNgpFKrQaF8P4HSCc2hEisMnYs3qzu5qutDfXRiqd+6GqItXRzaJQcNTNw2Km4bRUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o6umwes1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o6umwes1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB4FC116C6;
	Sun,  8 Mar 2026 20:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773002167;
	bh=q9LTsFTTiAh9mn5ZeWNaKBVVCrzaHJCCMllds5JaBhA=;
	h=Date:To:From:Subject:From;
	b=o6umwes1pAAeTqD1qGpd1hKpcI9vMgbSKVObUtqW4tQnjUNpRvB7+XgJA6iHghwCX
	 6vj3nNgwAruSHJZVrv4xvypyLwAMd8amqbXSKpiHMxJzczYbEebXMFHvvI01baCuN6
	 abyJYqJE5rs9ELfoJ1TuuE7s0FQ/3JsI4NBzgfgg=
Date: Sun, 08 Mar 2026 13:36:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch added to mm-new branch
Message-Id: <20260308203607.CBB4FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove damos_set_next_apply_sis() duplicates
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch

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
Subject: mm/damon/core: remove damos_set_next_apply_sis() duplicates
Date: Sat, 7 Mar 2026 11:49:12 -0800

Patch series "mm/damon/core: make passed_sample_intervals comparisons
overflow-safe".

DAMON accounts time using its own jiffies-like time counter, namely
damon_ctx->passed_sample_intervals.  The counter is incremented on each
iteration of kdamond_fn() main loop, which sleeps at least one sample
interval.  Hence the name is like that.

DAMON has time-periodic operations including monitoring results
aggregation and DAMOS action application.  DAMON sets the next time to do
each of such operations in the passed_sample_intervals unit.  And it does
the operation when the counter becomes the same to or larger than the
pre-set values, and update the next time for the operation.  Note that the
operation is done not only when the values exactly match but also when the
time is passed, because the values can be updated for online-committed
DAMON parameters.

The counter is 'unsigned long' type, and the comparison is done using
normal comparison operators.  It is not safe from overflows.  This can
cause rare and limited but odd situations.

Let's suppose there is an operation that should be executed every 20
sampling intervals, and the passed_sample_intervals value for next
execution of the operation is ULONG_MAX - 3.  Once the
passed_sample_intervals reaches ULONG_MAX - 3, the operation will be
executed, and the next time value for doing the operation becomes 17
(ULONG_MAX - 3 + 20), since overflow happens.  In the next iteration of
the kdamond_fn() main loop, passed_sample_intervals is larger than the
next operation time value, so the operation will be executed again.  It
will continue executing the operation for each iteration, until the
passed_sample_intervals also overflows.

Note that this will not be common and problematic in the real world.  The
sampling interval, which takes for each passed_sample_intervals increment,
is 5 ms by default.  And it is usually [auto-]tuned for hundreds of
milliseconds.  That means it takes about 248 days or 4,971 days to have
the overflow on 32 bit machines when the sampling interval is 5 ms and 100
ms, respectively (1<<32 * sampling_interval_in_seconds / 3600 / 24).  On
64 bit machines, the numbers become 2924712086.77536 and 58494241735.5072
years.  So the real user impact is negligible.  But still this is better
to be fixed as long as the fix is simple and efficient.

Fix this by simply replacing the overflow-unsafe native comparison
operators with the existing overflow-safe time comparison helpers.

The first patch only cleans up the next DAMOS action application time
setup for consistency and reduced code.  The second and the third patches
update DAMOS action application time setup and rest, respectively.


This patch (of 3):

There is a function for damos->next_apply_sis setup.  But some places are
open-coding it.  Consistently use the helper.

Link: https://lkml.kernel.org/r/20260307194915.203169-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-damos_set_next_apply_sis-duplicates
+++ a/mm/damon/core.c
@@ -2450,8 +2450,6 @@ static void kdamond_apply_schemes(struct
 	struct damon_target *t;
 	struct damon_region *r;
 	struct damos *s;
-	unsigned long sample_interval = c->attrs.sample_interval ?
-		c->attrs.sample_interval : 1;
 	bool has_schemes_to_apply = false;
 
 	damon_for_each_scheme(s, c) {
@@ -2482,9 +2480,7 @@ static void kdamond_apply_schemes(struct
 		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
 		damos_walk_complete(c, s);
-		s->next_apply_sis = c->passed_sample_intervals +
-			(s->apply_interval_us ? s->apply_interval_us :
-			 c->attrs.aggr_interval) / sample_interval;
+		damos_set_next_apply_sis(s, c);
 		s->last_applied = NULL;
 		damos_trace_stat(c, s);
 	}
@@ -2858,7 +2854,6 @@ static void kdamond_init_ctx(struct damo
 {
 	unsigned long sample_interval = ctx->attrs.sample_interval ?
 		ctx->attrs.sample_interval : 1;
-	unsigned long apply_interval;
 	struct damos *scheme;
 
 	ctx->passed_sample_intervals = 0;
@@ -2869,9 +2864,7 @@ static void kdamond_init_ctx(struct damo
 		ctx->attrs.intervals_goal.aggrs;
 
 	damon_for_each_scheme(scheme, ctx) {
-		apply_interval = scheme->apply_interval_us ?
-			scheme->apply_interval_us : ctx->attrs.aggr_interval;
-		scheme->next_apply_sis = apply_interval / sample_interval;
+		damos_set_next_apply_sis(scheme, ctx);
 		damos_set_filters_default_reject(scheme);
 	}
 }
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

