Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C17C3043D5
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308393; cv=none; b=DUqJJALvhYxe8wToP7ZrJnJgzBBjv0ZaudYdsIn7UeQOauupJ85bT8pcriVGQjGXqj+Kdpipr+Bd9MQjSOxRjmHQ7rRSg+Gt39/WNQ9b0tlgXErSBuUs8YwoO4axLVKYEtQ6JjnEyt8A1we/KCTCuhwuysTpo9VQ2MzWUXX+udY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308393; c=relaxed/simple;
	bh=+6coB6QsLqlfOzjpOzYW9PldZnodFWNlgVMbVa4heuA=;
	h=Date:To:From:Subject:Message-Id; b=f8buQa4xUCzEzWQPPrjERnOlZ5kUBHKNRg6Y426yXw7kbtw34DdA6VX7YslNA5hzP+83ye+NIsfxD2VVs//g3oAhVYX2rAZWrVFUsuA7IG5bh1cZYORCD/sTiFoqIy7eBEgn5uRxijd0VYruwV53oPhy0LgOTRNF5hJ/UiuCZT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=smfy8p/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="smfy8p/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C77C4CEF5;
	Tue,  9 Dec 2025 19:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308392;
	bh=+6coB6QsLqlfOzjpOzYW9PldZnodFWNlgVMbVa4heuA=;
	h=Date:To:From:Subject:From;
	b=smfy8p/I3cQTo3II2wydZpe4e9Rv9Jv1h6zHBLm/cyh96uQxpigBXeivBSod3jfpX
	 H34tNlG6M7hWBuBEvNKkW4r90Hck97miyI/rXrOgF47TJ0aEBpnpQDvfSzxFrPGHHO
	 D11Spxt1s41BI9dBfniWeNrR+VdOkVI9xZDcGJJY=
Date: Tue, 09 Dec 2025 11:26:32 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lujialin4@huawei.com,lorenzo.stoakes@oracle.com,lance.yang@linux.dev,jaewon31.kim@samsung.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-correct-nr_requested-tracing-in-scan_folios.patch removed from -mm tree
Message-Id: <20251209192632.84C77C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: correct nr_requested tracing in scan_folios
has been removed from the -mm tree.  Its filename was
     mm-vmscan-correct-nr_requested-tracing-in-scan_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ridong <chenridong@huawei.com>
Subject: mm: vmscan: correct nr_requested tracing in scan_folios
Date: Thu, 4 Dec 2025 12:23:55 +0000

When enabling vmscan tracing, it is observed that nr_requested is always
4096, which is confusing.

        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...

This is because it prints MAX_LRU_BATCH, which is meaningless as it's a
constant.  To fix this, modify it to print capped valued.

Link: https://lkml.kernel.org/r/20251204122355.1822919-1-chenridong@huaweicloud.com
Fixes: 8c2214fc9a47 ("mm: multi-gen LRU: reuse some legacy trace events")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lu Jialin <lujialin4@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-correct-nr_requested-tracing-in-scan_folios
+++ a/mm/vmscan.c
@@ -4541,7 +4541,8 @@ static int scan_folios(unsigned long nr_
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
-	int remaining = min(nr_to_scan, MAX_LRU_BATCH);
+	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
+	int remaining = scan_batch;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
@@ -4601,7 +4602,7 @@ static int scan_folios(unsigned long nr_
 	count_memcg_events(memcg, item, isolated);
 	count_memcg_events(memcg, PGREFILL, sorted);
 	__count_vm_events(PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
_

Patches currently in -mm which might be from chenridong@huawei.com are


