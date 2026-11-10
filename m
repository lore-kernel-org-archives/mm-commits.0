Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270035;
	b=eOD1sCyq1KvPIBMyss5SwrBcjJrGpcJqVvFlSb+shnUrl+tRVQ2FnKkc2XPkZHWxIwUJ
	 J97LZXs0xf4oAHmEjKHlVR7iA0C/925MgrTGyqMC2x8KY+MVL3RDM5xJtSoyN1p+bGOLx
	 Q7Ee6llBcdooGNPdUVLQWwV4NFKfhizksUb1WrMit2wxYigY85oHOL1BILuKw4tCHxaU1
	 Rvgy4VaDDRyAetWYq8aTr0ezotC4D+60D7Qwmo1OJyXy3kB0Iv3AEdh5mXFPi3al5V0R5
	 uDE5Ougwjs4ElGNHr5YwJn2fD9BkAIm2XW81p4pZnOXw0RgeejLH1DToZVLCOOi5fvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270035;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=vNNx/8wUToSdhYA7ZX2whOn7PJQXw/7TxqowMlheq38=;
	b=X7Q3CiahDEmkDNyzR4ysK7R6XqyyDophyHKnA5C0A/kmP7gueyw8eFKlUwJ1R6cM2z6l
	 01URxrRZBmpW3/cs4btv48SYUzSgNETDs5psOc5RK3m8XR126MHpR2EJzAFlpfBXstkmm
	 kJoM2KMVFgHruF6udw8n+Dp+6mdZg8v0+urgdRRYexFem1EoeFTVTxIzjsG55hugMu8br
	 V1TQlTS/scv1lrdpQR/PP/aV3X13LlNG94bFmQMvZFkoCOke6Ojp9sLvrQN0iUPyJIfkw
	 Xb1zE3JPiRZIsc4HXOl3bPFLVwpFZPBk2pFQyFQoXNMyC8kvqqTEYSlDVttXEI3Hg4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dD2LaXtx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751FF606A335
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 00:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dD2LaXtx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AED1F0089F;
	Tue, 10 Nov 2026 00:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794270035;
	bh=vNNx/8wUToSdhYA7ZX2whOn7PJQXw/7TxqowMlheq38=;
	h=Date:To:From:Subject;
	b=dD2LaXtxHIEr1GYr0bUIL1HaJRQKRGqDKG88Xx6OQXE0zQSUMJzD2OkrAFskX7B8y
	 IxdtIi8GpbdnppEMtzN9AMd2Oo20WvN2/lZYaH4ZARUKImEmBR5eCOWljEPUGpkfKk
	 pwtICG68WGruCTcsGtZTn/a00lmXnp2x8xoal+kU=
Date: Mon, 09 Nov 2026 16:20:34 -0800
To: mm-commits@vger.kernel.org,chengkaitao@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch removed from -mm tree
Message-Id: <20261110002035.26AED1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: preserve persistent flags when returning folios to the pool
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/hugetlb: preserve persistent flags when returning folios to the pool
Date: Mon, 02 Nov 2026 10:49:09 +0800

add_hugetlb_folio() returns a folio to the HugeTLB pool when vmemmap
restoration fails. It clears folio->private and restores only
HPG_vmemmap_optimized, losing other flags that must survive the rollback.

Clearing HPG_cma causes a later free to bypass the CMA release path,
leaving the CMA allocation bitmap set. Clearing HPG_raw_hwp_unreliable
loses the indication that the locations of poisoned subpages are unknown,
undermining the checks that prevent freeing or unpoisoning such folios.

Preserve the existing flags instead of resetting folio->private. Callers
already clear HPG_restore_reserve, HPG_migratable and HPG_freed before
returning a folio to the pool. Clear HPG_temporary in free_huge_folio()
before attempting to free a temporary folio, so a failed vmemmap restore
does not leave that flag set on a folio returned as surplus.

Add a VM_WARN_ON_ONCE_FOLIO() check for flags other than
HPG_vmemmap_optimized, HPG_raw_hwp_unreliable and HPG_cma to detect
incomplete transient flag cleanup.

Link: https://lore.kernel.org/20261102024910.31486-3-kaitao.cheng@linux.dev
Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism of raw error pages")
Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
---

 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool
+++ a/mm/hugetlb.c
@@ -1443,6 +1443,12 @@ void add_hugetlb_folio(struct hstate *h,
 
 	lockdep_assert_held(&hugetlb_lock);
 
+	/* Callers must clear transient flags before returning to the pool. */
+	VM_WARN_ON_ONCE_FOLIO((unsigned long)folio->private &
+			     ~(BIT(HPG_vmemmap_optimized) |
+			       BIT(HPG_raw_hwp_unreliable) |
+			       BIT(HPG_cma)), folio);
+
 	INIT_LIST_HEAD(&folio->lru);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
@@ -1453,9 +1459,6 @@ void add_hugetlb_folio(struct hstate *h,
 	}
 
 	__folio_set_hugetlb(folio);
-	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
-	folio->private = NULL;
-	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	arch_clear_hugetlb_flags(folio);
 	enqueue_hugetlb_folio(h, folio);
@@ -1743,6 +1746,7 @@ void free_huge_folio(struct folio *folio
 		h->resv_huge_pages++;
 
 	if (folio_test_hugetlb_temporary(folio)) {
+		folio_clear_hugetlb_temporary(folio);
 		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-hugetlb-fix-nr_hugetlb-accounting-for-surplus-folios.patch

