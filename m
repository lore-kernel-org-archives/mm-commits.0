Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952982F747A;
	Thu, 27 Aug 2026 04:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787805598; cv=none; b=rwJq3jVLy8bmY6CFDo0DGLLOxzD6gtqT+NK5JYCYDGCasNU6UEQfEkUVfXb/njXQk3nHpAVG5kju8xVKoqC6LNeh/5xMaq0n3RGxjs2+l/1UmLR8qGaavYCDnZZnASsLaH5kXL5Br0DA/9C28dvTUl/8kvPeRl3XoItkiR5H3MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787805598; c=relaxed/simple;
	bh=RHxIikPc7hergzh3NxifN9KYH5P4fU8Kqyx0Ch89eF8=;
	h=Date:To:From:Subject:Message-Id; b=LnyqeAik6DPfPpSJC7EvB9uIeDiXw0N1w2zTcf3NEzq5LUAYJm4hkeBFi96rmgMG4xMA/tneG9rSJTUxPXkflK9qo8MThYIX1tTabDV0VOC/0SM5zI3APaOxsjJzK4nHMXbe4O3cHJsfBuY3V/zVCO7HNKPT6gAjtRRbArPkrM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PTpg5rC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PTpg5rC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7271F000E9;
	Thu, 27 Aug 2026 04:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787805597;
	bh=G27fV0oynmgN/z73nxVrc4j5aydEc/NhC9AtYuFO95g=;
	h=Date:To:From:Subject;
	b=PTpg5rC7cYnCm9veMMtx9Lufn+MQQTWIKHL1+U4fEiBS6Bc2migbUhSSWx1HNW3oq
	 dDrLrKZO5Q90ngX2QCR/yW3rUlgLN7MQc1g48+37L1sq65nOm06Gk6fx4Jub/q2dmQ
	 s7MviiIIGP37y/6XoDXzJdAJ5b5f/0w0QDH/XdZA=
Date: Wed, 26 Aug 2026 21:39:56 -0700
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-initialize-damos_quota_goal-last_psi_total.patch added to mm-new branch
Message-Id: <20260827043956.EE7271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: initialize damos_quota_goal->last_psi_total
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-initialize-damos_quota_goal-last_psi_total.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-initialize-damos_quota_goal-last_psi_total.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-damon-core-initialize-damos_quota_goal-last_psi_total.patch
mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch

