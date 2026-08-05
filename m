Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76FC3AC0F5
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896575; cv=none; b=SlUDY5ky/lobn0w58B2+Jw4O0FJikDjC2W0/pXy/hn7oftUV53eDC50PSgbLHqtO+rxgqKE3VVj6Rlo592RF1jY18P4InC90SCtUKj1drwuA7Eru0B1S9Uw+ppXDCHTvkyZdl6VnsXajdJxoLiP4LHkN67PcIKEKnPZgZDIWua8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896575; c=relaxed/simple;
	bh=coYo2bBpUhj51yhxwhrmU/h65EUXCqg83HRgXgIRVls=;
	h=Date:To:From:Subject:Message-Id; b=EAdZ/hP7bh+/jR8h3jiqOjjwubRMoz/LdFgugM646iwgRByhY0SEUozDqu9xA3jQ8arI0oiPTYkEgHct0LnQBeimlq9MTireMbG3uaRto3Gy4LaWdNik7q18e0X1gwWk4Uu7dfc7RM9AX4bQn4YTvjI9DJZg5kD/vSdZN0H82lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zJqzsMJs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zJqzsMJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEE81F000E9;
	Wed,  5 Aug 2026 02:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896572;
	bh=sKkaRvklCdza4FBKM5hMTO0beN0UNg2pTGNc7gPLbyA=;
	h=Date:To:From:Subject;
	b=zJqzsMJsx2Dqn58h5ng/EJiRPm0K3CNCAKEPZBJvOXitKgmsB/LEb3mhKrwtxaQ2B
	 3lliyzIMFGHyUOHsL2pJ0BhwHmcSpYkPmynK8CT++jWMJfZVU+6nxsVlJ0iqeO3A2D
	 aqyOyl2dl9DEuZbqNdkyfrB8bTkvoiB868NKvnNE=
Date: Tue, 04 Aug 2026 19:22:51 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-make-damon_stop-never-fails.patch removed from -mm tree
Message-Id: <20260805022252.4EEE81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: make damon_stop() never fail
has been removed from the -mm tree.  Its filename was
     mm-damon-core-make-damon_stop-never-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: make damon_stop() never fail
Date: Mon, 6 Jul 2026 07:06:18 -0700

damon_stop() has no reason to fail.  It returns an error code only for
possible future changes that can make it fail.  Such a change has not been
made yet, and this only makes the error handling complicated and
confusing.  Ensure it returns no error.

Link: https://lore.kernel.org/20260706140628.87414-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-make-damon_stop-never-fails
+++ a/mm/damon/core.c
@@ -1926,10 +1926,8 @@ int damon_start(struct damon_ctx **ctxs,
 /*
  * __damon_stop() - Stops monitoring of a given context.
  * @ctx:	monitoring context
- *
- * Return: 0 on success, negative error code otherwise.
  */
-static int __damon_stop(struct damon_ctx *ctx)
+static void __damon_stop(struct damon_ctx *ctx)
 {
 	struct task_struct *tsk;
 
@@ -1939,31 +1937,24 @@ static int __damon_stop(struct damon_ctx
 		get_task_struct(tsk);
 		mutex_unlock(&ctx->kdamond_lock);
 		kthread_stop_put(tsk);
-		return 0;
+		return;
 	}
 	mutex_unlock(&ctx->kdamond_lock);
-
-	return -EPERM;
 }
 
 /**
  * damon_stop() - Stops the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to stop monitoring
  * @nr_ctxs:	size of @ctxs
- *
- * Return: 0 on success, negative error code otherwise.
  */
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
 {
-	int i, err = 0;
+	int i;
 
-	for (i = 0; i < nr_ctxs; i++) {
+	for (i = 0; i < nr_ctxs; i++)
 		/* nr_running_ctxs is decremented in kdamond_fn */
-		err = __damon_stop(ctxs[i]);
-		if (err)
-			break;
-	}
-	return err;
+		__damon_stop(ctxs[i]);
+	return 0;
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

