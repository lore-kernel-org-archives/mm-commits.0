Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794446234;
	b=WYtpSoX7k+xQsYh47WCSOPSyGyWA7WldwED51DbbMTmT5HVE1xYBxyTMF1NHQsEfnfcU
	 A9tk1a14OUGb5e7+UddfyD3PPvWZqCIu5XrybVyyiOeLB3+WO4+RxgWlfaTEb16sLNTKo
	 WkCAcPfPiAS4U3BYpDn/ncsU1PnY+K3sRZmbF6BgnJnzYaXN5TNsDLlQjLylQyO0kt5a+
	 rwBgo+eEQXnqC3RlDs20Ipe0z45cJPtcnGT8XPzSZlo2KWlYxbrCxubdYsKm4AmTHcRh8
	 p/zIDJXYTd44cJJQ0ib/sd1gPKF0rSZD4XPkBKhZQV2cF7gukIIIf0WFnTtysCbHFig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794446234;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=yUL/p4JfC8rUp9QUfSWBWo2bOoUht6fpB3AOCRQD1O0=;
	b=igynSiPVgjjLbpoIs0PEmRpAfiM5RAFfnRJniAhuv0V7KySIIZgQBB+qk/woKuWWWfso
	 SEt4yq8Sr4PzR94xRNswfJm4sLc3qJyvmOKJgR1fZe796ZeX7qNIapGtroadXNMWQ5cP/
	 ddiCbnjL1Ec5HyV8HTqNzIYcu31pTFBmMy9sVOQw4jkiOD4HK/owxUaMhuDdqzxnRr8oj
	 kNURI8WNa/9riU5aVH1r4GG52Kj9ZOpWD2zLBZGKpokn/jZtRY5j3DmXAF5FhB6eoF90x
	 AayVxdxzDZYhieChJrOE3mFaWwjGLL/1Qx6gexHywKjtema+1VMKnszyz5mCRibknRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Iexug4Uk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10583606A31C
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 01:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Iexug4Uk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36BC1F00A05;
	Thu, 12 Nov 2026 01:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794446233;
	bh=yUL/p4JfC8rUp9QUfSWBWo2bOoUht6fpB3AOCRQD1O0=;
	h=Date:To:From:Subject;
	b=Iexug4UkL8powuiW4V4K+V3PqMws2mgKd83Rl5D5lXcdwbX9jrZQprKR1LjRPq9em
	 hSebcNUK1B4mu0O57C1JiF/9APWxtk9Z018gwfP1jxRVuaaBS4okQnq2e4Ywl+Dtlr
	 ZUZRSa/JaDm6Z2h47ciLKCCPQc3VO/jhiZPyBtQg=
Date: Wed, 11 Nov 2026 17:17:13 -0800
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,zhangbo56@xiaomi.com,
	yuanchu@google.com,weixugc@google.com,wangzicheng@honor.com,
	surenb@google.com,sidchintamaneni@gmail.com,shakeel.butt@linux.dev,
	ryncsn@gmail.com,rppt@kernel.org,ridong.chen@linux.dev,qi.zheng@linux.dev,
	mhocko@suse.com,lyugaofei@xiaomi.com,liuxiang.277@bytedance.com,
	lianux.mm@gmail.com,liam@infradead.org,kunwu.chan@gmail.com,
	hui.zhu@linux.dev,hannes@cmpxchg.org,chentao@kylinos.cn,baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,
	kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch added to mm-new branch
Message-Id: <20261112011713.C36BC1F00A05@smtp.kernel.org>
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

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

