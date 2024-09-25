Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E3B130E58
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 20:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727296437; cv=none; b=p0WQvSefWQiezlpOszdMcCW56p8lLcd7Ap19STngSZMam+pvpjlk86b/64OF/fs4p45SktcZNYfB3bZEyhcy4eIMnOKlO4e0ql9rF0mloA2iJh9riqYtOnDpyj9RrKsLxMQCTvRbpAsqs8oSs0kfszyk7H3J954RtM35IUm3z14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727296437; c=relaxed/simple;
	bh=zX1b3e7RyZ6oNJkAZVv1rymXnSwRQ0psc9NoMJN2VM8=;
	h=Date:To:From:Subject:Message-Id; b=CPhEEFkYFcHKGpT46RXE5qYeEc+ovpAclsXjUIbPuxgihFvXWWNa+xqERWNgGbbdPCmsyt7PHy9Qx2CaCHbmsNeDFTTtI1v2d//IXZOc2rmahFL0pWGqj++U5c/Sw8VTn1HAluZiDk6jltXlnspW1Le79gXc7dqtJTSfyPS/CGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fsYPnT7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fsYPnT7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3E2C4CEC3;
	Wed, 25 Sep 2024 20:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727296437;
	bh=zX1b3e7RyZ6oNJkAZVv1rymXnSwRQ0psc9NoMJN2VM8=;
	h=Date:To:From:Subject:From;
	b=fsYPnT7MQgxgXnpAe92jwkAtnHW8KPMoiTKhW0Qw6mqIvTUTtWqdW5LM/gcpRqTWk
	 czjuq9Nmviz5+vj5vuzbvt47opc3bIoZCe9NQlBoOqBBh23DuRmQ63s7ADjACl2YGv
	 m6h/eO3dknXYJBgcR/OFbdCLE5Nsisqr6rxUNyzU=
Date: Wed, 25 Sep 2024 13:33:56 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,longman@redhat.com,hannes@cmpxchg.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-dont-pass-unnecessary-key-parameters.patch added to mm-unstable branch
Message-Id: <20240925203357.4A3E2C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/list_lru: don't pass unnecessary key parameters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lru-dont-pass-unnecessary-key-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-dont-pass-unnecessary-key-parameters.patch

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
Subject: mm/list_lru: don't pass unnecessary key parameters
Date: Thu, 26 Sep 2024 01:10:15 +0800

Patch series "Split list_lru lock into per-cgroup scope", v2.

Currently, every list_lru has a per-node lock that protects adding,
deletion, isolation, and reparenting of all list_lru_one instances
belonging to this list_lru on this node.  This lock contention is heavy
when multiple cgroups modify the same list_lru.

This can be alleviated by splitting the lock into per-cgroup scope.

To achieve this, this series reworked and optimized the reparenting
process step by step, making it possible to have a stable list_lru_one,
and making it possible to pin the list_lru_one.  Then split the lock into
per-cgroup scope.

The result is ~15% performance gain for simple multi-cgroup tar test of
small files, and reduced LOC.  See PATCH 5/6 for test details.


This patch (of 6):

When LOCKDEP is not enabled, lock_class_key is an empty struct that is
never used.  But the list_lru initialization function still takes a
placeholder pointer as parameter, and the compiler cannot optimize it
because the function is not static and exported.

Remove this parameter and move it inside the list_lru struct.  Only use it
when LOCKDEP is enabled.  Kernel builds with LOCKDEP will be slightly
larger, while !LOCKDEP builds without it will be slightly smaller (the
common case).

Link: https://lkml.kernel.org/r/20240925171020.32142-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20240925171020.32142-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   18 +++++++++++++++---
 mm/list_lru.c            |    9 +++++----
 mm/workingset.c          |    4 ++--
 3 files changed, 22 insertions(+), 9 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-dont-pass-unnecessary-key-parameters
+++ a/include/linux/list_lru.h
@@ -56,16 +56,28 @@ struct list_lru {
 	bool			memcg_aware;
 	struct xarray		xa;
 #endif
+#ifdef CONFIG_LOCKDEP
+	struct lock_class_key	*key;
+#endif
 };
 
 void list_lru_destroy(struct list_lru *lru);
 int __list_lru_init(struct list_lru *lru, bool memcg_aware,
-		    struct lock_class_key *key, struct shrinker *shrinker);
+		    struct shrinker *shrinker);
 
 #define list_lru_init(lru)				\
-	__list_lru_init((lru), false, NULL, NULL)
+	__list_lru_init((lru), false, NULL)
 #define list_lru_init_memcg(lru, shrinker)		\
-	__list_lru_init((lru), true, NULL, shrinker)
+	__list_lru_init((lru), true, shrinker)
+
+static inline int list_lru_init_memcg_key(struct list_lru *lru, struct shrinker *shrinker,
+					  struct lock_class_key *key)
+{
+#ifdef CONFIG_LOCKDEP
+	lru->key = key;
+#endif
+	return list_lru_init_memcg(lru, shrinker);
+}
 
 int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
--- a/mm/list_lru.c~mm-list_lru-dont-pass-unnecessary-key-parameters
+++ a/mm/list_lru.c
@@ -562,8 +562,7 @@ static void memcg_destroy_list_lru(struc
 }
 #endif /* CONFIG_MEMCG */
 
-int __list_lru_init(struct list_lru *lru, bool memcg_aware,
-		    struct lock_class_key *key, struct shrinker *shrinker)
+int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shrinker)
 {
 	int i;
 
@@ -583,8 +582,10 @@ int __list_lru_init(struct list_lru *lru
 
 	for_each_node(i) {
 		spin_lock_init(&lru->node[i].lock);
-		if (key)
-			lockdep_set_class(&lru->node[i].lock, key);
+#ifdef CONFIG_LOCKDEP
+		if (lru->key)
+			lockdep_set_class(&lru->node[i].lock, lru->key);
+#endif
 		init_one_lru(&lru->node[i].lru);
 	}
 
--- a/mm/workingset.c~mm-list_lru-dont-pass-unnecessary-key-parameters
+++ a/mm/workingset.c
@@ -823,8 +823,8 @@ static int __init workingset_init(void)
 	if (!workingset_shadow_shrinker)
 		goto err;
 
-	ret = __list_lru_init(&shadow_nodes, true, &shadow_nodes_key,
-			      workingset_shadow_shrinker);
+	ret = list_lru_init_memcg_key(&shadow_nodes, workingset_shadow_shrinker,
+				      &shadow_nodes_key);
 	if (ret)
 		goto err_list_lru;
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-dont-pass-unnecessary-key-parameters.patch
mm-list_lru-dont-export-list_lru_add.patch
mm-list_lru-code-clean-up-for-reparenting.patch
mm-list_lru-simplify-reparenting-and-initial-allocation.patch
mm-list_lru-split-the-lock-to-per-cgroup-scope.patch
mm-list_lru-simplify-the-list_lru-walk-callback-function.patch

