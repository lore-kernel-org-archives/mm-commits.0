Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5833CF73;
	Fri,  1 Nov 2024 00:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730420723; cv=none; b=ViqoWbYWoamdHxXtBMq/BdN1Fvsvr/dqOvMwkLKkQltzj9Rym4YzQui0v8jtB3BBenZtDrw8kHLEaFUIm1lImZbabolvc1nuUyyhgdsUOC1/Dcc/RJNGGlN2q5TrceUp0vEkew9AdtHw1pdYx3SLRh3gRz7YQ3ziDvv14V9tlbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730420723; c=relaxed/simple;
	bh=V46/P9Tl4kwIfOEQTPaZals9+Qn+S40XGmhYDBe6ylQ=;
	h=Date:To:From:Subject:Message-Id; b=Grhrv6gQuK3in8xFugfGGxQMuR+/F+tSCUchWaDJmzpY7ufC2prGxmVP0sqk8WlH303GpWqqLIP1UYOgLDhzK8FaNW48bwg6hmVGogIs5Q5AxMiNJsgih4vWYaoWK3GdKtrrkf9ijkEgnwfB+8SCjlOlUrEwrnenQGib/7jhrKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T1UXFbtm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T1UXFbtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0688DC4CECF;
	Fri,  1 Nov 2024 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730420723;
	bh=V46/P9Tl4kwIfOEQTPaZals9+Qn+S40XGmhYDBe6ylQ=;
	h=Date:To:From:Subject:From;
	b=T1UXFbtm9vQiCa68LyTlL3M8IMQEchwzt8RiQL35HX7GS27EWD+1kLzfkDZ2CKVzQ
	 fbOkP5vUz52tuVjDW1KDpa+6Ienet/iOiXq/yI9gU7XXhU1vBBwji6VN3mzY4v9Ut2
	 icRT6hRR+n+ZKrimXc7E1v/LcrWif+n32Usrxo8U=
Date: Thu, 31 Oct 2024 17:25:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-handle-zero-aggregationops_update-intervals.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101002523.0688DC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: handle zero {aggregation,ops_update} intervals
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-handle-zero-aggregationops_update-intervals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-handle-zero-aggregationops_update-intervals.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/core: handle zero {aggregation,ops_update} intervals
Date: Thu, 31 Oct 2024 11:37:56 -0700

Patch series "mm/damon/core: fix handling of zero non-sampling intervals".

DAMON's internal intervals accounting logic is not correctly handling
non-sampling intervals of zero values for a wrong assumption.  This could
cause unexpected monitoring behavior, and even result in infinite hang of
DAMON sysfs interface user threads in case of zero aggregation interval. 
Fix those by updating the intervals accounting logic.  For details of the
root case and solutions, please refer to commit messages of fixes.


This patch (of 2):

DAMON's logics to determine if this is the time to do aggregation and ops
update assumes next_{aggregation,ops_update}_sis are always set larger
than current passed_sample_intervals.  And therefore it further assumes
continuously incrementing passed_sample_intervals every sampling interval
will make it reaches to the next_{aggregation,ops_update}_sis in future. 
The logic therefore make the action and update
next_{aggregation,ops_updaste}_sis only if passed_sample_intervals is same
to the counts, respectively.

If Aggregation interval or Ops update interval are zero, however,
next_aggregation_sis or next_ops_update_sis are set same to current
passed_sample_intervals, respectively.  And passed_sample_intervals is
incremented before doing the next_{aggregation,ops_update}_sis check. 
Hence, passed_sample_intervals becomes larger than
next_{aggregation,ops_update}_sis, and the logic says it is not the time
to do the action and update next_{aggregation,ops_update}_sis forever,
until an overflow happens.  In other words, DAMON stops doing aggregations
or ops updates effectively forever, and users cannot get monitoring
results.

Based on the documents and the common sense, a reasonable behavior for
such inputs is doing an aggregation and an ops update for every sampling
interval.  Handle the case by removing the assumption.

Note that this could incur particular real issue for DAMON sysfs interface
users, in case of zero Aggregation interval.  When user starts DAMON with
zero Aggregation interval and asks online DAMON parameter tuning via DAMON
sysfs interface, the request is handled by the aggregation callback. 
Until the callback finishes the work, the user who requested the online
tuning just waits.  Hence, the user will be stuck until the
passed_sample_intervals overflows.

Link: https://lkml.kernel.org/r/20241031183757.49610-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20241031183757.49610-2-sj@kernel.org
Fixes: 4472edf63d66 ("mm/damon/core: use number of passed access sampling as a timer")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-handle-zero-aggregationops_update-intervals
+++ a/mm/damon/core.c
@@ -2000,7 +2000,7 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
-		if (ctx->passed_sample_intervals == next_aggregation_sis) {
+		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
 			kdamond_merge_regions(ctx,
 					max_nr_accesses / 10,
 					sz_limit);
@@ -2018,7 +2018,7 @@ static int kdamond_fn(void *data)
 
 		sample_interval = ctx->attrs.sample_interval ?
 			ctx->attrs.sample_interval : 1;
-		if (ctx->passed_sample_intervals == next_aggregation_sis) {
+		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
 			ctx->next_aggregation_sis = next_aggregation_sis +
 				ctx->attrs.aggr_interval / sample_interval;
 
@@ -2028,7 +2028,7 @@ static int kdamond_fn(void *data)
 				ctx->ops.reset_aggregated(ctx);
 		}
 
-		if (ctx->passed_sample_intervals == next_ops_update_sis) {
+		if (ctx->passed_sample_intervals >= next_ops_update_sis) {
 			ctx->next_ops_update_sis = next_ops_update_sis +
 				ctx->attrs.ops_update_interval /
 				sample_interval;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-zero-aggregationops_update-intervals.patch
mm-damon-core-handle-zero-schemes-apply-interval.patch
selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch

