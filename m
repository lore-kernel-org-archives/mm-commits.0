From: akpm@linux-foundation.org
Subject: + memcg-refactor-mem_cgroup_resize_limit.patch added to -mm tree
Date: Mon, 08 Jan 2018 16:22:46 -0800
Message-ID: <5a540b56.Pm8h5A1Mh9+LOpT4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbeAIAWr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jan 2018 19:22:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, hannes@cmpxchg.org, mhocko@suse.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: refactor mem_cgroup_resize_limit()
has been added to the -mm tree.  Its filename is
     memcg-refactor-mem_cgroup_resize_limit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-refactor-mem_cgroup_resize_limit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-refactor-mem_cgroup_resize_limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: memcg: refactor mem_cgroup_resize_limit()

mem_cgroup_resize_limit() and mem_cgroup_resize_memsw_limit() have
identical logics.  Refactor code so we don't need to keep two pieces of
code that does same thing.

Link: http://lkml.kernel.org/r/20180108224238.14583-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   77 ++++++++++------------------------------------
 1 file changed, 17 insertions(+), 60 deletions(-)

diff -puN mm/memcontrol.c~memcg-refactor-mem_cgroup_resize_limit mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-refactor-mem_cgroup_resize_limit
+++ a/mm/memcontrol.c
@@ -2460,13 +2460,15 @@ static inline int mem_cgroup_move_swap_a
 static DEFINE_MUTEX(memcg_limit_mutex);
 
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
-				   unsigned long limit)
+				   unsigned long limit, bool memsw)
 {
 	unsigned long curusage;
 	unsigned long oldusage;
 	bool enlarge = false;
 	int retry_count;
 	int ret;
+	bool limits_invariant;
+	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
 
 	/*
 	 * For keeping hierarchical_reclaim simple, how long we should retry
@@ -2476,7 +2478,7 @@ static int mem_cgroup_resize_limit(struc
 	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
 		      mem_cgroup_count_children(memcg);
 
-	oldusage = page_counter_read(&memcg->memory);
+	oldusage = page_counter_read(counter);
 
 	do {
 		if (signal_pending(current)) {
@@ -2485,73 +2487,28 @@ static int mem_cgroup_resize_limit(struc
 		}
 
 		mutex_lock(&memcg_limit_mutex);
-		if (limit > memcg->memsw.limit) {
-			mutex_unlock(&memcg_limit_mutex);
-			ret = -EINVAL;
-			break;
-		}
-		if (limit > memcg->memory.limit)
-			enlarge = true;
-		ret = page_counter_limit(&memcg->memory, limit);
-		mutex_unlock(&memcg_limit_mutex);
-
-		if (!ret)
-			break;
-
-		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, true);
-
-		curusage = page_counter_read(&memcg->memory);
-		/* Usage is reduced ? */
-		if (curusage >= oldusage)
-			retry_count--;
-		else
-			oldusage = curusage;
-	} while (retry_count);
-
-	if (!ret && enlarge)
-		memcg_oom_recover(memcg);
-
-	return ret;
-}
-
-static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
-					 unsigned long limit)
-{
-	unsigned long curusage;
-	unsigned long oldusage;
-	bool enlarge = false;
-	int retry_count;
-	int ret;
-
-	/* see mem_cgroup_resize_res_limit */
-	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
-		      mem_cgroup_count_children(memcg);
-
-	oldusage = page_counter_read(&memcg->memsw);
-
-	do {
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-
-		mutex_lock(&memcg_limit_mutex);
-		if (limit < memcg->memory.limit) {
+		/*
+		 * Make sure that the new limit (memsw or memory limit) doesn't
+		 * break our basic invariant rule memory.limit <= memsw.limit.
+		 */
+		limits_invariant = memsw ? limit >= memcg->memory.limit :
+					   limit <= memcg->memsw.limit;
+		if (!limits_invariant) {
 			mutex_unlock(&memcg_limit_mutex);
 			ret = -EINVAL;
 			break;
 		}
-		if (limit > memcg->memsw.limit)
+		if (limit > counter->limit)
 			enlarge = true;
-		ret = page_counter_limit(&memcg->memsw, limit);
+		ret = page_counter_limit(counter, limit);
 		mutex_unlock(&memcg_limit_mutex);
 
 		if (!ret)
 			break;
 
-		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, false);
+		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, !memsw);
 
-		curusage = page_counter_read(&memcg->memsw);
+		curusage = page_counter_read(counter);
 		/* Usage is reduced ? */
 		if (curusage >= oldusage)
 			retry_count--;
@@ -3231,10 +3188,10 @@ static ssize_t mem_cgroup_write(struct k
 		}
 		switch (MEMFILE_TYPE(of_cft(of)->private)) {
 		case _MEM:
-			ret = mem_cgroup_resize_limit(memcg, nr_pages);
+			ret = mem_cgroup_resize_limit(memcg, nr_pages, false);
 			break;
 		case _MEMSWAP:
-			ret = mem_cgroup_resize_memsw_limit(memcg, nr_pages);
+			ret = mem_cgroup_resize_limit(memcg, nr_pages, true);
 			break;
 		case _KMEM:
 			ret = memcg_update_kmem_limit(memcg, nr_pages);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-dont-expose-page-to-fast-gup-before-its-ready.patch
zswap-only-save-zswap-header-if-zpool-is-shrinkable.patch
memcg-refactor-mem_cgroup_resize_limit.patch

