Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F8419D093
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744868; cv=none; b=QTOX07bbV2iHSdgekEa1BAEHKZO8ZxyBUe4ov6K3lq1ipk/7Hj0EZMjhqzIsCb0jtvbTQ0h8z2f06d5RZ6xYgEJZ6+DCDbsz01cQdzd6v4bWzuLG6IaCFcR1A4I1vC8s2PBGo/GfY9NaOyiO0z0BOHlBBT52a0+wFrsxhsYujY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744868; c=relaxed/simple;
	bh=g1e9LDOKkqWAhpgpZ0zfXe6AfT2AbBFrloQWhL7th44=;
	h=Date:To:From:Subject:Message-Id; b=iF4vtmIyramDSVNC3c8Z2GJ9jYozaMR2UrpLD35n3ehNF3jWlN003p8GWySfNRxDYSstWui2wnDCv+oAA78Co8gi26tD7k1aj7MqEXjX/ycpYYL61wnLli/gOLTUec9+zR6OMcKhZH50c+BW0WCDRwJqP1RuAAnaXDnnkW+oCUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dkc1Nygk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dkc1Nygk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E756C4CEF7;
	Sun, 29 Mar 2026 00:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744868;
	bh=g1e9LDOKkqWAhpgpZ0zfXe6AfT2AbBFrloQWhL7th44=;
	h=Date:To:From:Subject:From;
	b=dkc1NygkqHs7FF/l5iH6vJGsYA0x26AyXNR9S+YFYERehHFzNvSRqFxjh7w7iyzwr
	 edBBsCyvxXrBBSuL9LC5iD3vaonDt+Z3dlAocoKPgdZuFGlQy8EKKRxmBzIoWEEf0p
	 tNiO4+kSmKwxclY5VtYofD3OKQhmdyR8eAZxUl1o=
Date: Sat, 28 Mar 2026 17:41:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch removed from -mm tree
Message-Id: <20260329004108.3E756C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
Date: Mon, 9 Mar 2026 18:05:19 -0700

Introduce a new goal-based DAMOS quota auto-tuning algorithm, namely
DAMOS_QUOTA_GOAL_TUNER_TEMPORAL (temporal in short).  The algorithm aims
to trigger the DAMOS action only for a temporal time, to achieve the goal
as soon as possible.  For the temporal period, it uses as much quota as
allowed.  Once the goal is achieved, it sets the quota zero, so
effectively makes the scheme be deactivated.

Link: https://lkml.kernel.org/r/20260310010529.91162-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |   29 ++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-introduce-damos_quota_goal_tuner_temporal
+++ a/include/linux/damon.h
@@ -218,9 +218,11 @@ struct damos_quota_goal {
 /**
  * enum damos_quota_goal_tuner - Goal-based quota tuning logic.
  * @DAMOS_QUOTA_GOAL_TUNER_CONSIST:	Aim long term consistent quota.
+ * @DAMOS_QUOTA_GOAL_TUNER_TEMPORAL:	Aim zero quota asap.
  */
 enum damos_quota_goal_tuner {
 	DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+	DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
 };
 
 /**
--- a/mm/damon/core.c~mm-damon-core-introduce-damos_quota_goal_tuner_temporal
+++ a/mm/damon/core.c
@@ -2347,6 +2347,26 @@ static unsigned long damos_quota_score(s
 	return highest_score;
 }
 
+static void damos_goal_tune_esz_bp_consist(struct damos_quota *quota)
+{
+	unsigned long score = damos_quota_score(quota);
+
+	quota->esz_bp = damon_feed_loop_next_input(
+			max(quota->esz_bp, 10000UL), score);
+}
+
+static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
+{
+	unsigned long score = damos_quota_score(quota);
+
+	if (score >= 10000)
+		quota->esz_bp = 0;
+	else if (quota->sz)
+		quota->esz_bp = quota->sz * 10000;
+	else
+		quota->esz_bp = ULONG_MAX;
+}
+
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
@@ -2361,11 +2381,10 @@ static void damos_set_effective_quota(st
 	}
 
 	if (!list_empty(&quota->goals)) {
-		unsigned long score = damos_quota_score(quota);
-
-		quota->esz_bp = damon_feed_loop_next_input(
-				max(quota->esz_bp, 10000UL),
-				score);
+		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
+			damos_goal_tune_esz_bp_consist(quota);
+		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
+			damos_goal_tune_esz_bp_temporal(quota);
 		esz = quota->esz_bp / 10000;
 	}
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

