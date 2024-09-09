Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8E518A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925225; cv=none; b=SNAmX5Ehy4F9v+pul/eZrbx3dGBTqoU7dioZb9D9ADSeIB2arBU8dXG5AxZlkZScUiK1SuYiTA5VpRN82kr6+ef46gLvCfUxn5eFaDDneYcUnZHD+SZQFa1mldzkpw9dIxaDtSsOmST7n5yvMf3BTS0JJiMRiBK2pKHOry/cp+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925225; c=relaxed/simple;
	bh=RwCdPdnbOseIb5wcDpivmuurnYF8nJPjH+wf/ixjCGY=;
	h=Date:To:From:Subject:Message-Id; b=j75XSQs1Y/iH2nZ4zoK3464vsfL/0ctw1KjZSWzXhv8B3P2buJToDk9V/06eMhkGDaoecBzqnc+Q7V4GC6Syaa1vs/iTs6QEaxQJGeoIv80ARuS0aW+ac96E2QYTCuOESPvA2yZAzt+P//9Th0hmJVZvcTD2Ve/ewwt4rT3O5+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a9fW+TEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a9fW+TEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7241EC4CEC5;
	Mon,  9 Sep 2024 23:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925225;
	bh=RwCdPdnbOseIb5wcDpivmuurnYF8nJPjH+wf/ixjCGY=;
	h=Date:To:From:Subject:From;
	b=a9fW+TEoIDp4+ed/FL5dv4zWwLiyoMrGpC5zvwmSIHfi+WyxP+DsBNgb0hK971oqI
	 vObuiE1BzJnSXZHCzDuOCzqYhSvrGUAmB+GQGHA831BJEzCVxo4Q/QjP6kfuclLgzl
	 4QrTVsRTb8dTEaxRCack1FcJv1MoOx2jeTz+N6Ds=
Date: Mon, 09 Sep 2024 16:40:24 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch removed from -mm tree
Message-Id: <20240909234025.7241EC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm/damon/lru_sort: adjust local variable to dynamic allocation"
has been removed from the -mm tree.  Its filename was
     revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Revert "mm/damon/lru_sort: adjust local variable to dynamic allocation"
Date: Sun, 25 Aug 2024 21:23:23 -0700

This reverts commit 0742cadf5e4c ("mm/damon/lru_sort: adjust local
variable to dynamic allocation").

The commit was introduced to avoid unnecessary usage of stack memory for
per-scheme region priorities histogram buffer.  The fix is nice, but the
point of the fix looks not very clear if the commit message is not read
together.  That's mainly because the buffer is a private field, which
means it is hidden from the DAMON API users.  That's not the fault of the
fix but the underlying data structure.

Now the per-scheme histogram buffer is gone, so the problem that the
commit was fixing is also removed.  The use of kmemdup() has no more point
but just making the code bit difficult to understand.  Revert the fix.

Link: https://lkml.kernel.org/r/20240826042323.87025-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/mm/damon/lru_sort.c~revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation
+++ a/mm/damon/lru_sort.c
@@ -148,17 +148,12 @@ static struct damon_target *target;
 static struct damos *damon_lru_sort_new_scheme(
 		struct damos_access_pattern *pattern, enum damos_action action)
 {
-	struct damos *damos;
-	struct damos_quota *quota = kmemdup(&damon_lru_sort_quota,
-				    sizeof(damon_lru_sort_quota), GFP_KERNEL);
-
-	if (!quota)
-		return NULL;
+	struct damos_quota quota = damon_lru_sort_quota;
 
 	/* Use half of total quota for hot/cold pages sorting */
-	quota->ms = quota->ms / 2;
+	quota.ms = quota.ms / 2;
 
-	damos = damon_new_scheme(
+	return damon_new_scheme(
 			/* find the pattern, and */
 			pattern,
 			/* (de)prioritize on LRU-lists */
@@ -166,12 +161,10 @@ static struct damos *damon_lru_sort_new_
 			/* for each aggregation interval */
 			0,
 			/* under the quota. */
-			quota,
+			&quota,
 			/* (De)activate this according to the watermarks. */
 			&damon_lru_sort_wmarks,
 			NUMA_NO_NODE);
-	kfree(quota);
-	return damos;
 }
 
 /* Create a DAMON-based operation scheme for hot memory regions */
_

Patches currently in -mm which might be from sj@kernel.org are


