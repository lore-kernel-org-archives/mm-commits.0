Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391293BBFBE
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896571; cv=none; b=oq3KMtPwmxfgs6u33t+WXUrdvCf49vQgi+fTPlTKOxeVzE1jbI+VlHmGpa4Coj48BKi3JnEwBoHTV2mzKu8ZrWtTJnNlxlKsllYY+JHV/DpPPnxa42CZLySg/SJdUV0UV7qPeeZxdGmYy3IJEtC4jpIriu9Gd4Cb1HLa5j/4hUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896571; c=relaxed/simple;
	bh=43aBLAXQH/+733equSa1576O1nODcqiM62hSbTHKAT0=;
	h=Date:To:From:Subject:Message-Id; b=YOdqDbi9uDvMKZkDtyM4Mo2OEko0fy8hk4wTl8vmeKGksXsg4skhv/0R3fhUej8CR2rnVD9jzrtakxRJoTKWFwNGhkP91lASWMSRvvyJT9IL9mAQmEoQgXIO3iXQB3bMhMxXLVRfEaSGGBzf8Zqa6P8JeDY3dfofLbj2wWN/7Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=exBgDaKj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="exBgDaKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036B61F00A3D;
	Wed,  5 Aug 2026 02:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896570;
	bh=GWea+D088xEqqL94YylslpRWNRpdXuK2RR1n8xomSSg=;
	h=Date:To:From:Subject;
	b=exBgDaKj0wUU5hH2wiyvdxChFkTq2AP1h/VZ07b7fBldbyIjm+j4iqDaz2uaeC9tb
	 TVHGOpzpHYYnv4KIhKrouX0nTo0sKQ3EgWSMQqZOI8cEnUbrVY/Xj3/uX5+PSYHSGI
	 YEfVuM1RaXhFIH/sAO5ZZIFTw3KROVHhdn5ROHbM=
Date: Tue, 04 Aug 2026 19:22:49 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-mtier-do-not-stop-first-context-for-damon_start-failure.patch removed from -mm tree
Message-Id: <20260805022250.036B61F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: do not stop first context for damon_start() failure
has been removed from the -mm tree.  Its filename was
     samples-damon-mtier-do-not-stop-first-context-for-damon_start-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: samples/damon/mtier: do not stop first context for damon_start() failure
Date: Mon, 6 Jul 2026 07:06:17 -0700

damon_start() was able to fail while keeping the first context running. 
mtier hence stops the first context in the case.  damon_start() is
refactored to avoid that.  The error handling is no longer necessary. 
Remove it.

Link: https://lore.kernel.org/20260706140628.87414-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    2 --
 1 file changed, 2 deletions(-)

--- a/samples/damon/mtier.c~samples-damon-mtier-do-not-stop-first-context-for-damon_start-failure
+++ a/samples/damon/mtier.c
@@ -193,8 +193,6 @@ static int damon_sample_mtier_start(void
 	if (!err)
 		return 0;
 
-	if (damon_is_running(ctxs[0]))
-		damon_stop(ctxs, 1);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 	return err;
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

