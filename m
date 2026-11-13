Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598877;
	b=qXq+74ULe1bgYwomFhN9jjzrICmUBjGE2KeErIjaxqzkts4xkRVGrzRdjkP9GWzN0GME
	 WPQi8Fq40YvoKm9QpvsZRo5KwjLjLihXG/0Sl4mSvooAf4C8F2Yfpdl5Kh+WzmhGeRzox
	 89put4b3zfjoJHSUNt4O22YoQvELU9Wrfo0pX+oZr4UB6mMvZ3o4YrCUNGkCulMkPo3+d
	 RfHSY3/zmHJPG826TGq2oy+Rx6NnXxvbHfc6UO+yKhNUwgr9I3Ugu/BEZfjY6Eg7BKux4
	 glzeaGdUvrVKCPvwgByPr+yKuP7ZyXsQxfhf4hAfXs1UUf5sz5y7vEYC2qPHcgzFiUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598877;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tmAxQe7kqdr9fp5dnRxl5XhH9VmvJBdZ5/nN3KtZcKk=;
	b=sP6Dp2RDXvyXHOGos53wL0hFKMA7vC6eiadri6PYeIreO4pO1o/iamTmX9BvTNNxpN8y
	 I5FYwtqcjAhTmTgPncGMWTIZad1qJ5CTq5nMZxJMN2iOA913a4VEHdCTs+nfjH8FuXLTH
	 eEZtazAyMgqjKn8SG3umteI5Ao274VVvFzOh8GZkbBnRwEmzcCTol+dpbEJbwL4WG1IQB
	 afMEVES1Cn4BinDH7iRgKynGy4wv2dO2SM7MB5BMr9n0QrWsqZk8kHYCZC2GwNf5k3OUE
	 aCeXAgUunjebGBC3PGBGSVjYQORVIzAOApAn42P9doM4JVd0bcnb+cJDr9RF69n0LBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tjVdpTNm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37710606A331
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tjVdpTNm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26691F000C4;
	Fri, 13 Nov 2026 19:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794598876;
	bh=tmAxQe7kqdr9fp5dnRxl5XhH9VmvJBdZ5/nN3KtZcKk=;
	h=Date:To:From:Subject;
	b=tjVdpTNmpvhuSPc4r6KqIP3WkucfwHXXJUvLUKsI4zDJrXPbpPzZzi95rpkJNyFX/
	 LzCNG0rDQ6LtmPSyTiUQplnfpJ6b+9/cCdEvsdrTz4Lzol86+m1DwsVHHAzWuz4/3Z
	 qnivAW0rpaXfDFSRCCoQyr4YTvdQj9krBqUhf6zE=
Date: Fri, 13 Nov 2026 11:41:16 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch removed from -mm tree
Message-Id: <20261113194116.B26691F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: lift youngest gen protection for higher priority
has been removed from the -mm tree.  Its filename was
     mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: lift youngest gen protection for higher priority
Date: Thu, 12 Nov 2026 07:25:55 +0800

The forced protection of younger generations contradicts the
goal of minimizing the I/O cost of reclaim. Under high memory
pressure, MGLRU can repeatedly trigger premature OOMs, while
the classic LRU does not.

The problem is that aging may fail to keep up with reclaim.
When this happens, reclaimers may all abort prematurely
because they see only empty generations or just two
generations remaining.

Proactive aging does not solve this problem either. The
number of threads performing proactive aging is limited,
while the number of concurrent reclaimers can be much
larger. This is a fundamental limitation of MGLRU. One
possible solution is to use an aging lock. However, the
aging lock introduces significant jitter under heavy memory
pressure and has been reported to cause noticeable lags
on Android.

Furthermore, the generation-based reclaim model can
conflict with the goal of swappiness, which is to minimize
I/O cost rather than blindly follow folio hotness.

The previous commit allowed reclaimers running at
non-default priorities to reclaim up to `lrugen->max_seq`,
while reclaimers at the default priority could reclaim only
up to `lrugen->min_seq`.

This patch further refines generation protection based on
reclaim priority. At the default priority, reclaimers can
reclaim generations down to `lrugen->min_seq - MIN_NR_GENS`.
As reclaim priority increases, reclaimers are progressively
allowed to reclaim younger generations.

With this graduated protection, premature OOMs are no
longer observed, while swappiness is also respected.

Link: https://lore.kernel.org/20261111232603.9934-9-baohua@kernel.org
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

 mm/vmscan.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-mglru-lift-youngest-gen-protection-for-higher-priority
+++ a/mm/vmscan.c
@@ -4774,12 +4774,14 @@ static int scan_folios(unsigned long nr_
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	/*
-	 * Respect the gen hotness distribution at low priority to avoid
-	 * aging and scan cost, but prefer to satisfy the reclaimers request
-	 * when under pressure to respect swappiness more and reduce IO cost.
+	 * Respect hotness at default priority, and only reach into the
+	 * newest generation when under severe pressure, so hot folios are
+	 * not evicted as soon as priority is raised.
 	 */
 	if (sc->priority == DEF_PRIORITY)
-		seq = lrugen->min_seq[type];
+		seq = lrugen->max_seq - MIN_NR_GENS;
+	else if (sc->priority > DEF_PRIORITY / 2)
+		seq = lrugen->max_seq - 1;
 	else
 		seq = lrugen->max_seq;
 
_

Patches currently in -mm which might be from kasong@tencent.com are


