Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C211B4223
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896583; cv=none; b=Lhwh9NGyfbMq3V9Qz9+ltuHOmJK11/uJ/ATPwR9hofd99u84uombLPcag9oXj0KA2TYzVvF1NlZ700EOq0wFDUW6FW0jxEcmldwvhju0lxNkzSl+x6Q9VZaXJOafo23hH9HfYLVcXlSy6DE8nZpMA+sX6et96AYdyLKq9oCmhoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896583; c=relaxed/simple;
	bh=ngi4bi/21wRZ3p3t+RPRqiuINLa/vsMYkm1Q3o72q2E=;
	h=Date:To:From:Subject:Message-Id; b=UstpfBDXJ2HUChPAiM2fW08Ao+TZLyVCjArFPp8nXKv0VVQwh9do0AoMJxgp3bN9fjgbGbL0/f+VozJynnfA9QBHNbpZWhsbeaM2uRkpLYnatYBIyKd2GGyjACN5ujVnwVu8+iPvPwS1lioiy16ToBL7ISZo7Od/ZDHWoIheRZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KlX2UDX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KlX2UDX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41F21F00A3A;
	Wed,  5 Aug 2026 02:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896580;
	bh=2vbot6A9bYcvGBSKFqrkSu/+6E7hw/O5YyOxhgvLC6A=;
	h=Date:To:From:Subject;
	b=KlX2UDX7YSgdSkX7hVNxK9dGVAawWpRbWugSAJE3OZ8bQo7I0d1Rgg9Qjb1Es6+2S
	 3afzKgNt2kqju+MxV0Fuh06cqOWoZyWPR5Q6sllbKE09//B49W3VXkKIe/dvpIwh6z
	 +Mihi9s6ILfFpvMRo5oPmUPOo1aG2RvfztoQyaaQ=
Date: Tue, 04 Aug 2026 19:23:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call.patch removed from -mm tree
Message-Id: <20260805022300.A41F21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: stop all contexts with single damon_stop() call
has been removed from the -mm tree.  Its filename was
     samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: samples/damon/mtier: stop all contexts with single damon_stop() call
Date: Mon, 6 Jul 2026 07:06:23 -0700

damon_stop() was theoretically able to return failure while keeping the
second context for mtier running.  mtier stops its contexts one by one
with two damon_stop() call for the reason.  damon_stop() is refactored to
always successfully stop all requested DAMON contexts.  The two calls are
unnecessary.  Use only single damon_stop() call for all contexts.

Link: https://lore.kernel.org/20260706140628.87414-9-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/samples/damon/mtier.c~samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call
+++ a/samples/damon/mtier.c
@@ -200,8 +200,7 @@ static int damon_sample_mtier_start(void
 
 static void damon_sample_mtier_stop(void)
 {
-	damon_stop(ctxs, 1);
-	damon_stop(&ctxs[1], 1);
+	damon_stop(ctxs, 2);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
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

