Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F6C1A8418
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274605; cv=none; b=bX9vXbKQVzjsBZIkA2yNad8vXC5CJsWOGEkmBNzwIYuCw3u4Qh00y0BPwtbZ+mpjJ+uy1s7nkAvQn2hUto/iuUHPnW5+DsJ/rTusc5dPbDxSmHb9BfA7b1CySXsMNh7cnsWt09p9v9+zkdlzKz1eFmArCvSevxs5pDSrrtK5Kt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274605; c=relaxed/simple;
	bh=tkHwnDz8z3+wRMWUrIUAKDuZzQTqFZvduMNiau6IDtQ=;
	h=Date:To:From:Subject:Message-Id; b=rdX2rf7YmnUO17epx0k/CZYl3/uWOVnMOCN/CseMatH4g/n6NWuXWoYFSzVT9H9ZIFPFyA2OA510Q0TDZGrUmfPqmFXvKAd7cpzMPIGY+4NJuguykcIOGHt1KepJM6L/xvSTvVNDnllfAVRVJkSzsrdbsp9HR6aif4ibeNhS2OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nzasbCy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nzasbCy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9DDC4CEDD;
	Tue, 18 Mar 2025 05:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274604;
	bh=tkHwnDz8z3+wRMWUrIUAKDuZzQTqFZvduMNiau6IDtQ=;
	h=Date:To:From:Subject:From;
	b=nzasbCy/MQCwuPIdMLE/FBkVNzw7jyAz40TYt6loMCPE8fk5noG4yscbSn+vvR7j7
	 no9FR4WkPC7UiABsWRImjpWh8dG4Gz/utyEpxDlZ2f5NBWMxpbtXPNk90ActOFDeW6
	 2MP0k1pk2881U1fVnuxxIR1Oeld6/D1/XkgW3wSY=
Date: Mon, 17 Mar 2025 22:10:04 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-damon_callback-after_sampling.patch removed from -mm tree
Message-Id: <20250318051004.BB9DDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: remove damon_callback->after_sampling
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-damon_callback-after_sampling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: remove damon_callback->after_sampling
Date: Thu, 6 Mar 2025 09:59:06 -0800

The callback was used by DAMON sysfs interface for reading DAMON internal
data.  But it is no more being used, and damon_call() can do similar works
in a better way.  Remove it.

Link: https://lkml.kernel.org/r/20250306175908.66300-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   11 ++++-------
 mm/damon/core.c       |    3 ---
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-damon_callback-after_sampling
+++ a/include/linux/damon.h
@@ -604,7 +604,6 @@ struct damon_operations {
  * struct damon_callback - Monitoring events notification callbacks.
  *
  * @after_wmarks_check:	Called after each schemes' watermarks check.
- * @after_sampling:	Called after each sampling.
  * @after_aggregation:	Called after each aggregation.
  * @before_damos_apply:	Called before applying DAMOS action.
  * @before_terminate:	Called before terminating the monitoring.
@@ -617,17 +616,15 @@ struct damon_operations {
  * attributes of the monitoring context while it's deactivated due to the
  * watermarks, this is the good place to do.
  *
- * The monitoring thread calls @after_sampling and @after_aggregation for each
- * of the sampling intervals and aggregation intervals, respectively.
- * Therefore, users can safely access the monitoring results without additional
- * protection.  For the reason, users are recommended to use these callback for
- * the accesses to the results.
+ * The monitoring thread calls @after_aggregation for each of the aggregation
+ * intervals.  Therefore, users can safely access the monitoring results
+ * without additional protection.  For the reason, users are recommended to use
+ * these callback for the accesses to the results.
  *
  * If any callback returns non-zero, monitoring stops.
  */
 struct damon_callback {
 	int (*after_wmarks_check)(struct damon_ctx *context);
-	int (*after_sampling)(struct damon_ctx *context);
 	int (*after_aggregation)(struct damon_ctx *context);
 	int (*before_damos_apply)(struct damon_ctx *context,
 			struct damon_target *target,
--- a/mm/damon/core.c~mm-damon-remove-damon_callback-after_sampling
+++ a/mm/damon/core.c
@@ -2432,9 +2432,6 @@ static int kdamond_fn(void *data)
 
 		if (ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
-		if (ctx->callback.after_sampling &&
-				ctx->callback.after_sampling(ctx))
-			break;
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
_

Patches currently in -mm which might be from sj@kernel.org are


