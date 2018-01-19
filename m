From: akpm@linux-foundation.org
Subject: [obsolete] mm-memcg-try-harder-to-decrease-limit_in_bytes.patch
 removed from -mm tree
Date: Fri, 19 Jan 2018 12:46:53 -0800
Message-ID: <5a62593d.SLYRCw5e5azUavJm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55624 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754118AbeASUqz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jan 2018 15:46:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: try harder to decrease [memory,memsw].limit_in_bytes
has been removed from the -mm tree.  Its filename was
     mm-memcg-try-harder-to-decrease-limit_in_bytes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/memcontrol.c: try harder to decrease [memory,memsw].limit_in_bytes

mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
pages on each iteration.  This makes it practically impossible to decrease
limit of memory cgroup.  Tasks could easily allocate back 32 pages, so we
can't reduce memory usage, and once retry_count reaches zero we return
-EBUSY.

Easy to reproduce the problem by running the following commands:

  mkdir /sys/fs/cgroup/memory/test
  echo $$ >> /sys/fs/cgroup/memory/test/tasks
  cat big_file > /dev/null &
  sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
  -bash: echo: write error: Device or resource busy

Instead of relying on retry_count, keep retrying the reclaim until the
desired limit is reached or fail if the reclaim doesn't make any progress
or a signal is pending.

Link: http://lkml.kernel.org/r/20180110124317.28887-1-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   44 ++++++++------------------------------------
 1 file changed, 8 insertions(+), 36 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-try-harder-to-decrease-limit_in_bytes mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-try-harder-to-decrease-limit_in_bytes
+++ a/mm/memcontrol.c
@@ -1176,20 +1176,6 @@ void mem_cgroup_print_oom_info(struct me
 }
 
 /*
- * This function returns the number of memcg under hierarchy tree. Returns
- * 1(self count) if no children.
- */
-static int mem_cgroup_count_children(struct mem_cgroup *memcg)
-{
-	int num = 0;
-	struct mem_cgroup *iter;
-
-	for_each_mem_cgroup_tree(iter, memcg)
-		num++;
-	return num;
-}
-
-/*
  * Return the memory (and swap, if configured) limit for a memcg.
  */
 unsigned long mem_cgroup_get_limit(struct mem_cgroup *memcg)
@@ -2462,24 +2448,12 @@ static DEFINE_MUTEX(memcg_limit_mutex);
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 				   unsigned long limit, bool memsw)
 {
-	unsigned long curusage;
-	unsigned long oldusage;
+	unsigned long usage;
 	bool enlarge = false;
-	int retry_count;
 	int ret;
 	bool limits_invariant;
 	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
 
-	/*
-	 * For keeping hierarchical_reclaim simple, how long we should retry
-	 * is depends on callers. We set our retry-count to be function
-	 * of # of children which we should visit in this loop.
-	 */
-	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
-		      mem_cgroup_count_children(memcg);
-
-	oldusage = page_counter_read(counter);
-
 	do {
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -2506,15 +2480,13 @@ static int mem_cgroup_resize_limit(struc
 		if (!ret)
 			break;
 
-		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, !memsw);
-
-		curusage = page_counter_read(counter);
-		/* Usage is reduced ? */
-		if (curusage >= oldusage)
-			retry_count--;
-		else
-			oldusage = curusage;
-	} while (retry_count);
+		usage = page_counter_read(counter);
+		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
+						GFP_KERNEL, !memsw)) {
+			ret = -EBUSY;
+			break;
+		}
+	} while (true);
 
 	if (!ret && enlarge)
 		memcg_oom_recover(memcg);
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

kasan-makefile-support-llvm-style-asan-parameters.patch
lib-strscpy-remove-word-at-a-time-optimization.patch
lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang.patch
lib-ubsan-remove-returns-nonnull-attribute-checks.patch

