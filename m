Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BDA18A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925223; cv=none; b=midVU0VNTve6XZd2/BReGMtQoQkeStO4SEX0rQgJ05x/Ogm6ZEqVwvH/HYdTZqfiBF1RUH1lTJXCloAQ1DLeJ4DJ4ldP9FpgtEH+4NcCjRNTS5cktrTPwlZxtMbw8oyhfHd9D0vEvo/fMpzO/WpI4SYlDZG4kp6rVobtbzRAwJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925223; c=relaxed/simple;
	bh=DIZoF69Zbh+zQmJ+mhP682RAa2ryS5P5hhcJ048X87Q=;
	h=Date:To:From:Subject:Message-Id; b=knlRtQ73uVSdUanmNYX+BH1S1D3F5R4y6hBUm6Tiathx2/cKQztNN/kZmRNQId1/LulbXHLqN8AfZmZ4iOkl4GY1cTMFro0tRKXKjvVbAfymqD7PAm+k5tQaL4L/KyRKSLFZq+gkcRX/YErWTSJIeitgZNk0/Jx4JB6m52EWYF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M3kYwmXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M3kYwmXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0BDC4CEC5;
	Mon,  9 Sep 2024 23:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925222;
	bh=DIZoF69Zbh+zQmJ+mhP682RAa2ryS5P5hhcJ048X87Q=;
	h=Date:To:From:Subject:From;
	b=M3kYwmXAu9Gna6VyCR4Nsa3FPbb5uegAqCGxvKNHSypfxDOIcWP81BDHX07Icnpkt
	 DFH+cvdQIkLtLBv0QpdRYOdj0fsRKCBNL/KhkQqAJrLthn7WLY3FpxVaWR5JG52DKX
	 Nm/gWwZT+HtoUDhXGcP45Z1SubbqZSOIfWPL+kd8=
Date: Mon, 09 Sep 2024 16:40:21 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch removed from -mm tree
Message-Id: <20240909234022.6D0BDC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce per-context region priorities histogram buffer
has been removed from the -mm tree.  Its filename was
     mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce per-context region priorities histogram buffer
Date: Sun, 25 Aug 2024 21:23:20 -0700

Patch series "replace per-quota region priorities histogram buffer with
per-context one".

Each DAMOS quota (struct damos_quota) maintains a histogram for total
regions size per its prioritization score.  DAMOS calcultes minimum
prioritization score of regions that are ok to apply the DAMOS action to
while respecting the quota.  The histogram is constructed only for the
calculation of the minimum score in damos_adjust_quota() for each quota
which called by kdamond_fn().

Hence, there is no real reason to have per-quota histogram.  Only
per-kdamond histogram is needed, since parallel kdamonds could have races
otherwise.  The current implementation is only wasting the memory, and can
easily cause unintended stack usage[1].

So, introducing a per-kdamond histogram and replacing the per-quota one
with it would be the right solution for the issue.  However, supporting
multiple DAMON contexts per kdamond is still an ongoing work[2] without a
clear estimated time of arrival.  Meanwhile, per-context histogram could
be an effective and straightforward solution having no blocker.  Let's fix
the problem first in the way.


This patch (of 4):

Introduce per-context buffer for region priority scores-total size
histogram.  Same to the per-quota one (->histogram of struct damos_quota),
the new buffer is hidden from DAMON API users by being defined as a
private field of DAMON context structure.  It is dynamically allocated and
de-allocated at the beginning and ending of the execution of the kdamond
by kdamond_fn() itself.

[1] commit 0742cadf5e4c ("mm/damon/lru_sort: adjust local variable to dynamic allocation")
[2] https://lore.kernel.org/20240531122320.909060-1-yorha.op@gmail.com

Link: https://lkml.kernel.org/r/20240826042323.87025-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240826042323.87025-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |    5 +++++
 2 files changed, 7 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer
+++ a/include/linux/damon.h
@@ -630,6 +630,8 @@ struct damon_ctx {
 	unsigned long next_ops_update_sis;
 	/* for waiting until the execution of the kdamond_fn is started */
 	struct completion kdamond_started;
+	/* for scheme quotas prioritization */
+	unsigned long *regions_score_histogram;
 
 /* public: */
 	struct task_struct *kdamond;
--- a/mm/damon/core.c~mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer
+++ a/mm/damon/core.c
@@ -1957,6 +1957,10 @@ static int kdamond_fn(void *data)
 		ctx->ops.init(ctx);
 	if (ctx->callback.before_start && ctx->callback.before_start(ctx))
 		goto done;
+	ctx->regions_score_histogram = kmalloc_array(DAMOS_MAX_SCORE + 1,
+			sizeof(*ctx->regions_score_histogram), GFP_KERNEL);
+	if (!ctx->regions_score_histogram)
+		goto done;
 
 	sz_limit = damon_region_sz_limit(ctx);
 
@@ -2034,6 +2038,7 @@ done:
 		ctx->callback.before_terminate(ctx);
 	if (ctx->ops.cleanup)
 		ctx->ops.cleanup(ctx);
+	kfree(ctx->regions_score_histogram);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
_

Patches currently in -mm which might be from sj@kernel.org are


