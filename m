Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698614F615
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 23:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721778360; cv=none; b=j0aZ6q2SGjxA+WhiFx8+icf0PeNZhNGWYpY0VxhgC+kdx5J0F22TrDN5e0GSocoF7sp1/f9eCUEQqG8G3i+w7ckHEkRBI/XnfNagCBhEVju7thMyDHq6jpuxWJyPCqOH434mzTVTtTwLz8mlH96u1wNFwOwCs4tMPHPbe18kF+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721778360; c=relaxed/simple;
	bh=r8V+Gr5OgQF3C78STFcygvLu/E7mj/5ECDS59sYL5jA=;
	h=Date:To:From:Subject:Message-Id; b=SiZdKvlOLTUXbnZjylN5NAMhTxfCTDzx8G0l/DghqIm+1rWcqmXHhSz0OUWbTTGsjvCiY6sBJ/GSguHTiTR/JHZGRIplxrxRyuDC5PIcFqef3zHDLDsJvWg6cXj7RSp2XVzdoqPGifoBxQhDhs19PkfLTddBNpmxNIUI34kS6kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rTsWuyzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rTsWuyzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D67C4AF0A;
	Tue, 23 Jul 2024 23:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721778360;
	bh=r8V+Gr5OgQF3C78STFcygvLu/E7mj/5ECDS59sYL5jA=;
	h=Date:To:From:Subject:From;
	b=rTsWuyzc1KsHoPsi5EN1QUTjZus++Bzi/mkok1ABlLR7tISRPowj5EsZXM7UZ0Xbi
	 GP7bbEZ8GI3j9/dc8gD7sFHxpHrpWp3YW4XnGU3eeyYC8h3TYdboUUGVhF1tRVVAXy
	 QL135C220Ite6kejBtdgIghygnpGnnLE1VE5AvhE=
Date: Tue, 23 Jul 2024 16:45:59 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,flyingpeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch added to mm-unstable branch
Message-Id: <20240723234559.E8D67C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: adjust local variable to dynamic allocation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch

