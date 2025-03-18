Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC5B1DE3C9
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274606; cv=none; b=rmgOHvQYMhNX4vGYMR/cM6PBFE0Peebwok38gK/X6I2erqqq59T+xITtNYpJY2/KRIJHkuy5Oub21q+UM+nhBnn9nJDkIgzz754fpEmoqjtz0F+PbzYfP/vnuWoXPl3bN3NauFGipvojwrIOwoFmKv20PEOASzvoMLVdca5AZ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274606; c=relaxed/simple;
	bh=I+tbhH+0pcROgEZGFbb4/YS2ieWFIzPrqGfatlAwwuM=;
	h=Date:To:From:Subject:Message-Id; b=aYjK1AnCx40L58eNDcn7ZCVNDH2NAKNYChf2xStItXCNme1KcPEzrYWh8T0Pf5PtbpOWhSvIctBuQbrOhQjF9zDQ07C8JzqgrtRTrzT5uR6R6Klps7tfiFi0euORWEpKq0r+9QHqVk9mTq4Aazh53xoV1kxXG7RL7AHSpBtyoz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XPQvI5/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XPQvI5/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69DCC4CEDD;
	Tue, 18 Mar 2025 05:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274605;
	bh=I+tbhH+0pcROgEZGFbb4/YS2ieWFIzPrqGfatlAwwuM=;
	h=Date:To:From:Subject:From;
	b=XPQvI5/Ee6o/iz2XLvqn488k3PKdnn8w3wEFyuzd3kjVP19Rc7/gXDfWzS6PFUPEU
	 1ZVGhamZkkveFB7Z2mzi7hOkcEfB6rRY410vUvccIJhNGYttwgzZwRDRJIlH0tV1BP
	 pAxmbwsNb18c9a6mMXkC0tAkn/84kkvmo7N0mLlg=
Date: Mon, 17 Mar 2025 22:10:05 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-damon_callback-before_damos_apply.patch removed from -mm tree
Message-Id: <20250318051005.C69DCC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: remove damon_callback->before_damos_apply
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-damon_callback-before_damos_apply.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: remove damon_callback->before_damos_apply
Date: Thu, 6 Mar 2025 09:59:07 -0800

The hook was introduced to let DAMON kernel API users access DAMOS
schemes-eligible regions in a safe way.  Now it is no more used by anyone,
and the functionality is provided in a better way by damos_walk().  Remove
it.

Link: https://lkml.kernel.org/r/20250306175908.66300-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 -----
 mm/damon/core.c       |   13 ++++---------
 2 files changed, 4 insertions(+), 14 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-damon_callback-before_damos_apply
+++ a/include/linux/damon.h
@@ -605,7 +605,6 @@ struct damon_operations {
  *
  * @after_wmarks_check:	Called after each schemes' watermarks check.
  * @after_aggregation:	Called after each aggregation.
- * @before_damos_apply:	Called before applying DAMOS action.
  * @before_terminate:	Called before terminating the monitoring.
  *
  * The monitoring thread (&damon_ctx.kdamond) calls @before_terminate just
@@ -626,10 +625,6 @@ struct damon_operations {
 struct damon_callback {
 	int (*after_wmarks_check)(struct damon_ctx *context);
 	int (*after_aggregation)(struct damon_ctx *context);
-	int (*before_damos_apply)(struct damon_ctx *context,
-			struct damon_target *target,
-			struct damon_region *region,
-			struct damos *scheme);
 	void (*before_terminate)(struct damon_ctx *context);
 };
 
--- a/mm/damon/core.c~mm-damon-remove-damon_callback-before_damos_apply
+++ a/mm/damon/core.c
@@ -1731,7 +1731,6 @@ static void damos_apply_scheme(struct da
 	struct timespec64 begin, end;
 	unsigned long sz_applied = 0;
 	unsigned long sz_ops_filter_passed = 0;
-	int err = 0;
 	/*
 	 * We plan to support multiple context per kdamond, as DAMON sysfs
 	 * implies with 'nr_contexts' file.  Nevertheless, only single context
@@ -1771,14 +1770,10 @@ static void damos_apply_scheme(struct da
 		if (damos_filter_out(c, t, r, s))
 			return;
 		ktime_get_coarse_ts64(&begin);
-		if (c->callback.before_damos_apply)
-			err = c->callback.before_damos_apply(c, t, r, s);
-		if (!err) {
-			trace_damos_before_apply(cidx, sidx, tidx, r,
-					damon_nr_regions(t), do_trace);
-			sz_applied = c->ops.apply_scheme(c, t, r, s,
-					&sz_ops_filter_passed);
-		}
+		trace_damos_before_apply(cidx, sidx, tidx, r,
+				damon_nr_regions(t), do_trace);
+		sz_applied = c->ops.apply_scheme(c, t, r, s,
+				&sz_ops_filter_passed);
 		damos_walk_call_walk(c, t, r, s, sz_ops_filter_passed);
 		ktime_get_coarse_ts64(&end);
 		quota->total_charged_ns += timespec64_to_ns(&end) -
_

Patches currently in -mm which might be from sj@kernel.org are


