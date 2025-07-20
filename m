Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D6A14AD2D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976934; cv=none; b=LIrgAcJE4LztxOMfJv3280YHYSAAu47Fybtigq14i4s4T4RGW9806BpLWZamGwTGVsWan0NoSUTwSAS8srzYtHEZhwMx7L5NM1dXGEd95pNe9geS9AY7mb3CpjEaGxtv5PC5Qhx7pDP1lvFxXwJKsIjXQnuOpQtb5No4acaeUGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976934; c=relaxed/simple;
	bh=CJIXnXG1ytIvyckJGodCnZz6K/z5JsoJls8bWyNoJjU=;
	h=Date:To:From:Subject:Message-Id; b=CYTmjl0JZLcSnHbKOasYjd4mhD/m91G1XZDbAs1JRjitrCWF2VTt4jijF6X+fFvMPuOeVV+H4VNJv2P2hrkkqSHcDKXPahT/ja8fMx5D/UKnIs2I+SZ1CjUUqbU7tV3EOGQ2X9ThbzpBMfJYwyNJzYskPb0iMa1KbLLCpWt4xn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ytdWXah4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ytdWXah4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE90FC4CEE3;
	Sun, 20 Jul 2025 02:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976933;
	bh=CJIXnXG1ytIvyckJGodCnZz6K/z5JsoJls8bWyNoJjU=;
	h=Date:To:From:Subject:From;
	b=ytdWXah48DgrACUaxZRJlnfdz0gKDuhkeluW+kkV4a7ETxDSmvniHIiIBJxNXPKxC
	 WtuiZWSEpXavsn9GlM+ew1zYjDlKAwLfWb9vw8k+iU18rZLJMYg9BWtu+9EuWeOg9C
	 BiIZQd/Sz5fz/sS9CCU7JMGFNRWPH8Px6Q2Byp4o=
Date: Sat, 19 Jul 2025 19:02:13 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch removed from -mm tree
Message-Id: <20250720020213.BE90FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: use damon_call() repeat mode instead of damon_callback
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use damon_call() repeat mode instead of damon_callback
Date: Sat, 12 Jul 2025 12:50:07 -0700

DAMON_LRU_SORT uses damon_callback for periodically reading and writing
DAMON internal data and parameters.  Use its alternative, damon_call()
repeat mode.

Link: https://lkml.kernel.org/r/20250712195016.151108-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   70 +++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback
+++ a/mm/damon/lru_sort.c
@@ -230,6 +230,39 @@ out:
 	return err;
 }
 
+static int damon_lru_sort_handle_commit_inputs(void)
+{
+	int err;
+
+	if (!commit_inputs)
+		return 0;
+
+	err = damon_lru_sort_apply_parameters();
+	commit_inputs = false;
+	return err;
+}
+
+static int damon_lru_sort_damon_call_fn(void *arg)
+{
+	struct damon_ctx *c = arg;
+	struct damos *s;
+
+	/* update the stats parameter */
+	damon_for_each_scheme(s, c) {
+		if (s->action == DAMOS_LRU_PRIO)
+			damon_lru_sort_hot_stat = s->stat;
+		else if (s->action == DAMOS_LRU_DEPRIO)
+			damon_lru_sort_cold_stat = s->stat;
+	}
+
+	return damon_lru_sort_handle_commit_inputs();
+}
+
+static struct damon_call_control call_control = {
+	.fn = damon_lru_sort_damon_call_fn,
+	.repeat = true,
+};
+
 static int damon_lru_sort_turn(bool on)
 {
 	int err;
@@ -249,7 +282,7 @@ static int damon_lru_sort_turn(bool on)
 	if (err)
 		return err;
 	kdamond_pid = ctx->kdamond->pid;
-	return 0;
+	return damon_call(ctx, &call_control);
 }
 
 static int damon_lru_sort_enabled_store(const char *val,
@@ -288,38 +321,6 @@ module_param_cb(enabled, &enabled_param_
 MODULE_PARM_DESC(enabled,
 	"Enable or disable DAMON_LRU_SORT (default: disabled)");
 
-static int damon_lru_sort_handle_commit_inputs(void)
-{
-	int err;
-
-	if (!commit_inputs)
-		return 0;
-
-	err = damon_lru_sort_apply_parameters();
-	commit_inputs = false;
-	return err;
-}
-
-static int damon_lru_sort_after_aggregation(struct damon_ctx *c)
-{
-	struct damos *s;
-
-	/* update the stats parameter */
-	damon_for_each_scheme(s, c) {
-		if (s->action == DAMOS_LRU_PRIO)
-			damon_lru_sort_hot_stat = s->stat;
-		else if (s->action == DAMOS_LRU_DEPRIO)
-			damon_lru_sort_cold_stat = s->stat;
-	}
-
-	return damon_lru_sort_handle_commit_inputs();
-}
-
-static int damon_lru_sort_after_wmarks_check(struct damon_ctx *c)
-{
-	return damon_lru_sort_handle_commit_inputs();
-}
-
 static int __init damon_lru_sort_init(void)
 {
 	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
@@ -327,8 +328,7 @@ static int __init damon_lru_sort_init(vo
 	if (err)
 		goto out;
 
-	ctx->callback.after_wmarks_check = damon_lru_sort_after_wmarks_check;
-	ctx->callback.after_aggregation = damon_lru_sort_after_aggregation;
+	call_control.data = ctx;
 
 	/* 'enabled' has set before this function, probably via command line */
 	if (enabled)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

