Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569833BCD3D
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896576; cv=none; b=ueLTF/WL6MoDDKdiX7VfwVN/362yF/otATTrVBvbR0t3vdnDsAPZ6vXm5I4vOPIuGOyoYrG6hQ/QcI6pPolaIElgiHOkarDDYUSM237c4oJjeEXhYpYsyQq52BJloScmI8HtqcQXDyuSTG0O885miH7B2ljmIqdNyR3WfzuWqVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896576; c=relaxed/simple;
	bh=t/kmQ+yzlimb4G7FDv3ZYYWGRtSxMM8kn2RdpcrNzxk=;
	h=Date:To:From:Subject:Message-Id; b=Jpmnxt+XcIZHtkPcNlr/cWy4uR86k553Eua2lKqOw8RKelyavEnkxpF7LWPxcy1OMyZCkjr6MOdikBdGINE5yWnZJsQhAWNpFANK+iWoGdWI94A9yCr/F4L/eLZ1HdOZZ328erDg0e0jdK4GmJ9kwvEteDT+dPh9j7RGNJg3ldM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zfwrtN5I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zfwrtN5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E431F00A3D;
	Wed,  5 Aug 2026 02:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896575;
	bh=aV5Os77QkxftIzvJ71lL6lwh840Wq4D/5K8JvyoOEns=;
	h=Date:To:From:Subject;
	b=zfwrtN5IEzEPotCu4yrWpiHGzvvkztFNm1iSdEvKu4w30wsQmfk3WzuGZc9Ikao8j
	 BcRcgmp9od5zLHWa1WJ8JFB7pWtssr263EBs3IJEcyz6LZyRVG6D46n4GvwcnIv8I/
	 ctsntygO2uqRVUgBbTu+02HJDV2IuQUnJ86WYRwo=
Date: Tue, 04 Aug 2026 19:22:54 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaaim-ignore-damon_stop-return-value.patch removed from -mm tree
Message-Id: <20260805022254.D1E431F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: ignore damon_stop() return value
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaaim-ignore-damon_stop-return-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/reclaim: ignore damon_stop() return value
Date: Mon, 6 Jul 2026 07:06:20 -0700

damon_stop() return value is guaranteed to be 0.  Ignore it.

Link: https://lore.kernel.org/20260706140628.87414-6-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaaim-ignore-damon_stop-return-value
+++ a/mm/damon/reclaim.c
@@ -332,8 +332,10 @@ static int damon_reclaim_turn(bool on)
 {
 	int err;
 
-	if (!on)
-		return damon_stop(&ctx, 1);
+	if (!on) {
+		damon_stop(&ctx, 1);
+		return 0;
+	}
 
 	err = damon_reclaim_apply_parameters();
 	if (err)
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

