Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795638953;
	b=BxjU1t1dLskoTriXwzGJ0+ZMOy26ubM3yVoh1/LR2yYd2q6A2YRTZHbD0ECuqBm6ap3t
	 +lxLyNiFtDH3rsXKFjNwUQN7rI520w8JAX5BvLNJA6etqVvlAeTMGFahPhRwfnWMRdAet
	 IdfML3sm9yrJdR98MBtsu96CaxE9b1Ln8fz/FrT68ZoPUbvFGCtTYiWfM0CD7qMe73CGc
	 tNZe1Yn21VeKyDI5ivDfqznCUxj02EPgeqh3eTC7aAXJCNL0VjtW+yhqd5yRVucVOriKz
	 U1aeKu2KRWulkRkBPVxg1Y6B0NJ0jCuD3mvr2Y3lvBuSezi9aMwjKE37lZIaWHTpWYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795638953;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=KS18A412k97Uw8YUOJnxzuJ9uuzhw8FHZo2+irVLrB4=;
	b=O82SrC1DzBDQiL2Boa1+JwTBjCE3Iw5itX1aBsHuQ4MRDIOyuQD2SLS3/EEa82xCCRhX
	 heiTw1kcNvEgBwTL1FLwbJFpR8IXP6ofaRmQ5y+6xVR7zRhyyuULoKTU9Alq0KCh3FNU6
	 iZ6j7+A0/2Fa045+W4Y6v9jV+u/3xGfFLImLEEJD2zeb6QDLZGiLN//CgcEQ2NBkaMk4t
	 wM4hP67Prl1/S1RFdw8zWcD4znV7QFdj+M6dVO33sRwL/mjVmYv/KaIWiRBePcSjlrWkT
	 jcsZQ0zgrLBFiwsC6sCz6mmrYn/3UsZEhp+vvqjjz++dC9ffazwJOffwLZ2kXlcbtew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rmKQ1MLb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C166606A326
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 20:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rmKQ1MLb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6EB1F000C0;
	Wed, 25 Nov 2026 20:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795638953;
	bh=KS18A412k97Uw8YUOJnxzuJ9uuzhw8FHZo2+irVLrB4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=rmKQ1MLbZbzCOf7aUvxWzpOLtEVs+Nt67IpxJr8UP/UNVTEdKLPKaKk9gXuVFDmf5
	 U/CiJJ5BQH2iqZMixvmQ852Fk99P+ya/BKBUN6QztwtkxpES5vrLRXYFq18V5RC2aU
	 c4+NJdSAoLZBqK5o+/xDHb2+y2udYMngHMEndpeY=
Date: Wed, 25 Nov 2026 12:35:52 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
Subject: [to-be-updated] mm-memcontrol-avoid-potential-counter-leak-when-reparenting-local-stats.patch removed from -mm tree
Message-Id: <20261125203552.EC6EB1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/memcontrol: avoid potential counter leak when reparenting local stats
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-avoid-potential-counter-leak-when-reparenting-local-stats.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/memcontrol: avoid potential counter leak when reparenting local stats
Date: Tue, 24 Nov 2026 02:52:55 +0800

lruvec_page_state_local() clamps negative values to zero on SMP.  That
is right for readers reporting page counts, but can be wrong for
reparenting once MGLRU updates the counters without the lruvec lock.

Reparenting runs after the forced stats flush, so a negative is a real
balance that has to move to the parent, not be discarded. We will
introduce lockless MGLRU promotion which may cause following problem:

 1. A refs CAS on a folio on the child's lruvec moves it from
    inactive to active, and its active/inactive counter update follows
    as a separate step.

 2. A concurrent isolation of the folio reads the folio as active,
    debits the child's NR_ACTIVE_* by delta before CSS_DYING is visible
    to it.

 3. The child is killed, and the two __update_lru_size() calls from
    step 1 land on the parent: NR_INACTIVE_* -delta, then NR_ACTIVE_*
    +delta.

The child is left with NR_ACTIVE_* -delta while the parent holds the
matching +delta, and reparenting the child's raw value is what cancels
the parent's credit.  However, if the child happens to hold few enough
folios for that counter to be negative, lruvec_page_state_local() clamps
the child's negative to zero, which drops the debit instead, so the
parent keeps NR_ACTIVE_* overcounted by delta, and its active + inactive
total overcounted as well, permanently: the child's local counters are
gone once reparenting is done.

So use a raw signed helper and reparent with that.  Ordinary readers
still keep the clamp.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
Closes: https://lore.kernel.org/linux-mm/CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com/
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Xiang Liu <liuxiang.277@bytedance.com>
Cc: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: Tianyi Chen <hi@tychen.cc>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Harry Yoo <harry@kernel.org>

 mm/memcontrol.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-avoid-potential-counter-leak-when-reparenting-local-stats
+++ a/mm/memcontrol.c
@@ -562,11 +562,10 @@ unsigned long lruvec_page_state_monotoni
 	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
 }
 
-unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
+static long __lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
 	const struct mem_cgroup_per_node *pn;
-	long x;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -577,7 +576,14 @@ unsigned long lruvec_page_state_local(co
 		return 0;
 
 	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
+	return READ_ONCE(pn->lruvec_stats->state_local[i]);
+}
+
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
+				      enum node_stat_item idx)
+{
+	long x = __lruvec_page_state_local(lruvec, idx);
+
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -595,7 +601,8 @@ void reparent_memcg_lruvec_state_local(s
 
 	for_each_node(nid) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-		unsigned long value = lruvec_page_state_local(lruvec, idx);
+		/* Reparent the raw value: the clamp drops the child's debit. */
+		long value = __lruvec_page_state_local(lruvec, idx);
 
 		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
 		__mod_memcg_lruvec_state(parent, nid, idx, value);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch
mm-mglru-make-generation-page-counters-atomic.patch
mm-memcg-add-folio-based-lruvec-live-helper.patch
mm-mglru-frequency-guided-workingset-promotion-mglru-fg.patch
mm-mglru-make-folio-lru-referenced-times-count-a-generic-api.patch
mm-mglru-move-add-del-lru-size-accounting-out-of-lru_gen_update_size.patch
mm-mglru-gup-mark-folios-referenced-via-a-fast-helper.patch
mm-mglru-smaps-convert-to-lru-refs-based-operations-for-mglru.patch
mm-damon-convert-to-lru-refs-based-operations-for-mglru.patch
mm-khugepaged-convert-to-lru-refs-based-operations-for-mglru.patch
mm-madvise-adapt-for-lru-refs-based-operations-for-mglru.patch
mm-huge_memory-mark-folio-as-accessed-more-accurately-on-split.patch
mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch
mm-mglru-folio-lru-refs-based-active-inactive-number-accounting.patch
mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

