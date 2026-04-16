Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A64C39A071;
	Thu, 16 Apr 2026 15:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776352132; cv=none; b=pd+Si7V5KYmrwtadVjDyPpn5aVLPWDallcsnMkyXllD+zJLoU/Og6v2B1A5Iwbg09iob4CBOTwgsYgdhHV2FoVaKrYm8Xk/eObA/Y0CIVVuXjAE15syp6rf2HbJNHtkPzarf20NzoLk3EqCqLA0jnkx5JyqSkW4Fq1DReHsPsfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776352132; c=relaxed/simple;
	bh=GUAmJeCr9JXvslkWuXyHVP/oVPE+DP0njCp50EYiiUM=;
	h=Date:To:From:Subject:Message-Id; b=fgAojZWIMIH/OdPkRzT+vr9Zl1sxLoPKa1QQEfdbaC2EX7aRn2+DaCu5pmAWYCRdBtZsAtS5F9mz9+Vepx2SgWlBQ8Pla6uFwTxjq5dVrQ69v2eiNeNSi+ogEYQ4L5XUGcyNp47i99oYdswr8OeBHCzJcnipNXerWU5+bhSbojk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WpwE0+3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WpwE0+3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3B3C2BCAF;
	Thu, 16 Apr 2026 15:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776352132;
	bh=GUAmJeCr9JXvslkWuXyHVP/oVPE+DP0njCp50EYiiUM=;
	h=Date:To:From:Subject:From;
	b=WpwE0+3ykaKYk8O1+71Vd+dbsAFECusZOaP5fIB/ed2TZjFjpYxvxpv2GKn+1Ftaj
	 yPYaqAMcTz2pPbDHKUPms9IW0YUl/qsuta56zXoiFPd8CFQVO9/94sYKBkLzSsxS3P
	 YJS4mUi+oU0WNjotHtMX7VZRrSTk8//Z1zxSyouw=
Date: Thu, 16 Apr 2026 08:08:48 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch added to mm-hotfixes-unstable branch
Message-Id: <20260416150850.EB3B3C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: disallow non-power of two min_region_sz on damon_start()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: disallow non-power of two min_region_sz on damon_start()
Date: Sat, 11 Apr 2026 14:36:36 -0700

Commit d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region") introduced
a bug that allows unaligned DAMON region address ranges.  Commit
c80f46ac228b ("mm/damon/core: disallow non-power of two min_region_sz")
fixed it, but only for damon_commit_ctx() use case.  Still, DAMON sysfs
interface can emit non-power of two min_region_sz via damon_start().  Fix
the path by adding the is_power_of_2() check on damon_start().

The issue was discovered by sashiko [1].

Link: https://lore.kernel.org/20260411213638.77768-1-sj@kernel.org
Link: https://lore.kernel.org/20260403155530.64647-1-sj@kernel.org [1]
Fixes: d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start
+++ a/mm/damon/core.c
@@ -1368,6 +1368,11 @@ int damon_start(struct damon_ctx **ctxs,
 	int i;
 	int err = 0;
 
+	for (i = 0; i < nr_ctxs; i++) {
+		if (!is_power_of_2(ctxs[i]->min_region_sz))
+			return -EINVAL;
+	}
+
 	mutex_lock(&damon_lock);
 	if ((exclusive && nr_running_ctxs) ||
 			(!exclusive && running_exclusive_ctxs)) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-disallow-time-quota-setting-zero-esz.patch
mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch
mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch
mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch
mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch
docs-admin-guide-mm-damon-reclaim-warn-commit_inputs-vs-param-updates-race.patch
docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race.patch

