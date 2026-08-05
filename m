Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81E71B4223
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896586; cv=none; b=edPZfF8vUHpLGyjmN5hiYjAUL9fvt5QGsaUfYSFeGAVv0b4C0Yde+QMpz61cEvmwcFHA2jA4Eseo36nfkeJPZyDEqfORF6amEdxMBLPDHSMrx48rIXRnPYbmFFc+Hlv1x/KICSBc71CT83dRcF808bwF56zAhY6+dJrnB8UobLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896586; c=relaxed/simple;
	bh=m/63ZA6Ivn9twXIrrKxiXEIccR+uN+ZSGDvmp4fw31Q=;
	h=Date:To:From:Subject:Message-Id; b=oYBHso+p62Yeh0iQE/YUt1a/Ov2/VG59Br6dcoKyhJKQAocwYH4eoOAajH8a4sqVJHYSkS+UKKfFNsQ9OdE8YlxUP746pRZ0Du7fzfquW7WzXK/lHwKQxi4a9jlkmBZ6hBX5OhzqRh1WkjaC/s+C+g/f8mxKsz8o+9YRzVTcIFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ALIimyQd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ALIimyQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715631F000E9;
	Wed,  5 Aug 2026 02:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896585;
	bh=VZhBYjjPy4S+QaVRy524cJWzy0tJiWMdL2RoDgyJL2g=;
	h=Date:To:From:Subject;
	b=ALIimyQdGSoXty004kwnkczxWuLHNUl1/Fn0fXVlBL6wXbblR3TG8w1s+uxvI1jCm
	 f98baJcr/3bL1Xqo5musYGE0xpuj6vYEA9m4tMC+J1v4ppuoA8yuQPAEZ74PGJ74Zh
	 2YV4MufjB+FJm+v/yS78YPgbM3Y3RP76FDbJsPZA=
Date: Tue, 04 Aug 2026 19:23:04 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-prcl-do-not-stop-damon-for-damon_call-failure.patch removed from -mm tree
Message-Id: <20260805022305.715631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/prcl: do not stop DAMON for damon_call() failure
has been removed from the -mm tree.  Its filename was
     samples-damon-prcl-do-not-stop-damon-for-damon_call-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: samples/damon/prcl: do not stop DAMON for damon_call() failure
Date: Mon, 6 Jul 2026 07:06:26 -0700

damon_call() failure was causing the context to be stopped, but
asynchronously by the kdamond thread.  To handle the race, the caller had
to stop the context.  damon_call() is updated to do the stop on its own. 
Remove the damon_stop() call from the damon_call() error handling.

Link: https://lore.kernel.org/20260706140628.87414-12-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/samples/damon/prcl.c~samples-damon-prcl-do-not-stop-damon-for-damon_call-failure
+++ a/samples/damon/prcl.c
@@ -113,10 +113,8 @@ static int damon_sample_prcl_start(void)
 
 	repeat_call_control.data = ctx;
 	err = damon_call(ctx, &repeat_call_control);
-	if (err) {
-		damon_stop(&ctx, 1);
+	if (err)
 		damon_destroy_ctx(ctx);
-	}
 	return err;
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

