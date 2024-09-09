Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A32018A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925223; cv=none; b=A2laeh/SRgBcgjogVW8bPAvYu2nbtP8tEhey7KOiTTTLE57/q3hP1IzkT/ss5aK4pBuJ9SvkcjuMFuEEILxQQK/doKWzm7BJ/UyFZjFeF6qwuiNvytG0Ab9qXzQQkh/bVtlNvXGQJ25O2p7dO31hOQJvf3AAgJZcBMAMx+W9HM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925223; c=relaxed/simple;
	bh=ed4Ewy13q+mHwGpLOdjGjrNK4A8c7OPt11bX65/LYH8=;
	h=Date:To:From:Subject:Message-Id; b=DPiDFP7ihMjCSAyIHGo1wMrHOlYMR4NcyTtTuQVwoHRE2qETYmHA81+K7gQRidAbgGQHBvUhXTn50l7jwkgBTMbPLDoATht2T4MhmBRrXFXV9MlAkmh8aMuVdF44i7SRNbiYID5+0qkwpOzd7Xg/ks0kkglPyRJAucg1ZpBfqqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vP87Bg5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vP87Bg5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3DAC4CEC5;
	Mon,  9 Sep 2024 23:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925223;
	bh=ed4Ewy13q+mHwGpLOdjGjrNK4A8c7OPt11bX65/LYH8=;
	h=Date:To:From:Subject:From;
	b=vP87Bg5Olz5wxQcplYbsyixcb2RmWLf6IdPIguo5LsZj4ySD6nhcvbRtem5KHmT0m
	 AA9bO++kASLyPvisy0fkHHxHQToON7ZAHlbVUCkO9/XjPTjSApHnvpP3aLxjl2/NDz
	 2iOxwltc/lHI7E4ji9tIOwtGM9SZy9uEEsusWzDw=
Date: Mon, 09 Sep 2024 16:40:22 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch removed from -mm tree
Message-Id: <20240909234023.6F3DAC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: replace per-quota regions priority histogram buffer usage with per-context one
has been removed from the -mm tree.  Its filename was
     mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: replace per-quota regions priority histogram buffer usage with per-context one
Date: Sun, 25 Aug 2024 21:23:21 -0700

Replace the usage of per-quota region priorities histogram buffer with the
per-context one.  After this change, the per-quota histogram is not used
by anyone, and hence it is ready to be removed.

Link: https://lkml.kernel.org/r/20240826042323.87025-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one
+++ a/mm/damon/core.c
@@ -1582,13 +1582,16 @@ static void damos_adjust_quota(struct da
 		return;
 
 	/* Fill up the score histogram */
-	memset(quota->histogram, 0, sizeof(quota->histogram));
+	memset(c->regions_score_histogram, 0,
+			sizeof(*c->regions_score_histogram) *
+			(DAMOS_MAX_SCORE + 1));
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t) {
 			if (!__damos_valid_target(r, s))
 				continue;
 			score = c->ops.get_scheme_score(c, t, r, s);
-			quota->histogram[score] += damon_sz_region(r);
+			c->regions_score_histogram[score] +=
+				damon_sz_region(r);
 			if (score > max_score)
 				max_score = score;
 		}
@@ -1596,7 +1599,7 @@ static void damos_adjust_quota(struct da
 
 	/* Set the min score limit */
 	for (cumulated_sz = 0, score = max_score; ; score--) {
-		cumulated_sz += quota->histogram[score];
+		cumulated_sz += c->regions_score_histogram[score];
 		if (cumulated_sz >= quota->esz || !score)
 			break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are


