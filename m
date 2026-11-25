Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795638969;
	b=BvGgDPcxrUCLMluDNiklMKMGb7kSmQhRD0lVsFgC13C8xqr+UfR+wgtsjYpYbu4+HlBF
	 pXuB6CvbAA2sEndCmiZ9W1LrBL2OK6ciWOEeQ8VpZJ1uKPSLa1Rk2jT7YzIATHphJTv3w
	 yag/FawJdL9Nc72k4nTxZ7GKigYCJWOz1fSWItN0PoXikwOpJ09xsbMBxnGPXOV6zQKeZ
	 I+zUMRDdlznaJ5C2AkyjB8CvAYatU+jmfry9mJFrsI9P7qp91L84GfGhqEJd5gyf7XM+Z
	 8ka+OOAxbnbDxv01IteYta8wCUiT62yemaEPn3UioMyT4BhPm3peMhTs0kyNMmcLcXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795638969;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=8w1kDv9Y8BTJ7AnoekVHVwC4+UH60Jeoc1NrTBtqcIs=;
	b=Qhk++EIxjRcngXFmFdBdDVaiG5AaX0EmJJs7KhLJnUma+vj6DfW3SlEZ9x4xqnM92Xnj
	 qoLwu7bY8XSVnQbPamB9fal2wqnB5EmXvRiGShXXiGUYZ9oatlBtOT4KE869phkFJ04Q5
	 E9DlNU476WjD5epgnfV1xIiwC5an6cfnA1eyX6MDqZnT44F4HiDUHtl3j4WXcAU1gZOzO
	 SXghsawyPAKQ/naJ0DV41q3T0DM05w+X9mpXeHveukOqC3M19+mLatm+UrO5OGnJ9w+W/
	 1pjh6UQGSf8TjulpGZrYegSwnOdVINsscgAnDGanQ1B6rRlZcTodrQcWlkWT8PhLFag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PTHnPOha;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77F4606A321
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 20:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PTHnPOha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDCB1F000C0;
	Wed, 25 Nov 2026 20:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795638969;
	bh=8w1kDv9Y8BTJ7AnoekVHVwC4+UH60Jeoc1NrTBtqcIs=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=PTHnPOha4qcFGioDDkRtflbHdGQu//+DZAjzvtxpyovk4i7lZ2pemjcvBUBWetSYR
	 Rmb749NveznmBkYIDCroANO6Rmit/lbFV5GInICW8Vvvbu+POKBPbAdD0Ntv6HdZT3
	 ajIFeB2tUm8xsj1Nn+U5XzRq/8Dqvw/QfMyEcy4I=
Date: Wed, 25 Nov 2026 12:36:08 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-12-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-12-8ffea39934a6@tencent.com>
Subject: [to-be-updated] mm-damon-convert-to-lru-refs-based-operations-for-mglru.patch removed from -mm tree
Message-Id: <20261125203609.3CDCB1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon: convert to LRU refs based operations for MGLRU
has been removed from the -mm tree.  Its filename was
     mm-damon-convert-to-lru-refs-based-operations-for-mglru.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/damon: convert to LRU refs based operations for MGLRU
Date: Tue, 24 Nov 2026 02:53:04 +0800

damon_pa_pageout() cleared PG_referenced directly, which under MGLRU
corrupts the folio's refs count. That flag is now
bit 0 of the count (LRU_REFS_FLAGS).

Reset the count instead under MGLRU.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-12-8ffea39934a6@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Xiang Liu <liuxiang.277@bytedance.com>
Cc: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: Tianyi Chen <hi@tychen.cc>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Harry Yoo <harry@kernel.org>

 mm/damon/paddr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-convert-to-lru-refs-based-operations-for-mglru
+++ a/mm/damon/paddr.c
@@ -279,7 +279,8 @@ static unsigned long damon_pa_pageout(st
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		folio_clear_referenced(folio);
+		/* The region is cold, better drop the hotness info. */
+		folio_clear_lru_refs(folio);
 		folio_test_clear_young(folio);
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
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
mm-khugepaged-convert-to-lru-refs-based-operations-for-mglru.patch
mm-madvise-adapt-for-lru-refs-based-operations-for-mglru.patch
mm-huge_memory-mark-folio-as-accessed-more-accurately-on-split.patch
mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch
mm-mglru-folio-lru-refs-based-active-inactive-number-accounting.patch
mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

