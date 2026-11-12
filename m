Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794446244;
	b=yUhXzrHeoEoBosbcVEWeoOUBRk1Zr6vSvkD1+Pyoohysx/4BOVeLytwV1Y+zXJ4iuG/8
	 YWF3LT6ObudD/P573L2bqMB6RVH0M0VoZGKcbwdZtejcG0SucnUHhSo57GHOAEUIzOyFH
	 J+ffk0qKLuiauLuFvoebV2BTfyU3Hxz9pr53XzfbP50NG4tOou/2vV67Td8NxT7TjZCmo
	 Gu/uuzqqmltpYCXLtyuJj/oXqi98S1bGIj1K+wVmndnSiCBwHtFbsLh9RILrgMRivor06
	 VQCsW2ZA6OSgwShxfKp0wbDNzrCFUBgGeEiDKAsneoKPkqWbnyL8BVxNPMzNvs5+Kaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794446244;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GGmDPxKyV4CZ2VIKnFP2jJzyDm+FQLLEF8EYuSdXzgA=;
	b=KBQscwmklfiqXKJx/jKI+i11YZv7TDG7IUd1nXOiL32BbHoB6AD7XATE5zz+gHL1m9Dz
	 qOzzq5YD3ZWl+SBxNbildCqCuBOt0qom/RZyAkWfYQoP5deomJqwZtcAiO+3zYOMzHhFJ
	 Lj+Ibq2QZQF5wjHBIExqewWBhRI02gbBoIEE5fZfaIL1UyuVk93Q6i402ARZEaDPdhG45
	 Mr//uxf+hf+IBcntsy0imMCKV0T8iU+r2vMM5IciN7EIr5b11AF2QLs9YIPhHwxo6yviQ
	 COMhOmhwneOxg3FHtFn2KI1+QwCAkwuBrfUO/WUi3Zgh99Pg6y3zgGadX0tdy9pzUmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wWuE9i6j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7C7606A32A
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 01:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wWuE9i6j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452191F00A06;
	Thu, 12 Nov 2026 01:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794446244;
	bh=GGmDPxKyV4CZ2VIKnFP2jJzyDm+FQLLEF8EYuSdXzgA=;
	h=Date:To:From:Subject;
	b=wWuE9i6jzTMVOZ4tBcVgMkFBb/bl2IaJYuQ2iqkGjLz7tJhmRIMhhetLBRiSyv/9V
	 UfCshw5mbBnk7lXo3a/ySEgJRHNrSu2d7UCz+vlxgoGuBMbSNRuBwdvrbU5uPepQYL
	 m09628HFVnEtqhoQKGlZrSC0S4t00Xz8QNz1ItSM=
Date: Wed, 11 Nov 2026 17:17:23 -0800
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,zhangbo56@xiaomi.com,
	yuanchu@google.com,weixugc@google.com,wangzicheng@honor.com,
	surenb@google.com,sidchintamaneni@gmail.com,shakeel.butt@linux.dev,
	rppt@kernel.org,ridong.chen@linux.dev,qi.zheng@linux.dev,mhocko@suse.com,
	liuxiang.277@bytedance.com,lianux.mm@gmail.com,liam@infradead.org,
	kunwu.chan@gmail.com,kasong@tencent.com,hui.zhu@linux.dev,hannes@cmpxchg.org,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	axelrasmussen@google.com,lyugaofei@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200.patch added to mm-new branch
Message-Id: <20261112011724.452191F00A06@smtp.kernel.org>
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
From: lyugaofei <lyugaofei@xiaomi.com>
Subject: mm/mglru: avoid prolonged anon reclaim with swappiness=200
Date: Thu, 12 Nov 2026 07:26:01 +0800

It has been observed that swappiness=200 can significantly slow down
reclaim on some machines, with some workloads running 3x slower
under MGLRU than under CLRU.

This is because swappiness=200 currently results in file_factor=0.
Give file reclaim a small factor at lower priorities, for example,
when sc->priority < DEF_PRIORITY / 2.

Link: https://lore.kernel.org/20261111232603.9934-15-baohua@kernel.org
Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
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

mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen.patch
mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200.patch

