Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832291;
	b=ebeK38wUlW1aqM2knvBbmePSWhZonUdzQjfaXOHkz7yqEsrYdJpJ9CXgZrCOOHQXcUsR
	 P06c6b/7lB3/5WYzfEi43+DNRqBSfMuNOOXUL8Jh8af1cIc0rac1gC25SBWKovAW8E9Jh
	 2B7iIOSqzqOL0EveOKmXAOCpceNYjdlxkGzkoHefWg6Sl5BG1dfbYNsEP5OfXFpSpaZFn
	 xCeElbyWDFFu4pCaeg2alG84aktZVC8WqmKjXzQIOVpo1fomzcydid1YBswEVXOblrVtb
	 qByxBA4VYFVz4I4KyM+l8mHBQQDpMFbof0hZRhGyju62QtFgmGnshViYWF2HBXD95Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832291;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=m/JJvVuotEWVIbVHKe86yc1j5+ARZhhkSmjJgCU9n28=;
	b=ocF+7h2ScJ4trzxmyDFAPoslV12rtP7SdnjjirZ+w9IskbnmWG3MOVlfkqqK4zngygh7
	 jtR3fFUIeAovkZlXupeECwJOewa3oyD/NC5eFomuBCa36BDlStrtjZ4hRSsPlQcWJd8o7
	 6Qja1xdVWPWR7Z017S2dNjLsVJWsC5VnVGyYDOgtFwrK4xisyRgMTZ6hS3POCD1QF9PXH
	 vtnuB9vJA1yu7D6/rT4zRyLWlLSy0tSDT0YYYP+b3FkagtugdWzeyq/3YFamEZoCs9bUr
	 BuJ1lQ4AKx8sAePGdR0le/6uUpQsw5X51wCde3vYlCAC2AHZffMl2UJNdM1sNIH7fbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Ye/2Fskm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32CE606A31B;
	Sat, 24 Oct 2026 08:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ye/2Fskm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6831F01828;
	Sat, 24 Oct 2026 08:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832290;
	bh=m/JJvVuotEWVIbVHKe86yc1j5+ARZhhkSmjJgCU9n28=;
	h=Date:To:From:Subject;
	b=Ye/2Fskm+8sN6Vb+3H7ft+cO9+tdeeSN8j1hmd3uKXaRskj2XTZhf0pFUsYClG2GY
	 rkScbaTnfi1zCQ80Sqx0yBDEr90dhCRaVB3IHyNU6AV9nKgF1Unmp0yxTgmGTNxs06
	 +pyOn9UFNsErmizTKruXlnExjC/Y9zrFY1YFRz18=
Date: Sat, 24 Oct 2026 01:58:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,bijan311@gmail.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch removed from -mm tree
Message-Id: <20261024085810.BF6831F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/core: preserve the quota passed to damon_new_scheme()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: mm/damon/core: preserve the quota passed to damon_new_scheme()
Date: Mon, 28 Sep 2026 01:58:33 -0700

Patch series "mm/damon/core: preserve quota state when constructing
schemes", v3.

damon_commit_ctx() first commits the running context's parameters to a
temporary context for validating proposed updates.  Constructing the
temporary schemes clears the running schemes' quota state because
damon_new_scheme() initializes the quota passed as a parameter before
copying it to the new scheme.  Even an update later rejected with -EINVAL
loses the running quota state.

Initialize the new scheme's copy instead, and add KUnit tests for the
constructor and for accepted and rejected context updates.

Note: below are test results and changelogs that could be removed from the
final commit log.

In the v1 live test with damo, a scheme with a plain 64 KiB size quota and
a 60-second reset interval uses its quota, and a full "damo tune" with
unchanged parameters then lets it try another 64 KiB within the same
window.  With the fix, sz_tried stays at 64 KiB.

KUnit was rerun after the rebase on x86-64 and i386. With only patch 2
applied, the two new tests fail. With the fix, all 46 DAMON KUnit tests
pass on both architectures.

The v1 DAMON selftests showed no new failures (QEMU TCG guest; the
wss_estimation test missed its accuracy bounds with and without the fix).


This patch (of 2):

damon_commit_ctx() first commits the running context's parameters to a
temporary context for validating proposed updates.  When
damon_commit_schemes() creates the temporary schemes, it passes the
running scheme's quota as the quota parameter of damon_new_scheme().

damon_new_scheme() calls damos_quota_init() on that quota before copying
it to the new scheme.  This clears the running scheme's effective quota,
feedback input and charging state.  Even an update rejected with -EINVAL
loses the running quota state.

For a size quota, this discards the bytes already charged and allows the
scheme to use a fresh quota before the reset interval has elapsed.  For a
goal-driven quota, the consist tuner loses its accumulated input and
restarts from its minimum input.  A time quota loses its throughput
estimate and falls back to the initial estimate.

The end users will show DAMOS works more or less aggressively than
expected for online-commit updates of quotas.  DAMON provides best efforts
by default.  DAMON parameters online commit is supposed to be executed
only occasionally.  Hence, the issue wouldn't be critical on sane setups. 
For user_input type quota goals, online commit of the user input score is
expected to be frequent.  But, for the case commit_schemes_quota_goals
command is recommended for optimal execution, and it doesn't have this
bug.

Commit 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic
destination") introduced this problem in v6.19 when sysfs validation began
committing the running context's parameters to a temporary context. 
Commit b90408ef1163 ("mm/damon/core: safely validate src on
damon_commit_ctx()") later moved that validation into the core API,
exposing other callers including DAMON_RECLAIM and DAMON_LRU_SORT.

Sashiko reported the same side effect [1] on the RFC of the core API
change.

Copy the quota to the new scheme first, then initialize that copy.  Make
damos_quota_init() return void, since its return value is no longer
needed.

Link: https://lore.kernel.org/20260928085835.7675-1-sj@kernel.org
Link: https://lore.kernel.org/20260928085835.7675-2-sj@kernel.org
Link: https://lore.kernel.org/r/20260702212143.0CB6D1F00A3D@smtp.kernel.org/ [1]
Fixes: 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic destination")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Assisted-by: LLM
Cc: Bijan Tabatabai <bijan311@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/damon/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme
+++ a/mm/damon/core.c
@@ -734,7 +734,7 @@ static bool damos_quota_goals_empty(stru
 }
 
 /* initialize fields of @quota that normally API users wouldn't set */
-static struct damos_quota *damos_quota_init(struct damos_quota *quota)
+static void damos_quota_init(struct damos_quota *quota)
 {
 	quota->esz = 0;
 	quota->total_charged_sz = 0;
@@ -744,7 +744,6 @@ static struct damos_quota *damos_quota_i
 	quota->charge_target_from = NULL;
 	quota->charge_addr_from = 0;
 	quota->esz_bp = 0;
-	return quota;
 }
 
 struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
@@ -776,7 +775,8 @@ struct damos *damon_new_scheme(struct da
 	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota = *(damos_quota_init(quota));
+	scheme->quota = *quota;
+	damos_quota_init(&scheme->quota);
 	/* quota.goals should be separately set by caller */
 	INIT_LIST_HEAD(&scheme->quota.goals);
 
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

