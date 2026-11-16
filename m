Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794804650;
	b=B2v4iI6RyD7ZSATUSPVy9FCb4lByNesQoaedNkslbQ0Wu4NRoTel3yFUi4x2BIAnbjQB
	 L0pnwWMlO5NuGDlQXypYH4XgaXdZV/bqrln93tHm69njLhRj4pFR4qUmqducmgUBwG+dt
	 WO2wKhnistP4SZbvUfRP4EeBwbVpsppWo8vwBNSsp4eIr87hUBuAT/WjeJwbjQtN5YOp/
	 ynXn5MMdQPn9hUCWJYM84bsLtuCxaK24nfIKAuL6f1+DDENhEZU6O2dAzBhg+1t+3jYc8
	 dnEF6si998AjE7VU/Q32ES2JnBpIMCW7ggH9sS7h2tVwMWfrANI2WLPcTA3FEU9aZZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794804650;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=N+kewBmAtNL/iPgGa2XqsENnZCZoA5dXb7cGL3BUX6c=;
	b=XkZTvjiGvaT+VQMROiIrW62JvRlTvh/pJsD0VAha767z8H7bMDZwlQD233UDskQRgS1b
	 0NCvvf2zmQiD1q5yLcP5OgneECOlwTjtXvUq6rRLmeImn0AOBl2j11nK9cKJ1uqlDZc1l
	 4ZJVVqSHiXjwqsTz0QFowXyEGawl8IKyiWCAGF4y8zoeHpwTSKblzd+zf1+aMKD66WVyn
	 lmsQUZz7HFIFqYSs6XxXcyNcil8Ov7yDU3nHVPuSKf8m2O/U9gbPyqgPCA0dpF1xRgXH6
	 55VF7E3T+HHhOMb5LUNqzcb0Ojw6q75g8uQIpcNie+ccBo96lXCfkeNWTj9aV69rdPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="cv+crM8/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F581606A329
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 04:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cv+crM8/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DE61F000C4;
	Mon, 16 Nov 2026 04:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794804650;
	bh=N+kewBmAtNL/iPgGa2XqsENnZCZoA5dXb7cGL3BUX6c=;
	h=Date:To:From:Subject;
	b=cv+crM8/NfcrT99fjHs6+xvmKKBv2K8mCv0PZYlJXNtayeNjT1FbMPfRJ38U/A51d
	 AHYswZrYhRNXcV8Z/QzgBhs30sr0ACqhANowLCgwz0ZpxWquIlnZlkhrifnUP/ocaG
	 KWsjVwG2sjVIJDJqoeUZQUhIr/W0jZXqwYzP3SOM=
Date: Sun, 15 Nov 2026 20:50:49 -0800
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,zhangbo56@xiaomi.com,
	yuanchu@google.com,weixugc@google.com,wangzicheng@honor.com,
	surenb@google.com,sidchintamaneni@gmail.com,shakeel.butt@linux.dev,
	ryncsn@gmail.com,rppt@kernel.org,ridong.chen@linux.dev,qi.zheng@linux.dev,
	mhocko@kernel.org,lyugaofei@xiaomi.com,liuxiang.277@bytedance.com,
	lianux.mm@gmail.com,liam@infradead.org,kunwu.chan@gmail.com,
	hui.zhu@linux.dev,hannes@cmpxchg.org,baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen-fix.patch added to mm-new branch
Message-Id: <20261116045050.43DE61F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: cleanup-mm-mglru-Run-aging-when-pages-are-rare-outside-the-youngest-gen
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen-fix.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: cleanup-mm-mglru-Run-aging-when-pages-are-rare-outside-the-youngest-gen
Date: Mon, 16 Nov 2026 11:48:44 +0800

As suggested by Kairui[1], we don't need youngest and old as
array. just an accumulative value should be enough.

No functional change.

Link: https://lore.kernel.org/20261116042556.42111-1-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kairui Song <ryncsn@gmail.com>
Link: https://lore.kernel.org/linux-mm/CAMgjq7C_cH75JrYs8=P5LbxnDjDD6bqeqsCidOPa=r8Z+42sCQ@mail.gmail.com/ [1]
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
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
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>

 mm/vmscan.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen-fix
+++ a/mm/vmscan.c
@@ -5078,8 +5078,8 @@ retry:
 static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
 		int swappiness)
 {
-	unsigned long youngest[ANON_AND_FILE] = {0}, old[ANON_AND_FILE] = {0};
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	unsigned long youngest = 0, old = 0;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 	int type;
@@ -5099,14 +5099,13 @@ static bool lru_gen_imbalanced(struct lr
 	for_each_evictable_type(type, swappiness) {
 		unsigned long seq;
 
-		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		youngest += lruvec_gen_size(lrugen, type, max_seq);
 		for (seq = min_seq[type]; seq < max_seq; seq++)
-			old[type] += lruvec_gen_size(lrugen, type, seq);
+			old += lruvec_gen_size(lrugen, type, seq);
 	}
 
 	/* the vast majority of pages sit in the youngest gen */
-	return youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
-	       (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS;
+	return youngest > old * MAX_NR_GENS;
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch
mm-mglru-avoid-placing-rejected-folios-below-populated-gen.patch
mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen-fix.patch
mm-mglru-run-aging-when-one-type-is-drained.patch
mm-mglru-run-aging-when-one-type-is-drained-fix.patch
mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

