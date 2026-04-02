Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2AC40DFAD;
	Thu,  2 Apr 2026 18:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775153814; cv=none; b=eFEJNcv2ppZNgUMXL10Ka9pP0j2nBfSfkXZwVItUhZSi0Ggm3n25/he2+vB8NyRCSJpZe1XvdARt2rGxIt7Xnyq9j4/uO+j/0XwI+Vz3a4BhuEsXK5fc9z5cXasX6/8GPm3oMpRDWQXNRr3WR1eDzZy1ANBjK76Q/vTvVGnl/qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775153814; c=relaxed/simple;
	bh=1HUIFxw7IEVSVQfSYHCrsFERzjTsfVDyFOwcnC9cNSA=;
	h=Date:To:From:Subject:Message-Id; b=COGtiKdZ8HyKt6wSLk9zBmtfAd2DBpem7k+NuroGzuNOhcgB5hJGzJcmMS5qinqvARWGNidVXBmwlQ7OwQudBbz8Em/s24NydNFwxr5qwMY9sLDmt5yLBVV+orhv88N6JpdDPJIFqonaYcIFKjIIo3Ta1J+olmu1JY1LZG/sTFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wJzBnGdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wJzBnGdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C913C116C6;
	Thu,  2 Apr 2026 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775153814;
	bh=1HUIFxw7IEVSVQfSYHCrsFERzjTsfVDyFOwcnC9cNSA=;
	h=Date:To:From:Subject:From;
	b=wJzBnGdHrj69LwG5yPIjfMwCRzPtcvpX82Rz2rC38zg/I4PWQHlQSl9Dma1sdQgdo
	 jQSDvSF3jBsUQXzS2asNwY3bkEhKQ+JcJKc3d7aSbeQOz8M7u6uShoQ/91BRToqZ5L
	 xyDiyeJpBx2bltnsts1uiQZLf5hUt+YqJD6cNvwk=
Date: Thu, 02 Apr 2026 11:16:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch removed from -mm tree
Message-Id: <20260402181654.2C913C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Wed, 1 Apr 2026 18:04:55 -0700

DAMON_STAT does not deallocate its dynamically allocated damon_ctx object
when damon_call() is failed.  As a result, the memory is leaked.  Check
the failure and deallocate the damon_ctx object.

The issue was discovered [1] by sashiko.


Link: https://lkml.kernel.org/r/20260402010457.66860-1-sj@kernel.org
Link: https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org [1]
Fixes: 405f61996d9d ("mm/damon/stat: use damon_call() repeat mode instead of damon_callback")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/damon/stat.c~mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx
+++ a/mm/damon/stat.c
@@ -254,7 +254,12 @@ static int damon_stat_start(void)
 
 	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
-	return damon_call(damon_stat_context, &call_control);
+	err = damon_call(damon_stat_context, &call_control);
+	if (err) {
+		damon_destroy_ctx(damon_stat_context);
+		damon_stat_context = NULL;
+	}
+	return err;
 }
 
 static void damon_stat_stop(void)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch
mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch
mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch
mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch
docs-admin-guide-mm-damon-reclaim-warn-commit_inputs-vs-param-updates-race.patch
docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race.patch

