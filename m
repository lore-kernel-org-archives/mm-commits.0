Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB65B1E884
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374573; cv=none; b=ESt5hwJwn48lc8dVnKl1n5NdzQvHqJtz56GJye021KGozdMz4AzKsYX0nS9pOqUsRCRAPw4raAOrjJJjQFy5xIG9opB0iq/3WD3MLXzeQg2F+VFZTv23JBlrpWSVbXv1sVBNIcJPWTHffjwh6xblhqPMpMxzLPUrZD+Dzo2clEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374573; c=relaxed/simple;
	bh=oqb92OcvsVsnuzB+1RMeMvB8oMKrFkCyLpSa8tuyF7E=;
	h=Date:To:From:Subject:Message-Id; b=c1Ytx0mgE/WLfVic8LxolSS49MK1CAWKitrklt1MKuI8nPWcKw3df8P+oklJ8NjbH4KgrIYlAfYSxJT3iCvZkCnKm/DAMPxdkwwaF99fLX/zX4jLX/Zw1A5dGEOrNfPKEOkg5jfs97B2WmdBKElRPluKHonZR22Odp1Wx5hppWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ef2Xo4la; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ef2Xo4la"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE9CC4CECF;
	Tue, 12 Nov 2024 01:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374573;
	bh=oqb92OcvsVsnuzB+1RMeMvB8oMKrFkCyLpSa8tuyF7E=;
	h=Date:To:From:Subject:From;
	b=ef2Xo4layZFfSNHy7UKxvN9r95f5lHw87CnjuV/7XLnfCEudqA2FnjDueCSdPXCTA
	 ojVGD+DTzJupxBcy1JNJ3s4QGtHB4BDn6U/3bqCvXIMdheUMahkyfdG4+DB9lHGmui
	 YfgHbzFonqKTEZSa2GM/YmF7o0ui3bw71BJnCBgE=
Date: Mon, 11 Nov 2024 17:22:53 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,longman@redhat.com,hannes@cmpxchg.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-dont-pass-unnecessary-key-parameters.patch removed from -mm tree
Message-Id: <20241112012253.9BE9CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/list_lru: don't pass unnecessary key parameters
has been removed from the -mm tree.  Its filename was
     mm-list_lru-dont-pass-unnecessary-key-parameters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/list_lru: don't pass unnecessary key parameters
Date: Tue, 5 Nov 2024 01:52:52 +0800

Patch series "mm/list_lru: Split list_lru lock into per-cgroup scope".

When LOCKDEP is not enabled, lock_class_key is an empty struct that is
never used.  But the list_lru initialization function still takes a
placeholder pointer as parameter, and the compiler cannot optimize it
because the function is not static and exported.

Remove this parameter and move it inside the list_lru struct.  Only use it
when LOCKDEP is enabled.  Kernel builds with LOCKDEP will be slightly
larger, while !LOCKDEP builds without it will be slightly smaller (the
common case).

Link: https://lkml.kernel.org/r/20241104175257.60853-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20241104175257.60853-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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
@@ -813,8 +813,8 @@ static int __init workingset_init(void)
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


