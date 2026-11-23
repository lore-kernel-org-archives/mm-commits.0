Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795465429;
	b=FU37VRMVcxK9kk8nrtjAXQd9VVS8MzDvX3WE0/FjvwQkQx2M2VHZUpsMe7xt+FgNdhRs
	 U/cfeWddlUtugTn8p/xzdqP8vrUoMlsGra9DNBwwz+2iDSwMYIssw68E84J5p0nRJEBt5
	 hLPbU4pSWW8onRSQbAdEz3Gwqf+WRCu1QC32bcY+5juD1xbIqqeRcESTs+GWuX806bTya
	 YXTVxubKMKwKF2Ee6kwUz0aCELS7sgi4e1OZXegfo/gOnvlO/xSdNyk2vkE2t0CyRTSlf
	 M0KZJeuSj4BYCVVL0m77JyM8Y+ObP6CDF31gLGUXMDs0mj3xYxGUzaMGitkKVud7qOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465429;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=jB+z3rBGWqSA7gq+yBMsT4KpGVkfTjmjj4FPIjJFzMI=;
	b=Fg6Pw9C6jIwgbviDF3SRb9qZt3egL15RNBxK0xvt0H1fcJplgwYbgdTW+NyPSaVNzzk4
	 a4JhLDQcJqOwRhXXwI/nZAqvrgqiWKVqjuno1tFsng4STGW55Lxclr8cxO4ZPfVpPlYas
	 u3BB9hYJXJnUQEwygybrKRRD39bNMyhJDuufQrPVneQSQoQt9/lp9NetU2HfXH7NWTgeK
	 VOLovCeGpl/Sch+lnquKIiUo94Zq3j21HhT/nMpSUIJjemEyxfsZ7DueNFV+QkeJB3W97
	 P2ogW32vEys4nJ9q5apZnB9fzIqM50K5aD/5ZvB6P5kFwP5G2X71XTDSjuhIiXgu5vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=g55NclCO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87912606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 20:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=g55NclCO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA81F1F000C0;
	Mon, 23 Nov 2026 20:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795465429;
	bh=jB+z3rBGWqSA7gq+yBMsT4KpGVkfTjmjj4FPIjJFzMI=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=g55NclCOSR9kfEMvtecpgK1A0P9LB4F9s+YfN/W9ebm258Sp6Vt7f1TCzBAG2Mp/d
	 621pnPbtVg9orwp5XFM1TohdJuFrAPoaKeM7dJeTK3T2Ri3I/cZcqXfdJmnq7Aqw5b
	 UwR9zghoHGdGzzxV/UxJINKRWz5Y3WYclqZSTas4=
Date: Mon, 23 Nov 2026 12:23:48 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-18-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-18-8ffea39934a6@tencent.com>
Subject: + mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch added to mm-new branch
Message-Id: <20261123202348.EA81F1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: make folio_inc_lru_refs lruvec lockless
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: make folio_inc_lru_refs lruvec lockless
Date: Tue, 24 Nov 2026 02:53:10 +0800

The lruvec spinlock in folio_inc_lru_refs was only taken to keep
concurrent aging from corrupting the size counters.  This is no
longer needed: the per-generation counters are atomic, and the
active/inactive ABI counters are updated per folio and linearized by
the CAS on the folio flags, so concurrent aging can no longer corrupt
them.  The same argument is what lets folio_reset_lru_refs() update
the counters without the lruvec lock.

Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
read lock around the lruvec lookup, and drop the spinlock entirely.

Without the lock, aging can advance max_seq while a promotion is in
flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
flags can return to the value read earlier and the cmpxchg succeeds
with a target gen computed from a stale max_seq.  Recheck max_seq after
a gen-changing cmpxchg: if it moved, account the committed update and
retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
The retry may count the access twice, which is acceptable and avoids
folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
orders the flags read, including the one returned by a failed
cmpxchg(), before the max_seq read.

Also simplify the post-CAS accounting guards: gen is only assigned
non-negative values after the old_gen < 0 early exit, so gen != old_gen
implies gen >= 0, and lru_gen_update_size() needs no explicit guard.
The active/inactive ABI update keeps its gen >= 0 check because an
off-LRU folio has no lruvec to update.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-18-8ffea39934a6@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
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

 include/linux/mm_inline.h |   10 +++----
 include/linux/mmzone.h    |    3 +-
 mm/vmscan.c               |   51 ++++++++++++++++++++++--------------
 3 files changed, 39 insertions(+), 25 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-make-folio_inc_lru_refs-lruvec-lockless
+++ a/include/linux/mm_inline.h
@@ -335,10 +335,9 @@ static inline bool lru_gen_is_old(struct
 	       gen == lru_gen_from_seq(min_seq + 1);
 }
 
-static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *folio,
-				       int old_gen, int new_gen)
+static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
+				       struct folio *folio, int old_gen, int new_gen)
 {
-	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -417,7 +416,7 @@ static inline bool __lru_gen_add_folio(s
 	/* use the refs from the atomic snapshot to avoid raced update */
 	refs = lru_get_refs_flags(flags);
 
-	lru_gen_update_size(lruvec, folio, -1, gen);
+	lru_gen_update_size(lruvec, type, folio, -1, gen);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, delta);
@@ -447,6 +446,7 @@ static inline bool lru_gen_del_folio(str
 	unsigned long flags;
 	unsigned int refs;
 	int gen;
+	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
@@ -470,7 +470,7 @@ static inline bool lru_gen_del_folio(str
 	if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
 		folio_set_active(folio);
 
-	lru_gen_update_size(lruvec, folio, gen, -1);
+	lru_gen_update_size(lruvec, type, folio, gen, -1);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, -delta);
--- a/include/linux/mmzone.h~mm-mglru-make-folio_inc_lru_refs-lruvec-lockless
+++ a/include/linux/mmzone.h
@@ -540,9 +540,10 @@ enum lruvec_flags {
 #define LRU_TIER_MIN		0U
 #define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
 
-/* Access source flags for folio_inc_lru_refs() */
+/* Flags for folio_inc_lru_refs() */
 #define LRU_REF_MAPPED		0x1U
 #define LRU_REF_EXEC		0x2U
+#define LRU_REF_FORCE		0x4U
 
 #define LRU_REFS_REFERENCED	0x1
 #define LRU_REFS_WORKINGSET	0x2
--- a/mm/vmscan.c~mm-mglru-make-folio_inc_lru_refs-lruvec-lockless
+++ a/mm/vmscan.c
@@ -876,37 +876,35 @@ void folio_inc_lru_refs(struct folio *fo
 	long nr_pages = folio_nr_pages(folio);
 	struct lru_gen_folio *lrugen;
 	struct lruvec *lruvec = NULL;
+	bool aged = false;
 
+retry:
 	old_flags = READ_ONCE(*folio_flags(folio, 0));
 	do {
 		new_flags = old_flags;
 		old_gen = lru_get_gen_flags(old_flags);
 		old_refs = lru_get_refs_flags(old_flags);
-		file = folio_flags_is_file_lru(&old_flags);
 		refs = old_refs + 1;
 		gen = old_gen;
+		file = folio_flags_is_file_lru(&old_flags);
 		if (old_gen < 0)
 			goto out;
-		/*
-		 * Lock the lruvec if the folio is on-list. We are already
-		 * doing lazy promotion so in theory we don't need this,
-		 * but for now, concurrent aging would still corrupt the
-		 * size counters.  This is a temporary limitation and
-		 * will be lifted very soon, so the lock here is not a
-		 * performance concern.
-		 */
 		if (!lruvec) {
-			lruvec = lruvec_live_lock_irq(folio_lruvec(folio));
+			lruvec = folio_lruvec_live_get(folio);
 			lrugen = &lruvec->lrugen;
 		}
+		/*
+		 * Read the flags before max_seq, paired with the store of a
+		 * gen, which samples max_seq first.
+		 */
+		smp_rmb();
 		max_seq = READ_ONCE(lrugen->max_seq);
 		max_gen = lru_gen_from_seq(max_seq);
 		if (old_gen == max_gen)
 			goto out;
-
-		if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
-			/* Promote second page table access or executable */
-			if (refs > LRU_REFS_REFERENCED || flags & LRU_REF_EXEC)
+		if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_FORCE)) {
+			if (lru_refs_is_workingset(refs) ||
+			    flags & (LRU_REF_EXEC | LRU_REF_FORCE))
 				gen = max_gen;
 			/* First access only defers eviction of an old generation */
 			else if (lru_gen_is_old(lruvec, file, old_gen))
@@ -931,9 +929,19 @@ out:
 			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
-	if (gen != old_gen)
-		lru_gen_update_size(lruvec, folio, old_gen, gen);
-	if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && old_gen >= 0) {
+	if (gen != old_gen) {
+		/*
+		 * Gen-index reuse can fool cmpxchg(). Retry locklessly, accepting
+		 * an extra reference to avoid folio_activate() latency.
+		 */
+		if (unlikely(READ_ONCE(lrugen->max_seq) != max_seq)) {
+			flags = LRU_REF_FORCE;
+			aged = true;
+		}
+		lru_gen_update_size(lruvec, file, folio, old_gen, gen);
+	}
+
+	if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && gen >= 0) {
 		enum lru_list lru = file * LRU_INACTIVE_FILE;
 
 		__update_lru_size(lruvec, lru + lru_refs_is_active(old_refs),
@@ -941,8 +949,12 @@ out:
 		__update_lru_size(lruvec, lru + lru_refs_is_active(refs),
 				  folio_zonenum(folio), nr_pages);
 	}
+	if (aged) {
+		aged = false;
+		goto retry;
+	}
 	if (lruvec)
-		lruvec_unlock_irq(lruvec);
+		folio_lruvec_live_put(lruvec);
 }
 
 /**
@@ -3527,12 +3539,13 @@ static int __folio_inc_gen(struct lruvec
 /* protect pages selected by the tier PID controller */
 static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, int old_gen)
 {
+	int type = folio_is_file_lru(folio);
 	int new_gen;
 	bool gen_increased;
 
 	new_gen = __folio_inc_gen(lruvec, folio, old_gen, &gen_increased);
 	if (gen_increased)
-		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+		lru_gen_update_size(lruvec, type, folio, old_gen, new_gen);
 
 	return new_gen;
 }
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
mm-memcontrol-allow-update-of-lru-statistic-without-holding-lru-lock.patch
mm-memcontrol-avoid-potential-counter-leak-when-reparenting-local-stats.patch
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

