Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378FF41760
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803050; cv=none; b=IlrVLeLYLOwqCakt9QEcjPeC4FnPzV1OT/tSHX1NPHS3rAH4RBVhUE8bHVv5ij862JVqvKLAuZg+oE21cgPQLiIPqAuEqv7cODdCRWonJN1Vb8eQNZj5YFljiXHIhJb005rqD83RG81qrrW5LKU4dtxouFid6ZVyEWkP02mzlFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803050; c=relaxed/simple;
	bh=pnp59yGlOo00mQqc7wVk1lTg+4J9Y1F+EKdaeBeIfMY=;
	h=Date:To:From:Subject:Message-Id; b=Dq0HVDAmaOcI0eEpKfNZTtPFR9LNG3+Lg18MBQxGC7/wBLcUCjT8WLDA+fijLJvvqY9TuUfnNiHRbMQY6+pnZLC6mD1AFHlLL6fh/i2PVsJgSo9HrSJ78a1/TOKY/JuzIZTjG/svHq7J4EWX+9b3QsTdl6jMeVakwV29ckX/oyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FexE1Rhj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FexE1Rhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6874C32782;
	Tue, 27 Aug 2024 23:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803050;
	bh=pnp59yGlOo00mQqc7wVk1lTg+4J9Y1F+EKdaeBeIfMY=;
	h=Date:To:From:Subject:From;
	b=FexE1RhjO8bWB74IWQ0QymO0ZxmbWTJw3+kv69HAi2kAMS0u2AzWR6DncCbj853Ro
	 brIIQ7CV/89zWTB57UF3bf8VBNbf0UT4dPSSOLLHW3RwDCOZCreY0ddmNn+asQdHj8
	 CNuNZrWI4a3yv7Hyro/WdEVbxXOPusFhEho4UxEU=
Date: Tue, 27 Aug 2024 16:57:29 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clean-up-mem_cgroup_iter.patch added to mm-unstable branch
Message-Id: <20240827235729.E6874C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: clean up mem_cgroup_iter()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-clean-up-mem_cgroup_iter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-clean-up-mem_cgroup_iter.patch

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
Subject: mm: clean up mem_cgroup_iter()
Date: Tue, 27 Aug 2024 23:07:42 +0000

A clean up to make variable names more clear and to improve code
readability.

No functional change.

Link: https://lkml.kernel.org/r/20240827230753.2073580-6-kinseyho@google.com
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

 mm/memcontrol.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

--- a/mm/memcontrol.c~mm-clean-up-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -987,8 +987,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 {
 	struct mem_cgroup_reclaim_iter *iter;
 	struct cgroup_subsys_state *css;
-	struct mem_cgroup *memcg = NULL;
-	struct mem_cgroup *pos = NULL;
+	struct mem_cgroup *pos;
+	struct mem_cgroup *next = NULL;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1000,10 +1000,9 @@ struct mem_cgroup *mem_cgroup_iter(struc
 restart:
 	if (reclaim) {
 		int gen;
-		struct mem_cgroup_per_node *mz;
+		int nid = reclaim->pgdat->node_id;
 
-		mz = root->nodeinfo[reclaim->pgdat->node_id];
-		iter = &mz->iter;
+		iter = &root->nodeinfo[nid]->iter;
 		gen = atomic_read(&iter->generation);
 
 		/*
@@ -1016,29 +1015,22 @@ restart:
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
@@ -1046,13 +1038,13 @@ restart:
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
@@ -1071,7 +1063,7 @@ out_unlock:
 	if (prev && prev != root)
 		css_put(&prev->css);
 
-	return memcg;
+	return next;
 }
 
 /**
_

Patches currently in -mm which might be from kinseyho@google.com are

cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu.patch
mm-dont-hold-css-refcnt-during-traversal.patch
mm-increment-gen-before-restarting-traversal.patch
mm-restart-if-multiple-traversals-raced.patch
mm-clean-up-mem_cgroup_iter.patch

