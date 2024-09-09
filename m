Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB3D18E35B
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925316; cv=none; b=Eo/9efOWGzXEOEHd4UpPpVgujH/XN0RaZ6EjpfeR4H3hS6GZT5JB3qFEo5usJ66QHziQD7DfraaBUXDs7Kpncu2JzXsprHSvgyus2S/k57+FE5pd88NAb7ugIwbRkCWFt11o5esDugBFuiHfRNIYwkMnuo7ehEvl+GoSndrM5gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925316; c=relaxed/simple;
	bh=8WIiuF2BIB5KoLL6T0XoLYEdgX9zkdy+SEn2OYQuV8A=;
	h=Date:To:From:Subject:Message-Id; b=a8tRlkIeKGQgAIcf8wcZCCAAlF7hhh4LqkdIXssakwk/3RlgcwK3gkGRjzHwyOwAtIIcF4g3nQgjbDqXeX56682N6Lpa0wUx39gFFJKbuDCNbm6I2TCstiGBvP0sI7UGdaDoHvp8AlRB66+13UVJ1TZ2b+fBA69Ho69BNbnhxMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DYDqAB6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DYDqAB6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FC1C4CEC5;
	Mon,  9 Sep 2024 23:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925316;
	bh=8WIiuF2BIB5KoLL6T0XoLYEdgX9zkdy+SEn2OYQuV8A=;
	h=Date:To:From:Subject:From;
	b=DYDqAB6RSBmY4cLOrh25rgzgZ48NK4uYo9gaS0Psl2nTF2ygCO4MHPVhc1ksXlh6u
	 /5SBGBWUv6OepggI9O8/rDGk3E3wJWfJfBtCWXh4LEsXLSw/AAK+ACYIbkeifcwStT
	 3O2KgKY/vqMAWm/uzQrlrMJXBwDu8nlGAAWKepUA=
Date: Mon, 09 Sep 2024 16:41:56 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hughd@google.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-restart-if-multiple-traversals-raced.patch removed from -mm tree
Message-Id: <20240909234156.93FC1C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: restart if multiple traversals raced
has been removed from the -mm tree.  Its filename was
     mm-restart-if-multiple-traversals-raced.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kinsey Ho <kinseyho@google.com>
Subject: mm: restart if multiple traversals raced
Date: Thu, 5 Sep 2024 00:30:53 +0000

Currently, if multiple reclaimers raced on the same position, the
reclaimers which detect the race will still reclaim from the same memcg. 
Instead, the reclaimers which detect the race should move on to the next
memcg in the hierarchy.

So, in the case where multiple traversals race, jump back to the start of
the mem_cgroup_iter() function to find the next memcg in the hierarchy to
reclaim from.

Link: https://lkml.kernel.org/r/20240905003058.1859929-5-kinseyho@google.com
Reported-by: syzbot+e099d407346c45275ce9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/000000000000817cf10620e20d33@google.com/
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   26 +++++++++++++++++---------
 2 files changed, 19 insertions(+), 11 deletions(-)

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
@@ -986,8 +986,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 				   struct mem_cgroup_reclaim_cookie *reclaim)
 {
 	struct mem_cgroup_reclaim_iter *iter;
-	struct cgroup_subsys_state *css = NULL;
-	struct mem_cgroup *memcg = NULL;
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
 	struct mem_cgroup *pos = NULL;
 
 	if (mem_cgroup_disabled())
@@ -998,19 +998,23 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 	rcu_read_lock();
 restart:
+	memcg = NULL;
+
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
@@ -1018,8 +1022,7 @@ restart:
 		pos = prev;
 	}
 
-	if (pos)
-		css = &pos->css;
+	css = pos ? &pos->css : NULL;
 
 	for (;;) {
 		css = css_next_descendant_pre(css, &root->css);
@@ -1033,21 +1036,26 @@ restart:
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


