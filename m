Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC76B3BADB1;
	Fri,  7 Aug 2026 02:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068077; cv=none; b=VtsbJW+2aNyYo4zA3i+YU4YZJjUuOG1zldWfxpTpGVWnMDpZYsD2LWlKUNoqFeje4mrjiplOJvfSOwUhzuQfIPOIJy206BPJKgYK0KUwrKpqY2uwQNHkFE40xVKBvTQ+9cKhsyQUbnaBIsXAnSKWKS+7uz0+JowFJjcsQROWRLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068077; c=relaxed/simple;
	bh=925M/HXsVyxmI6KwIcM6U/jcwYmH+O2INrjawOSj3Vc=;
	h=Date:To:From:Subject:Message-Id; b=PUPv4B4ZlRQ3tqyP/GEtMSHT0nrGkcRpBb8pC3L3W6Ot3SXelqYvmiNhUxMmA1PysJqGyODP4mGuuaY1mcL5XiOt23gcV+Vzc259DNKCHbR/6QObbxo8ZRRMo3pt0/ShrKE45ntcJ+NpI4l5QqwEKAA0frTzwmQssQJjg6ZOTng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=spwubQAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="spwubQAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCB21F00A3D;
	Fri,  7 Aug 2026 02:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068074;
	bh=xmVlC5HKS027LvA86XHpW6tB0s0Gg5nAM8kizbj0gHo=;
	h=Date:To:From:Subject;
	b=spwubQAsVQ6Rl+giTdXrCM44pKQsdwgnfIGI+xPIo/y0FQkNZvms0ZVBkO8QuOV0D
	 e5dfNF+pobVq1qLON/bxhaBUdRr7gKuNXPJj3RwO5n+K2HsYpK92AFmlfKUWAjLXFG
	 gEp7PSdgnzN9dDDnus85lWpMxQwp9XZGZX7KVxHE=
Date: Thu, 06 Aug 2026 19:01:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop.patch removed from -mm tree
Message-Id: <20260807020114.8BCB21F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
has been removed from the -mm tree.  Its filename was
     mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
Date: Tue, 14 Jul 2026 20:09:56 -0700

Patch series "mm/damon: unurgent fixes for infinite loop, NULL de-ref and
races", v1.1.

Sashiko found a few issues in DAMON that could cause infinite loop, NULL
dereference and monitoring results degradation.  The first two sounds
scary but the infinite loop happens only under unreasonable user setup. 
The NULL dereference is only in a unit test.  Monitoring results
degradation is trivial since it is only best-effort, and those happens
from only unlikely races.  Still those are bugs that better to fix if
possible.  Fix those.


This patch (of 6):

Due to online parameter update like events, the number of DAMON regions
could be higher than the user-set upper limit.  kdamond_merge_regions()
repeats merge regions until the number meets the limit, while doubling the
merge threshold up to the theoretical maximum threshold.  It is tried only
up to the theoretical maximum threshold because even the aggressive
merging can fail from reducing the number of regions under the
user-defined upper limit.  For example, there could be many user-defined
non-contiguous regions that cannot be merged.

The threshold based loop break condition is evaluated by comparing the
threshold for the next merging try against the theoretical maximum
threshold.  If max_thres is larger than UINT_MAX / 2, doubling the
threshold could make it overflow, and bypass the loop break condition.  In
the case, if the number of regions cannot be reduced under the upper limit
like explained above, the loop will run infinitely.

Prevent the case by doing the break condition check before doubling the
threshold.  Also, prevent the threshold exceeding the maximum threshold,
as it could overflow and apply the wrong merge threshold.

This issue is unlikely to occur in real world, since having the max_thres
higher than UINT_MAX / 2 require unrealistically large aggregation
intervals compared to the sampling interval.  Also, it requires an
unrealistically large number of uncontiguous regions setup.  Nonetheless,
the consequence is bad and the fix is simple.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-1-sj@kernel.org
Link: https://lore.kernel.org/20260715031002.108504-2-sj@kernel.org
Link: https://lore.kernel.org/20260709145425.96247-1-sj@kernel.org [1]
Fixes: 310d6c15e910 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.10.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop
+++ a/mm/damon/core.c
@@ -3372,7 +3372,7 @@ static void kdamond_merge_regions(struct
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
-	do {
+	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
 			damon_merge_regions_of(t, threshold, sz_limit, c,
@@ -3380,9 +3380,14 @@ static void kdamond_merge_regions(struct
 			nr_regions += damon_nr_regions(t);
 		}
 		count_age = false;
-		threshold = max(1, threshold * 2);
-	} while (nr_regions > c->attrs.max_nr_regions &&
-			threshold / 2 < max_thres);
+		if (nr_regions <= c->attrs.max_nr_regions ||
+				max_thres <= threshold)
+			break;
+		if (threshold < max_thres / 2)
+			threshold = max(1, threshold * 2);
+		else
+			threshold = max_thres;
+	}
 }
 
 #ifdef CONFIG_DAMON_DEBUG_SANITY
_

Patches currently in -mm which might be from sj@kernel.org are


