Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2B310F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744831; cv=none; b=fP2qOt/O7CC0V63uiqlFAsYUFdyeMmF1DMqbttQu5eNfxWUPsAw9S6fryt/LTN36rGSLSnMKceyCmcEaAj9lJU8Ej8AF1UH9Wa0N5U5gH/D+460MUanXJZXJuxnyhd4NgL+pjHH/qA6Qepn3bsqtdeCutEn8tdGu5HapnAVR2tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744831; c=relaxed/simple;
	bh=WcLmNCU5IwKdbl7j473uE7Tv5T+YuCkpCnI//9UB1ZE=;
	h=Date:To:From:Subject:Message-Id; b=AB9fYTI59/cxrDUxh+8cc/V2aLmY6CSgNsvZcpFwGA6DIW+saEV5bVw1cVAAlWNiPSeMtDeMhOssWSy3+rN17y1zPnHBVAwX0YH4sR8iAJcMxdZGMQMHjvXBG3Bsc+Hpe9nGctXj267rW45ikeg4g0olMyhY3VH+Kt6JjBrQdy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iHmcnPFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iHmcnPFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E32C4CEF7;
	Sun, 29 Mar 2026 00:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744831;
	bh=WcLmNCU5IwKdbl7j473uE7Tv5T+YuCkpCnI//9UB1ZE=;
	h=Date:To:From:Subject:From;
	b=iHmcnPFLOXeyMYRVsaSPCGm0uR0aJ0TNOqbcdR1DkLcpMAD4EvrGQ3FFuwBckNyjg
	 GnALq9XIc6hdIj92Y7svjYcS58DRKYOL8XB1ZmHYDKgk/SZwyCa4n1ND4S0Ey/9Xli
	 rmygOtnZhn2qQTi7C2Za2Nqp27wLV00lG3ZBOGYk=
Date: Sat, 28 Mar 2026 17:40:31 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch removed from -mm tree
Message-Id: <20260329004031.85E32C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove damos_set_next_apply_sis() duplicates
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: remove damos_set_next_apply_sis() duplicates
Date: Sat, 7 Mar 2026 11:49:12 -0800

Patch series "mm/damon/core: make passed_sample_intervals comparisons
overflow-safe".

DAMON accounts time using its own jiffies-like time counter, namely
damon_ctx->passed_sample_intervals.  The counter is incremented on each
iteration of kdamond_fn() main loop, which sleeps at least one sample
interval.  Hence the name is like that.

DAMON has time-periodic operations including monitoring results
aggregation and DAMOS action application.  DAMON sets the next time to do
each of such operations in the passed_sample_intervals unit.  And it does
the operation when the counter becomes the same to or larger than the
pre-set values, and update the next time for the operation.  Note that the
operation is done not only when the values exactly match but also when the
time is passed, because the values can be updated for online-committed
DAMON parameters.

The counter is 'unsigned long' type, and the comparison is done using
normal comparison operators.  It is not safe from overflows.  This can
cause rare and limited but odd situations.

Let's suppose there is an operation that should be executed every 20
sampling intervals, and the passed_sample_intervals value for next
execution of the operation is ULONG_MAX - 3.  Once the
passed_sample_intervals reaches ULONG_MAX - 3, the operation will be
executed, and the next time value for doing the operation becomes 17
(ULONG_MAX - 3 + 20), since overflow happens.  In the next iteration of
the kdamond_fn() main loop, passed_sample_intervals is larger than the
next operation time value, so the operation will be executed again.  It
will continue executing the operation for each iteration, until the
passed_sample_intervals also overflows.

Note that this will not be common and problematic in the real world.  The
sampling interval, which takes for each passed_sample_intervals increment,
is 5 ms by default.  And it is usually [auto-]tuned for hundreds of
milliseconds.  That means it takes about 248 days or 4,971 days to have
the overflow on 32 bit machines when the sampling interval is 5 ms and 100
ms, respectively (1<<32 * sampling_interval_in_seconds / 3600 / 24).  On
64 bit machines, the numbers become 2924712086.77536 and 58494241735.5072
years.  So the real user impact is negligible.  But still this is better
to be fixed as long as the fix is simple and efficient.

Fix this by simply replacing the overflow-unsafe native comparison
operators with the existing overflow-safe time comparison helpers.

The first patch only cleans up the next DAMOS action application time
setup for consistency and reduced code.  The second and the third patches
update DAMOS action application time setup and rest, respectively.


This patch (of 3):

There is a function for damos->next_apply_sis setup.  But some places are
open-coding it.  Consistently use the helper.

Link: https://lkml.kernel.org/r/20260307194915.203169-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-damos_set_next_apply_sis-duplicates
+++ a/mm/damon/core.c
@@ -2452,8 +2452,6 @@ static void kdamond_apply_schemes(struct
 	struct damon_target *t;
 	struct damon_region *r;
 	struct damos *s;
-	unsigned long sample_interval = c->attrs.sample_interval ?
-		c->attrs.sample_interval : 1;
 	bool has_schemes_to_apply = false;
 
 	damon_for_each_scheme(s, c) {
@@ -2484,9 +2482,7 @@ static void kdamond_apply_schemes(struct
 		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
 		damos_walk_complete(c, s);
-		s->next_apply_sis = c->passed_sample_intervals +
-			(s->apply_interval_us ? s->apply_interval_us :
-			 c->attrs.aggr_interval) / sample_interval;
+		damos_set_next_apply_sis(s, c);
 		s->last_applied = NULL;
 		damos_trace_stat(c, s);
 	}
@@ -2864,7 +2860,6 @@ static void kdamond_init_ctx(struct damo
 {
 	unsigned long sample_interval = ctx->attrs.sample_interval ?
 		ctx->attrs.sample_interval : 1;
-	unsigned long apply_interval;
 	struct damos *scheme;
 
 	ctx->passed_sample_intervals = 0;
@@ -2875,9 +2870,7 @@ static void kdamond_init_ctx(struct damo
 		ctx->attrs.intervals_goal.aggrs;
 
 	damon_for_each_scheme(scheme, ctx) {
-		apply_interval = scheme->apply_interval_us ?
-			scheme->apply_interval_us : ctx->attrs.aggr_interval;
-		scheme->next_apply_sis = apply_interval / sample_interval;
+		damos_set_next_apply_sis(scheme, ctx);
 		damos_set_filters_default_reject(scheme);
 	}
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

