Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FE53A8CB
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247667; cv=none; b=GXldmvMckFcRu6zscPw/nx8lGIQWFT0dvJ+vNZxgiumNRcOSCXalfsIK/IDS0XlahV5FSxNPcZRGtq20ajvesOYG5G47jxzhpS8us7F3Tpe5s27by/FS4fi1ueH1WBkC2cEqwejhBF0Q1+HF3lP3BZ5lIDi05XBxiZmeyhuuokk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247667; c=relaxed/simple;
	bh=P6MT9r3xcv1i9YYlT1+dR8blzxIIb5KeZ9sAWP4Rilw=;
	h=Date:To:From:Subject:Message-Id; b=hQEqwWj96SjYrBn6h7InVaaVhaFeDG5ID1L+nAyg9gt6fAY/7/fPsbVxuRyTi2gDABx6EYO4XIjNuuSbWHOjzI/4K4F3/3HpIa8fJ7LVWP4kbv5ImAPl8QgH69XfsUiOFdP0qXChejmTppDt3cNEMyw9iEwrJlf0sf/SPB0cz/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tfe4uacs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tfe4uacs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78020C4CEC8;
	Mon,  2 Sep 2024 03:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247667;
	bh=P6MT9r3xcv1i9YYlT1+dR8blzxIIb5KeZ9sAWP4Rilw=;
	h=Date:To:From:Subject:From;
	b=Tfe4uacsRPmDjfVuq5ucei74hZ/VngJxTXZKtz3F8UVnaZ/MTLGzwbuopuvuAiqes
	 QWf/82gInFagZShowJ8RO/ALm9hfquU2jBjRC8XiDzSYCK33+kvmZhnkj/pFnJlpN0
	 V6fAzOGrPHAhv/AkYdrWuZMrvphGpLjvksGl3Y9I=
Date: Sun, 01 Sep 2024 20:27:46 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,flyingpeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch removed from -mm tree
Message-Id: <20240902032747.78020C4CEC8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: adjust local variable to dynamic allocation
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Hao <flyingpeng@tencent.com>
Subject: mm/damon/lru_sort: adjust local variable to dynamic allocation
Date: Tue, 23 Jul 2024 11:55:13 +0800

When KASAN is enabled and built with clang:
    mm/damon/lru_sort.c:199:12: error: stack frame size (2328) exceeds
limit (2048) in 'damon_lru_sort_apply_parameters' [-Werror,-Wframe-larger-than]
    static int damon_lru_sort_apply_parameters(void)
               ^
    1 error generated.

This is because damon_lru_sort_quota contains a large array, and
assigning this variable to a local variable causes a large amount of
stack space to be occupied.

So adjust local variable to dynamic allocation.

Link: https://lkml.kernel.org/r/20240723035513.20153-1-flyingpeng@tencent.com
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation
+++ a/mm/damon/lru_sort.c
@@ -148,12 +148,17 @@ static struct damon_target *target;
 static struct damos *damon_lru_sort_new_scheme(
 		struct damos_access_pattern *pattern, enum damos_action action)
 {
-	struct damos_quota quota = damon_lru_sort_quota;
+	struct damos *damos;
+	struct damos_quota *quota = kmemdup(&damon_lru_sort_quota,
+				    sizeof(damon_lru_sort_quota), GFP_KERNEL);
+
+	if (!quota)
+		return NULL;
 
 	/* Use half of total quota for hot/cold pages sorting */
-	quota.ms = quota.ms / 2;
+	quota->ms = quota->ms / 2;
 
-	return damon_new_scheme(
+	damos = damon_new_scheme(
 			/* find the pattern, and */
 			pattern,
 			/* (de)prioritize on LRU-lists */
@@ -161,10 +166,12 @@ static struct damos *damon_lru_sort_new_
 			/* for each aggregation interval */
 			0,
 			/* under the quota. */
-			&quota,
+			quota,
 			/* (De)activate this according to the watermarks. */
 			&damon_lru_sort_wmarks,
 			NUMA_NO_NODE);
+	kfree(quota);
+	return damos;
 }
 
 /* Create a DAMON-based operation scheme for hot memory regions */
_

Patches currently in -mm which might be from flyingpeng@tencent.com are


