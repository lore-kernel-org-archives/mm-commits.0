Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6834DAD5E
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739418; cv=none; b=j8NvJjta+CPmj9QnaltUT8oNjVlMN4/LRxGDHaGMYuV9TLg9Sb411JOsSBSU0mv7LpAbFak4hNNIDPF2SUzGH+4Mq6KFK5q+lREWKj4qxS+NtA3F2HABCLzmMH2uxQvQEaqFyoZ1s6zj3LLT7vrA/UjQScY7dTPYGkF5cSLEOVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739418; c=relaxed/simple;
	bh=n7BWynU0y7P4BrUjg9PwbhGsFBjzP0jy7uRZkvY652Y=;
	h=Date:To:From:Subject:Message-Id; b=AQIwImTL4ZtzvbfLho0WWCqLN6qfO+JWYkuc6dI6vdQD2GcFyz+VDpIPg3VE0Lka6sJXmKJcWjh3xaJRsVxAj2Y8Sm35gwEp74dTsVcK7zTgTiA+WrMKVNgkuTQFJXQZlERf12IC3qveoJXwb61RdizvcvqDyRE2xTRcldH8emE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iLjglaMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iLjglaMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFBAC43390;
	Sat, 24 Feb 2024 01:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739418;
	bh=n7BWynU0y7P4BrUjg9PwbhGsFBjzP0jy7uRZkvY652Y=;
	h=Date:To:From:Subject:From;
	b=iLjglaMf1p4LE7Ja18+FGSbxiHx5emhYfsTUhZrxgwhu7eeLecraY6Y3rLkWcWdO3
	 KtviAd2YfiBgtuzQB43xvuhuQy/ltdLbYE4NGwCN3V1jnthiGH8ZGoE4LpPCVCbhGy
	 utiAVOlKVJwCADivI5xLnDrtnRFA/QetXZ7W/D84=
Date: Fri, 23 Feb 2024 17:50:17 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch removed from -mm tree
Message-Id: <20240224015018.3BFBAC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add multiple goals per damos_quota and helpers for those
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add multiple goals per damos_quota and helpers for those
Date: Mon, 19 Feb 2024 11:44:19 -0800

The feedback-driven DAMOS quota auto-tuning feature allows only single
goal to the DAMON kernel API users.  The API users could implement
multiple goals for the end-users on their level, and that's what DAMON
sysfs interface is doing.  More DAMON kernel API users such as
DAMON_RECLAIM would need to do similar work.  To reduce unnecessary future
duplciated efforts, support multiple goals from DAMOS core layer.  To make
the support in minimum non-destructive change, keep the old single goal
setup interface, and add multiple goals setup.  The single goal will
treated as one of the multiple goals, so old API users are not required to
make any change.

Link: https://lkml.kernel.org/r/20240219194431.159606-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   17 ++++++++
 mm/damon/core.c       |   78 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 88 insertions(+), 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those
+++ a/include/linux/damon.h
@@ -130,6 +130,7 @@ enum damos_action {
  * struct damos_quota_goal - DAMOS scheme quota auto-tuning goal.
  * @get_score:		Function for getting current score of the goal.
  * @get_score_arg:	Parameter for @get_score
+ * @list:		List head for siblings.
  *
  * Data structure for getting the current score of the quota tuning goal.
  * Calling @get_score with @get_score_arg as the parameter should return the
@@ -140,6 +141,7 @@ enum damos_action {
 struct damos_quota_goal {
 	unsigned long (*get_score)(void *arg);
 	void *get_score_arg;
+	struct list_head list;
 };
 
 /**
@@ -148,6 +150,7 @@ struct damos_quota_goal {
  * @ms:			Maximum milliseconds that the scheme can use.
  * @sz:			Maximum bytes of memory that the action can be applied.
  * @goal:		Quota auto-tuning goal.
+ * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
  * @esz:		Effective size quota in bytes.
  *
  * @weight_sz:		Weight of the region's size for prioritization.
@@ -171,6 +174,8 @@ struct damos_quota_goal {
  * every @reset_interval.  Then, if the new size quota is smaller than the
  * effective quota, it uses the new size quota as the effective quota.
  *
+ * If @goals is not empty, same action is taken for each goal of the list.
+ *
  * The resulting effective size quota in bytes is set to @esz.
  *
  * For selecting regions within the quota, DAMON prioritizes current scheme's
@@ -184,6 +189,7 @@ struct damos_quota {
 	unsigned long ms;
 	unsigned long sz;
 	struct damos_quota_goal goal;
+	struct list_head goals;
 	unsigned long esz;
 
 	unsigned int weight_sz;
@@ -648,6 +654,12 @@ static inline unsigned long damon_sz_reg
 #define damon_for_each_scheme_safe(s, next, ctx) \
 	list_for_each_entry_safe(s, next, &(ctx)->schemes, list)
 
+#define damos_for_each_quota_goal(goal, quota) \
+	list_for_each_entry(goal, &quota->goals, list)
+
+#define damos_for_each_quota_goal_safe(goal, next, quota) \
+	list_for_each_entry_safe(goal, next, &(quota)->goals, list)
+
 #define damos_for_each_filter(f, scheme) \
 	list_for_each_entry(f, &(scheme)->filters, list)
 
@@ -681,6 +693,11 @@ struct damos_filter *damos_new_filter(en
 void damos_add_filter(struct damos *s, struct damos_filter *f);
 void damos_destroy_filter(struct damos_filter *f);
 
+struct damos_quota_goal *damos_new_quota_goal(
+		unsigned long (*get_score)(void *), void *get_score_arg);
+void damos_add_quota_goal(struct damos_quota *q, struct damos_quota_goal *g);
+void damos_destroy_quota_goal(struct damos_quota_goal *goal);
+
 struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 			enum damos_action action,
 			unsigned long apply_interval_us,
--- a/mm/damon/core.c~mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those
+++ a/mm/damon/core.c
@@ -299,6 +299,41 @@ void damos_destroy_filter(struct damos_f
 	damos_free_filter(f);
 }
 
+struct damos_quota_goal *damos_new_quota_goal(
+		unsigned long (*get_score)(void *), void *get_score_arg)
+{
+	struct damos_quota_goal *goal;
+
+	goal = kmalloc(sizeof(*goal), GFP_KERNEL);
+	if (!goal)
+		return NULL;
+	goal->get_score = get_score;
+	goal->get_score_arg = get_score_arg;
+	INIT_LIST_HEAD(&goal->list);
+	return goal;
+}
+
+void damos_add_quota_goal(struct damos_quota *q, struct damos_quota_goal *g)
+{
+	list_add_tail(&g->list, &q->goals);
+}
+
+static void damos_del_quota_goal(struct damos_quota_goal *g)
+{
+	list_del(&g->list);
+}
+
+static void damos_free_quota_goal(struct damos_quota_goal *g)
+{
+	kfree(g);
+}
+
+void damos_destroy_quota_goal(struct damos_quota_goal *g)
+{
+	damos_del_quota_goal(g);
+	damos_free_quota_goal(g);
+}
+
 /* initialize fields of @quota that normally API users wouldn't set */
 static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 {
@@ -337,6 +372,8 @@ struct damos *damon_new_scheme(struct da
 	INIT_LIST_HEAD(&scheme->list);
 
 	scheme->quota = *(damos_quota_init(quota));
+	/* quota.goals should be separately set by caller */
+	INIT_LIST_HEAD(&scheme->quota.goals);
 
 	scheme->wmarks = *wmarks;
 	scheme->wmarks.activated = true;
@@ -373,8 +410,12 @@ static void damon_free_scheme(struct dam
 
 void damon_destroy_scheme(struct damos *s)
 {
+	struct damos_quota_goal *g, *g_next;
 	struct damos_filter *f, *next;
 
+	damos_for_each_quota_goal_safe(g, g_next, &s->quota)
+		damos_destroy_quota_goal(g);
+
 	damos_for_each_filter_safe(f, next, s)
 		damos_destroy_filter(f);
 	damon_del_scheme(s);
@@ -1083,22 +1124,44 @@ static unsigned long damon_feed_loop_nex
 	return min_input;
 }
 
-/* Called only if quota->ms, quota->sz, or quota->goal.get_score are set */
+/* Return the highest score since it makes schemes least aggressive */
+static unsigned long damos_quota_score(struct damos_quota *quota)
+{
+	struct damos_quota_goal *goal;
+	unsigned long highest_score = 0;
+
+	if (quota->goal.get_score)
+		highest_score = quota->goal.get_score(
+				quota->goal.get_score_arg);
+
+	damos_for_each_quota_goal(goal, quota)
+		highest_score = max(highest_score,
+				goal->get_score(goal->get_score_arg));
+
+	return highest_score;
+}
+
+/*
+ * Called only if quota->ms, quota->sz, or quota->goal.get_score are set, or
+ * quota->goals is not empty
+ */
 static void damos_set_effective_quota(struct damos_quota *quota)
 {
 	unsigned long throughput;
 	unsigned long esz;
 
-	if (!quota->ms && !quota->goal.get_score) {
+	if (!quota->ms && !quota->goal.get_score &&
+			list_empty(&quota->goals)) {
 		quota->esz = quota->sz;
 		return;
 	}
 
-	if (quota->goal.get_score) {
+	if (quota->goal.get_score || !list_empty(&quota->goals)) {
+		unsigned long score = damos_quota_score(quota);
+
 		quota->esz_bp = damon_feed_loop_next_input(
 				max(quota->esz_bp, 10000UL),
-				quota->goal.get_score(
-					quota->goal.get_score_arg));
+				score);
 		esz = quota->esz_bp / 10000;
 	}
 
@@ -1108,7 +1171,7 @@ static void damos_set_effective_quota(st
 				quota->total_charged_ns;
 		else
 			throughput = PAGE_SIZE * 1024;
-		if (quota->goal.get_score)
+		if (quota->goal.get_score || !list_empty(&quota->goals))
 			esz = min(throughput * quota->ms, esz);
 		else
 			esz = throughput * quota->ms;
@@ -1128,7 +1191,8 @@ static void damos_adjust_quota(struct da
 	unsigned long cumulated_sz;
 	unsigned int score, max_score = 0;
 
-	if (!quota->ms && !quota->sz && !quota->goal.get_score)
+	if (!quota->ms && !quota->sz && !quota->goal.get_score &&
+			list_empty(&quota->goals))
 		return;
 
 	/* New charge window starts */
_

Patches currently in -mm which might be from sj@kernel.org are


