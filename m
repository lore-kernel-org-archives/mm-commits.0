Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D451DE8BB
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968131; cv=none; b=XjqQ1PqUxOJmniw26zdqjr74AqaTgNT4yXQG9ZcfhRKF+hq0+9ZjNYfx1i+PzmSwo4jnmsedQJvDez82sAnNP2zqLLPMp4kyPwTWCW8HxzzL0A0HKPcooONywh8GWJP5o6TDSL2E9YH8L52Brz7vfvy1GQZH+c0wy6WClURX4Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968131; c=relaxed/simple;
	bh=xPCjU7J/XqNhiU7eNfn4Ug7ucFrQMOfirdsm8UXC4JI=;
	h=Date:To:From:Subject:Message-Id; b=J1A4MYmClWHGjIG0Xk+xhUjnFUcjp1+VKC0dl9Zyap3AKLKXBN/JhBngGN5U9A2eyHBCM8NaKWrmD89b05bqM5nb1Jh8ld7A31BByUKGhYKFa6Umv02R430p3M1DE9GI0gezKXN3oQWBXxRKka3Y1lKpZfWwqu6TKhmRhzVBSVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZNnAlhoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZNnAlhoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AF81F00893;
	Tue,  9 Jun 2026 01:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968130;
	bh=uANxrUCaeDqEUu2+a3xytdYBp0PQwi1kLsC1ATTbV28=;
	h=Date:To:From:Subject;
	b=ZNnAlhoCfiaC+ChMZ0/0GoGxUJ1wZKGypUKttWXXnQTkXxf6CzyWe/SfMI/Vio3gq
	 WT0nPFlnIk/IfG2qUAFn6VsBbWMBZjNYus6TjzDLb0nrhoTLjArlVq7eXeTUl6/lVe
	 mqL3qu1rMOUbsodTTUCzOolr/v8kxjD8eXKhZiew=
Date: Mon, 08 Jun 2026 18:22:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-deduplicate-unlock_list_lru.patch removed from -mm tree
Message-Id: <20260609012209.E5AF81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: deduplicate unlock_list_lru()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-deduplicate-unlock_list_lru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: deduplicate unlock_list_lru()
Date: Wed, 27 May 2026 16:45:10 -0400

The MEMCG and !MEMCG variants are the same.  lock_list_lru() has the same
pattern when bailing.  Consolidate into a common implementation.

Link: https://lore.kernel.org/20260527204757.2544958-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-deduplicate-unlock_list_lru
+++ a/mm/list_lru.c
@@ -15,6 +15,14 @@
 #include "slab.h"
 #include "internal.h"
 
+static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
+{
+	if (irq_off)
+		spin_unlock_irq(&l->lock);
+	else
+		spin_unlock(&l->lock);
+}
+
 #ifdef CONFIG_MEMCG
 static LIST_HEAD(memcg_list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
@@ -67,10 +75,7 @@ static inline bool lock_list_lru(struct
 	else
 		spin_lock(&l->lock);
 	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
-		if (irq)
-			spin_unlock_irq(&l->lock);
-		else
-			spin_unlock(&l->lock);
+		unlock_list_lru(l, irq);
 		return false;
 	}
 	return true;
@@ -101,14 +106,6 @@ again:
 	*memcg = parent_mem_cgroup(*memcg);
 	goto again;
 }
-
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
-{
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
-}
 #else
 static void list_lru_register(struct list_lru *lru)
 {
@@ -147,14 +144,6 @@ lock_list_lru_of_memcg(struct list_lru *
 
 	return l;
 }
-
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
-{
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
-}
 #endif /* CONFIG_MEMCG */
 
 /* The caller must ensure the memcg lifetime. */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


