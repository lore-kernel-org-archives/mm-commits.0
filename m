Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0041337699
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498618; cv=none; b=GMY8mTMoHKjhh0MMjaY5r/MGFI5QZXlnP1PEI5UJFzLDXvJR5CrZ+c+xE8XYU2s9y9KV6Gws/AjgDkqxU4V6wuFQaPNy0rNrXFoFdeOcFXsF2FSoxPy8hAXpsckBB4DBn9iIXcLx0b74miCFCYv+B0IiIJfsWFNZMLUVpoKHObc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498618; c=relaxed/simple;
	bh=IcL7ctVL+H7f1lB+HhI46fYLed365UvW1qMYT/Ap1Aw=;
	h=Date:To:From:Subject:Message-Id; b=qx6GAju3FOtBsY6exY9fGsfgVle/TFv531jzPiuJShuSWKTayr8lj3KrYqE1ober+/jCA6/w3l2Ti2MkYLDjw6C4fBwvkWrnlIz0lJ98XJNDu38lPw3dj8LcVG4K0hyLaEec5jr+rHZGfVSziiUXdrp2hMzTo56NO67yebYuqBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SobYbyRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SobYbyRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00F2C19424;
	Sat, 18 Apr 2026 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498618;
	bh=IcL7ctVL+H7f1lB+HhI46fYLed365UvW1qMYT/Ap1Aw=;
	h=Date:To:From:Subject:From;
	b=SobYbyRGW4huJjJX2Pep7+SIegD46qUCY1ZW3GpXkJyMLwTW4h8pa/nUKPJ9rkNcg
	 d4B73jRdBWSjQy4VgozOmzz7tgNm730SMrLjJR8iQwsn7UCNZtH7jChqJXbC4rqPT0
	 9nl3DT09Lo3mbUnQDDAU/rEwVCHnsjJiT2/Nomak=
Date: Sat, 18 Apr 2026 00:50:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-prepare-for-reparenting-mglru-folios.patch removed from -mm tree
Message-Id: <20260418075016.B00F2C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: prepare for reparenting MGLRU folios
has been removed from the -mm tree.  Its filename was
     mm-vmscan-prepare-for-reparenting-mglru-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: vmscan: prepare for reparenting MGLRU folios
Date: Thu, 5 Mar 2026 19:52:44 +0800

Similar to traditional LRU folios, in order to solve the dying memcg
problem, we also need to reparenting MGLRU folios to the parent memcg when
memcg offline.

However, there are the following challenges:

1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
   number of generations of the parent and child memcg may be different,
   so we cannot simply transfer MGLRU folios in the child memcg to the
   parent memcg as we did for traditional LRU folios.
2. The generation information is stored in folio->flags, but we cannot
   traverse these folios while holding the lru lock, otherwise it may
   cause softlockup.
3. In walk_update_folio(), the gen of folio and corresponding lru size
   may be updated, but the folio is not immediately moved to the
   corresponding lru list. Therefore, there may be folios of different
   generations on an LRU list.
4. In lru_gen_del_folio(), the generation to which the folio belongs is
   found based on the generation information in folio->flags, and the
   corresponding LRU size will be updated. Therefore, we need to update
   the lru size correctly during reparenting, otherwise the lru size may
   be updated incorrectly in lru_gen_del_folio().

Finally, this patch chose a compromise method, which is to splice the lru
list in the child memcg to the lru list of the same generation in the
parent memcg during reparenting.  And in order to ensure that the parent
memcg has the same generation, we need to increase the generations in the
parent memcg to the MAX_NR_GENS before reparenting.

Of course, the same generation has different meanings in the parent and
child memcg, this will cause confusion in the hot and cold information of
folios.  But other than that, this method is simple enough, the lru size
is correct, and there is no need to consider some concurrency issues (such
as lru_gen_del_folio()).

To prepare for the above work, this commit implements the specific
functions, which will be used during reparenting.

[zhengqi.arch@bytedance.com: use list_splice_tail_init() to reparent child folios]
  Link: https://lore.kernel.org/20260324114937.28569-1-qi.zheng@linux.dev
Link: https://lore.kernel.org/e75050354cdbc42221a04f7cf133292b61105548.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Harry Yoo <harry.yoo@oracle.com>
Suggested-by: Imran Khan <imran.f.khan@oracle.com>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   17 ++++
 mm/vmscan.c            |  142 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 159 insertions(+)

--- a/include/linux/mmzone.h~mm-vmscan-prepare-for-reparenting-mglru-folios
+++ a/include/linux/mmzone.h
@@ -692,6 +692,9 @@ void lru_gen_online_memcg(struct mem_cgr
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
 void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
+void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
+bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
+void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
 
 #else /* !CONFIG_LRU_GEN */
 
@@ -733,6 +736,20 @@ static inline void lru_gen_soft_reclaim(
 {
 }
 
+static inline void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
+{
+}
+
+static inline bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
+{
+	return true;
+}
+
+static inline
+void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
+{
+}
+
 #endif /* CONFIG_LRU_GEN */
 
 struct lruvec {
--- a/mm/vmscan.c~mm-vmscan-prepare-for-reparenting-mglru-folios
+++ a/mm/vmscan.c
@@ -4426,6 +4426,148 @@ void lru_gen_soft_reclaim(struct mem_cgr
 		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
 }
 
+bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
+{
+	struct lruvec *lruvec = get_lruvec(memcg, nid);
+	int type;
+
+	for (type = 0; type < ANON_AND_FILE; type++) {
+		if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
+			return false;
+	}
+
+	return true;
+}
+
+static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
+				      struct lruvec *lruvec)
+{
+	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
+	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
+	int swappiness = mem_cgroup_swappiness(memcg);
+	DEFINE_MAX_SEQ(lruvec);
+	bool success = false;
+
+	/*
+	 * We are not iterating the mm_list here, updating mm_state->seq is just
+	 * to make mm walkers work properly.
+	 */
+	if (mm_state) {
+		spin_lock(&mm_list->lock);
+		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
+		if (max_seq > mm_state->seq) {
+			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
+			success = true;
+		}
+		spin_unlock(&mm_list->lock);
+	} else {
+		success = true;
+	}
+
+	if (success)
+		inc_max_seq(lruvec, max_seq, swappiness);
+}
+
+/*
+ * We need to ensure that the folios of child memcg can be reparented to the
+ * same gen of the parent memcg, so the gens of the parent memcg needed be
+ * incremented to the MAX_NR_GENS before reparenting.
+ */
+void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
+{
+	struct lruvec *lruvec = get_lruvec(memcg, nid);
+	int type;
+
+	for (type = 0; type < ANON_AND_FILE; type++) {
+		while (get_nr_gens(lruvec, type) < MAX_NR_GENS) {
+			try_to_inc_max_seq_nowalk(memcg, lruvec);
+			cond_resched();
+		}
+	}
+}
+
+/*
+ * Compared to traditional LRU, MGLRU faces the following challenges:
+ *
+ * 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
+ *    number of generations of the parent and child memcg may be different,
+ *    so we cannot simply transfer MGLRU folios in the child memcg to the
+ *    parent memcg as we did for traditional LRU folios.
+ * 2. The generation information is stored in folio->flags, but we cannot
+ *    traverse these folios while holding the lru lock, otherwise it may
+ *    cause softlockup.
+ * 3. In walk_update_folio(), the gen of folio and corresponding lru size
+ *    may be updated, but the folio is not immediately moved to the
+ *    corresponding lru list. Therefore, there may be folios of different
+ *    generations on an LRU list.
+ * 4. In lru_gen_del_folio(), the generation to which the folio belongs is
+ *    found based on the generation information in folio->flags, and the
+ *    corresponding LRU size will be updated. Therefore, we need to update
+ *    the lru size correctly during reparenting, otherwise the lru size may
+ *    be updated incorrectly in lru_gen_del_folio().
+ *
+ * Finally, we choose a compromise method, which is to splice the lru list in
+ * the child memcg to the lru list of the same generation in the parent memcg
+ * during reparenting.
+ *
+ * The same generation has different meanings in the parent and child memcg,
+ * so this compromise method will cause the LRU inversion problem. But as the
+ * system runs, this problem will be fixed automatically.
+ */
+static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
+				     int zone, int type)
+{
+	struct lru_gen_folio *child_lrugen, *parent_lrugen;
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
+	int i;
+
+	child_lrugen = &child_lruvec->lrugen;
+	parent_lrugen = &parent_lruvec->lrugen;
+
+	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
+		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
+		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
+		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
+		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
+
+		/* Assuming that child pages are colder than parent pages */
+		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
+				      &parent_lrugen->folios[gen][type][zone]);
+
+		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
+		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
+			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+
+		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
+			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
+			__update_lru_size(parent_lruvec, lru + parent_lru_active, zone, nr_pages);
+		}
+	}
+}
+
+void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
+{
+	struct lruvec *child_lruvec, *parent_lruvec;
+	int type, zid;
+	struct zone *zone;
+	enum lru_list lru;
+
+	child_lruvec = get_lruvec(memcg, nid);
+	parent_lruvec = get_lruvec(parent, nid);
+
+	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1)
+		for (type = 0; type < ANON_AND_FILE; type++)
+			__lru_gen_reparent_memcg(child_lruvec, parent_lruvec, zid, type);
+
+	for_each_lru(lru) {
+		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
+			unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
+
+			mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+		}
+	}
+}
+
 #endif /* CONFIG_MEMCG */
 
 /******************************************************************************
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


