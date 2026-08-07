Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06993B2D24;
	Fri,  7 Aug 2026 02:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068033; cv=none; b=kfni7UTUoci0U43bREan7Uj3HZIw+Jpy1VP9N6qHw7/XWNfA4FQiobHXdEcz6CJLhbcEuA/inUeS9PjJH56ktyBxCCdlDAyOxHCwlM1vCIfcVD0sloC8v54MMFXNmy3jmOVqOKYuh6HU7MT1rTuTszRzoax8/+8Q82HB+piwgeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068033; c=relaxed/simple;
	bh=ok9Ts9Y0GE1RjkCj/5XwU5R+DP62TUFesaq7oWsG7Vw=;
	h=Date:To:From:Subject:Message-Id; b=XELlCqMGR2k9+HOtTjuKN6nFc9zpVrlL4iNXolyEBknrSidFpobScO7vY28TBAYJFzFFjkrYBA5sdOMkP0lYtOI/8/9rdOOreaMs2AmNm4kG9D6Ui8ohSvElZhks07edX/kSDyy1/M+nDzgXd/h9Tqt6ibA0Wjm5bFb9QdaM0EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XXmKF6uv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XXmKF6uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BB71F00ACA;
	Fri,  7 Aug 2026 02:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068022;
	bh=ct1hoq26I73HfNGL0p7bxNO8xFS1zEhZmded3L2v19I=;
	h=Date:To:From:Subject;
	b=XXmKF6uvD0HF+Uiz/7f/fLzMzX7Oyhb4wLl5iRY1Dw23WCaeNeZiKEZUhI32tnXIb
	 SVwlfpbdzwgIWiJm+BCkFjc/srShRSnPr/IMV132l8U5r0892WCF4zfZg6oZjIr6vi
	 AOlYGl0PxP9adQ3PevX25d45xvgylU4jB7iZZEjs=
Date: Thu, 06 Aug 2026 19:00:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-skip-aging-from-repeated-aggressive-merging.patch removed from -mm tree
Message-Id: <20260807020022.66BB71F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: skip aging from repeated aggressive merging
has been removed from the -mm tree.  Its filename was
     mm-damon-core-skip-aging-from-repeated-aggressive-merging.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: skip aging from repeated aggressive merging
Date: Sun, 12 Jul 2026 09:54:30 -0700

The number of DAMON regions could temporarily exceed the user-defined
maximum number of regions limit for corner cases.  For example, users
could lower the limit via runtime parameters update.  For such a case,
kdamond_merge_regions() repeats merging regions in the case doubling the
merge threshold.  The repeated merge operation could update the age of
regions multiple times.  This corrupts the monitoring results.  Fix the
issue by asking the merge operation to skip aging for the corner case.

The user impact is degradation of the monitoring quality.  The impact
should be mild, since the degradation is only temporal, and it is not
common to happen in realistic setups.

The issue was discovered [1,2] by Sashiko.

Link: https://lore.kernel.org/20260712165432.87609-1-sj@kernel.org
Link: https://lore.kernel.org/20260621203548.10718-1-sj@kernel.org [1]
Link: https://lore.kernel.org/20260709145425.96247-1-sj@kernel.org [2]
Fixes: 310d6c15e910 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.10
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |   21 +++++++++++++--------
 mm/damon/tests/core-kunit.h |    2 +-
 2 files changed, 14 insertions(+), 9 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-skip-aging-from-repeated-aggressive-merging
+++ a/mm/damon/core.c
@@ -3308,7 +3308,7 @@ static unsigned int damon_merge_score(st
  * sz_limit	size upper limit of each region
  */
 static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
-		unsigned long sz_limit, struct damon_ctx *ctx)
+		unsigned long sz_limit, struct damon_ctx *ctx, bool count_age)
 {
 	struct damon_region *r, *prev = NULL, *next;
 	bool use_probe_hits = damon_has_probe_weights(ctx);
@@ -3319,12 +3319,14 @@ static void damon_merge_regions_of(struc
 		score = damon_merge_score(r, false, ctx, use_probe_hits);
 		last_score = damon_merge_score(r, true, ctx, use_probe_hits);
 
-		if (abs_diff(score, last_score) > thres)
-			r->age = 0;
-		else if ((score == 0) != (last_score == 0))
-			r->age = 0;
-		else
-			r->age++;
+		if (count_age) {
+			if (abs_diff(score, last_score) > thres)
+				r->age = 0;
+			else if ((score == 0) != (last_score == 0))
+				r->age = 0;
+			else
+				r->age++;
+		}
 
 		if (!prev)
 			goto set_prev_continue;
@@ -3366,15 +3368,18 @@ static void kdamond_merge_regions(struct
 	struct damon_target *t;
 	unsigned int nr_regions;
 	unsigned int max_thres;
+	bool count_age = true;
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
 	do {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-			damon_merge_regions_of(t, threshold, sz_limit, c);
+			damon_merge_regions_of(t, threshold, sz_limit, c,
+					count_age);
 			nr_regions += damon_nr_regions(t);
 		}
+		count_age = false;
 		threshold = max(1, threshold * 2);
 	} while (nr_regions > c->attrs.max_nr_regions &&
 			threshold / 2 < max_thres);
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-skip-aging-from-repeated-aggressive-merging
+++ a/mm/damon/tests/core-kunit.h
@@ -257,7 +257,7 @@ static void damon_test_merge_regions_of(
 		damon_add_region(r, t);
 	}
 
-	damon_merge_regions_of(t, 9, 9999, ctx);
+	damon_merge_regions_of(t, 9, 9999, ctx, true);
 	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
 	for (i = 0; i < 6; i++) {
_

Patches currently in -mm which might be from sj@kernel.org are


