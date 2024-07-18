Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC1F1E520
	for <mm-commits@vger.kernel.org>; Thu, 18 Jul 2024 04:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721275769; cv=none; b=bNgQ7yQAnpJWs8C43U+sqYpBT5Y/2hwOy9EH47oBWTHLTnbLVejjHAb92seEwGn/eUZORK3IX5AWwPxHQJuHu1ZMP0fKM7gpN0d/hExXJGT+f2yECMUGvaTim8Dp7/3eaq19jVWhYyLcq4DX6FfZTBgmIM1rWgO3ggZ9AyhyZL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721275769; c=relaxed/simple;
	bh=/rWuQ0eilYiuhBCppZqbl2OPccqaSBc9yZ3JhvheRVw=;
	h=Date:To:From:Subject:Message-Id; b=DgYStTzAmg+dmUP8MhwayrivnjxLjl8g4ujT5TSeq8nRJhH4mPjl/iELHDVxCq4CG7kjO0SdHaJ/m8GEhuz+G0hvHuLj2Mt8666hwSEYQBB7QLDvNMJ1VFQMTooxIFzJ+5Mj8O8rnZlM0gsrmC9yG4pLfS9q57j2sOz0g2NzEvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t5m1LSyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t5m1LSyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B60C116B1;
	Thu, 18 Jul 2024 04:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721275768;
	bh=/rWuQ0eilYiuhBCppZqbl2OPccqaSBc9yZ3JhvheRVw=;
	h=Date:To:From:Subject:From;
	b=t5m1LSyw5GRFrejwUbM9P+tf38y/c6IGogu2dSR1wWFUlrM8p9w6M11YXhS9vDg06
	 hYT7U3cgjWnlX2Y8e3ucdutHftMFRMDAiHJpUiNcsSEK7F9D9srcsSQ/ucOa0BscAx
	 EwYvPPCE6ZYHt9rBB3LjFaZBer/NYpfc2hPJN7dE=
Date: Wed, 17 Jul 2024 21:09:28 -0700
To: mm-commits@vger.kernel.org,chengming.zhou@linux.dev,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-fix-a-white-space-issue.patch removed from -mm tree
Message-Id: <20240718040928.C4B60C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: fix a white space issue
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-a-white-space-issue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: mm/zswap: fix a white space issue
Date: Mon, 15 Jul 2024 15:23:05 -0500

We accidentally deleted a tab in commit f84152e9efc5 ("mm/zswap: use only
one pool in zswap").  Add it back.

Link: https://lkml.kernel.org/r/c15066a0-f061-42c9-b0f5-d60281d3d5d8@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-fix-a-white-space-issue
+++ a/mm/zswap.c
@@ -803,7 +803,7 @@ static void zswap_entry_free(struct zswa
 		atomic_dec(&zswap_same_filled_pages);
 	else {
 		zswap_lru_del(&zswap_list_lru, entry);
-	zpool_free(entry->pool->zpool, entry->handle);
+		zpool_free(entry->pool->zpool, entry->handle);
 		zswap_pool_put(entry->pool);
 	}
 	if (entry->objcg) {
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are


