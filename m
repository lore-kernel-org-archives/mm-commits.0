Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598886;
	b=eXHHlyXhV/W6MrFWIgBcz5zOrFbwZLNmrdJChjUu7goKpdJr/+5CdYcb/rwygMFQ9gcu
	 5ut7G7h1eHGO3JaZ7y08VaaYZpptztt5O+ZLi7OxOYcNf5+aEyzyUxqQqqcr3jrAosY1T
	 gtD4U83/4rTDrU+ecihOxzfSksNHDjp0qMT/CQg+Lndo+ehyggco4fmK6QlOWPSgb4jJS
	 zTRnaIZDJifZ9mpvsOeAGF/5ag/jPhExKiZUOjH1l5rLBrufox0VxF5cYgXaDMJ7Y83V+
	 mQBFuyj5qE3b6jdvyuSrxeJQGFhMR9+H3pq7f7F3Bt6XSvOnEGCFKH67II6QyHWhQqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598886;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=d4aDwGoCKCUPVtdxYydEE2VE/EdnzFIdxSSPFbXs5CM=;
	b=HGDb6HXo2R3Iuun+dRGdZIuF28YBumTcSW6BnCCx050NqD1c9aPlTtxQo1N/wwgjLUJ8
	 AP/iXBWEtkUTKLRrRYHYIkMMrVjN+/dhBLNDyQWgMYqegMvCXSU2o5ZZ7JBaIo2ySCiZC
	 mzf+7936BpsXssJ6f0bA/R2vPoeJpPGBGHGgE+uPPOdHKB/IEr9QHX6ioEY3O2dTogiDL
	 TqkGQCBZIBhAFPdpEoO9DPyW2Dqd4471slKoueUSHd8f2wwuDjUNqe82TqAr3+ZFmuqVD
	 HifLmvsolN23Ih2fIS35uncneT3psFM8yMWK2YT7aD7sLPD7W+JibR4PE+hyqWy0K3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=o1d6T76Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D737606A323
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=o1d6T76Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071621F000C4;
	Fri, 13 Nov 2026 19:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794598886;
	bh=d4aDwGoCKCUPVtdxYydEE2VE/EdnzFIdxSSPFbXs5CM=;
	h=Date:To:From:Subject;
	b=o1d6T76YmuV3ypGITvysVwQmf9cp3HlHeVnlrVpbv1BdDyzT8H42aBmXHP34/S2Tp
	 Mac8C8G+706bfbZaOAMb6YrAUnxfnREsW8klCOuHT1PJLh46odB51DLSvdXpHYAOzf
	 byTVg2nSmAITNvI8xMd0ZWH9nBddjTsGsbjDUdH0=
Date: Fri, 13 Nov 2026 11:41:25 -0800
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-avoid-scan-anon-while-swapcache-is-low-for-gfp_noio-allocation.patch removed from -mm tree
Message-Id: <20261113194126.071621F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: avoid scan anon while swapcache is low for GFP_NOIO allocation
has been removed from the -mm tree.  Its filename was
     mm-mglru-avoid-scan-anon-while-swapcache-is-low-for-gfp_noio-allocation.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Bo Zhang <zhangbo56@xiaomi.com>
Subject: mm/mglru: avoid scan anon while swapcache is low for GFP_NOIO allocation
Date: Thu, 12 Nov 2026 07:26:03 +0800

With GFP_NOIO, we cannot reclaim anon folios unless they are in
the swap cache. CLRU skips anon reclaim when the swap cache is
very low by commit 74d9aa0d8e98 ("mm: vmscan: avoid anon scanning
for GFP_NOIO with low swapcache"). Apply the same logic to MGLRU.

The new scan-budget-based mechanism makes this straightforward to
implement. Thanks also to Xiang Liu, who previously attempted to fix
this before we had the scan-budget-based model [1].

Link: https://lore.kernel.org/20261111232603.9934-17-baohua@kernel.org
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
Cc: Michal Hocko <mhocko@suse.com>
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
 
@@ -4213,6 +4206,8 @@ static void lruvec_evictable_size(struct
 	int type;
 	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	int nid = lruvec_pgdat(lruvec)->node_id;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -4220,6 +4215,8 @@ static void lruvec_evictable_size(struct
 	nr[LRU_GEN_FILE] = 0;
 
 	for_each_evictable_type(type, swappiness) {
+		if (type == LRU_GEN_ANON && !can_reclaim_anon_pages(memcg, nid, sc))
+			continue;
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
 			nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
@@ -4900,23 +4897,19 @@ static void lru_gen_balance_scan(struct
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


