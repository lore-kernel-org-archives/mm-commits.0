Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC41E1AF0BF
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118303; cv=none; b=o162qvwyPJd75Ndfz6mRqmgEM6Y8nDlaLQv1/Re6tRozq4p8Q0QqySGeFXD+4x7LpdST399Wc61BdBwTZxf4MQFTm3L+RLo5RpP/0g8psnbm0XJA6vca8VRohzePuc7LHrqggp4jBi9c+fGHOFh39OX5AMaMXv5yFIta3rPSU7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118303; c=relaxed/simple;
	bh=DDTHgS00uRhP96wJYfSy1sKqa9l6IxibsFjrx0DsQ78=;
	h=Date:To:From:Subject:Message-Id; b=hVuYrIXiJxZ+V7kxzkv55WZL5JNFc0/DYzq3s+WSUJRKIsfH+uMriFjquC8CAFLjhTShvQGpADR3cKWGbdJzuiD7LiyTU4wtWzoMU/SwMFZG6g1swt/i19bFKzJfSHn1qf5CbKpeJuRlGGweVaCcdp63v80NCa45suKh53XdaSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cGqCFuLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cGqCFuLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE07C4CEE4;
	Tue, 13 May 2025 06:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118302;
	bh=DDTHgS00uRhP96wJYfSy1sKqa9l6IxibsFjrx0DsQ78=;
	h=Date:To:From:Subject:From;
	b=cGqCFuLiK+ltIBLfZUXiSNn2KhaloEbCioFRslXLNkRt+wSwiwYm9vx2GM/snM768
	 HtGTyqafQ7er3BYdhF2VzKJoZOXXwDlyjcDHP1NZ3+yd0gPthTTck6/g5BASM/TpPA
	 Dw7SQR4Qf6b3zUTroGSfYPW7TLS/F2USS4HYGNyQ=
Date: Mon, 12 May 2025 23:38:21 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch removed from -mm tree
Message-Id: <20250513063822.1FE07C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: fix wrong DAMON attrs setting
has been removed from the -mm tree.  Its filename was
     samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch

This patch was dropped because it was folded into samples-damon-implement-a-damon-module-for-memory-tiering.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/mtier: fix wrong DAMON attrs setting
Date: Sat, 10 May 2025 15:09:32 -0700

When intervals auto-tuning is enabled, DAMON monitoring attributes should
be set with damon_set_attrs().  Because damon_set_attrs() is the only
place that sets attrs->aggr_samples, not calling damon_set_attrs() can
result in divide-by-zero from damon_get_intervals_score().

mtier, which is a DAMON's sample module that merged in mm-unstable as of
this writing, is not calling the function while enabling the auto-tuning. 
Fix the problem by properly calling damon_set_attrs().

Link: https://lkml.kernel.org/r/20250510220932.47722-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/samples/damon/mtier.c~samples-damon-implement-a-damon-module-for-memory-tiering-fix
+++ a/samples/damon/mtier.c
@@ -41,6 +41,7 @@ static struct damon_ctx *ctxs[2];
 static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 {
 	struct damon_ctx *ctx;
+	struct damon_attrs attrs;
 	struct damon_target *target;
 	struct damon_region *region;
 	struct damos *scheme;
@@ -50,14 +51,24 @@ static struct damon_ctx *damon_sample_mt
 	ctx = damon_new_ctx();
 	if (!ctx)
 		return NULL;
+	attrs = (struct damon_attrs) {
+		.sample_interval = 5 * USEC_PER_MSEC,
+		.aggr_interval = 100 * USEC_PER_MSEC,
+		.ops_update_interval = 60 * USEC_PER_MSEC * MSEC_PER_SEC,
+		.min_nr_regions = 10,
+		.max_nr_regions = 1000,
+	};
+
 	/*
 	 * auto-tune sampling and aggregation interval aiming 4% DAMON-observed
 	 * accesses ratio, keeping sampling interval in [5ms, 10s] range.
 	 */
-	ctx->attrs.intervals_goal = (struct damon_intervals_goal) {
+	attrs.intervals_goal = (struct damon_intervals_goal) {
 		.access_bp = 400, .aggrs = 3,
 		.min_sample_us = 5000, .max_sample_us = 10000000,
 	};
+	if (damon_set_attrs(ctx, &attrs))
+		goto free_out;
 	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
 		goto free_out;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch
mm-damon-core-warn-and-fix-nr_accesses-corruption.patch
mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch
mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch
mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch
selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch
docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

