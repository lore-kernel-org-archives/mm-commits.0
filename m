Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794693551;
	b=BMqTNkJ18J/yErEeVcTsEOBsvvWfCx16vqpr5GgQckMQx+BL22I+DMrEkoBzu7UE02JB
	 miC69VxDTOAtGng/wA4gD5WBKfSyGHGdCxUXW2kH5LUE4ekB0+k59Gs+srKN6vA3TDnt5
	 YZu555K4iEk3e7PhOoj0MDwCuIo4UIxKdMe0irpDU7sgxkLZ/zEL9BntUl/bQMBx2cfse
	 LYUIpRoxV4/DHVlGDU7rz6EZp+tFaHWKm/8USzZUNpbRx9Zah5/uoUQ2n+F4Y7gv0uELK
	 IdjKGExz8iYHnftDMFaAd/UjboOMb8sMOVYJh1XVYe3tZ+WBNBM6wSAQh3kf6LjQQYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794693551;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3M9pEtivfsoUkZvBK1FYpxEts3Pjd8f9Ex5BZ/tsNjo=;
	b=gDKytPqDyNEgqo4v/no8j4gDavLqm7E44mkau3qhLgVXbqrue6jZtDcE4JEPVyUePoHS
	 wG8ni7/hTImys+66OoMw1bEZtq+KuSSQVb1gmQ7y8lKiEeSsKD4I41gnq/TCly5KVaf2o
	 TnpNKoqZ4d4swEwmev9QOeI/Qv7zyN+Sakfykb1DtOCg64LRgnbZ4wbd/jnjA9ejqwQJf
	 cJS4gerdpGA8tf7jWo2HtdXjGniAATQeOaB+MwFZYmG22mhX65v0ATx8zq76cyl15Hk5z
	 gEBIpA53dlDPi8wQ2vvcZPF2qHuQQKj9y9ztU2Hv1EepyeqfewoDAtgXdxp5ez5UqZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PR0b7w2A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB02606A327
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 21:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PR0b7w2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561931F000C4;
	Sat, 14 Nov 2026 21:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794693551;
	bh=3M9pEtivfsoUkZvBK1FYpxEts3Pjd8f9Ex5BZ/tsNjo=;
	h=Date:To:From:Subject;
	b=PR0b7w2ASo3FJZRxBrHLKIsGGzzTqlz9iSwK0JABHyK5D4wPbpT/kqfLEqpXBrPLf
	 cbcvZDaRpILEw4PRvD6S4BDAGiSVM8bNF7bjzFsCv8k9SsDe6OPvVL44M4afa/CMrm
	 6dCT/ednpmGLrk4TDSh5cElwZgCyySbsCX+2FbKM=
Date: Sat, 14 Nov 2026 13:59:10 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch removed from -mm tree
Message-Id: <20261114215911.561931F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: return for unavailable anon reclaim earlier
has been removed from the -mm tree.  Its filename was
     mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: return for unavailable anon reclaim earlier
Date: Sat, 14 Nov 2026 02:55:31 +0800

No feature change, just shuffle some code, prepare for later commits.

Link: https://lore.kernel.org/20261113185541.70203-7-baohua@kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: <liuxiang.277@bytedance.com>
Cc: <lyugaofei@xiaomi.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Kunwu Chan <chentao@kylinos.cn>
Cc: Bo Zhang <zhangbo0325@gmail.com>
---

 mm/vmscan.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/mm/vmscan.c~mm-mglru-return-for-unavailable-anon-reclaim-earlier
+++ a/mm/vmscan.c
@@ -5060,20 +5060,6 @@ static long get_nr_to_scan(struct lruvec
 			   struct mem_cgroup *memcg, int swappiness)
 {
 	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-	/*
-	 * Proactive reclaim initiated by userspace for anonymous memory only.
-	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
-	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
-	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
-	 * work when there is nothing eligible to reclaim.
-	 */
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
-		WARN_ON_ONCE(!sc->proactive);
-		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
-			return 0;
-	}
 
 	lruvec_evictable_size(lruvec, swappiness, sizes);
 	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
@@ -5126,6 +5112,19 @@ static bool try_to_shrink_lruvec(struct
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
+	 * work when there is nothing eligible to reclaim.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->node_id, sc))
+			return false;
+	}
+
 	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
 	while (nr_to_scan > 0) {
 		int delta;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

