Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC20D146A66;
	Thu, 27 Aug 2026 05:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787806959; cv=none; b=RnwLZPfz7g2xQlUPXaB8D6ECxTuUjwWUGR0nvdFLQuW72eNxDYH/Dr5GsyzmuozLeYW33MvSto2bpMKWbutmXzmkUcYcULy+lXVRFWPnyE0aJj2pD5Wj4QT3V4VAogb93OJGZB9ehTHjc6NSkyjI/mxDBdhNp2cjvG4AxdRqY8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787806959; c=relaxed/simple;
	bh=i+wUeZ7MG3m3VkG7W2VNpMGVyi3HjT0iKIkWo7X32lc=;
	h=Date:To:From:Subject:Message-Id; b=ZmZRYZvZZB1mLBvbb71WfGOzrlJlqlOqSxkW7Ey/aSFwgY+Xtmw81PHY3MU68goc890ycWIDgpfMh3t4SNqyrvwK4dJc4SmUxzu9jtvNrFrs9MnpMXgVUTYJZnr5B887nimFhah4j9o5gvGtVeFIHjcYYUf2K4qevsrC10jSIAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ViSiM7Dm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ViSiM7Dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674031F000E9;
	Thu, 27 Aug 2026 05:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787806957;
	bh=n9K6NnDFncTQqWWWL1iB6Yfdc9HxPxQG0Xb1YgqGWgw=;
	h=Date:To:From:Subject;
	b=ViSiM7DmBjdt4lz/GUvPtU8zehg/cZrfSBIbAm7oc9bAVez3z60UsHs0i6Hh4isJj
	 B5PDNfidp5iN47DGVwkz7bp3m72tR5MAMiLZISkAnhDYyuSvTNiXxhikMsKQ9IWU/Y
	 eALXtizHlvP2HKeIYdjDax1fgOWosZgYyySBOMmc=
Date: Wed, 26 Aug 2026 22:02:36 -0700
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-damon-core-initialize-damos_quota_goal-last_psi_total.patch removed from -mm tree
Message-Id: <20260827050237.674031F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: initialize damos_quota_goal->last_psi_total
has been removed from the -mm tree.  Its filename was
     mm-damon-core-initialize-damos_quota_goal-last_psi_total.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: initialize damos_quota_goal->last_psi_total
Date: Wed, 26 Aug 2026 21:29:18 -0700

Patch series "mm/damon: fix wrong behaviors in DAMOS PSI goal and sysfs
refresh_ms".

PSI based DAMOS auto-tuning and DAMON sysfs refresh_ms file have bugs that
can produce non critical but still unexpected behaviors.  Fix the two
bugs.


This patch (of 2):

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  However, it is initialized only after
the first feedback loop.  The first iteration of the loop uses the
uninitialized value.  As a result, the feedback loop can change the
effective quota in an unexpected way at the first iteration.

The user impact of the issue is not big, because the issue impacts only
the first iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.  For this reason, doing no initialization
at commit time was intentional.  It is also explicitly commented.  That
said, nobody likes behaviors that are unexpected or difficult to be
expected.  Fixing it is also simple and not expensive.

Initialize the field at the beginning of kdamond and each commit of
SOME_MEM_PSI_US type quota goals.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260827042920.93580-2-sj@kernel.org
Link: https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org [1]
Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-initialize-damos_quota_goal-last_psi_total
+++ a/mm/damon/core.c
@@ -1122,6 +1122,9 @@ static void damos_commit_quota_goal_unio
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
 	switch (dst->metric) {
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		dst->last_psi_total = damos_get_some_mem_psi_total();
+		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		dst->nid = src->nid;
@@ -1143,7 +1146,6 @@ static void damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
 	damos_commit_quota_goal_union(dst, src);
 }
 
@@ -3727,6 +3729,17 @@ static int kdamond_wait_activation(struc
 	return -EBUSY;
 }
 
+static void damos_init_quota_goal_last_psi(struct damos *s)
+{
+	struct damos_quota_goal *goal;
+
+	damos_for_each_quota_goal(goal, &s->quota) {
+		if (goal->metric != DAMOS_QUOTA_SOME_MEM_PSI_US)
+			continue;
+		goal->last_psi_total = damos_get_some_mem_psi_total();
+	}
+}
+
 static void kdamond_init_ctx(struct damon_ctx *ctx)
 {
 	unsigned long sample_interval = ctx->attrs.sample_interval ?
@@ -3743,6 +3756,7 @@ static void kdamond_init_ctx(struct damo
 	damon_for_each_scheme(scheme, ctx) {
 		damos_set_next_apply_sis(scheme, ctx);
 		damos_set_filters_default_reject(scheme);
+		damos_init_quota_goal_last_psi(scheme);
 	}
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch

