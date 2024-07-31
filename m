Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162FA38DE9
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 20:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722457710; cv=none; b=BiG11ShF57MhbbWNwtdkmaRs2m3ZKK9ZDR7XBqlgPa/4RRaTNkhWFhsws6gaSMQ8MPuP/bfOevhFnDHf6jg5eEfPmtaS67kv/8ZBGjmr4h/85top9UNaIhgaBq41bk/5tf0KiWTOpKreN5w1uMyD9RprzkqGjoXR/WmJ+ZhpoZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722457710; c=relaxed/simple;
	bh=zxihI8mt9lkISThbBGy1F7JpcGD/0RGXyozhgbjDdck=;
	h=Date:To:From:Subject:Message-Id; b=ebbHJ/ks93+VWa6B/5tuBHSCLmv7jg9lqpPsRY8upXCFK8ggj/CHquwC84Z48tsklPDwdjJkHfwT7KeCvsn9KzzyFLrppCQckb9nX2mj+gvL6w3L2PmQIxpa6lVXNT7bWK3DzIn7mz9KkCIEYzhI5RVtosP1ZePee/xKj9h6vlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yJ0XvxBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yJ0XvxBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86F6C116B1;
	Wed, 31 Jul 2024 20:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722457709;
	bh=zxihI8mt9lkISThbBGy1F7JpcGD/0RGXyozhgbjDdck=;
	h=Date:To:From:Subject:From;
	b=yJ0XvxBl5eZE/nBoKUtZG2EWe94ILP3sCmIx+78oAHOOtCO5ovQBicFQ4v/IewCZu
	 P0dCux2mlYWqYxqK6cL5ZS/OU0smf5DHkHpwNQYYvT7ALkCu+d5/lF6Dz5BNw0u7RF
	 brpmx0rJ6uJXTL5cXkPWQRAm5BQs6EBPePEy8VNw=
Date: Wed, 31 Jul 2024 13:28:29 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-fix-uaf-for-memory-cgroup.patch added to mm-hotfixes-unstable branch
Message-Id: <20240731202829.C86F6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: list_lru: fix UAF for memory cgroup
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-list_lru-fix-uaf-for-memory-cgroup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-fix-uaf-for-memory-cgroup.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: list_lru: fix UAF for memory cgroup
Date: Thu, 18 Jul 2024 16:36:07 +0800

The mem_cgroup_from_slab_obj() is supposed to be called under rcu lock or
cgroup_mutex or others which could prevent returned memcg from being
freed.  Fix it by adding missing rcu read lock.

Found by code inspection.

Link: https://lkml.kernel.org/r/20240718083607.42068-1-songmuchun@bytedance.com
Fixes: 0a97c01cd20bb ("list_lru: allow explicit memcg and NUMA node selection)
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-fix-uaf-for-memory-cgroup
+++ a/mm/list_lru.c
@@ -85,6 +85,7 @@ list_lru_from_memcg_idx(struct list_lru
 }
 #endif /* CONFIG_MEMCG */
 
+/* The caller must ensure the memcg lifetime. */
 bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 		    struct mem_cgroup *memcg)
 {
@@ -109,14 +110,20 @@ EXPORT_SYMBOL_GPL(list_lru_add);
 
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 {
+	bool ret;
 	int nid = page_to_nid(virt_to_page(item));
-	struct mem_cgroup *memcg = list_lru_memcg_aware(lru) ?
-		mem_cgroup_from_slab_obj(item) : NULL;
+	struct mem_cgroup *memcg;
 
-	return list_lru_add(lru, item, nid, memcg);
+	rcu_read_lock();
+	memcg = list_lru_memcg_aware(lru) ? mem_cgroup_from_slab_obj(item) : NULL;
+	ret = list_lru_add(lru, item, nid, memcg);
+	rcu_read_unlock();
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(list_lru_add_obj);
 
+/* The caller must ensure the memcg lifetime. */
 bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 		    struct mem_cgroup *memcg)
 {
@@ -139,11 +146,16 @@ EXPORT_SYMBOL_GPL(list_lru_del);
 
 bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
 {
+	bool ret;
 	int nid = page_to_nid(virt_to_page(item));
-	struct mem_cgroup *memcg = list_lru_memcg_aware(lru) ?
-		mem_cgroup_from_slab_obj(item) : NULL;
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = list_lru_memcg_aware(lru) ? mem_cgroup_from_slab_obj(item) : NULL;
+	ret = list_lru_del(lru, item, nid, memcg);
+	rcu_read_unlock();
 
-	return list_lru_del(lru, item, nid, memcg);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(list_lru_del_obj);
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-list_lru-fix-uaf-for-memory-cgroup.patch
mm-kmem-remove-mem_cgroup_from_obj.patch

