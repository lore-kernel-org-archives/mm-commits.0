Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FDE24293C
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896574; cv=none; b=Lv0ChZcEGph4dx7uuVJF0PKBkyNUL7qXRTtPhxJY4bs82q+XjYOGmNv6TsWL6bhxTuBZmzwVNj42KstoyX/tadDJROlNSeVfIh0mCP0gZ75izJBFPAyIcrzc6fwhu8h5YspzXYFs5LWzE32NAcKAKO01PPIACdu4ItEiAKlSKNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896574; c=relaxed/simple;
	bh=mTvVeeWfh6XRFlPOV2yjc1Srqd+LPDH9ClUUz50Blk4=;
	h=Date:To:From:Subject:Message-Id; b=ZPqu1AEmwfgpFSe24Cyx9OIC4dGrqC2mjMhhGTdECv6rjP3hpSi3+AM4++3pOUwCy0Q77qeZakF6MsOUprzYxzYi545bW52o2oRZ4UpyTRzJq8QckCrR7Lwa7uYAEDzWrZRaaAeOyn6cx7ZGqyuqHhjQWH3ml6mefYNKX4jzaTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JKX3HaWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JKX3HaWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9285B1F00A3A;
	Wed,  5 Aug 2026 02:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896573;
	bh=OVAvvAdY0st7eo81ib/hD8e0h4ZeiGk0NV4PEE7ZQyg=;
	h=Date:To:From:Subject;
	b=JKX3HaWchIZBleE+rxSb4MIj7on8l2x/U4M+4cuIkGNye3QcJ0xnYZRybpq9gzrQX
	 hgvmybqkPW75V9VxbxZURAoj1PYZExFlDwC4uCJEyT2Gt7W+OoTcA9gIPC/2uofGzG
	 ZP3hPki9todbVVxcQbp7XO9+XX9PuPEoWrLlFspo=
Date: Tue, 04 Aug 2026 19:22:53 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-ignore-damon_stop-return-value.patch removed from -mm tree
Message-Id: <20260805022253.9285B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: ignore damon_stop() return value
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-ignore-damon_stop-return-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: ignore damon_stop() return value
Date: Mon, 6 Jul 2026 07:06:19 -0700

damon_stop() return value is guaranteed to be 0.  Ignore it.

Link: https://lore.kernel.org/20260706140628.87414-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-ignore-damon_stop-return-value
+++ a/mm/damon/sysfs.c
@@ -2262,12 +2262,13 @@ static int damon_sysfs_turn_damon_off(st
 {
 	if (!kdamond->damon_ctx)
 		return -EINVAL;
-	return damon_stop(&kdamond->damon_ctx, 1);
+	damon_stop(&kdamond->damon_ctx, 1);
 	/*
 	 * To allow users show final monitoring results of already turned-off
 	 * DAMON, we free kdamond->damon_ctx in next
 	 * damon_sysfs_turn_damon_on(), or kdamonds_nr_store()
 	 */
+	return 0;
 }
 
 static int damon_sysfs_damon_call(int (*fn)(void *data),
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

