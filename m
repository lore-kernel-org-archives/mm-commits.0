Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE3BBA38;
	Thu,  8 Aug 2024 01:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723081327; cv=none; b=Aj9xq63x2VvJBMBbySFir4tehCiZIfFAFndq6iQk9sUeBB8s3gnOFtiNnrUadQqSo7dOMPv2NP42iNcKOmn2sX3St/afShpKuOtAD/ixMBTkVZtpbsWyX9ueBgbYOMHrf4GAfIcDtwZsn8+tubKIKSq4/RibYCTTNmwHRDfvITI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723081327; c=relaxed/simple;
	bh=dmR3ydn5zFJvm0zKNVn0Sl4YSq5Bkw7aElBgl7lFg70=;
	h=Date:To:From:Subject:Message-Id; b=al1jukS4olioWGaHdukqSgPFSvn2bEK8Vla59z+rh+nULf5u3zI0ArmQ1bvxRioF0KSyQ7NZ7aCN2ZBuWxqDODcBXbvS46M0ijPBloxWMKepOU2MpEGXung+ECTtJl3qNPU7kXpc5CIOVoQDMNYjneHy2reTEsq/JuhjvzoDyDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E51ujiy7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E51ujiy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51546C4AF10;
	Thu,  8 Aug 2024 01:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723081327;
	bh=dmR3ydn5zFJvm0zKNVn0Sl4YSq5Bkw7aElBgl7lFg70=;
	h=Date:To:From:Subject:From;
	b=E51ujiy7tb+9HVdAXj2ibJVuZoFxwhCqqNZuXPENpHK4UvBg76e6QxhTEkpFqARO6
	 Oykw3rhEFI7Ynre7+m9MClVJK2pCFEGlowVSmhUgNq6L2cVv4ndcJgtXJU0FuOJicP
	 vm0vb5AkKxUJTnM6dDRfX+dXy2hFZg8EnZCXeWO0=
Date: Wed, 07 Aug 2024 18:42:06 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-list_lru-fix-uaf-for-memory-cgroup.patch removed from -mm tree
Message-Id: <20240808014207.51546C4AF10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: fix UAF for memory cgroup
has been removed from the -mm tree.  Its filename was
     mm-list_lru-fix-uaf-for-memory-cgroup.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: list_lru: fix UAF for memory cgroup
Date: Thu, 18 Jul 2024 16:36:07 +0800

The mem_cgroup_from_slab_obj() is supposed to be called under rcu lock or
cgroup_mutex or others which could prevent returned memcg from being
freed.  Fix it by adding missing rcu read lock.

Found by code inspection.

[songmuchun@bytedance.com: only grab rcu lock when necessary, per Vlastimil]
  Link: https://lkml.kernel.org/r/20240801024603.1865-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20240718083607.42068-1-songmuchun@bytedance.com
Fixes: 0a97c01cd20b ("list_lru: allow explicit memcg and NUMA node selection")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-fix-uaf-for-memory-cgroup
+++ a/mm/list_lru.c
@@ -85,6 +85,7 @@ list_lru_from_memcg_idx(struct list_lru
 }
 #endif /* CONFIG_MEMCG */
 
+/* The caller must ensure the memcg lifetime. */
 bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 		    struct mem_cgroup *memcg)
 {
@@ -109,14 +110,22 @@ EXPORT_SYMBOL_GPL(list_lru_add);
 
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 {
+	bool ret;
 	int nid = page_to_nid(virt_to_page(item));
-	struct mem_cgroup *memcg = list_lru_memcg_aware(lru) ?
-		mem_cgroup_from_slab_obj(item) : NULL;
 
-	return list_lru_add(lru, item, nid, memcg);
+	if (list_lru_memcg_aware(lru)) {
+		rcu_read_lock();
+		ret = list_lru_add(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		rcu_read_unlock();
+	} else {
+		ret = list_lru_add(lru, item, nid, NULL);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(list_lru_add_obj);
 
+/* The caller must ensure the memcg lifetime. */
 bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 		    struct mem_cgroup *memcg)
 {
@@ -139,11 +148,18 @@ EXPORT_SYMBOL_GPL(list_lru_del);
 
 bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
 {
+	bool ret;
 	int nid = page_to_nid(virt_to_page(item));
-	struct mem_cgroup *memcg = list_lru_memcg_aware(lru) ?
-		mem_cgroup_from_slab_obj(item) : NULL;
 
-	return list_lru_del(lru, item, nid, memcg);
+	if (list_lru_memcg_aware(lru)) {
+		rcu_read_lock();
+		ret = list_lru_del(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		rcu_read_unlock();
+	} else {
+		ret = list_lru_del(lru, item, nid, NULL);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(list_lru_del_obj);
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-kmem-remove-mem_cgroup_from_obj.patch

