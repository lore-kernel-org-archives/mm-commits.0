Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C0318D647
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925318; cv=none; b=moQf+opR/SgXLJ5xYdV4sYPOgHTUSuyiSdOtj/+Z5oqhCEQzu7FEFkO2hyCXq0z5xS0dAVf4o2aAFRbVhvN9gZ607oOJB/T5Oc8nwJQJmTrIWSedCdRM8pmlkFmFpxy3o4CL9Sy6TY3c8l9wh6UovGVIkz2m/ru6y+ykYMQ4xdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925318; c=relaxed/simple;
	bh=nM+9czTr9MN0BfzwX+kRxJgBpybpKsx6Oop+S254kPA=;
	h=Date:To:From:Subject:Message-Id; b=Bvqj0FGpxQw94CNsdu6GHCwJcVg6tBAtAZWkc/Vr5r6jSq8QaqeL3VGoDCusqhnWX2BuHvRTkbaqoq/Pm3lR1mT/wCF7lzJSxD285wZfAo3cFtC7tMMZGtLST6AKdUzR7XTUsZIyVDghTGpKDfL7ghnB8pfFOTa+koGt6FkJvrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pumNhnl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pumNhnl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A17C4CEC5;
	Mon,  9 Sep 2024 23:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925318;
	bh=nM+9czTr9MN0BfzwX+kRxJgBpybpKsx6Oop+S254kPA=;
	h=Date:To:From:Subject:From;
	b=pumNhnl93icP2YQcOJLLz90yLL/hQujC+6u0QMkH0VJQIM4PKFKvjmqcYmgLhgOSi
	 RuMnP8P8Ih6IuWa8pwtTjHyx5d8aLBL7wX+J9YgQC62vczsqrQSmJk1II7MtsoqJ/H
	 GWGa6TyKJ8CBZFJygeJw/8EQOBG2VemGpOKXJHwQ=
Date: Mon, 09 Sep 2024 16:41:58 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hughd@google.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-clean-up-mem_cgroup_iter.patch removed from -mm tree
Message-Id: <20240909234158.89A17C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: clean up mem_cgroup_iter()
has been removed from the -mm tree.  Its filename was
     mm-clean-up-mem_cgroup_iter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kinsey Ho <kinseyho@google.com>
Subject: mm: clean up mem_cgroup_iter()
Date: Thu, 5 Sep 2024 00:30:54 +0000

A clean up to make variable names more clear and to improve code
readability.

No functional change.

Link: https://lkml.kernel.org/r/20240905003058.1859929-6-kinseyho@google.com
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

 mm/memcontrol.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

--- a/mm/memcontrol.c~mm-clean-up-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -987,8 +987,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 {
 	struct mem_cgroup_reclaim_iter *iter;
 	struct cgroup_subsys_state *css;
-	struct mem_cgroup *memcg;
-	struct mem_cgroup *pos = NULL;
+	struct mem_cgroup *pos;
+	struct mem_cgroup *next;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -998,14 +998,13 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 	rcu_read_lock();
 restart:
-	memcg = NULL;
+	next = NULL;
 
 	if (reclaim) {
 		int gen;
-		struct mem_cgroup_per_node *mz;
+		int nid = reclaim->pgdat->node_id;
 
-		mz = root->nodeinfo[reclaim->pgdat->node_id];
-		iter = &mz->iter;
+		iter = &root->nodeinfo[nid]->iter;
 		gen = atomic_read(&iter->generation);
 
 		/*
@@ -1018,29 +1017,22 @@ restart:
 			goto out_unlock;
 
 		pos = READ_ONCE(iter->position);
-	} else if (prev) {
+	} else
 		pos = prev;
-	}
 
 	css = pos ? &pos->css : NULL;
 
-	for (;;) {
-		css = css_next_descendant_pre(css, &root->css);
-		if (!css) {
-			break;
-		}
-
+	while ((css = css_next_descendant_pre(css, &root->css))) {
 		/*
 		 * Verify the css and acquire a reference.  The root
 		 * is provided by the caller, so we know it's alive
 		 * and kicking, and don't take an extra reference.
 		 */
-		if (css == &root->css || css_tryget(css)) {
+		if (css == &root->css || css_tryget(css))
 			break;
-		}
 	}
 
-	memcg = mem_cgroup_from_css(css);
+	next = mem_cgroup_from_css(css);
 
 	if (reclaim) {
 		/*
@@ -1048,13 +1040,13 @@ restart:
 		 * thread, so check that the value hasn't changed since we read
 		 * it to avoid reclaiming from the same cgroup twice.
 		 */
-		if (cmpxchg(&iter->position, pos, memcg) != pos) {
+		if (cmpxchg(&iter->position, pos, next) != pos) {
 			if (css && css != &root->css)
 				css_put(css);
 			goto restart;
 		}
 
-		if (!memcg) {
+		if (!next) {
 			atomic_inc(&iter->generation);
 
 			/*
@@ -1073,7 +1065,7 @@ out_unlock:
 	if (prev && prev != root)
 		css_put(&prev->css);
 
-	return memcg;
+	return next;
 }
 
 /**
_

Patches currently in -mm which might be from kinseyho@google.com are


