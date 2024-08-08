Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903B53D6B;
	Thu,  8 Aug 2024 01:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723080134; cv=none; b=HmPW9mmjZFNn4STDO7dYcbE00yW7IAWpak5RSfm6HQMJRln+VTzXCVnQEhYIysjP9l3ETf3efyOFR0by+AGfqIvTSMscU3D4QL599EQ1CIK74sEc0qCLlCa1qqgyzu23l50YFFrWxkoX4F1PRXrtugfUC0uUXaK6rfeDLRLadx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723080134; c=relaxed/simple;
	bh=Q9iG8XcqmMx33JQUTjEOFH7E6Sv0L21shlHay8t5HZ0=;
	h=Date:To:From:Subject:Message-Id; b=LMtSFV5XO0DIRL+z/SUfX4cdDSyCIcjdX4nDXWf1Aeepk6kiVT8wYHl/X3f/g5xEJb3uF+p++zR2BIIvXFrVqpR4Z5/y+lUFE2rQczfys2UEy2kneXI6tM0z/WkK0ywnyB+Sx4u5AKGxbzMb9D61xgPxwFTODlVXyNIXqmU5Td4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iF8h/1aL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iF8h/1aL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCB6C32781;
	Thu,  8 Aug 2024 01:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723080134;
	bh=Q9iG8XcqmMx33JQUTjEOFH7E6Sv0L21shlHay8t5HZ0=;
	h=Date:To:From:Subject:From;
	b=iF8h/1aLtwpmXKTjMstaGDWyQi1AWkVkMG1lvw4IWKEGH4+F8yqx2a7RG4PuIifmU
	 RaBWuEzKEa4QkCNqrf29dfzFrX0bXDJxfReD8dx/UrhYSYvjwMMb/l1hLTEoOE4QNs
	 XQuOEUpjoxU7W+Jg7Ula7mi1TcRrUKbF6nT58370=
Date: Wed, 07 Aug 2024 18:22:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-list_lru-fix-uaf-for-memory-cgroup-v2.patch removed from -mm tree
Message-Id: <20240808012214.0CCB6C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-list_lru-fix-uaf-for-memory-cgroup-v2
has been removed from the -mm tree.  Its filename was
     mm-list_lru-fix-uaf-for-memory-cgroup-v2.patch

This patch was dropped because it was folded into mm-list_lru-fix-uaf-for-memory-cgroup.patch

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm-list_lru-fix-uaf-for-memory-cgroup-v2
Date: Thu, 1 Aug 2024 10:46:03 +0800

only grab rcu lock when necessary, per Vlastimil

Link: https://lkml.kernel.org/r/20240801024603.1865-1-songmuchun@bytedance.com
Fixes: 0a97c01cd20b ("list_lru: allow explicit memcg and NUMA node selection")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-fix-uaf-for-memory-cgroup-v2
+++ a/mm/list_lru.c
@@ -112,12 +112,14 @@ bool list_lru_add_obj(struct list_lru *l
 {
 	bool ret;
 	int nid = page_to_nid(virt_to_page(item));
-	struct mem_cgroup *memcg;
 
-	rcu_read_lock();
-	memcg = list_lru_memcg_aware(lru) ? mem_cgroup_from_slab_obj(item) : NULL;
-	ret = list_lru_add(lru, item, nid, memcg);
-	rcu_read_unlock();
+	if (list_lru_memcg_aware(lru)) {
+		rcu_read_lock();
+		ret = list_lru_add(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		rcu_read_unlock();
+	} else {
+		ret = list_lru_add(lru, item, nid, NULL);
+	}
 
 	return ret;
 }
@@ -148,12 +150,14 @@ bool list_lru_del_obj(struct list_lru *l
 {
 	bool ret;
 	int nid = page_to_nid(virt_to_page(item));
-	struct mem_cgroup *memcg;
 
-	rcu_read_lock();
-	memcg = list_lru_memcg_aware(lru) ? mem_cgroup_from_slab_obj(item) : NULL;
-	ret = list_lru_del(lru, item, nid, memcg);
-	rcu_read_unlock();
+	if (list_lru_memcg_aware(lru)) {
+		rcu_read_lock();
+		ret = list_lru_del(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		rcu_read_unlock();
+	} else {
+		ret = list_lru_del(lru, item, nid, NULL);
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-list_lru-fix-uaf-for-memory-cgroup.patch
mm-kmem-remove-mem_cgroup_from_obj.patch

