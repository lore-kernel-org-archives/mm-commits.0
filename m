Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0831615533F
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976935; cv=none; b=HYA4q+o1iCPC2krd+jjVzie6YNiuGEqtir5Qg+7OTLq7Z9rIC/lEG6/aFgIUeLujvBz46g8/YeTfyNDEO1wec5Yfnm0l2oysGyFzli8oAeC8gtlNjuG6zGdJNCXFnKk1wV9uOhJRpkQyKRV9kMZHJJhFpUzn2SEHwP2b2LuckK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976935; c=relaxed/simple;
	bh=Mf/seZI884OipzoEfjURekPX+txC54OVqTbhYlec6IY=;
	h=Date:To:From:Subject:Message-Id; b=HWgyWq7tWOmYZ4nTKZlnMB0bb3HoNBY4gWIJDPU894H8NNMlD+I9yZPu2pEdEkFJR8VuDsQv1hFEUFViZYl3Gl84cXsFAZgM5qbC5ObhoQdrjJBK6Oxqa4tjy2rmYzgrSn9nTSds+M5weF5VkUL9dYiL3/ZMZ0PluR1X2NtVp8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bssQnx06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bssQnx06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6DBC4CEE3;
	Sun, 20 Jul 2025 02:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976934;
	bh=Mf/seZI884OipzoEfjURekPX+txC54OVqTbhYlec6IY=;
	h=Date:To:From:Subject:From;
	b=bssQnx062ZTA52PA1FeNW1JMBaTNT+zUGxHYEQT+e7FYylnNam/GjWWvcUFwI1ujs
	 OWCPOoo9LjWdh8QUFEDGFHQiNT18U7gKcXJHCzZar8jlUUx56sxAOBJWpKGH6qo/eU
	 zaKpfYtPscl2+bTfSEXGZCjgsISFwjeu69PGcC4c=
Date: Sat, 19 Jul 2025 19:02:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch removed from -mm tree
Message-Id: <20250720020214.CF6DBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/prcl: use damon_call() repeat mode instead of damon_callback
has been removed from the -mm tree.  Its filename was
     samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/prcl: use damon_call() repeat mode instead of damon_callback
Date: Sat, 12 Jul 2025 12:50:08 -0700

prcl uses damon_callback for periodically reading DAMON internal data. 
Use its alternative, damon_call() repeat mode.

Link: https://lkml.kernel.org/r/20250712195016.151108-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/samples/damon/prcl.c~samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback
+++ a/samples/damon/prcl.c
@@ -34,8 +34,9 @@ MODULE_PARM_DESC(enabled, "Enable or dis
 static struct damon_ctx *ctx;
 static struct pid *target_pidp;
 
-static int damon_sample_prcl_after_aggregate(struct damon_ctx *c)
+static int damon_sample_prcl_repeat_call_fn(void *data)
 {
+	struct damon_ctx *c = data;
 	struct damon_target *t;
 
 	damon_for_each_target(t, c) {
@@ -51,10 +52,16 @@ static int damon_sample_prcl_after_aggre
 	return 0;
 }
 
+static struct damon_call_control repeat_call_control = {
+	.fn = damon_sample_prcl_repeat_call_fn,
+	.repeat = true,
+};
+
 static int damon_sample_prcl_start(void)
 {
 	struct damon_target *target;
 	struct damos *scheme;
+	int err;
 
 	pr_info("start\n");
 
@@ -79,8 +86,6 @@ static int damon_sample_prcl_start(void)
 	}
 	target->pid = target_pidp;
 
-	ctx->callback.after_aggregation = damon_sample_prcl_after_aggregate;
-
 	scheme = damon_new_scheme(
 			&(struct damos_access_pattern) {
 			.min_sz_region = PAGE_SIZE,
@@ -100,7 +105,12 @@ static int damon_sample_prcl_start(void)
 	}
 	damon_set_schemes(ctx, &scheme, 1);
 
-	return damon_start(&ctx, 1, true);
+	err = damon_start(&ctx, 1, true);
+	if (err)
+		return err;
+
+	repeat_call_control.data = ctx;
+	return damon_call(ctx, &repeat_call_control);
 }
 
 static void damon_sample_prcl_stop(void)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

