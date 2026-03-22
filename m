Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254A340DFD8;
	Sun, 22 Mar 2026 00:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774139849; cv=none; b=bIAQKoxTl6j9HssLBWEhiiitBHIVegEWH24nBvyx2VqoJYqikk3yCmBBSda6OoY4iY8+eJRkULpt5kEvxvNeLKGdJVrswWawQ6qNHX0qpZAYMdDMZF+Oc/3opGsZkWccfyr0oETI56F/xbkBXiU6i9O0XwnNIlM74uKgoWQCYLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774139849; c=relaxed/simple;
	bh=89fGsGWfw5adeU2D1DKTxKln2906eiVwM5FfbSShElI=;
	h=Date:To:From:Subject:Message-Id; b=RE+QeZ3fOK2bYAOXHR6dhQsUpNjz30gx6VXnGjq9Dw6WgpgxauHfFSTIpeJ8oemaH0nW67yWlWgZVf/jDKdwSD6Tw3acpFgpleWoGC/aEuUaBY5ph+GZo1pyUuiniQVWmtAGFUIV976jJ7XW3GPv/92YE8T5LU+KdeyWvn8Kqp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gxz/ixYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gxz/ixYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0086C19421;
	Sun, 22 Mar 2026 00:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774139848;
	bh=89fGsGWfw5adeU2D1DKTxKln2906eiVwM5FfbSShElI=;
	h=Date:To:From:Subject:From;
	b=Gxz/ixYnd/DOnEwRRccUv3GmwoeAJzHESZ0WLrVBLVbYZMHvXAYmGX2mItQUYN7ed
	 qyDNPKTbgWIZ4bwalU9gdzOBoRWsTSD0V+QovUPeh/+u30oPRStJPwW64973AmdNYY
	 0LX46pdq3Y76AMq1Ae31X7j9S06/4krzdGSw7WfM=
Date: Sat, 21 Mar 2026 17:37:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-avoid-use-of-half-online-committed-context.patch removed from -mm tree
Message-Id: <20260322003728.A0086C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: avoid use of half-online-committed context
has been removed from the -mm tree.  Its filename was
     mm-damon-core-avoid-use-of-half-online-committed-context.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: avoid use of half-online-committed context
Date: Thu, 19 Mar 2026 07:52:17 -0700

One major usage of damon_call() is online DAMON parameters update.  It is
done by calling damon_commit_ctx() inside the damon_call() callback
function.  damon_commit_ctx() can fail for two reasons: 1) invalid
parameters and 2) internal memory allocation failures.  In case of
failures, the damon_ctx that attempted to be updated (commit destination)
can be partially updated (or, corrupted from a perspective), and therefore
shouldn't be used anymore.  The function only ensures the damon_ctx object
can safely deallocated using damon_destroy_ctx().

The API callers are, however, calling damon_commit_ctx() only after
asserting the parameters are valid, to avoid damon_commit_ctx() fails due
to invalid input parameters.  But it can still theoretically fail if the
internal memory allocation fails.  In the case, DAMON may run with the
partially updated damon_ctx.  This can result in unexpected behaviors
including even NULL pointer dereference in case of damos_commit_dests()
failure [1].  Such allocation failure is arguably too small to fail, so
the real world impact would be rare.  But, given the bad consequence, this
needs to be fixed.

Avoid such partially-committed (maybe-corrupted) damon_ctx use by saving
the damon_commit_ctx() failure on the damon_ctx object.  For this,
introduce damon_ctx->maybe_corrupted field.  damon_commit_ctx() sets it
when it is failed.  kdamond_call() checks if the field is set after each
damon_call_control->fn() is executed.  If it is set, ignore remaining
callback requests and return.  All kdamond_call() callers including
kdamond_fn() also check the maybe_corrupted field right after
kdamond_call() invocations.  If the field is set, break the kdamond_fn()
main loop so that DAMON sill doesn't use the context that might be
corrupted.

[sj@kernel.org: let kdamond_call() with cancel regardless of maybe_corrupted]
  Link: https://lkml.kernel.org/r/20260320031553.2479-1-sj@kernel.org
  Link: https://sashiko.dev/#/patchset/20260319145218.86197-1-sj%40kernel.org
Link: https://lkml.kernel.org/r/20260319145218.86197-1-sj@kernel.org
Link: https://lore.kernel.org/20260319043309.97966-1-sj@kernel.org [1]
Fixes: 3301f1861d34 ("mm/damon/sysfs: handle commit command using damon_call()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 ++++++
 mm/damon/core.c       |    8 ++++++++
 2 files changed, 14 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-avoid-use-of-half-online-committed-context
+++ a/include/linux/damon.h
@@ -810,6 +810,12 @@ struct damon_ctx {
 	struct damos_walk_control *walk_control;
 	struct mutex walk_control_lock;
 
+	/*
+	 * indicate if this may be corrupted.  Currentonly this is set only for
+	 * damon_commit_ctx() failure.
+	 */
+	bool maybe_corrupted;
+
 	/* Working thread of the given DAMON context */
 	struct task_struct *kdamond;
 	/* Protects @kdamond field access */
--- a/mm/damon/core.c~mm-damon-core-avoid-use-of-half-online-committed-context
+++ a/mm/damon/core.c
@@ -1252,6 +1252,7 @@ int damon_commit_ctx(struct damon_ctx *d
 {
 	int err;
 
+	dst->maybe_corrupted = true;
 	if (!is_power_of_2(src->min_region_sz))
 		return -EINVAL;
 
@@ -1277,6 +1278,7 @@ int damon_commit_ctx(struct damon_ctx *d
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
 
+	dst->maybe_corrupted = false;
 	return 0;
 }
 
@@ -2678,6 +2680,8 @@ static void kdamond_call(struct damon_ct
 			complete(&control->completion);
 		else if (control->canceled && control->dealloc_on_cancel)
 			kfree(control);
+		if (!cancel && ctx->maybe_corrupted)
+			break;
 	}
 
 	mutex_lock(&ctx->call_controls_lock);
@@ -2707,6 +2711,8 @@ static int kdamond_wait_activation(struc
 		kdamond_usleep(min_wait_time);
 
 		kdamond_call(ctx, false);
+		if (ctx->maybe_corrupted)
+			return -EINVAL;
 		damos_walk_cancel(ctx);
 	}
 	return -EBUSY;
@@ -2790,6 +2796,8 @@ static int kdamond_fn(void *data)
 		 * kdamond_merge_regions() if possible, to reduce overhead
 		 */
 		kdamond_call(ctx, false);
+		if (ctx->maybe_corrupted)
+			break;
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else
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
mm-damon-core-introduce-damos_quota_goal_tuner.patch
mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch
mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch
mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch
docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch
docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch
docs-abi-damon-update-for-goal_tuner.patch
mm-damon-tests-core-kunit-test-goal_tuner-commit.patch
selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch
selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch
selftests-damon-sysfspy-test-goal_tuner-commit.patch
mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram-fix.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix.patch
mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch
mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

