Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795638973;
	b=uCkAOVaz8ev7keWORGWMfwYbnG1hNX+f4BcKBPxNA5LL1/CFjztzccYZcp7Ux5tBSIf7
	 J06ACGHgJnFPPM3I73ZTZ8F56hY1iWA3TmuOhwAkdfTDWL265sdqoL4dxUqHwTgzwOATL
	 hG60a8c3EeoOpHyMa0S/C5rzAtofYsycBFsKPdxy+rBLfyUYy2R9NnEIaAeyTk3/wBLS/
	 Hpmv4/mXOcXCsd/GijK4TesL5QTmUnO3PC+vpnyCogbXj0SrGna0I1fHJIJMSouw0RJU0
	 wfGB570FxPwLmB7GHyzflO62kJJCnXyHRpwgBzjzWCzyUwWmgJOvrUEK8QkNqyDvK+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795638973;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=zvLsqDMjkdtYA9fONRdDOlJ+vBeF+YVc1HR6jtFso7Q=;
	b=2LO/s3sw09zwbCBpNAOmnAcWk2qhNMilcd2xR5XkWxJWO2yiZ6Z5lFOolZICHUQRFfIF
	 x/HHpELyuEL8TYazHG4d1XC5gQ6a7wnIc2T0c1Kg9GWGIveltLVvsom22n9BTHZ1uE0fy
	 P/mIJQibeE2sgntAlYoZ1NyI/r9eFb1tbIT5QtvshbRdt6Ad8n6Sm1q/pIxuNbJkWoDib
	 Z3Y/OtCxtEhc1Khr0hCnJxhpAcOXhgF/YKdGk1e2+N7Hy+aG/UHk+6UlbbNYNlQCceMRn
	 VGVkg8E4xYTxJo0/Yz5SR0b6u1m4Ic3vJQpPAsN5kKfoSDGooDjqn+bK1P6BFtRwC7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=C3CmyxwD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E697606A327
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 20:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=C3CmyxwD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55871F000C0;
	Wed, 25 Nov 2026 20:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795638972;
	bh=zvLsqDMjkdtYA9fONRdDOlJ+vBeF+YVc1HR6jtFso7Q=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=C3CmyxwDJdPYzJQlBcuo+fIsYTLzfaUH5APEqb8QJ4SNq6o/QrjKbMtzfuXsdF4Rv
	 3N6gMK7mF50v9gNb4wYa/5XLlNtwdLJS0qyEdufe3U7785u/dLLblj2Ov4uwVKYZxS
	 VEL6+TGBYYwSivOp5+F350VXofw4uSQKMig74Ye8=
Date: Wed, 25 Nov 2026 12:36:12 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-14-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-14-8ffea39934a6@tencent.com>
Subject: [to-be-updated] mm-madvise-adapt-for-lru-refs-based-operations-for-mglru.patch removed from -mm tree
Message-Id: <20261125203612.C55871F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/madvise: adapt for LRU refs based operations for MGLRU
has been removed from the -mm tree.  Its filename was
     mm-madvise-adapt-for-lru-refs-based-operations-for-mglru.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/madvise: adapt for LRU refs based operations for MGLRU
Date: Tue, 24 Nov 2026 02:53:06 +0800

For the active/inactive LRU, madvise clears PG_referenced so that one more
access is not enough to reactivate a folio, and keeps PG_workingset on a
folio demoted out of the active list so its refault is still accounted as
a workingset refault (PSI).

MGLRU keeps that history in the folio's refs count instead, which now
lives in PG_referenced, PG_workingset and LRU_REFS_MASK, so writing to
those bits directly corrupts the count. The two hints want different
things:

- MADV_COLD resets the count in folio_deactivate(), which also requests
  deactivation.
- MADV_PAGEOUT clears non-workingset refs and caps the rest at
  LRU_REFS_WORKINGSET after isolation, before handing the folio to
  reclaim_pages(). The hint marks the folio as cold, so the
  eviction shadow records the capped count and does not inflate the
  eviction/refault counters of the hot tiers that drive aging, while
  folios at or above the workingset threshold keep their PSI
  classification.

PG_young is cleared for both LRUs as before, so the referenced walk does
not count stale history as a recent access.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-14-8ffea39934a6@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
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

 mm/madvise.c |   54 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 14 deletions(-)

--- a/mm/madvise.c~mm-madvise-adapt-for-lru-refs-based-operations-for-mglru
+++ a/mm/madvise.c
@@ -360,6 +360,42 @@ static inline int madvise_folio_pte_batc
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+static void madvise_cold_prep_folio(struct folio *folio)
+{
+	/*
+	 * VM couldn't reclaim the folio unless we clear PG_young.
+	 * As a side effect, idle-page tracking loses recent referenced history.
+	 */
+	folio_test_clear_young(folio);
+
+	/*
+	 * For the active/inactive LRU, a folio demoted out of the active
+	 * list should have PG_workingset so its refault is still accounted
+	 * as a workingset refault, and the referenced bit always needs to
+	 * be cleared even for inactive folios. For MGLRU, MADV_COLD clears
+	 * refs in folio_deactivate(); MADV_PAGEOUT handles refs after isolation.
+	 */
+	if (!lru_gen_enabled()) {
+		folio_clear_lru_refs(folio);
+		if (folio_test_active(folio))
+			folio_set_workingset(folio);
+	}
+}
+
+static void madvise_pageout_prep_folio(struct folio *folio)
+{
+	unsigned int refs = folio_lru_refs(folio);
+
+	/*
+	 * For MGLRU, clear refs below LRU_REFS_WORKINGSET and cap
+	 * the rest at it: MADV suggests the folio is cold, so the eviction shadow
+	 * should not record its hotness in the high tier counters, but
+	 * the workingset classification is preserved for PSI.
+	 */
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, refs >= LRU_REFS_WORKINGSET ? LRU_REFS_WORKINGSET : 0);
+}
+
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
@@ -434,12 +470,10 @@ static int madvise_cold_or_pageout_pte_r
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+		madvise_cold_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
+				madvise_pageout_prep_folio(folio);
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
 				else
@@ -544,18 +578,10 @@ restart:
 			tlb_remove_tlb_entries(tlb, pte, nr, addr);
 		}
 
-		/*
-		 * We are deactivating a folio for accelerating reclaiming.
-		 * VM couldn't reclaim the folio unless we clear PG_young.
-		 * As a side effect, it makes confuse idle-page tracking
-		 * because they will miss recent referenced history.
-		 */
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+		madvise_cold_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
+				madvise_pageout_prep_folio(folio);
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
 				else
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
mm-huge_memory-mark-folio-as-accessed-more-accurately-on-split.patch
mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch
mm-mglru-folio-lru-refs-based-active-inactive-number-accounting.patch
mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

