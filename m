Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D359B38A9A1
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898335; cv=none; b=Yoz+kIoOSdbJLFCvb8pBdRcd7KFsq6SkZ7M90EaNZUXCiFPcDUIffb3MKMSHY5OL/VhFNOptVBT7odosPBUEk8/RM14XgGCKrIb1/r3cGaFD8crVv549jf2uX29fNFzT4Zhb3Hb3q9hNUlJ5H9wm84kj1jAqAQZMszkBNB8nzZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898335; c=relaxed/simple;
	bh=txQa6RjTEPMW7oqLWXib8gPglSCt5fn+qPd+cmGRwH4=;
	h=Date:To:From:Subject:Message-Id; b=V6hR2ei8aQs+dmSqw1tFBqpTBtPkoCuWrnuscRTvSIVKrHeeZ+ESGOWIJ2FFZUDNPP4spBTwoh9wU13NfIePEqnuGYzMF/F5pxaYExvWfiH1clSxxj+6T+b/g90lVnM5KFGrbsE9jfSpP3mW/iQWyvTj8KN1ghu9CNb3xaXYVx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EZftqn/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EZftqn/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691D4C4CEF1;
	Sat, 31 Jan 2026 22:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898335;
	bh=txQa6RjTEPMW7oqLWXib8gPglSCt5fn+qPd+cmGRwH4=;
	h=Date:To:From:Subject:From;
	b=EZftqn/h+cryYYYBRTPvSc5979eSujMe3bH41tkIGnzuqZpOsND/sKtHVqRpfQrgl
	 h9ABeia//KJ/ECV5I5FGMa8wZJudti2htNh+BVvuOV7YZK0uein0kwlJXuSVsloaNe
	 l49K41SBf/9K/RGB7MLqVbaj/qoSfghKRFKCjIvE=
Date: Sat, 31 Jan 2026 14:25:34 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch removed from -mm tree
Message-Id: <20260131222535.691D4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: cancel damos_walk() before damon_ctx->kdamond reset
has been removed from the -mm tree.  Its filename was
     mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: cancel damos_walk() before damon_ctx->kdamond reset
Date: Sat, 17 Jan 2026 09:52:50 -0800

damos_walk() request is canceled after damon_ctx->kdamond is reset.  This
can make weird situations where damon_is_running() returns false but the
DAMON context has the damos_walk() request linked.  There was a similar
situation for damon_call() requests handling [1], which _was_ able to
cause a racy use-after-free bug.  Unlike the case of damon_call(), because
damos_walk() is always synchronously handled and allows only single
request at time, there is no such problematic race cases.  But, keeping it
as is could stem another subtle race condition bug in future.

Avoid that by cancelling the requests before the ->kdamond reset.  Note
that this change also makes all damon_ctx dependent resource cleanups
consistently done before the damon_ctx->kdamond reset.

Link: https://lkml.kernel.org/r/20260117175256.82826-4-sj@kernel.org
Link: https://lore.kernel.org/20251230014532.47563-1-sj@kernel.org [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset
+++ a/mm/damon/core.c
@@ -2856,14 +2856,13 @@ done:
 
 	kfree(ctx->regions_score_histogram);
 	kdamond_call(ctx, true);
+	damos_walk_cancel(ctx);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
 
-	damos_walk_cancel(ctx);
-
 	mutex_lock(&damon_lock);
 	nr_running_ctxs--;
 	if (!nr_running_ctxs && running_exclusive_ctxs)
_

Patches currently in -mm which might be from sj@kernel.org are


