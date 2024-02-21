Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8341E128386
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559306; cv=none; b=FysX/Z7XVeLF2Z9mA8S5w91/uitEX0Qji4IHZUdVCQCueIv59gZpbMeDT3oEKvLUwjou93U+jwfuUuRmFVlyWDE3j4yHGDx09oy6cd56dyXj8WybivbVHC8hoXRpN/Eq+oWbBi9TYfXMhxUo06jIO5wN59/M1aPTRjMWp1WZLpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559306; c=relaxed/simple;
	bh=/IR2AQIcpKg0FouTkm0eaT1FPV/vqeBPY1ivFJTJYWU=;
	h=Date:To:From:Subject:Message-Id; b=ordfXUkLNoDX62qbRbOlxwVB9qbNgUX0agGhkMcOakEt3vlp+fLho6lv9EGy7GouYfl4fTea8ef7gvFxsQ0r3ChlalGlYVajww05KmzkgPyeIynmpDdnZxHNyvpQ9t5jIRj7L1X4k5Z5lJeM2fgjzkZTPjp5GEyEUDEoLGjD+rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UuXxK6US; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UuXxK6US"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C81C43399;
	Wed, 21 Feb 2024 23:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708559306;
	bh=/IR2AQIcpKg0FouTkm0eaT1FPV/vqeBPY1ivFJTJYWU=;
	h=Date:To:From:Subject:From;
	b=UuXxK6USloUgOVXFZqMQuUpdrVkHAc8hruw1zzEcRaZsaXEECVQ5/H5QvZUIJrbKE
	 A4mdFfYQw3PWHFPBcSrUiB5R/icScmtrN4jsZRRKPe4RoHaZjrg3jS3KKI20/nUg4l
	 YNiS8Ms48W7VcsvS3bQcqVFHe25oBTsC+IsjpfXo=
Date: Wed, 21 Feb 2024 15:48:25 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,yangyifei03@kuaishou.com,songmuchun@bytedance.com,shakeelb@google.com,roman.gushchin@linux.dev,mkoutny@suse.com,mhocko@suse.com,hannes@cmpxchg.org,tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-use-larger-batches-for-proactive-reclaim-v4.patch removed from -mm tree
Message-Id: <20240221234826.03C81C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcg-use-larger-batches-for-proactive-reclaim-v4
has been removed from the -mm tree.  Its filename was
     mm-memcg-use-larger-batches-for-proactive-reclaim-v4.patch

This patch was dropped because it was folded into mm-memcg-use-larger-batches-for-proactive-reclaim.patch

------------------------------------------------------
From: "T.J. Mercier" <tjmercier@google.com>
Subject: mm-memcg-use-larger-batches-for-proactive-reclaim-v4
Date: Tue, 6 Feb 2024 17:52:50 +0000

Add additional info to commit message and move definition of batch_size
per Michal Hocko.  No functional changes.

Link: https://lkml.kernel.org/r/20240206175251.3364296-1-tjmercier@google.com
Fixes: 0388536ac291 ("mm:vmscan: fix inaccurate reclaim during proactive reclaim")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Michal Koutny <mkoutny@suse.com>
Cc: Efly Young <yangyifei03@kuaishou.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-use-larger-batches-for-proactive-reclaim-v4
+++ a/mm/memcontrol.c
@@ -6981,6 +6981,8 @@ static ssize_t memory_reclaim(struct ker
 
 	reclaim_options	= MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE;
 	while (nr_reclaimed < nr_to_reclaim) {
+		/* Will converge on zero, but reclaim enforces a minimum */
+		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
 		unsigned long reclaimed;
 
 		if (signal_pending(current))
@@ -6994,9 +6996,6 @@ static ssize_t memory_reclaim(struct ker
 		if (!nr_retries)
 			lru_add_drain_all();
 
-		/* Will converge on zero, but reclaim enforces a minimum */
-		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
-
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
 					batch_size, GFP_KERNEL, reclaim_options);
 
_

Patches currently in -mm which might be from tjmercier@google.com are

mm-memcg-dont-periodically-flush-stats-when-memcg-is-disabled.patch
mm-memcg-use-larger-batches-for-proactive-reclaim.patch

