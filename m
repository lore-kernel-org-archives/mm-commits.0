Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6453BF68D
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896676; cv=none; b=EjIMJ1KqU2Um8GQPJbIrh88oSryv+c7RWv0x8fxX9zd2+eXYTn8rbUcBaPoGCpvRubiKC5e7YdbyKX7EveYlo43y3W2u+HhxVVbz5zhrvGojtEctyFIEuu+CxaIYb3KOl54HOPlGRPPs64xWq6zKviYrTwW05WofhrbYsEIBMn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896676; c=relaxed/simple;
	bh=xhNEGPeg4zSsoE2vVl1SDAryTp9dUi+LrLdqtwKwn0w=;
	h=Date:To:From:Subject:Message-Id; b=kyZ1MxZmTS3js5uasgl+mhNcEpG7klCsreIAPWoQlrMRTH3hSA5JN9my9brtxcjsCu+KnhAkXTfDW3P8z2EYsDZez8xNxYjullUhk4s2aKqkm3OMvCL/venYJ2G/lGUlR4GdibuF9ucQCaxwQw8gkMi7LTNNDNPq2UCPomLKf1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jXUqJMJQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jXUqJMJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AF51F00A3A;
	Wed,  5 Aug 2026 02:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896674;
	bh=FBLKPJ6+Z6leDCFmWJI8F4cNomhbn4sMs2Dm6OovtvE=;
	h=Date:To:From:Subject;
	b=jXUqJMJQEnE4qxiuFihzWSm7BQf0NwIc/IWKK3n7Y2JFiU9USwdH/MWvsB4DEcl+i
	 4DnDR2iKFX7u+p/fW0d9G2ZntRxIOv9ye68b2d4P/5GoRhec21/nqy5CcebfuPQGYM
	 KMJsvFp2bE5ogZmQBGPIHXW8s4QRjngYb4NhOUcM=
Date: Tue, 04 Aug 2026 19:24:33 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-handle-unreset-probe_hits-in-probe_hits_mvsum.patch removed from -mm tree
Message-Id: <20260805022434.17AF51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-handle-unreset-probe_hits-in-probe_hits_mvsum.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()
Date: Wed, 8 Jul 2026 06:53:57 -0700

If damon_update_monitoring_result() is called at the end of the
aggregation interval, probe_hits is not reset.  That's because the value
will be exposed to the user via damon_region_aggregated trace event.

Meanwhile, damon_probe_hits_mvsum() can be called in this state.  Due to
its logic, it will return a value that is incorrectly high.  This could
happen if the user requested DAMOS schemes applied regions sysfs files
update exactly in the time sequence.

The impact is minor, but better to avoid.  Check the timing and simply
return the fully aggregated last_probe_hits, like
damon_nr_accesses_mvsum() also does.  It is not 100% accurate since it is
the last interval's aggregation.  But better than the value that is
completely reset.

Link: https://lore.kernel.org/20260708135359.122587-8-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-handle-unreset-probe_hits-in-probe_hits_mvsum
+++ a/mm/damon/core.c
@@ -290,6 +290,9 @@ unsigned char damon_probe_hits_mvsum(int
 			ctx->passed_sample_intervals;
 	left_window_bp = mult_frac(left_window, 10000, window_len);
 
+	if (left_window_bp == 10000)
+		return r->last_probe_hits[probe_idx];
+
 	return damon_mvsum(r->probe_hits[probe_idx],
 			r->last_probe_hits[probe_idx], left_window_bp);
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

