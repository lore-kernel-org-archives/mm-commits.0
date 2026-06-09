Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9991DE8BB
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968129; cv=none; b=eG5pa8ER8cy9RTTS9C1n4ry7K/4ahC/Yeo47P4chsSsGP8LigYwO5AbNEwpFNpIkaYKbA7E2TxIhjHVzjwvHRi+YeTLX3Zd1gKT62HvqS3B9bEqvLnmoCTi3R8LwrP/gOnk/i4TdqdX7E1JGEkAGkFrSJM4D5b7zKsq7IFYss0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968129; c=relaxed/simple;
	bh=tvV0IIKOg95BYzfnfWIoLz5PK0GGl7yHR8/el0UkJ+g=;
	h=Date:To:From:Subject:Message-Id; b=mbzIdkYIuchvJtAlVgkNJDxA4TAmKt0Vq9e4Dxu2LVs+SbhvhA5CaJcxcf69iMg3zV0c6k17EI46i2Rnc2Xdw8iblCTMqUXnihx1NnhgfZQhqXLI2jlg5Q2+RtW+KREE+73LhniLk5M7AAOZtpiIcfhNzSSnXf0t1ElMjia+D78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ys6JFr7B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ys6JFr7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6061F00893;
	Tue,  9 Jun 2026 01:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968128;
	bh=ILbNTDTeqkaPDv0Vw+1wPdnT2iIawcRm/mLxTTRDxbs=;
	h=Date:To:From:Subject;
	b=Ys6JFr7BPsQvyMXp++B39ROFooVqbsyD2e/2VmX9yv/AueI3DQT4lmVyoi6zDa3E4
	 zb7iBWxFiXr1Puq3LNkTBMQYR1s0gmDx54l79AsR7Qz+sv2KyAg+xmhBZjYHSg/aFz
	 WiSG0V+chyovTZqbZrhyu9ApjDxt/XMN+Z102c/s=
Date: Mon, 08 Jun 2026 18:22:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch removed from -mm tree
Message-Id: <20260609012208.3C6061F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: lock_list_lru_of_memcg() cannot return NULL if !skip_empty
has been removed from the -mm tree.  Its filename was
     mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: lock_list_lru_of_memcg() cannot return NULL if !skip_empty
Date: Wed, 27 May 2026 16:45:09 -0400

skip_empty is only for the shrinker to abort and skip a list that's empty
or whose cgroup is being deleted.

For list additions and deletions, the cgroup hierarchy is walked upwards
until a valid list_lru head is found, or it will fall back to the node
list.  Acquiring the lock won't fail.  Remove the NULL checks in those
callers.

Link: https://lore.kernel.org/20260527204757.2544958-3-hannes@cmpxchg.org
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

 mm/list_lru.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty
+++ a/mm/list_lru.c
@@ -165,8 +165,6 @@ bool list_lru_add(struct list_lru *lru,
 	struct list_lru_one *l;
 
 	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
-	if (!l)
-		return false;
 	if (list_empty(item)) {
 		list_add_tail(item, &l->list);
 		/*
@@ -208,9 +206,8 @@ bool list_lru_del(struct list_lru *lru,
 {
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
+
 	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
-	if (!l)
-		return false;
 	if (!list_empty(item)) {
 		list_del_init(item);
 		l->nr_items--;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


