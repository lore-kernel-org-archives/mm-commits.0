Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06233C10B6;
	Wed,  5 Aug 2026 03:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898985; cv=none; b=FoTDVZAo7iF/fOaER6vpq3Lv/R6st+fRIM1j8MfRzP0lpyQmnlsaGC0GdyWi/l2PJMocnyUPqXsCOBn2MRHHIubnTbX7ddXg/rNeDcnIbWK/l5XPmGxua7qOgZeLmb5kKqK8N/9UUvc4j5r/AY9wwCaaoq8RybsuBkmHPAlKJoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898985; c=relaxed/simple;
	bh=8qAzYKDSXQ/YZppdOSCXnmJXLJ/tY7GUghnER1w1GqU=;
	h=Date:To:From:Subject:Message-Id; b=Do/6iPXcJrqTge4GHzdssaGOsbpo+V+ekmzWDChCzU6UgZqwWik3XAKob7ny3FOBwxE85dnwknl9AOBBxwJ0H0paOUCDR2SDviV9uw5ChpEnV52keDcpUNJq5qff4yXV1U2GPBbLYbYQ25djmra6tMfKzPbPMfwY2lVRCzBYU6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qcyx/+mN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qcyx/+mN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973411F00A3A;
	Wed,  5 Aug 2026 03:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898983;
	bh=uBeAt8isLvJtuRBZcPq1/9bleDhCsuHkJb7u+stQvp0=;
	h=Date:To:From:Subject;
	b=qcyx/+mNLE5cLX9q8K0XIbN2NV7Fxtc48yE9JEYgnRH67kezV1Xt9gt1tllo+hduR
	 ieH01q9NBnJ9IMYN3JvMRmoOJsRPAL6V/nZqZJ8yHtAX1DqZhLlJntXCJYc1GQQa47
	 s6i/nBWxC26FwuG1lBRCzN4N9+TgiIHdZ8DEa9SU=
Date: Tue, 04 Aug 2026 20:03:03 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,aethernet65535@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch removed from -mm tree
Message-Id: <20260805030303.973411F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: skip damon_call() if ctx has not started
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/reclaim: skip damon_call() if ctx has not started
Date: Mon, 3 Aug 2026 06:46:44 -0700

Patch series "mm/damon/{reclaim,lru_sort}: fix commit_inputs infinite
hang".

Writing 'Y' to commit_inputs parameters of DAMON_RECLAIM and
DAMON_LRU_SORT before the modules were ever turned on causes infinite
hang.  Fix those.

The issue was discovered [1] by Sashiko.


This patch (of 2):

DAMON_RECLAIM calls damon_call() for commit_inputs parameter user input if
the DAMON context is initialized.  The context could be initialized, but
not yet successfully started.  In the case, damon_call() could
indefinitely hang.  Read the comment on damon_call() for more detail.  Fix
the problem by memorizing if the DAMON context has ever successfully
started, and skip damon_call() if it has not.

This issue can easily be reproduced by writing Y to commit_inputs on a
system that DAMON_RECLAIM was not turned on before.

Link: https://lore.kernel.org/20260803134646.16640-1-sj@kernel.org
Link: https://lore.kernel.org/20260803134646.16640-2-sj@kernel.org
Link: https://lore.kernel.org/20260802173021.762-1-sj@kernel.org [1]
Fixes: de3c60e1c831 ("mm/damon: add synchronous commit for commit_inputs")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: <stable@vger.kernel.org> # 7.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started
+++ a/mm/damon/reclaim.c
@@ -276,6 +276,8 @@ static int damon_reclaim_commit_inputs_f
 	return damon_reclaim_apply_parameters();
 }
 
+static bool damon_reclaim_damon_has_started;
+
 static int damon_reclaim_commit_inputs_store(const char *val,
 					     const struct kernel_param *kp)
 {
@@ -296,11 +298,8 @@ static int damon_reclaim_commit_inputs_s
 	if (!commit_inputs_request)
 		return 0;
 
-	/*
-	 * Skip damon_call() if ctx is not initialized to avoid
-	 * NULL pointer dereference.
-	 */
-	if (!ctx)
+	/* Skip damon_call() if ctx has not successfully started. */
+	if (!damon_reclaim_damon_has_started)
 		return -EINVAL;
 
 	err = damon_call(ctx, &control);
@@ -347,6 +346,8 @@ static int damon_reclaim_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
+	if (!damon_reclaim_damon_has_started)
+		damon_reclaim_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

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

