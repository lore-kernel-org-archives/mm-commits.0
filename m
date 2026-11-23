Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795465398;
	b=jM3xLll3LQ6yUvFRnFkpzg46vc2XxPYg78XBcYN2pDMR7v11NdNEqYULXQ6kgm5YXOQX
	 DwPccBmj8a4VZMz6pGkFWsi3EwtnPtKP54U5JOdZqkoPJ/7oVDjeB8su+eug2bLTZ5h+h
	 lUPMT1fqAnsD+eGFp8EeqsePs8dPlrSE+kyoqMKDValViFioFI6NCxr7m6TdsWB87kvdF
	 qz3tJzLCQ+N8VIHNgO5I20R54ZGTQrFkn/aq52f+FnBg5/N3/fF3ghgtXJhmeYYVNTmIC
	 AdbmA+W1Sp8T65KjKw8QDyMLAq5sTToVxIkrEMOX/mH96FwrGbyTdrU4KA7jpjio11A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465398;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=aaK2750YEWe1vnJb4HSlZEojcDlAWEDnSeyF3AdscLM=;
	b=YP2GrUhjWpMyQfgBgCz9i6l1m1UlcD8HcxZ5DU7a3NneWPK3U2Ztd0SPdGFOZJhw4Jbm
	 K+Toz4Iq+FA+A9308x7f5cuXo2KeM7/uRdKSJjQO48836peq2HpK0ZUkF62fNAHnHGt8x
	 SivfcKsCnkH8xf503zgoCNEXbX4LXVIvyRZ/KA7r16TjxfILAgrX3LQsx72G8RJH57EcO
	 tJU4/Tt6FVXcdWuDcO5FZ2UU0AYmUusaisM2lJPH2sSTwqXhXt2Xj3FCXXS/9o0vGGiP9
	 0IcTnNZLnvePxf/APv2D9gfsnXHF0JeynU7nkwuNKauDkqBV4ro54XiUusH5ilx7BzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LRjYSTz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242AA606A327
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 20:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LRjYSTz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8601F000CA;
	Mon, 23 Nov 2026 20:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795465397;
	bh=aaK2750YEWe1vnJb4HSlZEojcDlAWEDnSeyF3AdscLM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=LRjYSTz6NyHwnxAeQ5mQ0fHIhxAXdyUL+LmFTgxf0sXLY6V7JgjcneOYLkwpeiR0u
	 XaWk7LlhcdZ3Ao0WFdAUPJT+44BlUPf3c4WVCqVh/KZ7Sco1Y06GmeFfXHC0574XGU
	 SqyONWszHV98AC6Cgy6kjECbU9T9xahPHCGRau9o=
Date: Mon, 23 Nov 2026 12:23:17 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-9-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-9-8ffea39934a6@tencent.com>
Subject: + mm-mglru-move-add-del-lru-size-accounting-out-of-lru_gen_update_size.patch added to mm-new branch
Message-Id: <20261123202317.9A8601F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: move add/del LRU size accounting out of lru_gen_update_size()
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-move-add-del-lru-size-accounting-out-of-lru_gen_update_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-move-add-del-lru-size-accounting-out-of-lru_gen_update_size.patch

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
Subject: mm/mglru: move add/del LRU size accounting out of lru_gen_update_size()
Date: Tue, 24 Nov 2026 02:53:01 +0800

Pure code shuffle, no behavior change.  lru_gen_update_size() now only
updates the per-generation counters plus the promotion move; the
addition and deletion active/inactive accounting move to
lru_gen_add_folio() and lru_gen_del_folio(), which know the generation
and can apply the active-window test directly.

The unevictable case is untouched: unevictable folios never enter
lru_gen_add_folio() and keep being accounted by lruvec_add_folio() as
before.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-9-8ffea39934a6@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
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
Cc: wang lian <lianux.mm@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: Tianyi Chen <hi@tychen.cc>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Harry Yoo <harry@kernel.org>

 include/linux/mm_inline.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-move-add-del-lru-size-accounting-out-of-lru_gen_update_size
+++ a/include/linux/mm_inline.h
@@ -322,21 +322,9 @@ static inline void lru_gen_update_size(s
 	if (new_gen >= 0)
 		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
 
-	/* addition */
-	if (old_gen < 0) {
-		if (lru_gen_is_active(lruvec, new_gen))
-			lru += LRU_ACTIVE;
-		__update_lru_size(lruvec, lru, zone, delta);
+	/* return now if not a promotion */
+	if (old_gen < 0 || new_gen < 0)
 		return;
-	}
-
-	/* deletion */
-	if (new_gen < 0) {
-		if (lru_gen_is_active(lruvec, old_gen))
-			lru += LRU_ACTIVE;
-		__update_lru_size(lruvec, lru, zone, -delta);
-		return;
-	}
 
 	/* promotion */
 	if (!lru_gen_is_active(lruvec, old_gen) && lru_gen_is_active(lruvec, new_gen)) {
@@ -391,6 +379,8 @@ static inline bool __lru_gen_add_folio(s
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) != MAX_NR_GENS);
@@ -408,6 +398,10 @@ static inline bool __lru_gen_add_folio(s
 	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, delta);
+
 	/* for folio_rotate_reclaimable() */
 	if (reclaiming)
 		list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
@@ -432,6 +426,9 @@ static inline bool lru_gen_del_folio(str
 {
 	unsigned long flags;
 	int gen = folio_lru_gen(folio);
+	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
 
 	if (gen < 0)
 		return false;
@@ -445,6 +442,9 @@ static inline bool lru_gen_del_folio(str
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, -delta);
 	list_del(&folio->lru);
 
 	return true;
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

