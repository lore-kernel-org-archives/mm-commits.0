Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA4418EFF8
	for <mm-commits@vger.kernel.org>; Thu,  5 Sep 2024 23:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725577494; cv=none; b=tNpBxSXLKVMf+3EbEnzlg+LwAVHTVPncfI6HxTrj0uoUtD8ObBEohOsKAF7KcNJU5vdbqp93Tmbu4KXDbCm632v/DBfLV8SBSs0g953vo2xTwrGwwuz52NnVpAkilYNewUA3NmKX1L0uWPQtuaNO+7JbPleybg9Zb4ZRNpankSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725577494; c=relaxed/simple;
	bh=6zsTc9mvg5EVStltiC8r0EfLpd9EUhLjkP2ougg7th0=;
	h=Date:To:From:Subject:Message-Id; b=Nx0+zXeuW8jNHqY4XrDx7fmZ21cUthlBb05kMAAFIQL/fxnOu6p6dpTTDCVxTRfjSj2oAnClNyLu0T9VHvvuxBnp8c0iqknoxtUJSS4dlSlYF0T7MUyPwf7E+QyjpZalzTNPdEMHDls4EXPoKy7uGS4YUJBr2mimCe8akYyvxOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dYk8qzuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dYk8qzuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E45C4CEC3;
	Thu,  5 Sep 2024 23:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725577494;
	bh=6zsTc9mvg5EVStltiC8r0EfLpd9EUhLjkP2ougg7th0=;
	h=Date:To:From:Subject:From;
	b=dYk8qzuybutTNkfNOf55G3P52TodprvwOYI/BZTRq4fenqWZi7upKFuA9QEtqz8S1
	 6WoQl9XaFKC2O6yz07dIO+PIyJNC3FEz/XuAPriP+UGGP3tbA4H+cQxboKvZ6v7kJF
	 mft8Z/A+IzGtoXWUkxTlZ1dw4Ha5CaFRq1OxjCN8=
Date: Thu, 05 Sep 2024 16:04:53 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hughd@google.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-restart-if-multiple-traversals-raced.patch added to mm-unstable branch
Message-Id: <20240905230453.D9E45C4CEC3@smtp.kernel.org>
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
@@ -988,8 +988,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 				   struct mem_cgroup_reclaim_cookie *reclaim)
 {
 	struct mem_cgroup_reclaim_iter *iter;
-	struct cgroup_subsys_state *css = NULL;
-	struct mem_cgroup *memcg = NULL;
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
 	struct mem_cgroup *pos = NULL;
 
 	if (mem_cgroup_disabled())
@@ -1000,19 +1000,23 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
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
@@ -1020,8 +1024,7 @@ restart:
 		pos = prev;
 	}
 
-	if (pos)
-		css = &pos->css;
+	css = pos ? &pos->css : NULL;
 
 	for (;;) {
 		css = css_next_descendant_pre(css, &root->css);
@@ -1035,21 +1038,26 @@ restart:
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

