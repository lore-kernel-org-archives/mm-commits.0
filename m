Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794693564;
	b=0chyUueXyItaS8sDsVUJDUjCbN1MqnFZblEAHugfPSpqIE2dKvh9X4nIBtnRQ610nG+C
	 xSPv8UOvilUqiEif9rNtO5U751nU+HKKIP3FIq7CrDdqqkzIuBp4xcTy1ueEzrNnrhbQ2
	 J1JTdok1Gvb5rZQV8wsc9xomgN8xB2qppuO18Cw82YTKr2QMEoIsdMG1kRSypBFwwwsJe
	 FHUb5SBLZ+znU+nWo4naA3WbmsxqD/bp6fl2Ecca2tCW6HVtdZwEryk43K8yAhZ40F86I
	 nqDVh7UNTU1UETThpL+dx0DUBg6Rw8uP4H09LMNdsRCKJhU9wYgrvS4bKCcSi0MmdqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794693564;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Gc2y1Y85WZsko6w5vOFQC+WI3EEyrFjXKxKe4ymtIN0=;
	b=DtNK7c7xD4hUVGkcx7mFufvvbWCIanXPMxq5hvSMyahqd1E8PNRwfG0zeNWNliIegaa4
	 3unOEcEgEv6Tc2j7r+nNJu+1BPVpiUgBG1OVtrol2mAcRtqzo98eInuDpYbYGOWopV7ki
	 u7AKfVKncEbedE/tGFE1XRGMMdeKDquHwYyTs2n9Mx9aDbX4kiAeZLmHAx0Lf7zFZ3/S8
	 Prv7Ajl3VN+Jea+Z8kM1T/BWyG5am3i3E+JMo6+iAeGrOtTD0fdJVCksFZxxVfya3XR6Z
	 S34nnnZOWBxAWS5UVaJ0HfzYnYa4GVXrxGBQQoQZ6B2AgRjqrqdxJUIs+YWO539qvmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="zlFhCt/s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F577606A323
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 21:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zlFhCt/s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0C71F000C4;
	Sat, 14 Nov 2026 21:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794693563;
	bh=Gc2y1Y85WZsko6w5vOFQC+WI3EEyrFjXKxKe4ymtIN0=;
	h=Date:To:From:Subject;
	b=zlFhCt/soOkZtYLKgyNBTVwg2hmZgab0o+g1bHtT7DWHpKN/OQ8bj0GJ2wLosRS2f
	 E7RSJzdRORfhY0AaAQkgOPFRsiGUGI8Iacv5CFBCps6LcVH45fbUCtcrCd03rpomSN
	 rfE/viBksvWV2SVws4b9C64nl/e9oeG1ULbZGOC8=
Date: Sat, 14 Nov 2026 13:59:23 -0800
To: mm-commits@vger.kernel.org,lyugaofei@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200.patch removed from -mm tree
Message-Id: <20261114215923.CE0C71F000C4@smtp.kernel.org>
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
Date: Sat, 14 Nov 2026 02:55:39 +0800

It has been observed that swappiness=200 can significantly slow down
reclaim on some machines, with some workloads running 3x slower under
MGLRU than under CLRU.

This is because swappiness=200 currently results in file_factor=0.  Give
file reclaim a small factor at lower priorities, for example, when
sc->priority < DEF_PRIORITY / 2.

Link: https://lore.kernel.org/20261113185541.70203-15-baohua@kernel.org
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
Cc: Michal Hocko <mhocko@kernel.org>
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
Cc: Bo Zhang <zhangbo0325@gmail.com>
---

 mm/vmscan.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200
+++ a/mm/vmscan.c
@@ -4899,8 +4899,8 @@ static int get_tier_idx(struct lruvec *l
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
@@ -4957,7 +4957,12 @@ static void lru_gen_balance_scan(struct
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
@@ -5154,7 +5159,7 @@ static void lru_gen_prepare_scan(struct
 
 	total = apply_proportional_protection(memcg, sc, total);
 	total >>= sc->priority;
-	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
+	lru_gen_balance_scan(lruvec, sc, swappiness, total, nr_to_scan);
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -5914,7 +5919,7 @@ static int run_eviction(struct lruvec *l
 			return 0;
 
 		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
-		lru_gen_balance_scan(lruvec, swappiness,
+		lru_gen_balance_scan(lruvec, sc, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
 		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
_

Patches currently in -mm which might be from lyugaofei@xiaomi.com are


