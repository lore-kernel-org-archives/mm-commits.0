Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7723BFE3E
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896720; cv=none; b=H0huYdIhOPOmDjnKD81FB7UkEYeDcZjpLKwWftVUdoQjq8R+htirLVQihxyLzQBn2g9ZPGJUVLYIjpoH9zQUST2XJsUolawdayMWuKzognWtj5pSc38coRFbHNDmlyjnQz3U1hgznU/HmoONxT9qZBzeFBfXEfLhrpCdN5++erg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896720; c=relaxed/simple;
	bh=S/bgcSFTbyAUWVwZfEvOA3S8QL27LBjGO5EBqRDscFc=;
	h=Date:To:From:Subject:Message-Id; b=lYPAhz5q3uuvadNDQ1aSglEQ/gdPzN7Q7O2yJE6v60J5lM04VgUwUVeW2ssR7LqiJbxM5ztvaVP9JwG9IC6ARlAMUO1WbYO2fTjgTALJiNWfDyAyWcifNEHa0ekwUAETo1vijiOo9Nb+SnVlnSvRQ1iGif6ccMj96thszwKTtJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MQzrVtl/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MQzrVtl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C3E1F000E9;
	Wed,  5 Aug 2026 02:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896718;
	bh=NDp/3KbGdaLi8dB/mq9kAwm0LeNz9/8GrSK49LQfcbg=;
	h=Date:To:From:Subject;
	b=MQzrVtl/yTor7zVdBSgEWWC1J0kH/0i4pOSsq2VYy6lfgQvv/WSObyW0G8mONl59r
	 4wL81DuUpetHjCS7dIYK/Z51CsC7u/2OGtdFMUqLSwN2EcryaUzDLMR+fD4ara0xr+
	 aOdNSAMFpo5f+C2JA7y6qIqjMH+Inz1iOXLUw67Q=
Date: Tue, 04 Aug 2026 19:25:18 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-s-max_nr_accesses-max_merge_score-in-kdamond_fn.patch removed from -mm tree
Message-Id: <20260805022518.94C3E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: s/max_nr_accesses/max_merge_score/ in kdamond_fn()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-s-max_nr_accesses-max_merge_score-in-kdamond_fn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: s/max_nr_accesses/max_merge_score/ in kdamond_fn()
Date: Fri, 10 Jul 2026 06:46:42 -0700

When probe weights are set, DAMON merge logic works with the probe hits
weighted sum.  The core logic is setting the merge threshold based on the
access frequency, though.  Before using probe hits based threshold, rename
the variables to look more general.

Link: https://lore.kernel.org/20260710134651.18084-14-sj@kernel.org
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

 mm/damon/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-s-max_nr_accesses-max_merge_score-in-kdamond_fn
+++ a/mm/damon/core.c
@@ -3730,7 +3730,6 @@ static void kdamond_init_ctx(struct damo
 static int kdamond_fn(void *data)
 {
 	struct damon_ctx *ctx = data;
-	unsigned int max_nr_accesses = 0;
 	unsigned long sz_limit = 0;
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
@@ -3764,6 +3763,7 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
+		unsigned int max_merge_score = 0;
 
 		if (kdamond_wait_activation(ctx))
 			break;
@@ -3775,7 +3775,7 @@ static int kdamond_fn(void *data)
 		ctx->passed_sample_intervals++;
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
-			max_nr_accesses = ctx->ops.check_accesses(ctx);
+			max_merge_score = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
 			ctx->ops.apply_probes(ctx, access_check_disabled,
 					false);
@@ -3783,7 +3783,7 @@ static int kdamond_fn(void *data)
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
 			kdamond_merge_regions(ctx,
-					max_nr_accesses / 10,
+					max_merge_score / 10,
 					sz_limit);
 			/* online updates might be made */
 			sz_limit = damon_apply_min_nr_regions(ctx);
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

