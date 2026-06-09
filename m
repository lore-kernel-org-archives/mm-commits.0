Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B811DE8BB
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968132; cv=none; b=qu4wJDNCPRkdzWoQB7kmhXfje7iejyA1OtLtXgKNa7OG2YknfJHnMM1EfMZ8N0a1k64jnzOP6lon1cCK/Y1hd+vGDySwDnvpHZXnThlADo4IFTYAFNI/2s5GUN8ou7XTPZaqZ41AKO7a0ngPJ4vt6z7ptJeLy0WfYjcBw3Iibu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968132; c=relaxed/simple;
	bh=yovpaxY2jfdhfYJ5CtcgTRSgIiin0WKZ9I2dKOmDBhU=;
	h=Date:To:From:Subject:Message-Id; b=dJmscFKqfE9iyJr2sEcXfLEV4/Hs/qCdlLMhAxoR41ZQ4Vfr4M76OZ3NupGMLP0Fehrf+RBuWEE0mFt7LhBYNfl6IrgvWR+pfciDrvDfUP0riUoFwEq4LJCjAix5CIcmbdupoHocNLu+7W3vF/POd3cCocqe4b2kfrB3yg2Ncv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VM9olajj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VM9olajj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06571F00893;
	Tue,  9 Jun 2026 01:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968131;
	bh=MQ+qBz6coMdIMt7CrtRV4r3/HGsdiN1g2F3C575IwMw=;
	h=Date:To:From:Subject;
	b=VM9olajjaqrpmtBaSWzEunwPxY1oqrolEHyPSe820q8dIO92Nw8jDKkIKC3VCQdko
	 hbTH0yS5Cbozh6ArhNHBA3Z3dza2GEU01XfjfoNuPDxkRgAZp24AffDVEr3X1IzLEV
	 s1vH/RWSRhprQL/YqY6+bOhMoosp+YpPhKEOJMIg=
Date: Mon, 08 Jun 2026 18:22:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch removed from -mm tree
Message-Id: <20260609012211.A06571F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: move list dead check to lock_list_lru_of_memcg()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: move list dead check to lock_list_lru_of_memcg()
Date: Wed, 27 May 2026 16:45:11 -0400

Only the MEMCG variant of lock_list_lru() needs to check if there is a
race with cgroup deletion and list reparenting.  Move the check to the
caller, so that the next patch can unify the lock_list_lru() variants.

Link: https://lore.kernel.org/20260527204757.2544958-5-hannes@cmpxchg.org
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

 mm/list_lru.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg
+++ a/mm/list_lru.c
@@ -68,17 +68,12 @@ list_lru_from_memcg_idx(struct list_lru
 	return &lru->node[nid].lru;
 }
 
-static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
 {
 	if (irq)
 		spin_lock_irq(&l->lock);
 	else
 		spin_lock(&l->lock);
-	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
-		unlock_list_lru(l, irq);
-		return false;
-	}
-	return true;
 }
 
 static inline struct list_lru_one *
@@ -90,9 +85,13 @@ lock_list_lru_of_memcg(struct list_lru *
 	rcu_read_lock();
 again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
-	if (likely(l) && lock_list_lru(l, irq)) {
-		rcu_read_unlock();
-		return l;
+	if (likely(l)) {
+		lock_list_lru(l, irq);
+		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
+			rcu_read_unlock();
+			return l;
+		}
+		unlock_list_lru(l, irq);
 	}
 	/*
 	 * Caller may simply bail out if raced with reparenting or
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


