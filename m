Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794600356;
	b=xHoZC8tzc2EIuweTzb4bZKCwk9o9ONAPTZPNPcJEcouvoYBU5TdVy5tKxulJZ+E19/B2
	 9fpuzNCwEWBXSmaUuZ3wfUV2pXXrjV5TePneFObKIYSjeiyc4tMDjSwnZFfcToiuUhQzB
	 vbQBCrKWDH8O4gJQHQe6F4Iua/4WHwciJcEsHL8ZlJkN5YU9hv3qCYCUFMfdljTjSap+b
	 +Gi/Sr+C3rnfmZcx0gnzTWZfQC10GCAPnwI/0lSue7ft4j14vextxqjC3CDlj8AFsLUut
	 7wKWm0RV90YsLLuDtD0UO/pEEf2AkMJ2iHZsiHxXzaCqe8MlfuFmaNctlSA/664xJoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794600356;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=SbceXoDRrCQdBxeqaVbTfXuGcCYqlKi7IyHwfQjUTfo=;
	b=47potJ8Q22sW46wv4i0T9XzJWjMqw4NB8YaM9Mu98QTFtimWIGKIFPzSXeQUYPFaSQzl
	 G/NaU9nuCF0a/zsSkkbccP+3uDkmohcbM4Exfuc+GedLN6lwX5uY8VmTlDy2TrT1XsUkJ
	 h8hMWQwUnxQXkLX4O2x2pZhnbm0+mup1TW+gLQ1Yj86bByA9jsfMY6Q4D3jcFvxsKketF
	 DbBvBiOaEmPuhuclVLzGinJjZP7UDkCw2Z/QhAkBf+JqCWSFxgtTj4o408Eg7xFXKNORS
	 uQ4pZSUb4UpZ7Oo9vwN9NbaxxbAeSlIlEjPcBOUmE4X3HSNLWiT7m3u81O1Fe1W+etA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BihLGRaf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21504606A32D
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 20:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BihLGRaf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77C21F000C5;
	Fri, 13 Nov 2026 20:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794600355;
	bh=SbceXoDRrCQdBxeqaVbTfXuGcCYqlKi7IyHwfQjUTfo=;
	h=Date:To:From:Subject;
	b=BihLGRafWH4M3CpyzxU6BPLqbdbzYBdGPvGicP4AMx5NeuX7MEimy7jD04UF3VyQF
	 NV3uB5Haq0oFiyPDudCicpwHc55i9JQApzSG3V3cJfLY2+XikDQ/A0QRAwX+KqZQ+b
	 fouzpXdhcIlcq+uXAo2qaUQOU1Y90mAQwWrEmy6w=
Date: Fri, 13 Nov 2026 12:05:55 -0800
To: mm-commits@vger.kernel.org,lyugaofei@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200.patch added to mm-new branch
Message-Id: <20261113200555.C77C21F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: avoid prolonged anon reclaim with swappiness=200
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200.patch

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

mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen.patch
mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200.patch

