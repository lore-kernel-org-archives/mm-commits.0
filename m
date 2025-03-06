Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00422208981
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 21:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741297104; cv=none; b=BO3P7g3HpKVbzk5U/F/zYM0/sfx/1l/czJwHDno7W3mKJ9ubIjjXGWTQesmf74Sx89R1ruKX0cXLCbuOP0BIpRxz1WlRjabVw/VP/hENnpxOmJMAgik6U0+mHbwFaDcfGG6gBNB9y8BmO2bRqv4R7rW0uDyF3RBy5+EO+90V4ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741297104; c=relaxed/simple;
	bh=mYv0kAHjwwMh6+n/CWJVpD05YOcLJeNmHGGax2CedRo=;
	h=Date:To:From:Subject:Message-Id; b=ZtamBvo51wg8NUWuvoiZC0O+xt5io7BVkW9CrL8IrTUSpMFETMwwy3S1T1JaqDJq4kKAUI7SgxsDkU6Y9mEPC9STxM5Ctf+7qBHpJOOqwjmwSoA/x6uT6Imnx5MFohVhWJxneDqXQ2SsXWssCtpVeOxSPW4Lnm0plfqtWxKUgdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lSguPRRi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lSguPRRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594D2C4CEE8;
	Thu,  6 Mar 2025 21:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741297103;
	bh=mYv0kAHjwwMh6+n/CWJVpD05YOcLJeNmHGGax2CedRo=;
	h=Date:To:From:Subject:From;
	b=lSguPRRieUw5qufGawezznqOs2y0LCDBwdHuDM0M8H2hQTbvnp7HA7qWb/GMRog7L
	 u9W+5sgfOeEhf5gC2zrgv9gtiB1sBga2breJWqgh0PNqyR/j3ERlgTO4RCxpAiw8Ca
	 6AFF79LqQm/wnyLhruHz3qvgNRGCDIzfifpNQ0RQ=
Date: Thu, 06 Mar 2025 13:38:22 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch added to mm-unstable branch
Message-Id: <20250306213823.594D2C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: make damon_set_attrs() be safe to be called from damon_call()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: make damon_set_attrs() be safe to be called from damon_call()
Date: Thu, 6 Mar 2025 09:58:58 -0800

Currently all DAMON kernel API callers do online DAMON parameters commit
from damon_callback->after_aggregation because only those are safe place
to call the DAMON monitoring attributes update function, namely
damon_set_attrs().

Because damon_callback hooks provide no synchronization, the callers work
in asynchronous ways or implement their own inefficient and complicated
synchronization mechanisms.  It also means online DAMON parameters commit
can take up to one aggregation interval.  On large systems having long
aggregation intervals, that can be too slow.  The synchronization can be
done in more efficient and simple way while removing the latency
constraint if it can be done using damon_call().

The fact that damon_call() can be executed in the middle of the
aggregation makes damon_set_attrs() unsafe to be called from it, though. 
Two real problems can occur in the case.  First, converting the not yet
completely aggregated nr_accesses for new user-set intervals can arguably
degrade the accuracy or at least make the logic complicated.  Second,
kdamond_reset_aggregated() will not be called after the monitoring results
update, so next aggregation starts from unclean state.  This can result in
inconsistent and unexpected nr_accesses_bp.

Make it safe as follows.  Catch the middle-of-the-aggregation case from
damon_set_attrs() by checking the passed_sample_intervals and
next_aggregationsis of the context.  And pass the information to
nr_accesses conversion logic.  The logic works as before if it is not the
case (called after the current aggregation is completed).  If it is the
case (committing parameters in the middle of the aggregation), it drops
the nr_accesses information that so far aggregated, and make the status
same to the beginning of this aggregation, but as if the last aggregation
was started with the updated sampling/aggregation intervals.

The middle-of-aggregastion check introduce yet another edge case, though. 
This happens because kdamond_tune_intervals() can also call
damon_set_attrs() with the middle-of-aggregation check.  Consider
damon_call() for parameters commit and kdamond_tune_intervals() are called
in same iteration of kdamond main loop.  Because kdamond_tune_interval()
is called for aggregation intervals, it should be the end of the
aggregation.  The first damon_set_attrs() call from kdamond_call()
understands it is the end of the aggregation and correctly handle it. 
But, because the damon_set_attrs() updated next_aggregation_sis of the
context.  Hence, the second damon_set_attrs() invocation from
kdamond_tune_interval() believes it is called in the middle of the
aggregation.  It therefore resets aggregated information so far.  After
that, kdamond_reset_interval() is called and double-reset the aggregated
information.  Avoid this case, too, by setting the next_aggregation_sis
before kdamond_tune_intervals() is invoked.

Link: https://lkml.kernel.org/r/20250306175908.66300-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |   56 +++++++++++++++++++++++++++-------
 mm/damon/tests/core-kunit.h |    6 +--
 2 files changed, 48 insertions(+), 14 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call
+++ a/mm/damon/core.c
@@ -603,11 +603,25 @@ static unsigned int damon_nr_accesses_fo
 }
 
 static void damon_update_monitoring_result(struct damon_region *r,
-		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
+		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
+		bool aggregating)
 {
-	r->nr_accesses = damon_nr_accesses_for_new_attrs(r->nr_accesses,
-			old_attrs, new_attrs);
-	r->nr_accesses_bp = r->nr_accesses * 10000;
+	if (!aggregating) {
+		r->nr_accesses = damon_nr_accesses_for_new_attrs(
+				r->nr_accesses, old_attrs, new_attrs);
+		r->nr_accesses_bp = r->nr_accesses * 10000;
+	} else {
+		/*
+		 * if this is called in the middle of the aggregation, reset
+		 * the aggregations we made so far for this aggregation
+		 * interval.  In other words, make the status like
+		 * kdamond_reset_aggregated() is called.
+		 */
+		r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
+				r->last_nr_accesses, old_attrs, new_attrs);
+		r->nr_accesses_bp = r->last_nr_accesses * 10000;
+		r->nr_accesses = 0;
+	}
 	r->age = damon_age_for_new_attrs(r->age, old_attrs, new_attrs);
 }
 
@@ -620,7 +634,7 @@ static void damon_update_monitoring_resu
  * ->nr_accesses and ->age of given damon_ctx's regions for new damon_attrs.
  */
 static void damon_update_monitoring_results(struct damon_ctx *ctx,
-		struct damon_attrs *new_attrs)
+		struct damon_attrs *new_attrs, bool aggregating)
 {
 	struct damon_attrs *old_attrs = &ctx->attrs;
 	struct damon_target *t;
@@ -635,7 +649,7 @@ static void damon_update_monitoring_resu
 	damon_for_each_target(t, ctx)
 		damon_for_each_region(r, t)
 			damon_update_monitoring_result(
-					r, old_attrs, new_attrs);
+					r, old_attrs, new_attrs, aggregating);
 }
 
 /*
@@ -662,10 +676,10 @@ static bool damon_valid_intervals_goal(s
  * @ctx:		monitoring context
  * @attrs:		monitoring attributes
  *
- * This function should be called while the kdamond is not running, or an
- * access check results aggregation is not ongoing (e.g., from
- * &struct damon_callback->after_aggregation or
- * &struct damon_callback->after_wmarks_check callbacks).
+ * This function should be called while the kdamond is not running, an access
+ * check results aggregation is not ongoing (e.g., from &struct
+ * damon_callback->after_aggregation or &struct
+ * damon_callback->after_wmarks_check callbacks), or from damon_call().
  *
  * Every time interval is in micro-seconds.
  *
@@ -676,6 +690,8 @@ int damon_set_attrs(struct damon_ctx *ct
 	unsigned long sample_interval = attrs->sample_interval ?
 		attrs->sample_interval : 1;
 	struct damos *s;
+	bool aggregating = ctx->passed_sample_intervals <
+		ctx->next_aggregation_sis;
 
 	if (!damon_valid_intervals_goal(attrs))
 		return -EINVAL;
@@ -696,7 +712,7 @@ int damon_set_attrs(struct damon_ctx *ct
 	ctx->next_ops_update_sis = ctx->passed_sample_intervals +
 		attrs->ops_update_interval / sample_interval;
 
-	damon_update_monitoring_results(ctx, attrs);
+	damon_update_monitoring_results(ctx, attrs, aggregating);
 	ctx->attrs = *attrs;
 
 	damon_for_each_scheme(s, ctx)
@@ -2452,6 +2468,24 @@ static int kdamond_fn(void *data)
 			if (ctx->attrs.intervals_goal.aggrs &&
 					ctx->passed_sample_intervals >=
 					ctx->next_intervals_tune_sis) {
+				/*
+				 * ctx->next_aggregation_sis might be updated
+				 * from kdamond_call().  In the case,
+				 * damon_set_attrs() which will be called from
+				 * kdamond_tune_interval() may wrongly think
+				 * this is in the middle of the current
+				 * aggregation, and make aggregation
+				 * information reset for all regions.  Then,
+				 * following kdamond_reset_aggregated() call
+				 * will make the region information invalid,
+				 * particularly for ->nr_accesses_bp.
+				 *
+				 * Reset ->next_aggregation_sis to avoid that.
+				 * It will anyway correctly updated after this
+				 * if caluse.
+				 */
+				ctx->next_aggregation_sis =
+					next_aggregation_sis;
 				ctx->next_intervals_tune_sis +=
 					ctx->attrs.aggr_samples *
 					ctx->attrs.intervals_goal.aggrs;
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call
+++ a/mm/damon/tests/core-kunit.h
@@ -348,19 +348,19 @@ static void damon_test_update_monitoring
 
 	new_attrs = (struct damon_attrs){
 		.sample_interval = 100, .aggr_interval = 10000,};
-	damon_update_monitoring_result(r, &old_attrs, &new_attrs);
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 15);
 	KUNIT_EXPECT_EQ(test, r->age, 2);
 
 	new_attrs = (struct damon_attrs){
 		.sample_interval = 1, .aggr_interval = 1000};
-	damon_update_monitoring_result(r, &old_attrs, &new_attrs);
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
 	KUNIT_EXPECT_EQ(test, r->age, 2);
 
 	new_attrs = (struct damon_attrs){
 		.sample_interval = 1, .aggr_interval = 100};
-	damon_update_monitoring_result(r, &old_attrs, &new_attrs);
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
 	KUNIT_EXPECT_EQ(test, r->age, 20);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch
mm-damon-core-initialize-damos-walk_completed-in-damon_new_scheme.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch
mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch
docs-mm-damon-design-document-unmapped-damos-filter-type.patch
mm-damon-add-data-structure-for-monitoring-intervals-auto-tuning.patch
mm-damon-core-implement-intervals-auto-tuning.patch
mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch
mm-damon-sysfs-commit-intervals-tuning-goal.patch
mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch
docs-mm-damon-design-document-for-intervals-auto-tuning.patch
docs-mm-damon-design-document-for-intervals-auto-tuning-fix.patch
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch
mm-damon-core-introduce-damos-ops_filters.patch
mm-damon-paddr-support-ops_filters.patch
mm-damon-core-support-committing-ops_filters.patch
mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch
mm-damon-paddr-support-only-damos-ops_filters.patch
mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch
mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch
mm-damon-paddr-respect-ops_filters_default_reject.patch
docs-mm-damon-design-update-for-changed-filter-default-behavior.patch
mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch

