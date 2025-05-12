Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D208B1E87B
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 03:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747020496; cv=none; b=Ul61v7U8+DJ2/tidofe5vd9mHhubMc9Gm8FhRnqnIjjCNOnb/UaiYwLYTukEYjakj9FwxIUk7/VIZjar4mCHBkMvR9fqsQZv1LA2wDWeTRvHSnYfntwFEPkad/NDYLkX6FvCTcFY9UQDCJd2f9Xx18ryLq2PtUu2FpEPPRvS510=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747020496; c=relaxed/simple;
	bh=gZxFNlpDLCKvyHUM01pBGiyY1DwqZY+jN1AXN9BldE4=;
	h=Date:To:From:Subject:Message-Id; b=CnA5qlrzwkxAH82DROEiIrfwQyW2M0TmppmmoB5pvDpKbQ1fId5HgbOjeHPZj1wK2zJPZX9QYVJWU7ST1UoEoAOdLakgIfRkmwt9vQA7iGaMrlljOO//dCA959QzBfLSdWorNxpd0VHniWIfeaIjOD2mzm7VlssKYGn7mtNNNyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NN506gtL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NN506gtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BE4C4CEE4;
	Mon, 12 May 2025 03:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747020495;
	bh=gZxFNlpDLCKvyHUM01pBGiyY1DwqZY+jN1AXN9BldE4=;
	h=Date:To:From:Subject:From;
	b=NN506gtLYSFoGKa2QwdhKUEPDAuXbyayaD1gJMA2ieA/HoT6mbaQHDtdzkifdg/k6
	 0N9lUm+q1IwZiD1/elWSlTvNUi9DWC/pY7E8UxqhNnlN+8udWiWF6eFR1R8LwMrvek
	 idYW28deX9c+YE5TwoIKIDuIfkZ+/m2oAJbuzngw=
Date: Sun, 11 May 2025 20:28:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch added to mm-unstable branch
Message-Id: <20250512032815.21BE4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/mtier: fix wrong DAMON attrs setting
has been added to the -mm mm-unstable branch.  Its filename is
     samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch

