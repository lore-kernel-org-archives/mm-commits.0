Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832317;
	b=zMRybGr18liJs8r69v50ajDViamUa5KUHXMak+neQZShA1JOgh3NQCg9OZfWa14CIOAe
	 QlcrAknMzyrc/ihWgVKMU8DSwZbxnHfaSRn2hjDkvh1UAAvejhTtDnpjtI+fVc5/gb71J
	 UXkA9C0X8+nFCUcrYoWp7VrBGrnbO48zzYcR0Bk5MW6FS2JKmhHu7taje/mUFl/z/fM1s
	 lm1+a7wZmzvRoE5iPY4z6F2agbEF3TnLWcfSsHU6Si10dP+fzEkiQ/YrSifTzuayQZgBF
	 xEDdRUS7RtR8HiOsDxUX9Gx9ljr5E2oiDwrJfU98h5asztAHNhUVd9KKuYCcHtaQEuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832317;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GbLKFaFjXrU3oWI8v7zMCAQ1cIjXH9z+89lJYXzpK2s=;
	b=se0dqfOoeAuphSddVNzejJtqIrnzm5QrlwleJO72kix1odUEDJ4fa4BJtwPUiiGhaMWC
	 2KZFfHkmaos42Tgv7IN/mygRu8EEOpChxCfRJV4FcRnki0+3bNpZCcIDMUWckpIK0n3Ag
	 8ibC2Z7dPJceQ93dQPXu7m63wDMVJetrc0N0aR3osAfy3+5fiGB0+XLZfocKS9s5JYAGy
	 z9mXY6OQyp/wmYH6pw+M+U8pwLzpPQ3kU6WHg8KwLp+SHruzAwLaGdjYuAhE7KzffpMWp
	 9leHQlm1cGBOmg25FfxYoxGSAOGxY/Kojgt946fM5jyPe/OEJQutowQUkAHrURNn7jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="w+Z/++HP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1E2606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w+Z/++HP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E151F01828;
	Sat, 24 Oct 2026 08:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832316;
	bh=GbLKFaFjXrU3oWI8v7zMCAQ1cIjXH9z+89lJYXzpK2s=;
	h=Date:To:From:Subject;
	b=w+Z/++HP4Jz0LK911LuQQXyIu2PTlH1Pijm2OtaykuGcLV8LLxAhhd60NLDkNvSSX
	 7PdfOrAFHdJNgoVKTbH9FXqf4/PgNp6mBcxvUe9EixdYEo23wZ1/twNxOHMZJ3zGDy
	 uE6OC8+XbbEikqlQq3VFW0ADQgHMFh4fn2y4j7WY=
Date: Sat, 24 Oct 2026 01:58:36 -0700
To: mm-commits@vger.kernel.org,gutierrez.asier@huawei-partners.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch removed from -mm tree
Message-Id: <20261024085836.78E151F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/core: add complement argument to damos_new_quota_goal()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: add complement argument to damos_new_quota_goal()
Date: Tue, 29 Sep 2026 01:01:05 -0700

damos_quota_goal->complement needs to be manually set by each API
callers.  It is easy to make mistakes.  Extend the quota goal
constructor, damos_new_quota_goal() to receive and set the complement
flag value. Also update all callers to use the new signature.

Link: https://lore.kernel.org/20260929080113.41708-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---

 include/linux/damon.h       |    2 +-
 mm/damon/core.c             |    7 ++++---
 mm/damon/lru_sort.c         |    5 +++--
 mm/damon/reclaim.c          |    5 +++--
 mm/damon/sysfs-schemes.c    |    2 +-
 mm/damon/tests/core-kunit.h |    3 ++-
 samples/damon/mtier.c       |    2 +-
 7 files changed, 15 insertions(+), 11 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-add-complement-argument-to-damos_new_quota_goal
+++ a/include/linux/damon.h
@@ -1090,7 +1090,7 @@ bool damos_filter_for_ops(enum damos_fil
 void damos_destroy_filter(struct damos_filter *f);
 
 struct damos_quota_goal *damos_new_quota_goal(
-		enum damos_quota_goal_metric metric,
+		enum damos_quota_goal_metric metric, bool complement,
 		unsigned long target_value);
 void damos_add_quota_goal(struct damos_quota *q, struct damos_quota_goal *g);
 void damos_destroy_quota_goal(struct damos_quota_goal *goal);
--- a/mm/damon/core.c~mm-damon-core-add-complement-argument-to-damos_new_quota_goal
+++ a/mm/damon/core.c
@@ -691,7 +691,7 @@ void damos_destroy_filter(struct damos_f
 }
 
 struct damos_quota_goal *damos_new_quota_goal(
-		enum damos_quota_goal_metric metric,
+		enum damos_quota_goal_metric metric, bool complement,
 		unsigned long target_value)
 {
 	struct damos_quota_goal *goal;
@@ -700,6 +700,7 @@ struct damos_quota_goal *damos_new_quota
 	if (!goal)
 		return NULL;
 	goal->metric = metric;
+	goal->complement = complement;
 	goal->target_value = target_value;
 	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
 		goal->last_psi_total = U64_MAX;
@@ -1262,8 +1263,8 @@ int damos_commit_quota_goals(struct damo
 	damos_for_each_quota_goal_safe(src_goal, next, src) {
 		if (j++ < i)
 			continue;
-		new_goal = damos_new_quota_goal(
-				src_goal->metric, src_goal->target_value);
+		new_goal = damos_new_quota_goal(src_goal->metric,
+				src_goal->complement, src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
 		err = damos_commit_quota_goal(new_goal, src_goal);
--- a/mm/damon/lru_sort.c~mm-damon-core-add-complement-argument-to-damos_new_quota_goal
+++ a/mm/damon/lru_sort.c
@@ -233,12 +233,13 @@ static int damon_lru_sort_add_quota_goal
 
 	if (!active_mem_bp)
 		return 0;
-	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
+	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, false,
+			active_mem_bp);
 	if (!goal)
 		return -ENOMEM;
 	damos_add_quota_goal(&hot_scheme->quota, goal);
 	/* aim 0.2 % goal conflict, to keep little ping pong */
-	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP,
+	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP, false,
 			10000 - active_mem_bp + 2);
 	if (!goal)
 		return -ENOMEM;
--- a/mm/damon/reclaim.c~mm-damon-core-add-complement-argument-to-damos_new_quota_goal
+++ a/mm/damon/reclaim.c
@@ -233,7 +233,7 @@ static int damon_reclaim_apply_parameter
 	damon_set_schemes(param_ctx, &scheme, 1);
 
 	if (quota_mem_pressure_us) {
-		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
+		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US, false,
 				quota_mem_pressure_us);
 		if (!goal)
 			goto out;
@@ -241,7 +241,8 @@ static int damon_reclaim_apply_parameter
 	}
 
 	if (quota_autotune_feedback) {
-		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, false,
+				10000);
 		if (!goal)
 			goto out;
 		goal->current_value = quota_autotune_feedback;
--- a/mm/damon/sysfs-schemes.c~mm-damon-core-add-complement-argument-to-damos_new_quota_goal
+++ a/mm/damon/sysfs-schemes.c
@@ -2869,7 +2869,7 @@ static int damos_sysfs_add_quota_score(
 		if (!sysfs_goal->target_value)
 			continue;
 
-		goal = damos_new_quota_goal(sysfs_goal->metric,
+		goal = damos_new_quota_goal(sysfs_goal->metric, false,
 				sysfs_goal->target_value);
 		if (!goal)
 			return -ENOMEM;
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-add-complement-argument-to-damos_new_quota_goal
+++ a/mm/damon/tests/core-kunit.h
@@ -1014,6 +1014,7 @@ static void damos_test_commit_quota_goal
 		 * Make it kfree()-able.
 		 */
 		goal = damos_new_quota_goal(dst_goals[i].metric,
+				dst_goals[i].complement,
 				dst_goals[i].target_value);
 		if (!goal)
 			goto out;
@@ -2411,7 +2412,7 @@ static void damos_test_esz_goal_temporal
 	}
 	damon_add_scheme(ctx, s);
 
-	goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+	goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, false, 10000);
 	if (!goal) {
 		damon_destroy_ctx(ctx);
 		kunit_skip(test, "quota goal alloc fail");
--- a/samples/damon/mtier.c~mm-damon-core-add-complement-argument-to-damos_new_quota_goal
+++ a/samples/damon/mtier.c
@@ -163,7 +163,7 @@ static struct damon_ctx *damon_sample_mt
 	damon_set_schemes(ctx, &scheme, 1);
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
-			DAMOS_QUOTA_NODE_MEM_FREE_BP,
+			DAMOS_QUOTA_NODE_MEM_FREE_BP, false,
 			promote ? node0_mem_used_bp : node0_mem_free_bp);
 	if (!quota_goal)
 		goto free_out;
_

Patches currently in -mm which might be from sj@kernel.org are


