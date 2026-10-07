Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DFB32AAA8
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334375; cv=none; b=g8pqcynmkFG+wTe4VaBJcXHPEs7DM101nKy1no6upDsglwoKFVIWQQ2q0JDQub6/pmsyxdop/9LWrxcErjwslfmlYVfQ048VPzv/B8KAY0C8vOEevIcebAvH183waR7MS27DWz/O99Zc/eE3nTkPA+cZ3HcJlpf7QkkhTLfKeOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334375; c=relaxed/simple;
	bh=qD5ShDSppRyHWkCUGdB54GkTtC7zz7Z6X9XmDuXBzZE=;
	h=Date:To:From:Subject:Message-Id; b=Wg/U5AeP8DRaWQtAGSTFTgA5k4d75EcmGQWN2f5QhpMx68pH/WHWhesPGqsak64p8YM1EIrfV6kvukJGQ5roXhdrk6RYQ4ZV6gzTn1RhXSgYTaEzkWbCtEW5z4OWaE0wH6ThDhdjkeTXYl76vRzPxxahAilk2ZGV5BFKOGmfrq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZzzkJ3+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZzzkJ3+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A6E1F0089C;
	Wed,  7 Oct 2026 00:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334374;
	bh=t6FRYTI1KdpnHWCZtLxZlpG3p6Mw+UJrAe7p54VkgCY=;
	h=Date:To:From:Subject;
	b=ZzzkJ3+6IfwcLY1Or9St4DhC/U3W1qxadz/Cpdreoz7fA7CP2PilN+mTh726THsPB
	 CeTlkmfcKUGjZAEjnBViCeAoE52tjetiiDn6/jHIWrLfrLSUWGbu9NQbTFP4Dwo3i7
	 E7S/y/HizP0ceIDXity+MhUtU8DGtLdD6O0UgnZw=
Date: Tue, 06 Oct 2026 17:52:53 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch removed from -mm tree
Message-Id: <20261007005253.F1A6E1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
has been removed from the -mm tree.  Its filename was
     mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
Date: Wed, 2 Sep 2026 07:24:20 +0800

For reclamation, it makes sense to reclaim folios from tail to head, as
folios near the head are relatively hot.  However, when moving folios from
the oldest generation to the second-oldest generation, using the
tail-to-head order would effectively cause a cold/hot inversion.

The impact of the added prefetching might be arch-dependent.  Some
architectures could benefit more from prefetching, while others might
see little to no impact.  In my x86 test, it shows a very slight
improvement:


***** no-prefetch:

agetest:
...
gen 100:  2.421 ms
gen 101:  2.424 ms
gen 102:  2.420 ms
gen 103:  2.413 ms

Total: 248.418 ms
Average: 2.460 ms

agetest:
...
gen 100:  2.393 ms
gen 101:  2.396 ms
gen 102:  2.395 ms
gen 103:  2.392 ms

Total: 245.627 ms
Average: 2.432 ms

agetest:
...
gen 100:  2.433 ms
gen 101:  2.427 ms
gen 102:  2.432 ms
gen 103:  2.450 ms

Total: 249.186 ms
Average: 2.467 ms

**** has-prefetch:

agetest:
....
gen 100:  2.314 ms
gen 101:  2.310 ms
gen 102:  2.321 ms
gen 103:  2.303 ms

Total: 237.619 ms
Average: 2.353 ms

agetest:
gen 100:  2.342 ms
gen 101:  2.343 ms
gen 102:  2.339 ms
gen 103:  2.335 ms

Total: 239.929 ms
Average: 2.376 ms

agetest:

gen 100:  2.344 ms
gen 101:  2.347 ms
gen 102:  2.352 ms
gen 103:  2.348 ms

Total: 241.188 ms
Average: 2.388 ms

Basically, its 2.3xx vs. 2.4xx, lower is better.

Link: https://lore.kernel.org/20260901232421.40157-7-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail
+++ a/mm/vmscan.c
@@ -192,11 +192,27 @@ static inline void prefetchw_prev_lru_fo
 		prefetchw(&prev->flags);
 	}
 }
+
+static inline void prefetchw_next_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+	if (folio->lru.next != base) {
+		struct folio *next;
+
+		next = list_entry(folio->lru.next, struct folio, lru);
+		prefetchw(&next->flags);
+	}
+}
 #else
 static inline void prefetchw_prev_lru_folio(struct folio *folio,
 		struct list_head *base)
 {
 }
+
+static inline void prefetchw_next_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+}
 #endif
 
 /*
@@ -3943,10 +3959,11 @@ static bool inc_min_seq(struct lruvec *l
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
+		struct list_head *pos = head->next;
 		long delta = 0;
 
-		while (!list_empty(head)) {
-			struct folio *folio = lru_to_folio(head);
+		while (pos != head) {
+			struct folio *folio = list_entry(pos, struct folio, lru);
 			long nr_pages = folio_nr_pages(folio);
 			int refs = folio_lru_refs(folio);
 			bool workingset = folio_test_workingset(folio);
@@ -3957,6 +3974,8 @@ static bool inc_min_seq(struct lruvec *l
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
+			prefetchw_next_lru_folio(folio, head);
+			pos = pos->next;
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			/*
 			 * If gen_increased is false, this is a promotion. Put folios
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch

