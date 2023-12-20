Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742D239FE1
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YYr6kjAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342EEC433CB;
	Wed, 20 Dec 2023 22:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703111877;
	bh=I4cA27tpGnN5sL7fCeQYAr1kFYFUfMBM45Uks4gHAog=;
	h=Date:To:From:Subject:From;
	b=YYr6kjALCzE+e063T5IQRZzKMnx8KU/6W/mXX0auKQ/okoDZBbYPUTvrN4QzSRhL7
	 HoFx/iedaMcTDueShMdZJWuKUin+BLP1vs3sWFX2ISQhba8o+R/TacLQ8GGQa0dRXo
	 4pwehHrbJKhQcUkivXp2IWhdhjyiZBA7WzI4iYxU=
Date: Wed, 20 Dec 2023 14:37:56 -0800
To: mm-commits@vger.kernel.org,weixugc@google.com,tj@kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,ivan@cloudflare.com,hannes@cmpxchg.org,gthelen@google.com,chrisl@kernel.org,cerasuolodomenico@gmail.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-restore-subtree-stats-flushing-fix-2.patch removed from -mm tree
Message-Id: <20231220223757.342EEC433CB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: remove stats flushing mutex
has been removed from the -mm tree.  Its filename was
     mm-memcg-restore-subtree-stats-flushing-fix-2.patch

This patch was dropped because it was folded into mm-memcg-restore-subtree-stats-flushing.patch

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: remove stats flushing mutex
Date: Mon, 4 Dec 2023 23:43:29 +0000

The mutex was intended to make the waiters sleep instead of spin, and such
that we can check the update thresholds again after acquiring the mutex. 
However, the mutex has a risk of priority inversion, especially since the
underlying rstat lock can de dropped while the mutex is held.

Synthetic testing with high concurrency of flushers shows no regressions
without the mutex, so remove it.

Link: https://lkml.kernel.org/r/CAJD7tkZgP3m-VVPn+fF_YuvXeQYK=tZZjJHj=dzD=CcSSpp2qg@mail.gmail.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-restore-subtree-stats-flushing-fix-2
+++ a/mm/memcontrol.c
@@ -749,21 +749,14 @@ static void do_flush_stats(struct mem_cg
  */
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
-	static DEFINE_MUTEX(memcg_stats_flush_mutex);
-
 	if (mem_cgroup_disabled())
 		return;
 
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
-	if (memcg_should_flush_stats(memcg)) {
-		mutex_lock(&memcg_stats_flush_mutex);
-		/* Check again after locking, another flush may have occurred */
-		if (memcg_should_flush_stats(memcg))
-			do_flush_stats(memcg);
-		mutex_unlock(&memcg_stats_flush_mutex);
-	}
+	if (memcg_should_flush_stats(memcg))
+		do_flush_stats(memcg);
 }
 
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-change-flush_next_time-to-flush_last_time.patch
mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch
mm-memcg-make-stats-flushing-threshold-per-memcg.patch
mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
mm-memcg-restore-subtree-stats-flushing.patch

