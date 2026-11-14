Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794693562;
	b=jfrpN2pIFaIjpRiM/N/b+uoZ2PNOigFkJ/Fdv1qAGNpZ+0iKlIuHxgM63tlJIVFooJ9q
	 mGL5lZDJevhlADbdCVb63uR5n9s34gG9t3QiCbf2G3WA2kqJSjgHUE3MoSOS0J5Iqkw/X
	 OLtaT8eQcnsB0++NoBePNZQ9+0+v2JYvWHPyZEgjHKjX9wgmKzKp7u4iU2MZ2shQY1kwM
	 pW5Y7x8K7bH98ncWyAkQr+/Vgnuc4Y9sPHC2HOrEgIwdwlK3tiCDo0byIWb8LSCGmnpqC
	 Ej4ejo2/UEXhbIfFt625xWP/K4+bK+5jpsaKX5iJPPa8w0Gp0rMeF1KqX43W8v4rj0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794693562;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=1DQ9WQCU1wxZFLBjxtpRd7NEWLM7yCKdPYsDXZGhy4s=;
	b=hxUdlV3bCaBelyLhN3xW4GOx2pAFk0GTm85SRhBSJD2hebVnH1TeDxgOQilbgRnO78ZW
	 9ZLX/nA+piC4DsWvpvJvNRFlpeSqn/vQze/qgY2luC6SaPbw99KAEdT5wbFKLGF0el7vZ
	 7WVdnQrH1VJ/ZBxvPC5TppLi1k9gveO/E+7JkgE0hu24hv/Izif2QvIJDnNvt5c9pq2dF
	 4LAjHYTHGcMH0l6RuGc6+UtXfSKtnxDKX2VWPLy5a0IOb4iNhD8coVPK7QTqjKuWrFUW1
	 g4P0V+pZs9RlKYlAN5olN8pUyC+bXTNBLvaqs1DKb8k5yjkdzQmYfZW5FN6769/54Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="UGv9bkh/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD8F606A327
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 21:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UGv9bkh/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469FB1F000C4;
	Sat, 14 Nov 2026 21:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794693562;
	bh=1DQ9WQCU1wxZFLBjxtpRd7NEWLM7yCKdPYsDXZGhy4s=;
	h=Date:To:From:Subject;
	b=UGv9bkh/HGahAwE0ZssO219LEmjR/rJ7Tj7wcaSeLT2rZ+KfjOTqdHdvHJVvpC+o4
	 LZ0i5vabPvLZZXGS6707yD03+JVCdfRcKjqCVmSuENpYJ4tfH3PJcm1mGTL1zEVkJG
	 08H95+2NqIgxBgrX4sTdI+FunJnEFwCDxjVLO6+k=
Date: Sat, 14 Nov 2026 13:59:21 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch removed from -mm tree
Message-Id: <20261114215922.469FB1F000C4@smtp.kernel.org>
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
Date: Sat, 14 Nov 2026 02:55:38 +0800

Reduce the number of folios moved from the oldest generation to the
second-oldest generation in each batch.  This shortens the time the lruvec
lock is held, allowing concurrent LRU operations to make progress and
significantly reducing LRU lock contention.

Link: https://lore.kernel.org/20261113185541.70203-14-baohua@kernel.org
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

