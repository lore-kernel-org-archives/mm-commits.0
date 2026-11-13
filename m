Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794599447;
	b=GXKJBlYINn/bnOhyLU23iVK+sFuWueQF/xC1V4dpXMSo4JaGwfKm8maL9tja6B76IyGZ
	 kLkhC9I9+zIBxaJU39O1EmlbFXHeqW8yf6gd8RrVwP30dqoy6eSRXsKp2TsKjgP1hzYTW
	 1QD66mjcrpyIpH7hT0QK7mLxvwzJkjXv6J5a8XQ7uMggROaNtdacezF6SDIQ+kdTR0XZs
	 qV62usot/umfy1kDEwS87WwU13z53wFW0umdqL4bBiW8ugmGS6cUj7eiNQ0KIz3hW8Krb
	 r3EFB/kDbR3XR6Etwb8Id0PdE8Q4sh3Cb8kQHsqtEpTqfJBLoRk9sG9YqDVEsVKMZxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794599447;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=O0boy3b0DaDqU4wW6masnC7ZtzsASU9zSj84OM4jQiE=;
	b=xtUwhjWEfNKnkRzSoOtl1PbNZ9yInDq3n9+h/qzjon2MjFwfyrSUwSou0yjyJ874McIV
	 V25bNS0DvljQYAbTr8m3MeKDUiaaYiCRSFDvVzTWLutF6G1kXGJlQOQuziil6q4ZVTwcU
	 lcaGYWdomKvAsMaZe5yhBc6ujlAJ7lJ7fffLfzjZHWsb7v33tSWxkUTpqifyylhW6qxU4
	 JtgXrZhOYoy/RV2SrIpMR1ljZNeM6VkloEs/tTXlEAM/nSkn5gW+1YqrVBrOY0PanvJhu
	 p1I8QzevQm9sQJHYz8wtsAwZ/U/2NLiwIKGk1O+TKpy+CjWT3jjZZ2wDDdmO43HtJxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JIZVMiBi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9685E606A330
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JIZVMiBi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDA61F000C4;
	Fri, 13 Nov 2026 19:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794599447;
	bh=O0boy3b0DaDqU4wW6masnC7ZtzsASU9zSj84OM4jQiE=;
	h=Date:To:From:Subject;
	b=JIZVMiBiTKStaUNmZpj3GXYCaxB5F1WAFya4ceX0THdQKo7Otq5Y8yl5rpcyeY9Wy
	 LEplpde3NIydZmDg+BR6KAkvq5GbPWF+GMCEsi1C35rSpVso4OxM6xb+Z4vcWxWjot
	 glJSJ2eu5GLUwR/krRn5CHfBiarRRJyUlklGmIcU=
Date: Fri, 13 Nov 2026 11:50:46 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch added to mm-new branch
Message-Id: <20261113195047.1EDA61F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: return for unavailable anon reclaim earlier
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch

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

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

