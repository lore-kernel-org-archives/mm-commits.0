Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEB725A33F
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744867; cv=none; b=iEInBHLiIop6SxSh4Ar2I7W5gXjqJ2CW0KiI0yEabgouWMzwsnfL7ezNyiyg+TcfV6snYN3zV9bL5e7jKm1Zr+h994TLLVe4gu+NjVJtb6nOCmEDAZle1kprHo9s/z3pKrOMxGGUlFP+l3Be/cXagr2Ix8jMQE/FXNL51EYRMYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744867; c=relaxed/simple;
	bh=A5sC0enUi76V19ddPuTesUucqAXFCX8NybL3MxmbG2s=;
	h=Date:To:From:Subject:Message-Id; b=EauC7lDrPRJgvh9ZJTHmh1KU2J1e1irsbaaGsFUJME4CDFnqL1wAJ0s6IvqkSL8Txb9IylQdLnDwqcGxABs/fFYZ5Dw25n0XwptPenxmLC2cA0HJD+s5+Qatpe+1rGwI+v3YesiraLk38Vd2UQhMrz4MVsF/8/WsJ07UoGTakko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tAna4Cpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tAna4Cpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A50C4CEF7;
	Sun, 29 Mar 2026 00:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744867;
	bh=A5sC0enUi76V19ddPuTesUucqAXFCX8NybL3MxmbG2s=;
	h=Date:To:From:Subject:From;
	b=tAna4Cpi2oltJG3HTGWIais+xRfWBKOVaEpHO7LwEdEy0N91WZUOh6WIfeUGaIALE
	 QhM5wa1rDJ93k+g8QaB6k/RqD6VvF4VqKKfzWmaa3sivHcBcB4ZrvqpcxFPAoA+lai
	 +gB5L1JGvjLKuNlXG4G7VRLofO0krdmULvixpKKg=
Date: Sat, 28 Mar 2026 17:41:06 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch removed from -mm tree
Message-Id: <20260329004107.23A50C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: allow quota goals set zero effective size quota
has been removed from the -mm tree.  Its filename was
     mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: allow quota goals set zero effective size quota
Date: Mon, 9 Mar 2026 18:05:18 -0700

User-explicit quotas (size and time quotas) having zero value means the
quotas are unset.  And, effective size quota is set as the minimum value
of the explicit quotas.  When quota goals are set, the goal-based quota
tuner can make it lower.  But the existing only single tuner never sets
the effective size quota zero.  Because of the fact, DAMON core assumes
zero effective quota means the user has set no quota.

Multiple tuners are now allowed, though.  In the future, some tuners might
want to set a zero effective size quota.  There is no reason to restrict
that.  Meanwhile, because of the current implementation, it will only
deactivate all quotas and make the scheme work at its full speed.

Introduce a dedicated function for checking if no quota is set.  The
function checks the fact by showing if the user-set explicit quotas are
zero and no goal is installed.  It is decoupled from zero effective quota,
and hence allows future tuners set zero effective quota for intentionally
deactivating the scheme by a purpose.

Link: https://lkml.kernel.org/r/20260310010529.91162-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-allow-quota-goals-set-zero-effective-size-quota
+++ a/mm/damon/core.c
@@ -387,6 +387,11 @@ void damos_destroy_quota_goal(struct dam
 	damos_free_quota_goal(g);
 }
 
+static bool damos_quota_goals_empty(struct damos_quota *q)
+{
+	return list_empty(&q->goals);
+}
+
 /* initialize fields of @quota that normally API users wouldn't set */
 static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 {
@@ -1791,12 +1796,24 @@ static bool __damos_valid_target(struct
 		r->age <= s->pattern.max_age_region;
 }
 
+/*
+ * damos_quota_is_set() - Return if the given quota is actually set.
+ * @quota:	The quota to check.
+ *
+ * Returns true if the quota is set, false otherwise.
+ */
+static bool damos_quota_is_set(struct damos_quota *quota)
+{
+	return quota->esz || quota->sz || quota->ms ||
+		!damos_quota_goals_empty(quota);
+}
+
 static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 		struct damos *s)
 {
 	bool ret = __damos_valid_target(r, s);
 
-	if (!ret || !s->quota.esz || !c->ops.get_scheme_score)
+	if (!ret || !damos_quota_is_set(&s->quota) || !c->ops.get_scheme_score)
 		return ret;
 
 	return c->ops.get_scheme_score(c, r, s) >= s->quota.min_score;
@@ -2066,7 +2083,8 @@ static void damos_apply_scheme(struct da
 	}
 
 	if (c->ops.apply_scheme) {
-		if (quota->esz && quota->charged_sz + sz > quota->esz) {
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz + sz > quota->esz) {
 			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
 					c->min_region_sz);
 			if (!sz)
@@ -2085,7 +2103,8 @@ static void damos_apply_scheme(struct da
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		quota->charged_sz += sz;
-		if (quota->esz && quota->charged_sz >= quota->esz) {
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
 		}
@@ -2113,7 +2132,8 @@ static void damon_do_apply_schemes(struc
 			continue;
 
 		/* Check the quota */
-		if (quota->esz && quota->charged_sz >= quota->esz)
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz >= quota->esz)
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
@@ -2398,7 +2418,8 @@ static void damos_adjust_quota(struct da
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-		if (quota->esz && quota->charged_sz >= quota->esz)
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz >= quota->esz)
 			s->stat.qt_exceeds++;
 		quota->total_charged_sz += quota->charged_sz;
 		quota->charged_from = jiffies;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

