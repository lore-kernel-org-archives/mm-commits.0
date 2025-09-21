Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EFA27281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490024; cv=none; b=PP8pFwgs6laosXnzZjPjn/+3Axjf25lc4+u/5I1cKoEmjkh7mvOmvZfpojf4IjAk97HfXMtQW/E8/Sz3hCqYHnF4INAu8ZKVLyFmf5PuwvdseQvB8dTV2Q8bEaSw51n4o336JDpbsqHvDnuCLzOTR/Xx/BAG3T571lsZMVRK2hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490024; c=relaxed/simple;
	bh=bwgZS1Zd6YhkuD2vzaV40wMC01RPhz7WH4VLcXnWRho=;
	h=Date:To:From:Subject:Message-Id; b=A/nFADzBFqIFgiorDroG0WNaKGo3ot4IFSeFroq0DN3QcCr+Z/eSOh19VnE+1Fwop9IxMtQyNGHtJEEhQw+/qBrjM+GI433WuasykelsVxawXn3x9wIBhG8vEbZN4HybFpeLjlBT0yvD+8h5KBTFRYgL+m9yGiO5lm8hm+gMI9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MQ0x+O3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MQ0x+O3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A8DC4CEE7;
	Sun, 21 Sep 2025 21:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490024;
	bh=bwgZS1Zd6YhkuD2vzaV40wMC01RPhz7WH4VLcXnWRho=;
	h=Date:To:From:Subject:From;
	b=MQ0x+O3j8sBTK4HJZZ3DOY6AkdqNFhDox7iyEpYRy9QbzsuzN8yuRQRwxFSpN9/8V
	 p0gOvP6/2dUVZmD0Scqyqku6fPKO2fngYO/oKVuDaw+SWAOvEXzesGdG0o9+s/t4kr
	 XSkAG4R8A+YHMZ9bd2/dcZTsYFjt7ZE4i/DPrEgA=
Date: Sun, 21 Sep 2025 14:27:04 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-use-damon_initialized.patch removed from -mm tree
Message-Id: <20250921212704.98A8DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: use damon_initialized()
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-use-damon_initialized.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:08 -0700

DAMON_LRU_SORT is assuming DAMON is ready to use in module_init time, and
uses its own hack to see if it is the time.  Use damon_initialized(),
which is a way for seeing if DAMON is ready to be used that is more
reliable and better to maintain instead of the hack.

Link: https://lkml.kernel.org/r/20250916033511.116366-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-damon_initialized
+++ a/mm/damon/lru_sort.c
@@ -345,7 +345,7 @@ static int damon_lru_sort_enabled_store(
 		return 0;
 
 	/* Called before init function.  The function will handle this. */
-	if (!ctx)
+	if (!damon_initialized())
 		goto set_param_out;
 
 	err = damon_lru_sort_turn(enable);
@@ -368,8 +368,13 @@ MODULE_PARM_DESC(enabled,
 
 static int __init damon_lru_sort_init(void)
 {
-	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
+	int err;
 
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		goto out;
+	}
+	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
 	if (err)
 		goto out;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

