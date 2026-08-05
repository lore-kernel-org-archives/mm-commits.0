Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E785524293C
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896581; cv=none; b=sI+mpZmwzl5K3OnZNAc1QBibndnb+7JgvP5MrlkUYlw9vGTndn7U7eBaC+ZIMEycMtNp6Olufd/h9r39qK5cP+iBWHwUbrHdd0UX2n5Sd86DoC4w5cjHolKCNb+z5ix1LFrpL0/SpmFf3tG7Ju9QMVZq3cqCvq87R0soFOP02Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896581; c=relaxed/simple;
	bh=lHDCuUEu1A8+bgysO8EJSS+k5I69RFcdFVR/le1Agic=;
	h=Date:To:From:Subject:Message-Id; b=Zqqi9stB5XfGq6c8iJL46JZ0xPQ4DAlDxRzStDgdZr/VuojeXUeSd4imsuIRfg7zlXPy9vypOYnWKw9t/nszg4qKQHePm4wAn+y9PEoFPxsBOi5UIErA+vA3HZxOjygNewCxDco+lvsSitDdP1krZgGaCZ+bi36NrMH1UATWGhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MJp6y4IQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MJp6y4IQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB2B1F000E9;
	Wed,  5 Aug 2026 02:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896579;
	bh=hvv59Oo9RXdhP+rdaX8sj/qK6Tdjv78JYzYrUx3rbCI=;
	h=Date:To:From:Subject;
	b=MJp6y4IQ7yDtptK7i7sMO58x7JY5P9nCGcD4LiXswHK+Ybnppzis+Cwhehksa3srR
	 4Yc75+UhbgLWBkY6t86VPTATf7yiXcn5eCyNZJin3QJnxiNYweyyoDMXlSMRqbFSCe
	 Qvc/xJi4SmIONSnm8fBI1H287lWNGG6NdLthpBJY=
Date: Tue, 04 Aug 2026 19:22:58 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-change-damon_stop-return-type-to-void.patch removed from -mm tree
Message-Id: <20260805022259.5EB2B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: change damon_stop() return type to void
has been removed from the -mm tree.  Its filename was
     mm-damon-core-change-damon_stop-return-type-to-void.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: change damon_stop() return type to void
Date: Mon, 6 Jul 2026 07:06:22 -0700

damon_stop() always returns 0, and nobody cares.  Change the return type
to void.

Link: https://lore.kernel.org/20260706140628.87414-8-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 mm/damon/core.c       |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-change-damon_stop-return-type-to-void
+++ a/include/linux/damon.h
@@ -1070,7 +1070,7 @@ static inline unsigned int damon_max_nr_
 
 bool damon_initialized(void);
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
-int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
+void damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 bool damon_is_running(struct damon_ctx *ctx);
 int damon_kdamond_pid(struct damon_ctx *ctx);
 
--- a/mm/damon/core.c~mm-damon-core-change-damon_stop-return-type-to-void
+++ a/mm/damon/core.c
@@ -1947,14 +1947,13 @@ static void __damon_stop(struct damon_ct
  * @ctxs:	an array of the pointers for contexts to stop monitoring
  * @nr_ctxs:	size of @ctxs
  */
-int damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
+void damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
 {
 	int i;
 
 	for (i = 0; i < nr_ctxs; i++)
 		/* nr_running_ctxs is decremented in kdamond_fn */
 		__damon_stop(ctxs[i]);
-	return 0;
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

