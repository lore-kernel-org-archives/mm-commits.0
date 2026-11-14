Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794693566;
	b=ZXCI2RXWao3bTeAakKo0yy03XuUj1LI+YiAZAbrQmBdOAGgllcKrpq7wQmH1A0IKp/A0
	 E0om/eZIuhQMaJbi6cBWdB+1jpD66HklK6zhLrkWzCqJp4w2IMv+J0d8Wo+N2i+4XVP+R
	 OW0klhMC9BExJNo0UjoaMr2caqtBY1ccYAhq1hxnRjK6uKhtVARo7ZZFhEOZzW7ngQxwr
	 UZXzytd5Fj0qf0+7NYY1golaIiM8sjXnc14EovAyWOjvtJPUqpOulVYwj53j3i8ppuTO7
	 Z6pJwDGX1kp7OqQuuIqIuYilg3uHrVT9kWGmGSxB7JNiMPJ4digJYK4XDQ2f+R+9Xdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794693566;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ZQg797ueQQzoyD0wYszprKV9La1nW6evWH/wHYremBU=;
	b=bEmp3UwZtmrtkXISLME945omj5wVHEJKRFFIA/OkurRetc8Jiq289rBigoWrfYshzB1o
	 5L06N5SMyBqeh6DYJlYlAEisXYeEtGrUS6Y4mkkz4Pr67/Q6YMpTgkZyCc322Af6ZX0tV
	 CC1oEJy8+MpEkwL7004X+Srb1dCIgd3foG81WXagocq0oL+csIfLKNstUinq/NapdR5O9
	 A2GQ0m9IR92A1IP4g1a1iDv4PNfxda8VdPgimnv2RbE1f5JgrQkO0oGuR6wt6PsETYXRj
	 kIPk+B/JEoSLnMoCp5rKmnCry6QnoDXODjlZ01QRrG8+EgVMwLqmnrJhhgMs5rf1zGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KX8EJGtQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6D6606A323
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 21:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KX8EJGtQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662F51F000C4;
	Sat, 14 Nov 2026 21:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794693565;
	bh=ZQg797ueQQzoyD0wYszprKV9La1nW6evWH/wHYremBU=;
	h=Date:To:From:Subject;
	b=KX8EJGtQS0Pq+ePGtJrYKGGPeIQsA7c/PZ6ZmaOnqn7pOHC3K0+1DpD6drJYOuOjj
	 M0sA5BFAFBo6CS2HL65Gk8KgvhVPq9TZnwPWD7wOBc2P31JoqvIM8MiU1kM3EyvoG5
	 2nx6S2WGttlT3zsK6qHcSwTemFO9MnGWE9HQ3iLA=
Date: Sat, 14 Nov 2026 13:59:25 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch removed from -mm tree
Message-Id: <20261114215925.662F51F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: make swappiness=1 file reclaim more aggressive
has been removed from the -mm tree.  Its filename was
     mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: make swappiness=1 file reclaim more aggressive
Date: Sat, 14 Nov 2026 02:55:40 +0800

In MGLRU, swappiness=200 favors anon reclaim, while swappiness=1 favors
file reclaim.  Swappiness=0 allows only file reclaim, while swappiness=201
allows only anon reclaim.  Thus, swappiness=1 and swappiness=200 are
counterparts for file and anon reclaim, respectively.

Before this patchset, get_type_to_scan() always returned LRU_GEN_ANON for
swappiness=200 and LRU_GEN_FILE for swappiness=1.

For swappiness=200, file_factor is set to 0 at higher reclaim priorities. 
Similarly, for swappiness=1, anon_factor is set to 0 at higher reclaim
priorities.  This makes the two settings behave similarly, although the
thresholds differ slightly based on testing.

This allows file pages to be reclaimed more aggressively and benefits
workloads that prioritize file reclaim by using swappiness=1.

Link: https://lore.kernel.org/20261113185541.70203-16-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Bo Zhang <zhangbo0325@gmail.com>
---

 mm/vmscan.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-make-swappiness=1-file-reclaim-more-aggressive
+++ a/mm/vmscan.c
@@ -4956,7 +4956,11 @@ static void lru_gen_balance_scan(struct
 	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
-	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
+	if (swappiness == MIN_SWAPPINESS + 1)
+		anon_factor = sc->priority <= DEF_PRIORITY / 2 ?
+			      refault_rate[LRU_GEN_FILE] * anon_weight : 0;
+	else
+		anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
 	if (swappiness == MAX_SWAPPINESS)
 		file_factor = sc->priority < DEF_PRIORITY / 2 ?
 			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

