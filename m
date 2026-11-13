Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794600360;
	b=PhQA139sTkMBwEhzAJ01bFBbbBwIkPtfbmHhQf7QqT0V+WHdBdE0QqcWRrUlFBapIE3L
	 737UQ4dFy9M2b6Y88IGxusWFyr/K0sz1mRUZlbip6+tolqXsjgE9RKx9sxQGXpt469P5H
	 SfJXZ9WsaGiXIaMobjG/Etegz7LYuyb1M4gdRXJlMcvy62OVJMZ4yFZUHvGE1gA71PUy3
	 YfkNqPb9Pjwv+mSEUvxtCoHqmllQfAfpHi4rVjxWv+MPs0aHJHQdKS3IodYJSoiwcXk1l
	 qPozgeiH+uR7Bh5Mn1dUs406F+cWRofFeZAdw+/a6ZsIAO2RIl0tuDlhRWFTMhvw05A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794600360;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=UwM3DnCvdbpX/Hn76TdDkJqzYVd5CjM9/joNSnLPrRY=;
	b=jDb2dlZElwj+MBSG/ofLEKDrRHm+NZ+OQpFBxMOFh+U4DtnDuEBu67C9j0jOPSaBTUXM
	 oHDQzMwV9pqnm0RBmBurmTe6ql4Hovx0fhGeBNgCIrvjPnAPK9kB3mBeEoN2ZW9cAxV3l
	 VinzsuR0R4+DBFYv5Cn7n3Q/xO6faGLSR4aeMLkoyrVpbpj8DaQgBeXPIPPsrYgHxTSAV
	 tmYm4tVhX5M5jE/PxorIVwopuqR/wf1iPZBemFzkRejyz8PBO9rC/y1kIHDIgXTIoBHBo
	 m7HdaChgCQ0/XGSr1HLozYpX8uQZIgsJQhHo1g0uvFPMt0gzUj/W37DBXAT+qr2Xh4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qBteaBjt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F13F606A881
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 20:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qBteaBjt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DAD1F000C5;
	Fri, 13 Nov 2026 20:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794600360;
	bh=UwM3DnCvdbpX/Hn76TdDkJqzYVd5CjM9/joNSnLPrRY=;
	h=Date:To:From:Subject;
	b=qBteaBjtVP8trJs3bGcqNB7pGoyGC/EyFk5P5D5KabACxwlyEcXHszzboQEY8JNzG
	 acgEWL65XZiQzsnbscPt7s9Y4NPixmEO4IxMFlVI9ugROzVFXyOHTFOouM+HHpGHfg
	 8DuPTLsofHatd3k+/qsRq3oh8ZSn4O56gKsGHkn4=
Date: Fri, 13 Nov 2026 12:05:59 -0800
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-avoid-scan-anon-while-swapcache-is-low-for-gfp_noio-allocation.patch added to mm-new branch
Message-Id: <20261113200600.59DAD1F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: avoid scan anon while swapcache is low for GFP_NOIO allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-avoid-scan-anon-while-swapcache-is-low-for-gfp_noio-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-avoid-scan-anon-while-swapcache-is-low-for-gfp_noio-allocation.patch

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
From: Bo Zhang <zhangbo56@xiaomi.com>
Subject: mm/mglru: avoid scan anon while swapcache is low for GFP_NOIO allocation
Date: Sat, 14 Nov 2026 02:55:41 +0800

With GFP_NOIO, we cannot reclaim anon folios unless they are in the swap
cache.  CLRU skips anon reclaim when the swap cache is very low by commit
74d9aa0d8e98 ("mm: vmscan: avoid anon scanning for GFP_NOIO with low
swapcache").  Apply the same logic to MGLRU.

The new scan-budget-based mechanism makes this straightforward to
implement.  Thanks also to Xiang Liu, who previously attempted to fix this
before we had the scan-budget-based model [1].

Link: https://lore.kernel.org/20261113185541.70203-17-baohua@kernel.org
Link: https://lore.kernel.org/linux-mm/179248830836.1744016.8424217811286616919.noio-mglru-rfc-v2@bytedance.com/ [1]
Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
Cc: Xiang Liu <liuxiang.277@bytedance.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: <lyugaofei@xiaomi.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Bo Zhang <zhangbo0325@gmail.com>
---

 mm/vmscan.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

--- a/mm/vmscan.c~mm-mglru-avoid-scan-anon-while-swapcache-is-low-for-gfp_noio-allocation
+++ a/mm/vmscan.c
@@ -272,13 +272,6 @@ static inline bool reclaimable_anon_is_l
 	if (!sc || (sc->gfp_mask & __GFP_IO))
 		return false;
 
-	/*
-	 * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() for the
-	 * scanning type, so only apply this to the traditional LRU for now.
-	 */
-	if (lru_gen_enabled())
-		return false;
-
 	if (memcg) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
@@ -4211,6 +4204,8 @@ static void lruvec_evictable_size(struct
 	int type;
 	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	int nid = lruvec_pgdat(lruvec)->node_id;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -4218,6 +4213,8 @@ static void lruvec_evictable_size(struct
 	nr[LRU_GEN_FILE] = 0;
 
 	for_each_evictable_type(type, swappiness) {
+		if (type == LRU_GEN_ANON && !can_reclaim_anon_pages(memcg, nid, sc))
+			continue;
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
 			nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
@@ -4904,23 +4901,19 @@ static void lru_gen_balance_scan(struct
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
-	u64 anon_scan, file_scan, total;
+	u64 anon_scan, file_scan;
 	u64 anon_weight, file_weight;
 	int size_bias;
 
-	total = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE];
-	if (!total)
-		return;
-
-	if (swappiness <= MIN_SWAPPINESS) {
+	if (swappiness <= MIN_SWAPPINESS)
 		nr[LRU_GEN_ANON] = 0;
-		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
-		return;
-	}
 
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
+	if (swappiness == SWAPPINESS_ANON_ONLY)
 		nr[LRU_GEN_FILE] = 0;
+
+	if (!nr[LRU_GEN_ANON] || !nr[LRU_GEN_FILE]) {
 		nr[LRU_GEN_ANON] = min_t(u64, total_scan, nr[LRU_GEN_ANON]);
+		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
 		return;
 	}
 
_

Patches currently in -mm which might be from zhangbo56@xiaomi.com are

mm-mglru-avoid-scan-anon-while-swapcache-is-low-for-gfp_noio-allocation.patch

