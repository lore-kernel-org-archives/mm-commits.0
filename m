Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A102B675
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739428; cv=none; b=py3lUatiedxfJNIRyuxFOdwj2N7x/vG5v88+vWwEiScg8h1gi2fhsAEOw/ED4JpFh5s9W2YBkaSk5idb7hGCXihHrxK5OurWjuaMiT07VvXkjz8rTEJOaEEOBls7F+sEJ8WsQuXbs3ePLEENJKjqMbsG0veI/bACz+rMbG3THAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739428; c=relaxed/simple;
	bh=e3CdWtCR7hkacKsJTqN/xmE+/2aRTPTrfPGshFCSQN8=;
	h=Date:To:From:Subject:Message-Id; b=UfhtaMa3lD7Gk5i7UngrU4uhujAcQMnNuGGmLr5DZc1ePJsk7mVjKz7l0N70xI7mCYdzXjxdXc9oCixJbcv6YlnZdLDWwExk1NVck7ile/4Lyh4EM70UVvXuLToCFeZKWTy729PEhfV3BOFDzXSPax36fGeydp1nv+RIqcNpek8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gH7efjaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gH7efjaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CB5C433F1;
	Sat, 24 Feb 2024 01:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739428;
	bh=e3CdWtCR7hkacKsJTqN/xmE+/2aRTPTrfPGshFCSQN8=;
	h=Date:To:From:Subject:From;
	b=gH7efjaUOoz/jIFzOZCv/YW7DDtiGgMUsqOttPBUEZFkN08fVLZ5/JUxhgK64LiR8
	 yXOnqO5r2UKsiKz+Koj7T+6smrsOEeHEtLkHpMji5b4uAnZBwIIFgOOw/pulKgzj9n
	 Npq8DrQFE5nvJCjDFP0GFcd+R7u0bU/xSfkEx/CE=
Date: Fri, 23 Feb 2024 17:50:27 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch removed from -mm tree
Message-Id: <20240224015028.50CB5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: implement user-feedback driven quota auto-tuning
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: implement user-feedback driven quota auto-tuning
Date: Mon, 19 Feb 2024 11:44:29 -0800

DAMOS supports user-feedback driven quota auto-tuning, but only DAMON
sysfs interface is using it.  Add support of the feature on DAMON_RECLAIM
by adding one more input parameter, namely 'quota_autotune_feedback', for
providing the user feedback to DAMON_RECLAIM.  It assumes the target value
of the feedback is 10,000.

Link: https://lkml.kernel.org/r/20240219194431.159606-19-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning
+++ a/mm/damon/reclaim.c
@@ -62,6 +62,21 @@ static struct damos_quota damon_reclaim_
 };
 DEFINE_DAMON_MODULES_DAMOS_QUOTAS(damon_reclaim_quota);
 
+/*
+ * User-specifiable feedback for auto-tuning of the effective quota.
+ *
+ * While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
+ * increases and decreases the effective level of the quota aiming receiving this
+ * feedback of value ``10,000`` from the user.  DAMON_RECLAIM assumes the feedback
+ * value and the quota are positively proportional.  Value zero means disabling
+ * this auto-tuning feature.
+ *
+ * Disabled by default.
+ *
+ */
+static unsigned long quota_autotune_feedback __read_mostly;
+module_param(quota_autotune_feedback, ulong, 0600);
+
 static struct damos_watermarks damon_reclaim_wmarks = {
 	.metric = DAMOS_WMARK_FREE_MEM_RATE,
 	.interval = 5000000,	/* 5 seconds */
@@ -159,11 +174,13 @@ static void damon_reclaim_copy_quota_sta
 	dst->charged_from = src->charged_from;
 	dst->charge_target_from = src->charge_target_from;
 	dst->charge_addr_from = src->charge_addr_from;
+	dst->esz_bp = src->esz_bp;
 }
 
 static int damon_reclaim_apply_parameters(void)
 {
 	struct damos *scheme, *old_scheme;
+	struct damos_quota_goal *goal;
 	struct damos_filter *filter;
 	int err = 0;
 
@@ -180,6 +197,17 @@ static int damon_reclaim_apply_parameter
 			damon_reclaim_copy_quota_status(&scheme->quota,
 					&old_scheme->quota);
 	}
+
+	if (quota_autotune_feedback) {
+		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+		if (!goal) {
+			damon_destroy_scheme(scheme);
+			return -ENOMEM;
+		}
+		goal->current_value = quota_autotune_feedback;
+		damos_add_quota_goal(&scheme->quota, goal);
+	}
+
 	if (skip_anon) {
 		filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
 		if (!filter) {
_

Patches currently in -mm which might be from sj@kernel.org are


