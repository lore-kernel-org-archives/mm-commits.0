Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE06623C4FA
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744833; cv=none; b=QRmWwNepNdI7/i+djUSloUfRi9hCaaYiXbimbcL4DSEP79Pqqgp7g85r/IjlFNjHY5Ut8MWWm42OnxncAuIi5DJiMmWwfJWQf7wlhjx17xz2OsDOAOdOoJ/jcRpJbc1gqZ2CFnNI/hUu8Bm1ou6YvVJl4vKBNMzhYahwoJtXdCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744833; c=relaxed/simple;
	bh=/Hqwww5zWwNp5iLUR2Pmhc7sBrSH2A49vFdthLnHA9Q=;
	h=Date:To:From:Subject:Message-Id; b=BcdpFbsSwT54/ltxjLdGMccfUSkQTLQ/MWEp0MdEm0dnH/l7E++i/GdEOpwfvGkCTFWZmqpq0dfssxUwlu904AcTd+5hxRxXDudpmwVlVaJQYycvKPT0lq/oALPhxzFOXbVvIBc58b9KUHlDPYZpj9Aqw0aZoOCyNYR9dIJa9uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jejNCf6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jejNCf6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FF4C4CEF7;
	Sun, 29 Mar 2026 00:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744833;
	bh=/Hqwww5zWwNp5iLUR2Pmhc7sBrSH2A49vFdthLnHA9Q=;
	h=Date:To:From:Subject:From;
	b=jejNCf6jmasJt5QaxS6NUG05Lic1xfME8RvYz4Wv454LWMlXm4T8pxe3/rlDPBa6G
	 HduoFz26AUbdYd+Co+ocOYEWl9HexIGLw+FCwh00pG7cHCWixo5OUKz9i49Ct9rnXD
	 T+l6ap7jSwStiySfh6bPbwmN8FonYQYXC9kv4dAo=
Date: Sat, 28 Mar 2026 17:40:33 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-time_after_eq-in-kdamond_fn.patch removed from -mm tree
Message-Id: <20260329004033.B6FF4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use time_after_eq() in kdamond_fn()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-time_after_eq-in-kdamond_fn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: use time_after_eq() in kdamond_fn()
Date: Sat, 7 Mar 2026 11:49:14 -0800

damon_ctx->passed_sample_intervals and damon_ctx->next_*_sis are unsigned
long.  Those are compared in kdamond_fn() using normal comparison
operators.  It is unsafe from overflow.  Use time_after_eq(), which is
safe from overflows when correctly used, instead.

Link: https://lkml.kernel.org/r/20260307194915.203169-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-time_after_eq-in-kdamond_fn
+++ a/mm/damon/core.c
@@ -2921,7 +2921,8 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
-		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
+		if (time_after_eq(ctx->passed_sample_intervals,
+					next_aggregation_sis)) {
 			kdamond_merge_regions(ctx,
 					max_nr_accesses / 10,
 					sz_limit);
@@ -2943,10 +2944,12 @@ static int kdamond_fn(void *data)
 
 		sample_interval = ctx->attrs.sample_interval ?
 			ctx->attrs.sample_interval : 1;
-		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
+		if (time_after_eq(ctx->passed_sample_intervals,
+					next_aggregation_sis)) {
 			if (ctx->attrs.intervals_goal.aggrs &&
-					ctx->passed_sample_intervals >=
-					ctx->next_intervals_tune_sis) {
+					time_after_eq(
+						ctx->passed_sample_intervals,
+						ctx->next_intervals_tune_sis)) {
 				/*
 				 * ctx->next_aggregation_sis might be updated
 				 * from kdamond_call().  In the case,
@@ -2980,7 +2983,8 @@ static int kdamond_fn(void *data)
 			kdamond_split_regions(ctx);
 		}
 
-		if (ctx->passed_sample_intervals >= next_ops_update_sis) {
+		if (time_after_eq(ctx->passed_sample_intervals,
+					next_ops_update_sis)) {
 			ctx->next_ops_update_sis = next_ops_update_sis +
 				ctx->attrs.ops_update_interval /
 				sample_interval;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

