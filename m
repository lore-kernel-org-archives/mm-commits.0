Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD1E130E58
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 20:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727296440; cv=none; b=K+PK4AXX6mNUNA/w8UDnhrZHgSgugf5t6pi48c00CJqhb3QI7kUr6gES6p/iIWq8Nm/H2xZNsWW/wMpJotLQXsRDteA0Oj2zxb9Kj1szwADN/MAL5dYjF+oVQWOrQzwpdMyuCCTZIcwdkXQmtqEVEPvXPkBjLOTLpOcX1pNFkSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727296440; c=relaxed/simple;
	bh=MqQWy2R/jRWQEGGVWTyM3AUA9z7zux0kqjFkwwTGpDc=;
	h=Date:To:From:Subject:Message-Id; b=BFqB+KfAvCzT8/RRtou61mmEJ84pJSYGB//KBXow3FJU1KOjQrrU3zGwWSdiJxMV4bwfBPIJyGQED+4xdzs0M7n4yOz2YmxNkcWRvB5Av7L24ygtwbeYS3W9i1UE28EjQOMHSBYZuxtuqHrO3HEJnirTje/aU1TNaQaDuFtFZKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n4xv2x+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n4xv2x+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6FCC4CEC3;
	Wed, 25 Sep 2024 20:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727296440;
	bh=MqQWy2R/jRWQEGGVWTyM3AUA9z7zux0kqjFkwwTGpDc=;
	h=Date:To:From:Subject:From;
	b=n4xv2x+Lv4HAyF8qkUBuCzMRG1VRbqx+r0vTrWHA4KnX5C2Dn+yCxl67CzGJ2ON6b
	 ZN55tawMXipDhpvww6PoQQtUJtP4cE6CiprQVPFiRsLyweeqbAGiibCIzJwXhfCB6Y
	 cwzOdRE8MGGJlxhbMlSs4JSTlhXN6RN25ODdGyMc=
Date: Wed, 25 Sep 2024 13:33:59 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,longman@redhat.com,hannes@cmpxchg.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-code-clean-up-for-reparenting.patch added to mm-unstable branch
Message-Id: <20240925203400.2E6FCC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/list_lru: code clean up for reparenting
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lru-code-clean-up-for-reparenting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-code-clean-up-for-reparenting.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/list_lru: code clean up for reparenting
Date: Thu, 26 Sep 2024 01:10:17 +0800

No feature change, just change of code structure and fix comment.

The list lrus are not empty until memcg_reparent_list_lru_node() calls are
all done, so the comments in memcg_offline_kmem were slightly inaccurate.

Link: https://lkml.kernel.org/r/20240925171020.32142-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c   |   39 +++++++++++++++++----------------------
 mm/memcontrol.c |    7 -------
 2 files changed, 17 insertions(+), 29 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-code-clean-up-for-reparenting
+++ a/mm/list_lru.c
@@ -421,35 +421,16 @@ out:
 	spin_unlock_irq(&nlru->lock);
 }
 
-static void memcg_reparent_list_lru(struct list_lru *lru,
-				    int src_idx, struct mem_cgroup *dst_memcg)
-{
-	int i;
-
-	for_each_node(i)
-		memcg_reparent_list_lru_node(lru, i, src_idx, dst_memcg);
-
-	memcg_list_lru_free(lru, src_idx);
-}
-
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
 	struct cgroup_subsys_state *css;
 	struct list_lru *lru;
-	int src_idx = memcg->kmemcg_id;
+	int src_idx = memcg->kmemcg_id, i;
 
 	/*
 	 * Change kmemcg_id of this cgroup and all its descendants to the
 	 * parent's id, and then move all entries from this cgroup's list_lrus
 	 * to ones of the parent.
-	 *
-	 * After we have finished, all list_lrus corresponding to this cgroup
-	 * are guaranteed to remain empty. So we can safely free this cgroup's
-	 * list lrus in memcg_list_lru_free().
-	 *
-	 * Changing ->kmemcg_id to the parent can prevent memcg_list_lru_alloc()
-	 * from allocating list lrus for this cgroup after memcg_list_lru_free()
-	 * call.
 	 */
 	rcu_read_lock();
 	css_for_each_descendant_pre(css, &memcg->css) {
@@ -460,9 +441,23 @@ void memcg_reparent_list_lrus(struct mem
 	}
 	rcu_read_unlock();
 
+	/*
+	 * With kmemcg_id set to parent, holding the lock of each list_lru_node
+	 * below can prevent list_lru_{add,del,isolate} from touching the lru,
+	 * safe to reparent.
+	 */
 	mutex_lock(&list_lrus_mutex);
-	list_for_each_entry(lru, &memcg_list_lrus, list)
-		memcg_reparent_list_lru(lru, src_idx, parent);
+	list_for_each_entry(lru, &memcg_list_lrus, list) {
+		for_each_node(i)
+			memcg_reparent_list_lru_node(lru, i, src_idx, parent);
+
+		/*
+		 * Here all list_lrus corresponding to the cgroup are guaranteed
+		 * to remain empty, we can safely free this lru, any further
+		 * memcg_list_lru_alloc() call will simply bail out.
+		 */
+		memcg_list_lru_free(lru, src_idx);
+	}
 	mutex_unlock(&list_lrus_mutex);
 }
 
--- a/mm/memcontrol.c~mm-list_lru-code-clean-up-for-reparenting
+++ a/mm/memcontrol.c
@@ -3101,13 +3101,6 @@ static void memcg_offline_kmem(struct me
 		parent = root_mem_cgroup;
 
 	memcg_reparent_objcgs(memcg, parent);
-
-	/*
-	 * After we have finished memcg_reparent_objcgs(), all list_lrus
-	 * corresponding to this cgroup are guaranteed to remain empty.
-	 * The ordering is imposed by list_lru_node->lock taken by
-	 * memcg_reparent_list_lrus().
-	 */
 	memcg_reparent_list_lrus(memcg, parent);
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-dont-pass-unnecessary-key-parameters.patch
mm-list_lru-dont-export-list_lru_add.patch
mm-list_lru-code-clean-up-for-reparenting.patch
mm-list_lru-simplify-reparenting-and-initial-allocation.patch
mm-list_lru-split-the-lock-to-per-cgroup-scope.patch
mm-list_lru-simplify-the-list_lru-walk-callback-function.patch

