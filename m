Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644441;
	b=ZOp/OfpW0szlinuA1jywwsSmY9h4RmEmEnnFvH2IY4RYCnlGEIUwrry5S/RdnOYaVgds
	 5aZtP/LQ6ITboqKWtypktpk7p8DzXc8fkAFSBQoolWq4ONdH71vi9MUtaUDxRCX2Jvs4u
	 0xTsTIr2GNQ79r1QloVAYqhBa0zjrxrh5IqMJHNUke8ClmbUkx1QPqsES1HN2xbsteagf
	 ylA8iaZKsPAtCUGwRTMwkwRsjGy3Ehw9YZ021gOPBXJSG55VCcJdBzqR1nPCmUc4qbaX5
	 MVEgY65KcontcSmN/htpHZnjNfYH6buoIf5286Mz1Dq1IMdmWtEtbHrjNItqg/MHx+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644441;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=i+Bm6lviHlJCNRWde1Jz9M4JovGj3BM/tRWmayqfI74=;
	b=sTBmswI/WY/BDwR5xztTcCteck/fM9RY5uk1DS47sfE4MPx4Pv56YkIRrVChNic8L8RV
	 I2YgaSynMSsj9bsrBnETa+aavMMLPKvDnuEpSeXwGe5aIh2ph3o866YC4kIT143c2/zVe
	 Bz1ruze4vYqkMsHxL7X/04+eFMzirDh91lB6LKO7IOEGWpLYCBZ4qosFTjs8NcJ237u/S
	 Yy2N0MEBRGS2tpU5M96fGewHyT8QxhMWpY5zBugzDZjMjYqtby3nH6khJOvSZJyMjHbM9
	 83KpxgxgzehkGSSeE26xu1GbnMX3Vxd8QP18xbYNOaNmgWn8SCRRhisHPUkFnvNigsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lVTV0bmc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317B1606A32C
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 18:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lVTV0bmc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976311F00A16;
	Mon,  2 Nov 2026 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793644440;
	bh=i+Bm6lviHlJCNRWde1Jz9M4JovGj3BM/tRWmayqfI74=;
	h=Date:To:From:Subject;
	b=lVTV0bmckltoh1zvZJG4HirUXKkWOfr4HEEsmQmByUInVKRWWXmh0nlPd6PThR8KV
	 vZSQ7Bli4ThsvpoFqpnxlAxvhub9aJnsJNOQU6gDjzTOvksEoaDZz/2QvH9sxjF73B
	 DEtH0mM3l/tnM97F0RqXBYVq+I+EDTQur/T3ryPg=
Date: Mon, 02 Nov 2026 10:34:00 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,
	shakeel.butt@linux.dev,ryncsn@gmail.com,rppt@kernel.org,
	roman.gushchin@linux.dev,rdunlap@infradead.org,qi.zheng@linux.dev,
	muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,corbet@lwn.net,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	balbirs@nvidia.com,axelrasmussen@google.com,tjmercier@google.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-stop-rotating-offlined-memcgs-to-the-old-generation.patch added to mm-new branch
Message-Id: <20261102183400.976311F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: stop rotating offlined memcgs to the old generation
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-stop-rotating-offlined-memcgs-to-the-old-generation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-stop-rotating-offlined-memcgs-to-the-old-generation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "T.J. Mercier" <tjmercier@google.com>
Subject: mm/mglru: stop rotating offlined memcgs to the old generation
Date: Tue, 27 Oct 2026 18:06:06 -0700

lru_gen_offline_memcg() moves an offlining memcg to the head of the old
generation of the memcg LRU (MEMCG_LRU_OLD), so that global reclaim
visits it first and evicts the folios it left behind.

Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
dying memory cgroup for LRU folios"), those folios are reparented to the
parent before lru_gen_offline_memcg() runs, and nothing can be added
back to the offlined memcg's lruvec afterwards. Putting an empty
offlined memcg at the head of the old generation no longer serves any
purpose and only delays reclaim from the memcgs that still have memory
due to additional shrink_many() iteration.

Remove lru_gen_offline_memcg(), so that an offlined memcg is rotated
like any other memcg below the reclaimable size threshold until
lru_gen_release_memcg() takes it off the memcg LRU. MEMCG_LRU_OLD has no
other user, so remove the op and update the memcg LRU comment as well.

Link: https://lore.kernel.org/20261028010611.3929937-3-tjmercier@google.com
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>
---

 Documentation/mm/multigen_lru.rst |    4 +---
 include/linux/mmzone.h            |   14 +++-----------
 mm/memcontrol.c                   |    1 -
 mm/vmscan.c                       |   20 +-------------------
 4 files changed, 5 insertions(+), 34 deletions(-)

--- a/Documentation/mm/multigen_lru.rst~mm-mglru-stop-rotating-offlined-memcgs-to-the-old-generation
+++ a/Documentation/mm/multigen_lru.rst
@@ -234,9 +234,7 @@ the active/inactive LRU (of folios):
 1. It has the young and the old (generations), i.e., the counterparts
    to the active and the inactive;
 2. The increment of ``max_seq`` triggers promotion, i.e., the
-   counterpart to activation;
-3. Other events trigger similar operations, e.g., offlining an memcg
-   triggers demotion, i.e., the counterpart to deactivation.
+   counterpart to activation.
 
 In terms of global reclaim, it has two distinct features:
 
--- a/include/linux/mmzone.h~mm-mglru-stop-rotating-offlined-memcgs-to-the-old-generation
+++ a/include/linux/mmzone.h
@@ -626,12 +626,10 @@ struct lru_gen_mm_walk {
  * per-node memcg generation counter, whose reminder (mod MEMCG_NR_GENS) indexes
  * the old generation, is incremented when all its bins become empty.
  *
- * There are three operations:
+ * There are two operations:
  * 1. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
  *    current generation (old or young) and updates its "seg" to "tail";
- * 2. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
- *    generation, updates its "gen" to "old" and resets its "seg" to "default";
- * 3. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
+ * 2. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
  *    young generation, updates its "gen" to "young" and resets its "seg" to
  *    "default".
  *
@@ -643,8 +641,7 @@ struct lru_gen_mm_walk {
  * 3. The second attempt to reclaim a memcg below reclaimable size threshold,
  *    which triggers MEMCG_LRU_YOUNG;
  * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
- * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
- * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
+ * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG.
  *
  * Notes:
  * 1. Memcg LRU only applies to global reclaim, and the round-robin incrementing
@@ -675,7 +672,6 @@ bool lru_gen_look_around(struct page_vma
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
 void lru_gen_online_memcg(struct mem_cgroup *memcg);
-void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
 void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
@@ -709,10 +705,6 @@ static inline void lru_gen_online_memcg(
 {
 }
 
-static inline void lru_gen_offline_memcg(struct mem_cgroup *memcg)
-{
-}
-
 static inline void lru_gen_release_memcg(struct mem_cgroup *memcg)
 {
 }
--- a/mm/memcontrol.c~mm-mglru-stop-rotating-offlined-memcgs-to-the-old-generation
+++ a/mm/memcontrol.c
@@ -4503,7 +4503,6 @@ static void mem_cgroup_css_offline(struc
 	memcg_reparent_objcgs(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
-	lru_gen_offline_memcg(memcg);
 
 	drain_all_stock(memcg);
 
--- a/mm/vmscan.c~mm-mglru-stop-rotating-offlined-memcgs-to-the-old-generation
+++ a/mm/vmscan.c
@@ -4519,7 +4519,6 @@ bool lru_gen_look_around(struct page_vma
 enum {
 	MEMCG_LRU_NOP,
 	MEMCG_LRU_TAIL,
-	MEMCG_LRU_OLD,
 	MEMCG_LRU_YOUNG,
 };
 
@@ -4541,8 +4540,6 @@ static void lru_gen_rotate_memcg(struct
 	/* see the comment on MEMCG_NR_GENS */
 	if (op == MEMCG_LRU_TAIL)
 		seg = MEMCG_LRU_TAIL;
-	else if (op == MEMCG_LRU_OLD)
-		new = get_memcg_gen(pgdat->memcg_lru.seq);
 	else if (op == MEMCG_LRU_YOUNG)
 		new = get_memcg_gen(pgdat->memcg_lru.seq + 1);
 	else
@@ -4552,11 +4549,7 @@ static void lru_gen_rotate_memcg(struct
 	WRITE_ONCE(lruvec->lrugen.gen, new);
 
 	hlist_nulls_del_rcu(&lruvec->lrugen.list);
-
-	if (op == MEMCG_LRU_OLD)
-		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
-	else
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
+	hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
 
 	pgdat->memcg_lru.nr_memcgs[old]--;
 	pgdat->memcg_lru.nr_memcgs[new]++;
@@ -4594,17 +4587,6 @@ void lru_gen_online_memcg(struct mem_cgr
 	}
 }
 
-void lru_gen_offline_memcg(struct mem_cgroup *memcg)
-{
-	int nid;
-
-	for_each_node(nid) {
-		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-
-		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_OLD);
-	}
-}
-
 void lru_gen_release_memcg(struct mem_cgroup *memcg)
 {
 	int gen;
_

Patches currently in -mm which might be from tjmercier@google.com are

mm-memcontrol-fix-null-pointer-deref-and-uaf-from-high_work_func-on-dying-memcg.patch
mm-vmscan-remove-redundant-mem_cgroup_online-checks.patch
mm-mglru-stop-rotating-offlined-memcgs-to-the-old-generation.patch

