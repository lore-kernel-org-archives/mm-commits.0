Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598884;
	b=cJA2OsYovSQkWBRIGpACsmJJB2UOWItmXa66L69QkcZwXksPVuGQOzIGBuvlW7yE0SjG
	 ZjoY3g8BtgPnWIa+IpiLU51xFVrC/+pdjoLFxQFp3M1qpAF/5CC9WPqwdQZBAaQQBCkO2
	 ZDKWSkF3Qzmj1COACjdnMBwn4s9rREfi64FrnSDX1E/tGW7NXmdksmywdXnwBJktSaPAk
	 VLw58YPG4gLWbaNu+wo/L0hcc8DW2t3teABjQ/U6DB1OTkDLjEda2VZr/BC8t5IDFmG73
	 3lwOKn8FSkY1IKdQGgslk+mEZeq7vURu2Q1Y2ai8aGe1pJjC7Js96669/1ejPI9wQ2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598884;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iD0h6EkvIMSOGRZiSsZJKObBM3u5/BnVDlqGxcfpfH4=;
	b=ZSTLdn9bN7jHYHkMxCDzJmBs1MfAeepXUvE9NKr64PrGZ505p0HRFciFp+eZGWjo12I5
	 Gl7XpylIpzASYxeqFTcJnbk9JmgnFvgeKtV8KGwsLdDv36IIMZNvguUgIAEvLiZc+Tzet
	 LNcSRvyMeHwQDLElUMKAkqr2OfiywkzdgkGD9Zw4QZfu70ITjejeQOr72GBM6rLxpatWR
	 +5RLnkn9N/NIOv77HDUX2/hzrTj6g7m9pxzrqN43MFujOgff3h+LDftRTkgd1sqR+1kxa
	 C4BePPH6sdvMFQJDtdJPesCySZtnM/P9J+QvuIQLS/UeW927GGmBmxj6p4/1yscDm9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BClhI7SP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17864606A32D
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BClhI7SP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA22D1F000C4;
	Fri, 13 Nov 2026 19:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794598883;
	bh=iD0h6EkvIMSOGRZiSsZJKObBM3u5/BnVDlqGxcfpfH4=;
	h=Date:To:From:Subject;
	b=BClhI7SPaBy2Hg+h2pWwI3zKM9g1lB+ChY+LCzGNHkSindbFUw0jRS89icNRAXU+S
	 SDjnLjItawjZf3yEUF9AWXuf3fbH1ndvH8z8j3tjSMCdT1e8TpIhYWiBFULdwhHtvz
	 a++4/ux0+4qegv9rAG/nleidihhXJWrFQQ+hJKOM=
Date: Fri, 13 Nov 2026 11:41:23 -0800
To: mm-commits@vger.kernel.org,lyugaofei@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200.patch removed from -mm tree
Message-Id: <20261113194123.AA22D1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: avoid prolonged anon reclaim with swappiness=200
has been removed from the -mm tree.  Its filename was
     mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Gaofei Lyu <lyugaofei@xiaomi.com>
Subject: mm/mglru: avoid prolonged anon reclaim with swappiness=200
Date: Thu, 12 Nov 2026 07:26:01 +0800

It has been observed that swappiness=200 can significantly slow down
reclaim on some machines, with some workloads running 3x slower
under MGLRU than under CLRU.

This is because swappiness=200 currently results in file_factor=0.
Give file reclaim a small factor at lower priorities, for example,
when sc->priority < DEF_PRIORITY / 2.

Link: https://lore.kernel.org/20261111232603.9934-15-baohua@kernel.org
Signed-off-by: Gaofei Lyu <lyugaofei@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: <liuxiang.277@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
---

 mm/vmscan.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200
+++ a/mm/vmscan.c
@@ -4895,8 +4895,8 @@ static int get_tier_idx(struct lruvec *l
  * We don't calculate the scan cost, MGLRU uses lazy promotion, which will
  * cancel the scan budget natually.
  */
-static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
-		unsigned long total_scan, unsigned long nr[])
+static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
+		int swappiness, unsigned long total_scan, unsigned long nr[])
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
@@ -4953,7 +4953,12 @@ static void lru_gen_balance_scan(struct
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
 	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
-	file_factor = (u64)(MAX_SWAPPINESS - swappiness) * refault_rate[LRU_GEN_ANON] * file_weight;
+	if (swappiness == MAX_SWAPPINESS)
+		file_factor = sc->priority < DEF_PRIORITY / 2 ?
+			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
+	else
+		file_factor = (u64)(MAX_SWAPPINESS - swappiness) *
+			      refault_rate[LRU_GEN_ANON] * file_weight;
 
 	/* Cross-multiply the ratio above. */
 	anon_scan = mul_u64_u64_div_u64(total_scan, anon_factor, anon_factor + file_factor);
@@ -5150,7 +5155,7 @@ static void lru_gen_prepare_scan(struct
 
 	total = apply_proportional_protection(memcg, sc, total);
 	total >>= sc->priority;
-	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
+	lru_gen_balance_scan(lruvec, sc, swappiness, total, nr_to_scan);
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -5897,7 +5902,7 @@ static int run_eviction(struct lruvec *l
 			return 0;
 
 		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
-		lru_gen_balance_scan(lruvec, swappiness,
+		lru_gen_balance_scan(lruvec, sc, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
 		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
_

Patches currently in -mm which might be from lyugaofei@xiaomi.com are


