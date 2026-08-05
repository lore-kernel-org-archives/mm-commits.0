Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990053BED27
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896704; cv=none; b=Txbq09YbhIlRbaiFQOSTF24FxFQbSOpS6H3JTtNWd4P1bwydpkKb3ntT5iiQPzzHtIBL2QAB4OS5byzQYRCZqtx0cy+edVJ3fWIHDf/EjuexVBw5Q4ODRYQDrpQmPc8i5WiUa7Tfm6uH+Tiv3/A3Yaq9xhBwxBVbiLh+1pRz1Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896704; c=relaxed/simple;
	bh=qqPAcFe8W8akzobFdKk5OCpf3JDkYDyFSBN9zT82Vc4=;
	h=Date:To:From:Subject:Message-Id; b=O5BOgphwvCKczdgxSbkuLmuklAWT0oi8BiWfkxD3ebt63KLTT9aY0HCFtfa6Sm32DJCY+RsbHtdrRcEAo6rUF5vCWsIdgJSPWF4lHML9iGi4DQVp9UN3rYour3ep5Yv6rySBgrtz7pP9U2+ZNbESFyT8eq6y+KXMmXLhkWYO2mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QXHzuX/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QXHzuX/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CBB1F00A3A;
	Wed,  5 Aug 2026 02:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896703;
	bh=d2hZe1byxxIt8FJ4O9fOIrc58crmlfiPbiMgKI+lLeQ=;
	h=Date:To:From:Subject;
	b=QXHzuX/Mq91SZDs7XJJfavoSQ6lkOQLr1/Uhfib9wkfHgYJfXMaGWwmIwk68VeNzX
	 c7N+z5YgX9BBqzRICP9pjo2wRSxW03krM+Dt6CtRSUeR37/fQPwdbPLnv/RLEaURbo
	 cZKsyMp05CrmgFw02oY+NalO6kFVJ2PNEOuwLsXc=
Date: Tue, 04 Aug 2026 19:25:02 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-ask-apply_probes-ops-callback-to-set-sampling-address.patch removed from -mm tree
Message-Id: <20260805022503.62CBB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: ask apply_probes() ops callback to set sampling address
has been removed from the -mm tree.  Its filename was
     mm-damon-core-ask-apply_probes-ops-callback-to-set-sampling-address.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: ask apply_probes() ops callback to set sampling address
Date: Fri, 10 Jul 2026 06:46:31 -0700

prepare_access_checks() DAMON ops callback sets the monitoring sampling
address per region.  In future, DAMON will be able to call only
apply_probes().  In this case, applyy_probes() may need to do the sampling
address setup, to minimize unnecessary regions iteration.  Update the
protocol for the request.

Link: https://lore.kernel.org/20260710134651.18084-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 +++--
 mm/damon/core.c       |    2 +-
 mm/damon/paddr.c      |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-ask-apply_probes-ops-callback-to-set-sampling-address
+++ a/include/linux/damon.h
@@ -647,7 +647,8 @@ enum damon_ops_id {
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
  * @apply_probes should apply the data attribute probes to each region and
- * accordingly update the probe hits counter of the region.
+ * accordingly update the probe hits counter of the region.  It should also
+ * set &damon_region->sampling_addr of each region if ``set_samples`` is true.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -665,7 +666,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
-	void (*apply_probes)(struct damon_ctx *context);
+	void (*apply_probes)(struct damon_ctx *context, bool set_samples);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
--- a/mm/damon/core.c~mm-damon-core-ask-apply_probes-ops-callback-to-set-sampling-address
+++ a/mm/damon/core.c
@@ -3692,7 +3692,7 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx);
+			ctx->ops.apply_probes(ctx, false);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
--- a/mm/damon/paddr.c~mm-damon-core-ask-apply_probes-ops-callback-to-set-sampling-address
+++ a/mm/damon/paddr.c
@@ -166,7 +166,7 @@ static bool damon_pa_filter_pass(phys_ad
 	return pass;
 }
 
-static void damon_pa_apply_probes(struct damon_ctx *ctx)
+static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
 {
 	struct damon_target *t;
 	struct damon_region *r;
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

