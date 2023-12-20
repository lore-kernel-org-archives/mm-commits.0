Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752A14C603
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JN7IQeFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4842C433C8;
	Wed, 20 Dec 2023 22:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112539;
	bh=FICpyrNMcWcl6UScMcAacZfb6wqBq9X27C3E7V1uSOw=;
	h=Date:To:From:Subject:From;
	b=JN7IQeFu6Amifu02ax9+or+10BDvDUlocizxZOg0fpPWLXTx5TJU+7k3Sl1sfgPi3
	 s0zhPyE4I4VMVkoclWh2W8OzwpkDID6fkO/eJ73v9B3ztQTDEakzOnf79+Lj4UQl1Y
	 vxhBRMKWerzUYAPHFRsBOfK4g13AgufC7rECAXEk=
Date: Wed, 20 Dec 2023 14:48:58 -0800
To: mm-commits@vger.kernel.org,weixugc@google.com,tj@kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,ivan@cloudflare.com,hannes@cmpxchg.org,gthelen@google.com,chrisl@kernel.org,cerasuolodomenico@gmail.com,bagasdotme@gmail.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-change-flush_next_time-to-flush_last_time.patch removed from -mm tree
Message-Id: <20231220224858.E4842C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: change flush_next_time to flush_last_time
has been removed from the -mm tree.  Its filename was
     mm-memcg-change-flush_next_time-to-flush_last_time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: change flush_next_time to flush_last_time
Date: Wed, 29 Nov 2023 03:21:49 +0000

Patch series "mm: memcg: subtree stats flushing and thresholds", v4.

This series attempts to address shortages in today's approach for memcg
stats flushing, namely occasionally stale or expensive stat reads.  The
series does so by changing the threshold that we use to decide whether to
trigger a flush to be per memcg instead of global (patch 3), and then
changing flushing to be per memcg (i.e.  subtree flushes) instead of
global (patch 5).


This patch (of 5):

flush_next_time is an inaccurate name.  It's not the next time that
periodic flushing will happen, it's rather the next time that ratelimited
flushing can happen if the periodic flusher is late.

Simplify its semantics by just storing the timestamp of the last flush
instead, flush_last_time.  Move the 2*FLUSH_TIME addition to
mem_cgroup_flush_stats_ratelimited(), and add a comment explaining it. 
This way, all the ratelimiting semantics live in one place.

No functional change intended.

Link: https://lkml.kernel.org/r/20231129032154.3710765-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20231129032154.3710765-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Chris Li <chrisl@kernel.org> (Google)
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
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

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-change-flush_next_time-to-flush_last_time
+++ a/mm/memcontrol.c
@@ -593,7 +593,7 @@ static DECLARE_DEFERRABLE_WORK(stats_flu
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
-static u64 flush_next_time;
+static u64 flush_last_time;
 
 #define FLUSH_TIME (2UL*HZ)
 
@@ -653,7 +653,7 @@ static void do_flush_stats(void)
 	    atomic_xchg(&stats_flush_ongoing, 1))
 		return;
 
-	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
+	WRITE_ONCE(flush_last_time, jiffies_64);
 
 	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
 
@@ -669,7 +669,8 @@ void mem_cgroup_flush_stats(void)
 
 void mem_cgroup_flush_stats_ratelimited(void)
 {
-	if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
+	/* Only flush if the periodic flusher is one full cycle late */
+	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
 		mem_cgroup_flush_stats();
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are


