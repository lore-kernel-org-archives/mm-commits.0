Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832256;
	b=ODgzq7QfOnrRd6QTH6h9uD/c1D5vwVb5bFQpwCRUL/KPLeIFpNjz+Q+/PEGFoljIT54K
	 85vmm1IP978+hS/liD9lJY3D/yfT2QiZR8S2/rUVnqrJ+5LX6mIWm/pMCU4KhuRY0nAVT
	 spOv/CC618z08q/mlyufAMOdYrk8NfC8q1tqtwzvpfVzviz3jFhMmc6RD7y0Ckg8FqecS
	 88JrE1bNVZNQ6fnbB/XZrIon1yxQSd82RXNlSK1IHUdm9Nt/fLQ7aZvbUjs+7CioerDDx
	 BoxgLM1NLvLn25Emv3jQDSx27OTD8GrxGqw+TkAut5zF+agKDL0IWM3mBAhtTLM8tZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832256;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=wyHOOXNsQIpoAGcd5xEBpHK2bl1HlwN1EcZL2h5w9aU=;
	b=ieJB6uC6Lol8M8lZvQ7EM4FsoTRmUKVhN1WrtZD87HMbb7JWEG8tRT+3/BjeLlhZVphA
	 OQSoUQ9uySo8/UOf3D1guIc9/OiVImvMSM1N2RZdJof4BYG0c300pwTD7+0ThtSxH6ajl
	 wx9JwS5SUZBPGDmiWfKJWhXFybwth/Av5L+cQ7p7iGrqAAqDveOCWZA3hSXNzjVUo2Ery
	 zg66I1+njOruWF8LYZuNaT2yaEAvo5fzGaI3ZsCZSOxS/ogHrECTyIampbLU3jTfVVc5G
	 NPzKC8l86W4vLVSng6mTIKKzxth/ZXxK0+LMYZzlHJ879kd7RDX0hxx5c/Jn5Az9+Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=S4Kw+QA6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891D8606A31D;
	Sat, 24 Oct 2026 08:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=S4Kw+QA6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AF41F01825;
	Sat, 24 Oct 2026 08:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832256;
	bh=wyHOOXNsQIpoAGcd5xEBpHK2bl1HlwN1EcZL2h5w9aU=;
	h=Date:To:From:Subject;
	b=S4Kw+QA6bZmPARUE2hsXUMewvbvt29tYz6KRrSYyNC2yIXFnkAhDHr9nQyICdBKXL
	 rOC49vBm63cNxhSMMrS70hQZxrsRXR9rnnYDvhXnJfPwdZEthvz2nPY+1ZJ92Eoolw
	 FjNhk5kKG3+bSYADWdVCbGvYTST0po6TuDfzl0XU=
Date: Sat, 24 Oct 2026 01:57:35 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,david@kernel.org,chris@chrisdown.name,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch removed from -mm tree
Message-Id: <20261024085736.22AF41F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat
Date: Wed, 23 Sep 2026 10:05:15 +0800

Patch series "mm: fix hugetlb NR_HUGETLB accounting on folio migration", v2.

The hugeTLB counters added by 05d4532b60e3 ("memcg/hugetlb: add hugeTLB
counters to memcg") are maintained in two per-node places:
  - the per-node vmstat counter NR_HUGETLB, exposed as nr_hugetlb in
    /proc/vmstat;
  - the per-node memcg lruvec stat, exposed via memory.numa_stat.

Both are accounted against the folio's node, and both drift when a hugetlb
folio is migrated, though in different ways.

A migration target folio is allocated by alloc_hugetlb_folio_nodemask()
and inherits the old folio's state without ever being accounted, while the
old folio is freed right after and its free is accounted.  That alone
loses vmstat accounting: the target node has no matching increment for the
decrement on the old node, so /proc/vmstat's nr_hugetlb shrinks by
nr_pages per migration.  Patch 1 accounts the folio where it is obtained,
so the increment pairs with the free in free_huge_folio() on the
successful as well as the failed migration path.  The memfd page cache
preallocation helper has the same asymmetry and is fixed in the same
patch.

The per-node lruvec stat breaks differently.  mem_cgroup_migrate() moves
the charge to the new folio and drops the old folio's memcg data, so the
old folio's free right after migration skips the memcg per-node decrement;
the count stays attributed to the old node for the rest of the charge's
life, and the target folio never gets an increment on its new node.  Patch
2 moves that per-node accounting along with the charge, in
move_hugetlb_state().


This patch (of 2):

The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
when a huge page is handed to a user via hugetlb_alloc_folio() and
decremented when it is returned to the pool via free_huge_folio().

A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
hugetlb_alloc_folio(), so it is never accounted, while its free always is.
For a migration target this means the target node gets no matching
increment for the decrement on the old node, so the global nr_hugetlb in
/proc/vmstat drops by nr_pages for each migration.  The same asymmetry
affects the failed migration path, which frees the target again right
away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
same helper.

alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
folios, has the same asymmetry: the folio is handed to a user without
being accounted, while its free is accounted through free_huge_folio().

Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
decrement in free_huge_folio(): a successful migration hands the folio to
a user, a failed one frees it again.

Link: https://lore.kernel.org/20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn
Link: https://lore.kernel.org/20260923-for-hugetlb_state3-v2-1-e8a36245bfab@kylinos.cn
Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat
+++ a/mm/hugetlb.c
@@ -2206,6 +2206,11 @@ struct folio *alloc_hugetlb_folio_reserv
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
+
+	if (folio)
+		lruvec_stat_mod_folio(folio, NR_HUGETLB,
+				      folio_nr_pages(folio));
+
 	return folio;
 }
 
@@ -2213,24 +2218,30 @@ struct folio *alloc_hugetlb_folio_reserv
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback)
 {
-	spin_lock_irq(&hugetlb_lock);
-	if (available_huge_pages(h)) {
-		struct folio *folio;
+	struct folio *folio = NULL;
 
+	spin_lock_irq(&hugetlb_lock);
+	if (available_huge_pages(h))
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 						preferred_nid, nmask);
-		if (folio) {
-			spin_unlock_irq(&hugetlb_lock);
-			return folio;
-		}
-	}
 	spin_unlock_irq(&hugetlb_lock);
 
-	/* We cannot fallback to other nodes, as we could break the per-node pool. */
-	if (!allow_alloc_fallback)
-		gfp_mask |= __GFP_THISNODE;
+	if (!folio) {
+		/*
+		 * We cannot fallback to other nodes, as we could break the
+		 * per-node pool.
+		 */
+		if (!allow_alloc_fallback)
+			gfp_mask |= __GFP_THISNODE;
 
-	return alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid, nmask);
+		folio = alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid,
+						    nmask);
+	}
+
+	if (folio)
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
+
+	return folio;
 }
 
 static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are


