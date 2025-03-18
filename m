Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5471CF5C0
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274595; cv=none; b=Y3FexsyGXOb7CovqFg+nHc+RcrfB6aq+y1lxBNCjFbGwZkPDhPdIjwkk2n00fGsN4NsMlxppxxs5SNffICepvp8LQZm91yzX+21oEHcHGWQxVMdEXGleA4OwYyAE3GjfzpoaJwot/ASGaOYb9dFa48gsSjD3A4rdjYbYb9ZQD2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274595; c=relaxed/simple;
	bh=vQrvJbiuuXC76ip/Z8PxqYkursWVZL2dLgKoIHArG+I=;
	h=Date:To:From:Subject:Message-Id; b=QzQbmRZE+CVNKSVDRO+unFx3jEUIlcA7ExTz4JFFacD6MZTtT1MH3xLy/8mT3cKVUGxghMmJpq/LGFbHj+s3j/byaow5n5J6Q97/Oo/p6XJ1cbD+iKZrGpKpAThbc2nSeltg9Nkf2HeLV/VZ5/+BidSGYAJXXJ7yQf8Vk7gQVKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dNTory7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dNTory7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3579FC4CEDD;
	Tue, 18 Mar 2025 05:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274595;
	bh=vQrvJbiuuXC76ip/Z8PxqYkursWVZL2dLgKoIHArG+I=;
	h=Date:To:From:Subject:From;
	b=dNTory7vbWFIynaei+88cNq6jtD8gUNzSJLWjdx1f94k/5uzXn3yaUFruNJXAoqYz
	 z1rNs14mr3PwUAred3hpJoNX6q8ES1cjkTsysAGBOgSK0rrnS/Jo23MAPDTTUOWID4
	 kG8kzQ8vJpxgR4xHdvv1A0ZfLZ/nsRoaJNeRDtVQ=
Date: Mon, 17 Mar 2025 22:09:54 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch removed from -mm tree
Message-Id: <20250318050955.3579FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: invoke kdamond_call() after merging is done if possible
has been removed from the -mm tree.  Its filename was
     mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: invoke kdamond_call() after merging is done if possible
Date: Thu, 6 Mar 2025 09:58:57 -0800

kdamond_call() callers may iterate the regions, so better to call it when
the number of regions is as small as possible.  It is when
kdamond_merge_regions() is finished.  Invoke it on the point.

This change is also aimed to make future changes for carrying online
parameters commit with damon_call() easier.  The commit operation should
be able to make sequence between other aggregation interval based
operations including regioins merging and aggregation reset.  Placing
damon_call() invocation after the regions merging makes the sequence
handling simpler.

Link: https://lkml.kernel.org/r/20250306175908.66300-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible
+++ a/mm/damon/core.c
@@ -2421,7 +2421,6 @@ static int kdamond_fn(void *data)
 		if (ctx->callback.after_sampling &&
 				ctx->callback.after_sampling(ctx))
 			break;
-		kdamond_call(ctx, false);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
@@ -2439,9 +2438,10 @@ static int kdamond_fn(void *data)
 		}
 
 		/*
-		 * do kdamond_apply_schemes() after kdamond_merge_regions() if
-		 * possible, to reduce overhead
+		 * do kdamond_call() and kdamond_apply_schemes() after
+		 * kdamond_merge_regions() if possible, to reduce overhead
 		 */
+		kdamond_call(ctx, false);
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else
_

Patches currently in -mm which might be from sj@kernel.org are


