Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB963BFAC0
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896716; cv=none; b=I7Hcq105oBpp9ZI/FHOPCmByHYqvNTsaylTonzJr0A9FAz/GfPpBs5U3MiAGEDFZq695y2RUP9o4kX7yiouYavK30+RC6XrpjBuQiYKzsGuV5W1RJk6NXQ35QTd8/u8ENh+3t7T5mbWOKd0rhvQVNJLa5Fx0QtpBrEH5fnI+Emk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896716; c=relaxed/simple;
	bh=Gd4VY9r4K+fQcyBrOt/NB0M3zBPC7bNSBP4mK9BFqLA=;
	h=Date:To:From:Subject:Message-Id; b=lp+3IhW7Rmyf99xdnDC5RIkx96ltayWhS0YEEyAu6RUzNTRBrEUY80X6i1Z73idtKz3+d4bU9e2Wv5yiSn9wiWkAuFxDXix/wHdnMHqixcU+QgL2tStgaKqhS2vh7SJZZ82JSBjLsY1ugzT7bUzI+Lh+KzMSWONh9huCi6dsRo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z89+Znz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z89+Znz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E8B1F00A3A;
	Wed,  5 Aug 2026 02:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896714;
	bh=x+28/2cHyEH09uA2/q28wCIt69og2mlNtywIf2jnEuI=;
	h=Date:To:From:Subject;
	b=z89+Znz3DQmjLE99xB3h6jbK1xKilUXdwwhkjgMfy8xcSX4ej2nftC+1Wk9Kp1XjX
	 ZzVDvT+Q+hmRpDauy8XqheFM7HxcmeeV5r2qH0P0esBErkoxXuz2JCIj1W2B/CRhYp
	 +G50gHcygUzr7LZ6GjQeAjEJqnuKG56Nn4AiTryA=
Date: Tue, 04 Aug 2026 19:25:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-validate-params-for-probe-hits-weighted-sum-overflow.patch removed from -mm tree
Message-Id: <20260805022514.72E8B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: validate params for probe hits weighted sum overflow
has been removed from the -mm tree.  Its filename was
     mm-damon-core-validate-params-for-probe-hits-weighted-sum-overflow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: validate params for probe hits weighted sum overflow
Date: Fri, 10 Jul 2026 06:46:39 -0700

damon_probe_hits_wsum() could overflow in weird setups.  Users could set
the weight unreasonably high.  They could also set the aggregation
interval unreasonably high compared to the sampling interval.  Such user
setup is unlikely.  Even if such setup is used, damon_has_probe_weights()
always returns false, so the overflow cannot happen.  The function may be
completed in future, though.  Even if the overflow happens, the
consequence is degraded monitoring results for the unreasonable setup.  It
is just a trivial user experience issue.

It is still better to be prevented unless the cost is expensive.  Avoid
the overflow by adding the parameter validation in the core layer
parameters validation function.

Link: https://lore.kernel.org/20260710134651.18084-11-sj@kernel.org
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

 mm/damon/core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-validate-params-for-probe-hits-weighted-sum-overflow
+++ a/mm/damon/core.c
@@ -1335,6 +1335,9 @@ static void damos_set_filters_default_re
 static bool damon_valid_probe_params(struct damon_ctx *ctx)
 {
 	unsigned long sample_interval;
+	unsigned char max_probe_hits;
+	struct damon_probe *probe;
+	unsigned int wsum, wsum_to_add;
 
 	if (!damon_has_probe_weights(ctx))
 		return true;
@@ -1342,6 +1345,18 @@ static bool damon_valid_probe_params(str
 	sample_interval = ctx->attrs.sample_interval ? : 1;
 	if (ctx->attrs.aggr_interval / sample_interval > U8_MAX)
 		return false;
+
+	/* invalid if probe hits weighted sum can overflow */
+	max_probe_hits = damon_nr_samples_per_aggr(&ctx->attrs);
+	wsum = 0;
+	damon_for_each_probe(probe, ctx) {
+		if (probe->weight > UINT_MAX / max_probe_hits)
+			return false;
+		wsum_to_add = probe->weight * max_probe_hits;
+		if (UINT_MAX - wsum < wsum_to_add)
+			return false;
+		wsum += wsum_to_add;
+	}
 	return true;
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

