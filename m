Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9F83BCD2C
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896584; cv=none; b=lonmjg4wZ1BwFtmPDDcZNgHDec8zZlAiLF4oluOGZAhLK+AqyyVYrm1GAzd8XuKvbkDqC5ruFF0P9ZRDQFoVOttJkNm79CyvC7SPTlhcDSZEP50eLEq2KeDm0ermtX7C0TR6a+OV+HqEyZMagcAx9pa/WFWKI7Kv5SETdSZwxd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896584; c=relaxed/simple;
	bh=zub/NgmxoDlII7Eehmmm573RN6yCEan9Z+EZ+7DxOjw=;
	h=Date:To:From:Subject:Message-Id; b=qmfhhnRw7EONMc24gOV1zQTlROQS3cR+RVV6EiA6YWKfNx4MfrkJRwRf+xar3iKiJvTm+nwpr05qp3Z/UywSmZOQz25WN6XXzwF52DDa8uY9ogsq8cGcUg8L/xfiIqKYX3u8EPFER4mNlhbxdinQMqpcBsPU1mM8k6ssZxA35wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NmXPRmtp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NmXPRmtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD59D1F000E9;
	Wed,  5 Aug 2026 02:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896583;
	bh=CDVKZWYbmcswaXW7hYX8+cl69RON8esPc3HifJAiCVg=;
	h=Date:To:From:Subject;
	b=NmXPRmtprY4gS6xRq93ufvJqkEJ37LVRP/AecLYntFRVy2rObr95Y6XsxYEks2BEa
	 zFmnfjATM/zv4JsClmYGocstS4vDpoN3Q8i4TuucbigPOuZi/Qiu0yqT7HopTSiMUE
	 lTgAfr5IJHOCiVMKHwAfEh2MMutUuLH1aHNA0xms=
Date: Tue, 04 Aug 2026 19:23:02 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-wait-ctx-stop-in-damon_call-before-reruning-an-error.patch removed from -mm tree
Message-Id: <20260805022302.DD59D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: wait ctx stop in damon_call() before reruning an error
has been removed from the -mm tree.  Its filename was
     mm-damon-core-wait-ctx-stop-in-damon_call-before-reruning-an-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: wait ctx stop in damon_call() before reruning an error
Date: Mon, 6 Jul 2026 07:06:24 -0700

damon_call() failure means the DAMON context started its termination.  The
termination is asynchronously done in kdamond thread.  The caller's error
handling should handle the race, too.  It is complicated and easy to make
mistakes.

Update damon_call() to ensure the context is stopped in the case, by
waiting until the completion is confirmed.

Link: https://lore.kernel.org/20260706140628.87414-10-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-wait-ctx-stop-in-damon_call-before-reruning-an-error
+++ a/mm/damon/core.c
@@ -2010,6 +2010,8 @@ int damon_kdamond_pid(struct damon_ctx *
  * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
  * wait.
  *
+ * When this function is failed, the @ctx is guaranteed to be stopped.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
@@ -2022,7 +2024,7 @@ int damon_call(struct damon_ctx *ctx, st
 	mutex_lock(&ctx->call_controls_lock);
 	if (ctx->call_controls_obsolete) {
 		mutex_unlock(&ctx->call_controls_lock);
-		return -ECANCELED;
+		goto canceled;
 	}
 	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
@@ -2030,8 +2032,14 @@ int damon_call(struct damon_ctx *ctx, st
 		return 0;
 	wait_for_completion(&control->completion);
 	if (control->canceled)
-		return -ECANCELED;
+		goto canceled;
 	return 0;
+
+canceled:
+	while (damon_is_running(ctx))
+		schedule_timeout_idle(msecs_to_jiffies(100));
+	return -ECANCELED;
+
 }
 
 /**
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

