Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC783BFAEA
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896674; cv=none; b=kaZ+sYsC2QG2hOrPe3P66z487wdZn399htsl88uMxg0i+cloAO5Q1A5pI7IR7rj9sPZicsq7ZMGqwVvSamdvnKP2Eot9bLPh4AtucTTPdY5bCT4uiZ6VyFg8HSI80x3puAJ/mIgfb25NUfiP0vpo00gJ6BFQ8qA9nxO8l2AfxDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896674; c=relaxed/simple;
	bh=WN2x1VrC/Mfzg2KwuNbhw1C5djhK4kh5hz+EUi8Cyvk=;
	h=Date:To:From:Subject:Message-Id; b=R3Awg6lYk36Yvu7vT5hGgkuuejlsS0ewumc/m0mDomHDbiOJ+nz1FXFitJzydPiUxcn2jLGOOOD2rNNk9ZJD9OcjXg0V6br2XSM+jQNpz80WC5MC/xafpcee+IDBJCRznxXYhrR9mRXhOZ4HQ94FWAn5USR4LzXQ9Hm+YG8Fmmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NafSLR+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NafSLR+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB721F000E9;
	Wed,  5 Aug 2026 02:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896670;
	bh=83KdNXfOkrX1WM8PKfYNMRhm/HVs8gwiRPsnIIuFmAk=;
	h=Date:To:From:Subject;
	b=NafSLR+X1RMmjQl5dE6Ya00yVbDtg/NCpSu+TwxZ0swdUAuL7YY0++xiGfg5xGw+8
	 Fh9Kas28+l+BXDTn88dS/T+M3ctrKR045w/eOKn7yv+TzLAH4Rz/2rK3VzO7rbVB3X
	 NCEoSHjAs8FxOENqDkveefX28KSKuoRI0SzG7zAc=
Date: Tue, 04 Aug 2026 19:24:29 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-s-nr_accesses_to_accesses_bp-sample_count_to_bp.patch removed from -mm tree
Message-Id: <20260805022430.3DB721F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
has been removed from the -mm tree.  Its filename was
     mm-damon-core-s-nr_accesses_to_accesses_bp-sample_count_to_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
Date: Wed, 8 Jul 2026 06:53:54 -0700

damon_nr_accesses_to_accesses_bp() actually converts a positive sample
count to the ratio.  Rename it to better describe what it really does and
not confusing for more general uses.

Link: https://lore.kernel.org/20260708135359.122587-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-s-nr_accesses_to_accesses_bp-sample_count_to_bp
+++ a/mm/damon/core.c
@@ -883,19 +883,18 @@ static unsigned int damon_sample_bp_to_c
 	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
-/* Convert nr_accesses to access ratio in bp (per 10,000) */
-static unsigned int damon_nr_accesses_to_accesses_bp(
-		unsigned int nr_accesses, struct damon_attrs *attrs)
+/* convert sample count to ratio in bp (per 10,000) */
+static unsigned int damon_sample_count_to_bp(
+		unsigned int count, struct damon_attrs *attrs)
 {
-	return mult_frac(nr_accesses, 10000, damon_nr_samples_per_aggr(attrs));
+	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
-			damon_nr_accesses_to_accesses_bp(
-				nr_accesses, old_attrs),
+			damon_sample_count_to_bp(nr_accesses, old_attrs),
 			new_attrs);
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

