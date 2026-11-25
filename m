Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795638971;
	b=pFUSYDmJPaPZLVwI5FEvxYPpMvJ2aeAKKk4BpYkQQnbvqn7T476DGnDmOb3p7Iat6y9Z
	 LuzWoz+fNQ6an8nrcIUlAKO31iLEKpPqHGqcIxcDrVfzNbmqu9XW2gJ0tZYQF7JnkxGGs
	 4GV9H2URbETfbCkUoi14gojasw2PevOMaLb37SQAH4EblDYs5y3NOWyQjCvmEI1fkL1py
	 OKtskTBXlBJ51C/DJ5tWrorQ0+D45EkY5eT2E4xwjhRXE5sTc2ouKogQOOGECk4t5bDmx
	 lKlnh7mUV359EQOHSaezUINgxHFLdZYT3k16fg6g90acZyNTnteyIAfKJSiVtuJV2PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795638971;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=di4WNOA8s6gd3Z9egB1KHYJVbECTwr9tLSpxnolmYWM=;
	b=YDcE4Hb0i3oLnJMK75mx2JHP9WUByqt6uGdqJhmbHaG8vMlANoAgB7uUDzWkGXzu5NLJ
	 uzt/RM2L2N77TaJm1toKW7klCGW/m6OmeD0vUUUMkMrMwBdWQTrkiOd49hLmw5OEeiVS+
	 kEbPjXTmbBhaeEVKiPHa9b4+7oBBaaoHrtAUcyX/MDEKMI9F5kF/RhA7TLdjzxmaM5Nd0
	 RcFi6TXXPbdjbxE++Oaj0sRiykCQpiDIw+03QNlC0fo34/o3FfCuJwn7l84dCE71JZ4Il
	 /SPpAeF/2wT3dAEU3gBiboPUIXaeTC6WSe6dhrUqfBBq96LSbFMM+kOCRqmFK4hCxgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sz7oI5fj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3D5606A321
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 20:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sz7oI5fj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D28B1F000C4;
	Wed, 25 Nov 2026 20:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795638971;
	bh=di4WNOA8s6gd3Z9egB1KHYJVbECTwr9tLSpxnolmYWM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=sz7oI5fjQSxj5/ohgLMMwI3s2q0LPgZBqm0i9vpZSLhojmIQlT5ZgqP+nTJKvejkO
	 KPresmDxnRKOgCxOxcYCrWlccQ0IvRYDemWZB6beyKIQH5h1qR3QWlEZ7d+5L4GQjg
	 LxdD8IKBNREge8stZsz6zQO13yo9GPVqIrznM6Sg=
Date: Wed, 25 Nov 2026 12:36:10 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-13-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-13-8ffea39934a6@tencent.com>
Subject: [to-be-updated] mm-khugepaged-convert-to-lru-refs-based-operations-for-mglru.patch removed from -mm tree
Message-Id: <20261125203611.0D28B1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/khugepaged: convert to LRU refs based operations for MGLRU
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-convert-to-lru-refs-based-operations-for-mglru.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/khugepaged: convert to LRU refs based operations for MGLRU
Date: Tue, 24 Nov 2026 02:53:05 +0800

For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
count, so folios with nonzero even refs no longer have the bit set.
folio_pte_referenced() testing the raw bit misses hot folios at
refs 2, 4 or 6, under-counting the referenced folios of a candidate range
and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.

Test the refs count directly when MGLRU is enabled, mirroring the
smaps conversion.  The classical LRU keeps the plain bit test.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-13-8ffea39934a6@tencent.com
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

 mm/khugepaged.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-convert-to-lru-refs-based-operations-for-mglru
+++ a/mm/khugepaged.c
@@ -579,7 +579,9 @@ static bool folio_pte_referenced(struct
 		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
 	/* The folio was referenced previously ... */
-	if (folio_test_young(folio) || folio_test_referenced(folio))
+	if (folio_test_young(folio))
+		return true;
+	if (folio_check_lru_refs(folio))
 		return true;
 	/* ... or the PTE mapping was recently used */
 	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
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
mm-madvise-adapt-for-lru-refs-based-operations-for-mglru.patch
mm-huge_memory-mark-folio-as-accessed-more-accurately-on-split.patch
mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch
mm-mglru-folio-lru-refs-based-active-inactive-number-accounting.patch
mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

