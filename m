Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C58346797
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 20:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773002170; cv=none; b=M93GjtRhmHXhgq240QWaTG9P5j71AuhUMAeBVkMlAkk09ksFWKnJQ87vVhkoFByxdrcki1nKl2izq+y1NKqFtFRxzuvuiULjBWSrDfeAt54aZ/46eZ9UZdDexlAFvwE1GmosPGnayI9RJGXKTSBWVKiyOp4qms5sbu013uLKd7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773002170; c=relaxed/simple;
	bh=UR/sWCbpU1aSxXzZ3YuahNu7Ms6a0aO605RpVjW20N4=;
	h=Date:To:From:Subject:Message-Id; b=S2h+GBeJKaLKPMawhMzYVjRbwoTz0FQksDA71tDDFKI4tLsaRhKXTpSVEpmIbezbQ5QpF8CAfd7kNtNwv+c3ODW18PPGrxhealnx2ikEXsP6UQfCz7/R1M1KQd6gPqWGp52vULbqsINE61aJu9H/6lH4V7cEHZiugt/SIvKfOmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d3k1D+kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d3k1D+kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1DCC116C6;
	Sun,  8 Mar 2026 20:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773002169;
	bh=UR/sWCbpU1aSxXzZ3YuahNu7Ms6a0aO605RpVjW20N4=;
	h=Date:To:From:Subject:From;
	b=d3k1D+kt/rF7xAx888b5rMQRUpwB1QCnL7UN4uqPhEKrzpDueqXdnvuBKXt8Ogv6D
	 rHWEpKhP3ThLh7RCTEXijUDssJok8KuvPKt60Lv4bEu9Q1jMWfD8EMuYJr8ysEvU3f
	 4BYR4GvaWAM12A07TOW7MVJCTUnBf6XVelP7VewY=
Date: Sun, 08 Mar 2026 13:36:09 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-time_before-for-next_apply_sis.patch added to mm-new branch
Message-Id: <20260308203609.DB1DCC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: use time_before() for next_apply_sis
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-use-time_before-for-next_apply_sis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-time_before-for-next_apply_sis.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: use time_before() for next_apply_sis
Date: Sat, 7 Mar 2026 11:49:13 -0800

damon_ctx->passed_sample_intervals and damos->next_apply_sis are unsigned
long, and compared via normal comparison operators.  It is unsafe from
overflow.  Use time_before(), which is safe from overflow when correctly
used, instead.

Link: https://lkml.kernel.org/r/20260307194915.203169-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-time_before-for-next_apply_sis
+++ a/mm/damon/core.c
@@ -2095,7 +2095,7 @@ static void damon_do_apply_schemes(struc
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 
-		if (c->passed_sample_intervals < s->next_apply_sis)
+		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
 		if (!s->wmarks.activated)
@@ -2453,7 +2453,7 @@ static void kdamond_apply_schemes(struct
 	bool has_schemes_to_apply = false;
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals < s->next_apply_sis)
+		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
 		if (!s->wmarks.activated)
@@ -2477,7 +2477,7 @@ static void kdamond_apply_schemes(struct
 	}
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals < s->next_apply_sis)
+		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 		damos_walk_complete(c, s);
 		damos_set_next_apply_sis(s, c);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch

