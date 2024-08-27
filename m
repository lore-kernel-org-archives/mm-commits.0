Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3624B41760
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803048; cv=none; b=ssQfA3zgFEDZpjuo/jeF/cco4AxcEpabL0ljVFglCbHl9scA6tQfIFoDgHeIAXLEvKhEpK421jD0Vmp3mdU4DeAkO/vOnI+gqgvltbENuR9aQpoNrxT4ZCOTqAsboue1paQ35kMstRvTACMw0MyKqj8+imwgAQS2wosNa6h3Kc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803048; c=relaxed/simple;
	bh=yNrs/M+dbeyt53mV8DEejfYl7zahnFG+rtq1nzZyxWI=;
	h=Date:To:From:Subject:Message-Id; b=NFxDlvNzhdALEWmWVo3uGmAgvo/7zKkASMtKn6a7SSZ5ubg6ww9ntJzMayFFAiCDoVl0tZ9h1FUmn7m5ZnZWybM3m2piTwvqeRbViXKAecY+zAQQNuYorhJxEAJTrIHW94fnDalP3ICC+3FNbZg+CC5OuQ67Na1WyiO9F3GuUmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nZ4hzj2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nZ4hzj2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96944C32782;
	Tue, 27 Aug 2024 23:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803047;
	bh=yNrs/M+dbeyt53mV8DEejfYl7zahnFG+rtq1nzZyxWI=;
	h=Date:To:From:Subject:From;
	b=nZ4hzj2Y50zvidw7Y4v2PX3Tvg6mvZ57+qC4zZNL3J9+WvNJeaT/4MmAYkrBZ4aUG
	 WM6CIIccoUSr2zb1+odEudqzxxk64PwLnojaeK/DQMMYk3TMbrc/HZKNzsdDJag8ow
	 VKSpSCZWnuLCzgNEnOCcRtqDBnJ/5Am2R3P9rolo=
Date: Tue, 27 Aug 2024 16:57:27 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-restart-if-multiple-traversals-raced.patch added to mm-unstable branch
Message-Id: <20240827235727.96944C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: restart if multiple traversals raced
has been added to the -mm mm-unstable branch.  Its filename is
     mm-restart-if-multiple-traversals-raced.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-restart-if-multiple-traversals-raced.patch

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
From: Kinsey Ho <kinseyho@google.com>
Subject: mm: restart if multiple traversals raced
Date: Tue, 27 Aug 2024 23:07:41 +0000

Currently, if multiple reclaimers raced on the same position, the
reclaimers which detect the race will still reclaim from the same memcg. 
Instead, the reclaimers which detect the race should move on to the next
memcg in the hierarchy.

So, in the case where multiple traversals race, jump back to the start of
the mem_cgroup_iter() function to find the next memcg in the hierarchy to
reclaim from.

Link: https://lkml.kernel.org/r/20240827230753.2073580-5-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   22 ++++++++++++++--------
 2 files changed, 16 insertions(+), 10 deletions(-)

--- a/include/linux/memcontrol.h~mm-restart-if-multiple-traversals-raced
+++ a/include/linux/memcontrol.h
@@ -57,7 +57,7 @@ enum memcg_memory_event {
 
 struct mem_cgroup_reclaim_cookie {
 	pg_data_t *pgdat;
-	unsigned int generation;
+	int generation;
 };
 
 #ifdef CONFIG_MEMCG
@@ -78,7 +78,7 @@ struct lruvec_stats;
 struct mem_cgroup_reclaim_iter {
 	struct mem_cgroup *position;
 	/* scan generation, increased every round-trip */
-	unsigned int generation;
+	atomic_t generation;
 };
 
 /*
--- a/mm/memcontrol.c~mm-restart-if-multiple-traversals-raced
+++ a/mm/memcontrol.c
@@ -986,7 +986,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 				   struct mem_cgroup_reclaim_cookie *reclaim)
 {
 	struct mem_cgroup_reclaim_iter *iter;
-	struct cgroup_subsys_state *css = NULL;
+	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *pos = NULL;
 
@@ -999,18 +999,20 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	rcu_read_lock();
 restart:
 	if (reclaim) {
+		int gen;
 		struct mem_cgroup_per_node *mz;
 
 		mz = root->nodeinfo[reclaim->pgdat->node_id];
 		iter = &mz->iter;
+		gen = atomic_read(&iter->generation);
 
 		/*
 		 * On start, join the current reclaim iteration cycle.
 		 * Exit when a concurrent walker completes it.
 		 */
 		if (!prev)
-			reclaim->generation = iter->generation;
-		else if (reclaim->generation != iter->generation)
+			reclaim->generation = gen;
+		else if (reclaim->generation != gen)
 			goto out_unlock;
 
 		pos = READ_ONCE(iter->position);
@@ -1018,8 +1020,7 @@ restart:
 		pos = prev;
 	}
 
-	if (pos)
-		css = &pos->css;
+	css = pos ? &pos->css : NULL;
 
 	for (;;) {
 		css = css_next_descendant_pre(css, &root->css);
@@ -1033,21 +1034,26 @@ restart:
 		 * and kicking, and don't take an extra reference.
 		 */
 		if (css == &root->css || css_tryget(css)) {
-			memcg = mem_cgroup_from_css(css);
 			break;
 		}
 	}
 
+	memcg = mem_cgroup_from_css(css);
+
 	if (reclaim) {
 		/*
 		 * The position could have already been updated by a competing
 		 * thread, so check that the value hasn't changed since we read
 		 * it to avoid reclaiming from the same cgroup twice.
 		 */
-		(void)cmpxchg(&iter->position, pos, memcg);
+		if (cmpxchg(&iter->position, pos, memcg) != pos) {
+			if (css && css != &root->css)
+				css_put(css);
+			goto restart;
+		}
 
 		if (!memcg) {
-			iter->generation++;
+			atomic_inc(&iter->generation);
 
 			/*
 			 * Reclaimers share the hierarchy walk, and a
_

Patches currently in -mm which might be from kinseyho@google.com are

cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu.patch
mm-dont-hold-css-refcnt-during-traversal.patch
mm-increment-gen-before-restarting-traversal.patch
mm-restart-if-multiple-traversals-raced.patch
mm-clean-up-mem_cgroup_iter.patch

