Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410772192F9
	for <mm-commits@vger.kernel.org>; Sat,  6 Dec 2025 21:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765058101; cv=none; b=NJhfS0wK88NclEKYCBiZpR4PQvLoTcvJgljbeNmVkLEYZsvLkf8F3ZnrtQ5w3DIA1q2KlSCYao05uvRvaU7rUVFcS9OB7KUSBjZdywLCdy8ZFlKrkKxD+DaWpnfwVYjB6nXecesUmTAs2Gj+1q/oR0JBnp/owP9cPQWcSs8SH4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765058101; c=relaxed/simple;
	bh=u5FhVzuDwUaGnsAcToob1HfcyLVE+PyXYapMfvUvswo=;
	h=Date:To:From:Subject:Message-Id; b=ZYf5fgnmMslo5lXlpzMFBJStne+8gf7jHvg3vcki1seLSsuCzAN48vfzkGyMgY63v7Vudc23iOGG+MLTsL1VQdkio0169qdjZMD0RGRv7yI3l7FBDld6115NrdjKhXAQ2iFl/RkCDzhc2XEpWPSroD3hhUJbv/BuUucUKXnrs+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oS5ROKPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oS5ROKPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E544DC4CEF5;
	Sat,  6 Dec 2025 21:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765058101;
	bh=u5FhVzuDwUaGnsAcToob1HfcyLVE+PyXYapMfvUvswo=;
	h=Date:To:From:Subject:From;
	b=oS5ROKPwm7RfqClNqUXebN+sTDCp3Y6II7yfdPl89/akGd19tSKdMGOGfqIVqzN0c
	 w07ANNHa9qqZgc/g05Z+yv6EWJTxyJHnJEfWmPdhuGlgFsefW5LLcpyY2jz7zqYTT+
	 nEqjmo19Q5evfN7RCxmW3n4OkxzrpKuA5J1Z6rIE=
Date: Sat, 06 Dec 2025 13:55:00 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lujialin4@huawei.com,lorenzo.stoakes@oracle.com,lance.yang@linux.dev,jaewon31.kim@samsung.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-correct-nr_requested-tracing-in-scan_folios.patch added to mm-unstable branch
Message-Id: <20251206215500.E544DC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: correct nr_requested tracing in scan_folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-correct-nr_requested-tracing-in-scan_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-correct-nr_requested-tracing-in-scan_folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-vmscan-correct-nr_requested-tracing-in-scan_folios.patch

