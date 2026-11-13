Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598874;
	b=UGfKQnlUMO5IZ0zvCTpq+5PW9WgFh6gkAoPmYrfqOpk3VnTMRg5HpnEduk7brso26Uvu
	 JBBhLp3g9eMFQdlhDiGsgXXpQeAHqNhDayt6FczLzc6yw3oisP1JUkGOdXB3WJ3+EqScy
	 RkCgNvj6XdbXwjBos6Pv3YMzaefQ67ks3sy174p0bcFoRVBkaSNHh5/isqhOtRXOX/a6M
	 cT0LkH9PPfaXj4SH5ngy4G41RFNmTzvHzjdkn27Zga8wBFfVgo82RRITwGITGDuluHwBQ
	 NJrLhePsS7Vz0T2lkz8wc7rz17RK0VyN758vq1nWvg8IozdjcaHCdTo+hWkGyFSn01g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598874;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=s5lDkUs+uNmDV97XZ+JUpNvo2RRdcewnyWOTKm06d2s=;
	b=s73IDvIYgHdMoQgBg03Kgolx5fhEAcGBp9GF75gVX/iydgLfBWwPyVm1MXOxNN9Tsr0M
	 9e0xU4YVLxEt66NF5orKWJf5Lhurahuouy0+aEpwjmjR4Hq63E9GlNjPbqIO70GdfDh6Q
	 WvEILuSvHJbRjPeXxZVPls3MnQSJcbrv00Og7dj7QFV4qTFzVkB+/lX7cUSch6rjBDHss
	 A5OBEp9fxwlUwbqQrCClJCjpG+kRFpzA4K9zanE7MKSO59L5o3wb+nlCzgAck/XNQ96w1
	 0ZUfmK2KU9KrnxyDvp1CXLnlGWmKuKWSbXrwqoBjhheecOEuFLi/1sTFY3wyrDS1pBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="0p/8W9jq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911AE606A33B
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0p/8W9jq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B95A1F000C8;
	Fri, 13 Nov 2026 19:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794598874;
	bh=s5lDkUs+uNmDV97XZ+JUpNvo2RRdcewnyWOTKm06d2s=;
	h=Date:To:From:Subject;
	b=0p/8W9jqP/XzWBh25JTO8gbM3k2j+gR/enQsXyN/Erw18yFXkKyFBwO1HQ4ZDD3V+
	 fZWXtg9vZhdlcFVyuAZm6C1f/FahlZDmni/UT00G9MVR+7X4leqY4Y3J2YqJCVMZow
	 0QqulqIgGy5MEFKogd+TIzemj56wgA3h15C71XuU=
Date: Fri, 13 Nov 2026 11:41:13 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch removed from -mm tree
Message-Id: <20261113194114.5B95A1F000C8@smtp.kernel.org>
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
Date: Thu, 12 Nov 2026 07:25:53 +0800

No feature change, just shuffle some code, prepare for later commits.

Link: https://lore.kernel.org/20261111232603.9934-7-baohua@kernel.org
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
Cc: Michal Hocko <mhocko@suse.com>
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
---

 mm/vmscan.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/mm/vmscan.c~mm-mglru-return-for-unavailable-anon-reclaim-earlier
+++ a/mm/vmscan.c
@@ -5062,20 +5062,6 @@ static long get_nr_to_scan(struct lruvec
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
@@ -5128,6 +5114,19 @@ static bool try_to_shrink_lruvec(struct
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

