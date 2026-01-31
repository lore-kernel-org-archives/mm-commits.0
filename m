Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702AB38A73C
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898334; cv=none; b=PxjcMFNVkxTcdU1Xm1Q8G7q7bOQ4+bRBKSYkkJNSzJf0OTlE+BhrWqum8EXntVA4GM5+OpKiKO8VNIbF27Cxo06hizRCTQd3Kd4+punvjFgxD8zk+FMgSTRWAxlQm5e745PlEQTm37bp+E/4CSSDg2VPKuE7BhRFF95htyme4uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898334; c=relaxed/simple;
	bh=hBTS3NeMKJCpagLW5ZUj/AXHHoDfZeO6j8fTHnw7ER8=;
	h=Date:To:From:Subject:Message-Id; b=oJ648KbFOOSEtHtLkHVhzkEBe7fa2D4B+GN1dZYtt5I/icRkVjzK7SJ3FzZU0v6BflvF07DJ9MR4o+f+NGDkTy+rhHPpMm6nOEqY8GF9qAdRyg/Bh3bcklTJQ3C4Gi2dAD50KmMOTSrhAcFeML10z+uZIuuANhLOfvqHyyGS0ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yad6yYhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yad6yYhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48874C4CEF1;
	Sat, 31 Jan 2026 22:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898334;
	bh=hBTS3NeMKJCpagLW5ZUj/AXHHoDfZeO6j8fTHnw7ER8=;
	h=Date:To:From:Subject:From;
	b=Yad6yYhEJzXA+pSewj37H9/6HkfuLSWG24mDZmRnpzfnV2jAwyARWGJfvs5wX9Wi3
	 ROWMU2qvOHA23nDYuYW/wRCu6zig62bzTdWHz390BFw+Iqx/FQbSV2h1LWgyS1Mr8L
	 19P5AtgE6LZ8+h3vTPpc3p5ZV5ULrFQ6sZG0ky8I=
Date: Sat, 31 Jan 2026 14:25:33 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch removed from -mm tree
Message-Id: <20260131222534.48874C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: cleanup targets and regions at once on kdamond termination
has been removed from the -mm tree.  Its filename was
     mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: cleanup targets and regions at once on kdamond termination
Date: Sat, 17 Jan 2026 09:52:49 -0800

When kdamond terminates, it destroys the regions of the context first, and
the targets of the context just before the kdamond main function returns. 
Because regions are linked inside targets, doing them separately is only
inefficient and looks weird.  A more serious problem is that the cleanup
of the targets is done after damon_ctx->kdamond reset, which is the event
that lets DAMON API callers know the kdamond is no longer actively
running.  That is, some DAMON targets could still exist while kdamond is
not running.  There are no real problems from this, but this implicit fact
could cause subtle racy issues in future.  Destroy targets and regions at
one.

Adding contexts on how the code has evolved in the way.  Doing only
regions destruction was because putting pids of the targets were done on
DAMON API callers.  Commit 7114bc5e01cf ("mm/damon/core: add
cleanup_target() ops callback") moved the role to be done via operations
set on each target destruction.  Hence it removed the reason to do only
regions cleanup.  Commit 3a69f1635769 ("mm/damon/core: destroy targets
when kdamond_fn() finish") therefore further destructed targets on kdamond
termination time.  It was still separated from regions destruction because
damon_operations->cleanup() may do additional targets cleanup.  Placing
the targets destruction after damon_ctx->kdamond reset was just an
unnecessary decision of the commit.  The previous commit removed
damon_operations->cleanup(), so there is no more reason to do destructions
of regions and targets separately.

Link: https://lkml.kernel.org/r/20260117175256.82826-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination
+++ a/mm/damon/core.c
@@ -2748,8 +2748,6 @@ static void kdamond_init_ctx(struct damo
 static int kdamond_fn(void *data)
 {
 	struct damon_ctx *ctx = data;
-	struct damon_target *t;
-	struct damon_region *r, *next;
 	unsigned int max_nr_accesses = 0;
 	unsigned long sz_limit = 0;
 
@@ -2854,10 +2852,7 @@ static int kdamond_fn(void *data)
 		}
 	}
 done:
-	damon_for_each_target(t, ctx) {
-		damon_for_each_region_safe(r, next, t)
-			damon_destroy_region(r, t);
-	}
+	damon_destroy_targets(ctx);
 
 	kfree(ctx->regions_score_histogram);
 	kdamond_call(ctx, true);
@@ -2875,7 +2870,6 @@ done:
 		running_exclusive_ctxs = false;
 	mutex_unlock(&damon_lock);
 
-	damon_destroy_targets(ctx);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are


