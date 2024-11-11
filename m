Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF6615E5BB
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313710; cv=none; b=oluzQphLwj7uW0+9o2Cap6RV9FfeRhLyvI0GMxBslPFqrieJaH1M5OiwPDdNjUj2t7G6s9nWQnMJF+hR8Z+Wm6EPYAiEicCI8Nfcv8v/osmL74EvSCrxKzgg8AfLeBqjUDsGGUbANOjnj+I0rUr2uwGWxhg6Te6jXzA9JEORlAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313710; c=relaxed/simple;
	bh=cIeSsWHQVjS+efJ8IPH38Sa6w735tfyzlbblSZ/lsVE=;
	h=Date:To:From:Subject:Message-Id; b=nSf/PVpM2N7DXkHaUszKvlzU9gpElfYtYBxbCxgH7SSDkJw9abZAhKgCMkS/++o2lWb+YrSO1+CGBFXrKHG8OTGLmMTxQNkFdRKx/46t+bCK2HsPVvwVBXTlIcbXHNSYKMLrTptrFCuHtEiYdFtVLcxPQn3P6hzy9B+Z6S8IRE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bT9liMa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bT9liMa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3E6C4CED4;
	Mon, 11 Nov 2024 08:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313709;
	bh=cIeSsWHQVjS+efJ8IPH38Sa6w735tfyzlbblSZ/lsVE=;
	h=Date:To:From:Subject:From;
	b=bT9liMa10NV72EfhO3649RIAO4NcrkuEQTgHPq9KfJ1hXkgsvL8JojwawYwd4C30y
	 brd8fcAGy73CUS696vp0RK/DN+fw9k0gT6DDLRV08gy54sPctAgBsUP8ioAbJvsUvY
	 pjKYxb0v2zHQL3cbubz9+LM48tko0bxI6kRoZn/A=
Date: Mon, 11 Nov 2024 00:28:29 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,hannes@cmpxchg.org,inwardvessel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-rename-do_flush_stats-and-add-force-flag.patch removed from -mm tree
Message-Id: <20241111082829.8B3E6C4CED4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: rename do_flush_stats and add force flag
has been removed from the -mm tree.  Its filename was
     memcg-rename-do_flush_stats-and-add-force-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: JP Kobryn <inwardvessel@gmail.com>
Subject: memcg: rename do_flush_stats and add force flag
Date: Mon, 28 Oct 2024 19:11:05 -0700

Patch series "memcg: tracepoint for flushing stats", v3.

This series adds new capability for understanding frequency and circumstances
behind flushing memcg stats.


This patch (of 2):

Change the name to something more consistent with others in the file and
use double unders to signify it is associated with the
mem_cgroup_flush_stats() API call.  Additionally include a new flag that
call sites use to indicate a forced flush; skipping checks and flushing
unconditionally.  There are no changes in functionality.

Link: https://lkml.kernel.org/r/20241029021106.25587-1-inwardvessel@gmail.com
Link: https://lkml.kernel.org/r/20241029021106.25587-2-inwardvessel@gmail.com
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~memcg-rename-do_flush_stats-and-add-force-flag
+++ a/mm/memcontrol.c
@@ -595,8 +595,11 @@ static inline void memcg_rstat_updated(s
 	}
 }
 
-static void do_flush_stats(struct mem_cgroup *memcg)
+static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
 {
+	if (!force && !memcg_vmstats_needs_flush(memcg->vmstats))
+		return;
+
 	if (mem_cgroup_is_root(memcg))
 		WRITE_ONCE(flush_last_time, jiffies_64);
 
@@ -620,8 +623,7 @@ void mem_cgroup_flush_stats(struct mem_c
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
-	if (memcg_vmstats_needs_flush(memcg->vmstats))
-		do_flush_stats(memcg);
+	__mem_cgroup_flush_stats(memcg, false);
 }
 
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
@@ -637,7 +639,7 @@ static void flush_memcg_stats_dwork(stru
 	 * Deliberately ignore memcg_vmstats_needs_flush() here so that flushing
 	 * in latency-sensitive paths is as cheap as possible.
 	 */
-	do_flush_stats(root_mem_cgroup);
+	__mem_cgroup_flush_stats(root_mem_cgroup, true);
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
@@ -5286,11 +5288,8 @@ bool obj_cgroup_may_zswap(struct obj_cgr
 			break;
 		}
 
-		/*
-		 * mem_cgroup_flush_stats() ignores small changes. Use
-		 * do_flush_stats() directly to get accurate stats for charging.
-		 */
-		do_flush_stats(memcg);
+		/* Force flush to get accurate stats for charging */
+		__mem_cgroup_flush_stats(memcg, true);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
 		if (pages < max)
 			continue;
_

Patches currently in -mm which might be from inwardvessel@gmail.com are


