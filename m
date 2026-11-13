Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598882;
	b=Z32xYFuFZDwj6nsF0LLlE4q0k7JWBHONYcfRX9z3K4w+2EnRVsHOGRUPYu2oKQOe2ruU
	 P524IdCvAr055P5qmHuMua3BJH/Touk7VaB0h18KjvKOAB2Xbb9bEsNFYFjFN+t2EWk71
	 fDBEYHkrBIMbK1GsTXTiPwUK7WOylzU5WT2Qw2lIB9hU+Eni/WvYtRPrIqBKIfGLhOEBn
	 E9+HX8lg4+/2mO+oGVU9YIz6s/Mh92GggJu6U5TsYWQB8eZIPumWb9WArYrAjVp1agp0J
	 Ssz0cjEAQnFS6DnuaTI993KUrDCFSk5tGGOY2Md3UkPyqNOnozu3bNpH9XGPsNtaAVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598882;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=f6jfVyWqsUoUv9z3Rmv6l3WeYeThe7iGyg/n+yo9vTs=;
	b=WPjtS1bNne1wDahubaDsHMYhrhdYNrxcIM+DfF/ZVGJhvmXIPbYmMHdX4Z8bGNOKnYKw
	 Cup5vKP0MriHm09nqtwma+c/9FBRff+SKpNMo0A+HEyfzh/g1bLrDW9wfUG1bod8w4IQX
	 oRcSF4pYocMGv0glrx5t3uaMJ3bbZ+iYFy1AbLP7UIacDTOI/Jmfg+Gb/+RtinSVe6kDD
	 eO1V7XCcxkSrx+z4thRWD3dMSmgpqNTy1/CiHfpQJqrbRuPflfs9qw2zc0s83rRVcZ5zb
	 f+yYZEGv+2juIeQ1rr2XJv6pOXsQb5qYWDCXG2ZthUIBVZhVuuTHX6WtWqtT9ETb6iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=reSZTsCd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD786606A32E
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=reSZTsCd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8587E1F000C4;
	Fri, 13 Nov 2026 19:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794598882;
	bh=f6jfVyWqsUoUv9z3Rmv6l3WeYeThe7iGyg/n+yo9vTs=;
	h=Date:To:From:Subject;
	b=reSZTsCde41ZXGJPGdLZYivdQJIxuc0796H10fIeLqVWH/YGchQ4Xe2ua6Ilcqllc
	 vPWKAiPIq2A37dM+EfBcL0btkxqh4zeQvgy+Cb5qohZ5jdseih//UPnRJK5CUjAiYK
	 ydt5r6pqeKCcDOpwibdM2U9942jYmechuFrA57X8=
Date: Fri, 13 Nov 2026 11:41:22 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch removed from -mm tree
Message-Id: <20261113194122.8587E1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: reduce LRU lock contention by shrinking folio batches in inc_min_seq
has been removed from the -mm tree.  Its filename was
     mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: reduce LRU lock contention by shrinking folio batches in inc_min_seq
Date: Thu, 12 Nov 2026 07:26:00 +0800

Reduce the number of folios moved from the oldest generation to the
second-oldest generation in each batch. This shortens the time the
lruvec lock is held, allowing concurrent LRU operations to make
progress and significantly reducing LRU lock contention.

Link: https://lore.kernel.org/20261111232603.9934-14-baohua@kernel.org
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

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq
+++ a/mm/vmscan.c
@@ -3912,7 +3912,7 @@ static inline void flush_lru_batch(struc
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MIN_LRU_BATCH;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

