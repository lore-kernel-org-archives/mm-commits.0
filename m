Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60301DE8BB
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968134; cv=none; b=M1aXBEnsH7vME2OkG/2dnQMz/k3LO2Ix/Q3aXQxkV3UfgxrDTkzuoG1bYMlKVLVaf1xV1gU0QZ7NwIwBmVvSYUdfSQIW0LpTjFieKYwQXV3B/bVh/4ft8yRFee5bzj0Xj6ZWMaarIPc8lj7oDQFNqTVm4jAaRIulCatCzYGhLus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968134; c=relaxed/simple;
	bh=XmgDU5CeZ2DSQwjFCNj1UBiMmFZ/v04KP+FgPqq+39c=;
	h=Date:To:From:Subject:Message-Id; b=iM97i+Sn6kUzSUCwJJ22rKYnwqZFG4NDUQJXpg4wp4t285sPdLB28ddfi97YMwnmOOuK3tkOFvEpx655tDJWrf6IOrGgGRfdAHbWmsDoZs1Xls103laJKvtyEeNyvPXcuQJpbhj4oxP7qHXkArZhb5pL6elqqPcL9ehRR51WWDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1rD/WeS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1rD/WeS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F381F00893;
	Tue,  9 Jun 2026 01:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968133;
	bh=KnHv3EBZtWvsTPHUj/Uu5+0LZRcBIst3qYXLtAvMRgM=;
	h=Date:To:From:Subject;
	b=1rD/WeS1LphXlbsdYXoPrJ/lUIeTY0jPFFtpwuyXTUqPHZFzM8+oxLVqVOk99FfI7
	 P+LomTkQRaipcWzm8Zq/7t+eu1o9lweCwfrUsT4AiJaFdR5z2qklUhUNJKxsYgUXob
	 iNBaPGsPj4crJ4HuedPq9KOaGXP1Wv/7EUJu9lHA=
Date: Mon, 08 Jun 2026 18:22:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-deduplicate-lock_list_lru.patch removed from -mm tree
Message-Id: <20260609012213.57F381F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: deduplicate lock_list_lru()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-deduplicate-lock_list_lru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: deduplicate lock_list_lru()
Date: Wed, 27 May 2026 16:45:12 -0400

The MEMCG and !MEMCG paths have the same pattern. Share the code.

Link: https://lore.kernel.org/20260527204757.2544958-6-hannes@cmpxchg.org
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

 mm/list_lru.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-deduplicate-lock_list_lru
+++ a/mm/list_lru.c
@@ -15,6 +15,14 @@
 #include "slab.h"
 #include "internal.h"
 
+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
+{
+	if (irq)
+		spin_lock_irq(&l->lock);
+	else
+		spin_lock(&l->lock);
+}
+
 static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
 {
 	if (irq_off)
@@ -68,14 +76,6 @@ list_lru_from_memcg_idx(struct list_lru
 	return &lru->node[nid].lru;
 }
 
-static inline void lock_list_lru(struct list_lru_one *l, bool irq)
-{
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
-}
-
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 		       struct mem_cgroup **memcg, bool irq, bool skip_empty)
@@ -136,10 +136,7 @@ lock_list_lru_of_memcg(struct list_lru *
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
+	lock_list_lru(l, irq);
 
 	return l;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


