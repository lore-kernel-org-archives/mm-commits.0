Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794693557;
	b=Z9F7qFewQ7cKYiyQ09XDCGp72hcIOi+Tyk085FXs6kgti5/te5dQ1mIDeEEhF6ZHvF/C
	 fq/5bFW0GHOdnXmM2jgIlYsbQtcCecXlG+qY3kMKRR0pPaTeuViU05bcaUf+oI68DOM7W
	 s5/v9UC8MytbXx4XxYwVk/aOGbQIsh4y5rA4qx6ov7zw0n7zvLqCIJiMNJscBv6kOjzZ7
	 VhHhKrG6URFS/tcivpfIMWppdDftSdiPmTJcu2VEZ/AIpSqgDUHrrsE/GYwTQfFaTYW+2
	 RpQuo3BRXb34H1xe84Mkl48umt0TQSiYZ7Oo1umfpw5KeOAGtmjIVp76BdEuPmGddyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794693557;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=44Yl8f74LITsRVZBB7zSOegRG27uzTMD6McYWlZug2Y=;
	b=ZSmQTb9buk0BhXtAnbhTMdyGuOSs9asP6XGWOCO68HwCDAPzWiqIGOVi3Lg4smfo0ph+
	 rngEqRiOdyDqQHNeEZVTBaIbYvc4FeTVHezR3zZESSq0sfBA7d7jLPWgWSyJFUbI/XqTJ
	 hngjqNZRr/9LuZ5/QC4U617sqjG68ksHVNU5tU3nP25FqGjbmtIV4vXzoXxL5+2eSx1gX
	 6ScSHNttdQEHotxr9GleMPoN243+4d6rqqmEGEWmFN+pszCqqRvoeOzBOwaMywtoEIOlb
	 T7Mnn7axIVDVG1nbMsxfp2V3FiwHVY3fI/JRdVUbMwtdncY13f6FTu+nxNPL/e+b06A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ocxjmNAQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B25606A323
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 21:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ocxjmNAQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9491F000C4;
	Sat, 14 Nov 2026 21:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794693557;
	bh=44Yl8f74LITsRVZBB7zSOegRG27uzTMD6McYWlZug2Y=;
	h=Date:To:From:Subject;
	b=ocxjmNAQVSjXQU+QYtDAs1YY8OlPYaWhVfZ3Wp6TvECc9iLdll1VAuoApgdZaIMya
	 hQpPUgk0PmoPTiZ4Tvoy1KiaBGiu9pQe+l/2CB92/HYCMbbDXCUpMWrp5bom5Miqfo
	 uEPPjDChF569uGN/PLGNHUbMrjJUeSEzYs94zmgQ=
Date: Sat, 14 Nov 2026 13:59:17 -0800
To: mm-commits@vger.kernel.org,lyugaofei@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen.patch removed from -mm tree
Message-Id: <20261114215917.8F9491F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: run aging when pages are rare outside the youngest gen
has been removed from the -mm tree.  Its filename was
     mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Gaofei Lyu <lyugaofei@xiaomi.com>
Subject: mm/mglru: run aging when pages are rare outside the youngest gen
Date: Sat, 14 Nov 2026 02:55:35 +0800

Run aging when the total number of pages outside the youngest generation
across both types falls below 1/MAX_NR_GENS of the number of pages in the
youngest generation.  For extreme swappiness values such as 1 and 200,
also consider the balance of the corresponding type.

This improves reclaim efficiency, especially at extreme swappiness values,
while reducing system time.

To avoid the overhead of aging, we only allow imbalance-based aging when
the reclaim priority is low enough that we might reclaim the youngest
generation.

Link: https://lore.kernel.org/20261113185541.70203-11-baohua@kernel.org
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

 mm/vmscan.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-run-aging-when-pages-are-rare-outside-the-youngest-gen
+++ a/mm/vmscan.c
@@ -5073,6 +5073,41 @@ retry:
 	return scanned;
 }
 
+static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
+		int swappiness)
+{
+	unsigned long youngest[ANON_AND_FILE] = {0}, old[ANON_AND_FILE] = {0};
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	DEFINE_MAX_SEQ(lruvec);
+	DEFINE_MIN_SEQ(lruvec);
+	int type;
+
+	if (sc->priority > DEF_PRIORITY / 2)
+		return false;
+
+	for_each_evictable_type(type, swappiness) {
+		unsigned long seq;
+
+		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		for (seq = min_seq[type]; seq < max_seq; seq++)
+			old[type] += lruvec_gen_size(lrugen, type, seq);
+	}
+
+	/* the vast majority of pages sit in the youngest gen */
+	if (youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
+	    (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS)
+		return true;
+
+	/* Swappiness extremes: the corresponding type matters */
+	if (swappiness == MIN_SWAPPINESS + 1)
+		return youngest[LRU_GEN_FILE] > old[LRU_GEN_FILE] * MAX_NR_GENS;
+
+	if (swappiness == MAX_SWAPPINESS)
+		return youngest[LRU_GEN_ANON] > old[LRU_GEN_ANON] * MAX_NR_GENS;
+
+	return false;
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
@@ -5087,7 +5122,11 @@ static bool should_run_aging(struct lruv
 		return false;
 
 	/* better to run aging even though eviction is still possible */
-	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
+	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
+		return true;
+
+	/* run aging when folios outside the youngest gen are rare */
+	return lru_gen_imbalanced(lruvec, sc, swappiness);
 }
 
 static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
_

Patches currently in -mm which might be from lyugaofei@xiaomi.com are

mm-mglru-avoid-prolonged-anon-reclaim-with-swappiness=200.patch

