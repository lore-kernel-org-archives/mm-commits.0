Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB3527E04C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744967; cv=none; b=d5suBnH0wEyYIbIW2uuNqg1SEBtujzxYSTEhxUGlJkKxPyXOIlSYRQ43/WWuUwXRCLTKwDCf4YCzIdtZRflWbnju/cRoLCXbgi7YvNkZIWtwq3BZ8ic+kud4ep2Z3Na08hWd/RSTkDe3FxNdTuS2zcI8uxIbkiMGUkJptqOOIzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744967; c=relaxed/simple;
	bh=EpCkAfxgeR9rqoPE/2M2lbxBq/WwG3VXuCihNkcmiPc=;
	h=Date:To:From:Subject:Message-Id; b=HPfx7p4eqCUy/2WfmrUVsTvHMruzK0a8FoX6KX4c1e0SYGyO0LZrFb0Hc2ZIfASbogzvB/DuQARWu5qm824PoCHez675T3tj8ISO11XUwEOh7dO/IlfBQv8Fd3Uxlj6oHBM878YbUoDOAWAi+Ry7fOjjtjp9sjb2bwMx/NNnZx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ekf9KEi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ekf9KEi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E8BC4CEF7;
	Sun, 29 Mar 2026 00:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744967;
	bh=EpCkAfxgeR9rqoPE/2M2lbxBq/WwG3VXuCihNkcmiPc=;
	h=Date:To:From:Subject:From;
	b=ekf9KEi2p6rhHjmJxbpZ4gvC7S7/m3RYcXfebDziW08fEN80g15QMN1H9vHu0w766
	 i3cW2AfM3j+o7oAKF664KdGtLpWccFe+W3bGEC6nj+Ubidz7iG7hovwTRKyT39lr3x
	 iPHxl5pDVwygdo3x2qbv6pvDj8dv8vewAHNYuYhE=
Date: Sat, 28 Mar 2026 17:42:47 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,axelrasmussen@google.com,bingjiao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg.patch removed from -mm tree
Message-Id: <20260329004247.A7E8BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bing Jiao <bingjiao@google.com>
Subject: mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
Date: Sat, 21 Mar 2026 03:34:13 +0000

In try_charge_memcg(), the 'reclaim_options' variable is initialized once
at the start of the function.  However, the function contains a retry
loop.  If reclaim_options were modified during an iteration (e.g., by
encountering a memsw limit), the modified state would persist into
subsequent retries.

This leads to incorrect reclaim behavior.  Specifically,
MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit is
reached.  After reclaimation attempts, a subsequent retry may successfully
charge memcg->memsw but fail on the memcg->memory charge.  In this case,
swapping should be permitted, but the carried-over state prevents it.

This issue was identified during code reading of try_charge_memcg() while
analyzing memsw limit behavior in tiered-memory systems; no production
failures have been reported yet.

Fix by moving the initialization of 'reclaim_options' inside the retry
loop, ensuring a clean state for every reclaim attempt.

Link: https://lkml.kernel.org/r/20260321033500.2558070-1-bingjiao@google.com
Fixes: 6539cc053869 ("mm: memcontrol: fold mem_cgroup_do_charge()")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg
+++ a/mm/memcontrol.c
@@ -2385,7 +2385,7 @@ static int try_charge_memcg(struct mem_c
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
-	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	unsigned int reclaim_options;
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
@@ -2399,6 +2399,7 @@ retry:
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
 
+	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		if (page_counter_try_charge(&memcg->memory, batch, &counter))
_

Patches currently in -mm which might be from bingjiao@google.com are


