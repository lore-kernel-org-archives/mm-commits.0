Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9742A22DF9E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846621; cv=none; b=ZeOmx3xd4EovUVtJDSRa7od01+XAyIpbX4cGU4zviJ2r91W7UxIG/k9DQP72BW6LuPpuGDyPdz8m5oJD4OI2OMcWiWzmYIs9tmD9boCY+2uSO8Z4i0cWXAoh4FNp5MPuQAtuJtrj9d/NW0t9y+3c7s7fjBdzE7TF0bHiB1v+3Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846621; c=relaxed/simple;
	bh=MLden/K6wV5qS6ZT6bnkjfynNjSJzUK4zFM2Ld+7E70=;
	h=Date:To:From:Subject:Message-Id; b=gipGmjCcqCsd5HPk/CjsUX0K9PMfQwkhK02YvMHOc5uLbDGL8cHBM+3ui9DKss6vHZrJBYqlzJp6vpZ6IvoKEajdGi9is/5yHaKlizzEUZk0iwV2mswvgmDqXKi7tPEVWUGvwW73qPyVUfefAakaM6WOknJJXAOp1Dtf4hHPZ2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nqB6xUhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nqB6xUhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69001C4CEE4;
	Wed, 21 May 2025 16:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846621;
	bh=MLden/K6wV5qS6ZT6bnkjfynNjSJzUK4zFM2Ld+7E70=;
	h=Date:To:From:Subject:From;
	b=nqB6xUhG38WtzP+j19VULjE7zPWo7wy2RRa2R9oJWzrj+V8eEnWs41oF+mxCBuai5
	 q6UtA9v1woFX1fDObXp68HlKQTD3UKZ66mYf+38u/1MGYHuPv00qfU/NcO036p2Bmg
	 OHHZp9gvpg6OnEr/WgJ1N5+36czSbRmMJujytWq8=
Date: Wed, 21 May 2025 09:57:00 -0700
To: mm-commits@vger.kernel.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange.patch removed from -mm tree
Message-Id: <20250521165701.69001C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cma: set early_pfn and bitmap as a union in cma_memrange
has been removed from the -mm tree.  Its filename was
     mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: cma: set early_pfn and bitmap as a union in cma_memrange
Date: Fri, 9 May 2025 16:35:28 +0800

Since early_pfn and bitmap are never used at the same time, they can be
defined as a union to reduce the size of the data structure.  This change
can save 8 * u64 entries per CMA.

Link: https://lkml.kernel.org/r/20250509083528.1360952-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   11 ++++++-----
 mm/cma.h |    6 ++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/mm/cma.c~mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange
+++ a/mm/cma.c
@@ -143,13 +143,14 @@ bool cma_validate_zones(struct cma *cma)
 
 static void __init cma_activate_area(struct cma *cma)
 {
-	unsigned long pfn, end_pfn;
+	unsigned long pfn, end_pfn, early_pfn[CMA_MAX_RANGES];
 	int allocrange, r;
 	struct cma_memrange *cmr;
 	unsigned long bitmap_count, count;
 
 	for (allocrange = 0; allocrange < cma->nranges; allocrange++) {
 		cmr = &cma->ranges[allocrange];
+		early_pfn[allocrange] = cmr->early_pfn;
 		cmr->bitmap = bitmap_zalloc(cma_bitmap_maxno(cma, cmr),
 					    GFP_KERNEL);
 		if (!cmr->bitmap)
@@ -161,13 +162,13 @@ static void __init cma_activate_area(str
 
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
-		if (cmr->early_pfn != cmr->base_pfn) {
-			count = cmr->early_pfn - cmr->base_pfn;
+		if (early_pfn[r] != cmr->base_pfn) {
+			count = early_pfn[r] - cmr->base_pfn;
 			bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
 		}
 
-		for (pfn = cmr->early_pfn; pfn < cmr->base_pfn + cmr->count;
+		for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
 	}
@@ -193,7 +194,7 @@ cleanup:
 		for (r = 0; r < allocrange; r++) {
 			cmr = &cma->ranges[r];
 			end_pfn = cmr->base_pfn + cmr->count;
-			for (pfn = cmr->early_pfn; pfn < end_pfn; pfn++)
+			for (pfn = early_pfn[r]; pfn < end_pfn; pfn++)
 				free_reserved_page(pfn_to_page(pfn));
 		}
 	}
--- a/mm/cma.h~mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange
+++ a/mm/cma.h
@@ -25,9 +25,11 @@ struct cma_kobject {
  */
 struct cma_memrange {
 	unsigned long base_pfn;
-	unsigned long early_pfn;
 	unsigned long count;
-	unsigned long *bitmap;
+	union {
+		unsigned long early_pfn;
+		unsigned long *bitmap;
+	};
 #ifdef CONFIG_CMA_DEBUGFS
 	struct debugfs_u32_array dfs_bitmap;
 #endif
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are


