Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3438A3C060F
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896721; cv=none; b=VyF8HCiO1CEo8JGEeMU4n1kkRhWAgBaUw5EhrFwKS+OFi7PX16Eer8vFxKF97k/JQq4/ZWie8zv5yrlzsjW1qstq9d8krheEON2MK8Ymw+LbXrs/p7ePlSIDWwmDPA2YUb6r2TuTGWJlBuejA08bZr7T1q/J7WYUqV3tThfozh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896721; c=relaxed/simple;
	bh=0BSIqD2+y/wEwncsYU+GejPeI+PFDC3vOsmNSImTcVM=;
	h=Date:To:From:Subject:Message-Id; b=mSI78V9NOkxI5w//ED9eMp+ZVzp2e04aBgaUD7UYyr5zMwtMMHPvVeSAuDvzcfhq0K62BT32tD6zQjQH/VleoOGT0AVzuN1vhIyzCZ2a93oTrQAYpIB9bwhMqnAJmEzPds8CpH6uOSN5IZ1DV+JGXmzMG1p1hS9ObE8lPs6KSnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ifgpe3eU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ifgpe3eU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34B31F00A3A;
	Wed,  5 Aug 2026 02:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896720;
	bh=xWfnrfnLSORg6vJrs7lhdIzijOjCESlwrOA4eBZOjTs=;
	h=Date:To:From:Subject;
	b=ifgpe3eUFinupOg5vCKgpfgVzqKfn6nCez1DNup6z0eJCeRObFCQETNxK/nVRmDf/
	 qzh0FSi/CyZqgJQ9xKyyPAYlLRx/wGqwI4DeQaECxn1icRCCnxq00Le69I9qjR6tVk
	 QqBDP0UW/sQUpyvKQGfo9ghd+wNWvz9zHh0rDD8U=
Date: Tue, 04 Aug 2026 19:25:19 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-get-merge-threshold-from-probe-hits-when-weights-are-set.patch removed from -mm tree
Message-Id: <20260805022519.F34B31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: get merge threshold from probe hits when weights are set
has been removed from the -mm tree.  Its filename was
     mm-damon-core-get-merge-threshold-from-probe-hits-when-weights-are-set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: get merge threshold from probe hits when weights are set
Date: Fri, 10 Jul 2026 06:46:43 -0700

When probe weights are set, DAMON merges regions based on their probe hits
weighted sum.  But the merge threshold is calculated based on the access
frequency.  Update it to retrieve the maximum probe hits weighted sum in
the snapshot from apply_probes() ops callback, and generate the threshold
based on it.

Link: https://lore.kernel.org/20260710134651.18084-15-sj@kernel.org
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

 mm/damon/core.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-get-merge-threshold-from-probe-hits-when-weights-are-set
+++ a/mm/damon/core.c
@@ -3763,7 +3763,8 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
-		unsigned int max_merge_score = 0;
+		unsigned int max_merge_score = 0, max_wsum;
+		bool get_max_wsum;
 
 		if (kdamond_wait_activation(ctx))
 			break;
@@ -3776,9 +3777,18 @@ static int kdamond_fn(void *data)
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_merge_score = ctx->ops.check_accesses(ctx);
-		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, access_check_disabled,
-					false);
+		if (ctx->ops.apply_probes) {
+			if (time_after_eq(ctx->passed_sample_intervals,
+						next_aggregation_sis) &&
+					access_check_disabled)
+				get_max_wsum = true;
+			else
+				get_max_wsum = false;
+			max_wsum = ctx->ops.apply_probes(ctx,
+					access_check_disabled, get_max_wsum);
+			if (get_max_wsum)
+				max_merge_score = max_wsum;
+		}
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
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

