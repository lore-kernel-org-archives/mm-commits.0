Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE1A2F8E90
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896578; cv=none; b=VUxTjV/vZrUZYZ2Qh5neBXrzrHK7NtG70wGa9mknpg/Pc5oPG8BrqGvjsiORkTXmj2GWzvPQfz1l0FzyoDH/uXkhnH2YRVLx/dwkTDHlRDwAs3u4uHDbQcgiTJQsEVXAw/lPeTTAH0jh8utwONgiwYEbcvzp+9w68L1uY8hz/rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896578; c=relaxed/simple;
	bh=3NpBEJvU6ah2c32qXe7McusM8gP5DzFm8fcvBZBCWFQ=;
	h=Date:To:From:Subject:Message-Id; b=CtFOtlTeAK35Pu9L5ySNATpDV6Qa3C0CirQWGQpzWfVMMTnDL3NViiY6lSL45X+uEhFAJilv5z9imrqP6LGzClF21So9cqANOwvfsUGumRHwzu7DQ3kgoI9YJnv70mivEJVXAvVGm+XU7zSxVS0sbtWL5k598A2TNA1p48o4z0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pA4sOhkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pA4sOhkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4191F000E9;
	Wed,  5 Aug 2026 02:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896577;
	bh=RLUHlQ0dJg7RNgFYj90Fd7NiIzljRUOav2QFycShOCA=;
	h=Date:To:From:Subject;
	b=pA4sOhkD+x47pEqN/BEjc8/LryVttFKb3s6Zqvb6ywBQBuCKsXhWj8Bl4QETYNvyr
	 SqxXlYuDeXGiO6xD7Tsee+N1wGJIyBwi7ncLBSrfldEWif0QJ+M44+qWKKOJaP63mx
	 QxCczns16OvlytRr584Qn1CEh650UA2aDNR94p0c=
Date: Tue, 04 Aug 2026 19:22:56 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-ignore-damon_stop-return-value.patch removed from -mm tree
Message-Id: <20260805022257.1F4191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: ignore damon_stop() return value
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-ignore-damon_stop-return-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/lru_sort: ignore damon_stop() return value
Date: Mon, 6 Jul 2026 07:06:21 -0700

damon_stop() return value is guaranteed to be 0.  Ignore it.

Link: https://lore.kernel.org/20260706140628.87414-7-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-ignore-damon_stop-return-value
+++ a/mm/damon/lru_sort.c
@@ -409,8 +409,10 @@ static int damon_lru_sort_turn(bool on)
 {
 	int err;
 
-	if (!on)
-		return damon_stop(&ctx, 1);
+	if (!on) {
+		damon_stop(&ctx, 1);
+		return 0;
+	}
 
 	err = damon_lru_sort_apply_parameters();
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

