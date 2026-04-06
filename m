Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B4938F225;
	Mon,  6 Apr 2026 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775499266; cv=none; b=sNoOQAhCTb+nFdF6mMuFRShVAIhzbVsgaXll/g6btgLqk97YJ81a9RN7BFcn9eBvl2axova6KDaPlgKWW8Jt9TeetJv3px02SP8wf5tDOylz4GBmMOO3yFZfTJjJV/QJ+UuUSfEEZwSSEq714zleDcnNSla9kMWBR4ZfdJ0uBr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775499266; c=relaxed/simple;
	bh=ELqwEKtKuo2HvRhGypY4lanBnc/s6u6+NMS9yriKHqg=;
	h=Date:To:From:Subject:Message-Id; b=htXXzyP4nwTLYE6iI03Yrl6L8fc2qrzDF73Cvp1PQp31NKErg9bPGhI7nnd2NaLS48F6bsRtnIQzeuy9MzQkEstehf/zRHdOztliU8fSB8IXMxRzCuOyU88Eoq90TOgG7rZk4TsyXgGMl8l7mYa2XDhsbraDYXFoA/grobu4jac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XqZnYQpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XqZnYQpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9D7C4CEF7;
	Mon,  6 Apr 2026 18:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775499266;
	bh=ELqwEKtKuo2HvRhGypY4lanBnc/s6u6+NMS9yriKHqg=;
	h=Date:To:From:Subject:From;
	b=XqZnYQpddXCalyBpReyYGbXZi+UrJwRIPLL7GRFVyWvayg7dC9lnv5KicdJn5sLmj
	 LnebHPVpxSBFunT2/KjC6i11wqp605pTbo4DWQqbmir+0mrWVzbVTlq5SXE986HuZw
	 6NJblU/+JR5w5lYUiavzDqefOr9+ccT2Pj8y9vto=
Date: Mon, 06 Apr 2026 11:14:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch removed from -mm tree
Message-Id: <20260406181426.1A9D7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Thu, 2 Apr 2026 06:44:17 -0700

damon_stat_start() always allocates the module's damon_ctx object
(damon_stat_context).  Meanwhile, if damon_call() in the function fails,
the damon_ctx object is not deallocated.  Hence, if the damon_call() is
failed, and the user writes Y to “enabled” again, the previously
allocated damon_ctx object is leaked.

This cannot simply be fixed by deallocating the damon_ctx object when
damon_call() fails.  That's because damon_call() failure doesn't guarantee
the kdamond main function, which accesses the damon_ctx object, is
completely finished.  In other words, if damon_stat_start() deallocates
the damon_ctx object after damon_call() failure, the not-yet-terminated
kdamond could access the freed memory (use-after-free).

Fix the leak while avoiding the use-after-free by keeping returning
damon_stat_start() without deallocating the damon_ctx object after
damon_call() failure, but deallocating it when the function is invoked
again and the kdamond is completely terminated.  If the kdamond is not yet
terminated, simply return -EAGAIN, as the kdamond will soon be terminated.

The issue was discovered [1] by sashiko.

Link: https://lkml.kernel.org/r/20260402134418.74121-1-sj@kernel.org
Link: https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org [1]
Fixes: 405f61996d9d ("mm/damon/stat: use damon_call() repeat mode instead of damon_callback")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/stat.c~mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx
+++ a/mm/damon/stat.c
@@ -245,6 +245,12 @@ static int damon_stat_start(void)
 {
 	int err;
 
+	if (damon_stat_context) {
+		if (damon_is_running(damon_stat_context))
+			return -EAGAIN;
+		damon_destroy_ctx(damon_stat_context);
+	}
+
 	damon_stat_context = damon_stat_build_ctx();
 	if (!damon_stat_context)
 		return -ENOMEM;
@@ -261,6 +267,7 @@ static void damon_stat_stop(void)
 {
 	damon_stop(&damon_stat_context, 1);
 	damon_destroy_ctx(damon_stat_context);
+	damon_stat_context = NULL;
 }
 
 static int damon_stat_enabled_store(
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch
mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch
mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch
docs-admin-guide-mm-damon-reclaim-warn-commit_inputs-vs-param-updates-race.patch
docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race.patch

