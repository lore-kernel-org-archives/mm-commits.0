Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4874322A
	for <mm-commits@vger.kernel.org>; Sat, 10 May 2025 00:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746835652; cv=none; b=GbZcaOjNnCkW3CHB+lTPKpFRTXgGH7w20G90l2gF0Lzc9CdvdDYrvf+ZGQ1W6wzqQDK0YfpyOJt/Sj5r4FqhOM3ig8T0jpaHZmpsdMjSt+V9CRWLVXR596IAgLOwCu/2WHYBMqNDv5kHcQjYHXMFN2X5fekuLXFC5LbGeDHifoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746835652; c=relaxed/simple;
	bh=ayo/sNK3UV8ooZ5Ba/CQxS4OmZEyhqjWjglUyxz4FcI=;
	h=Date:To:From:Subject:Message-Id; b=EZBVge3UY2q7H5dWpKHvUBojIX4U41nOzl/Dv+EoOUV4wxYLQZO/h7KmBnckhvXAzQarL3Qrt3V9WjVrUj30w+DS8QGwkDNqUtghIU0dxydNzsx1Pbw3Z8u88tyQIiyzVpBCPYrZk/bHnuaMPU1/2M7XM2PQjwiDReES4f+0nKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l3vwaFrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l3vwaFrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125ADC4CEE4;
	Sat, 10 May 2025 00:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746835652;
	bh=ayo/sNK3UV8ooZ5Ba/CQxS4OmZEyhqjWjglUyxz4FcI=;
	h=Date:To:From:Subject:From;
	b=l3vwaFrbNw6Z9hl/TENqLmYjXls0wMNYRlfxYOj9fbn4Un9Zdd3uWoHmt+vSpjbIA
	 yQYLpds6Q8F792eR9FxB8mxnC4DoyIl7omTsv3ipNpkzmhYQnPS/N6rLeZyIGE1Evh
	 uwvQfg7LrHfC/ElSw0LSfF19zR9toYcDRA/xzrws=
Date: Fri, 09 May 2025 17:07:31 -0700
To: mm-commits@vger.kernel.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange.patch added to mm-new branch
Message-Id: <20250510000732.125ADC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cma: set early_pfn and bitmap as a union in cma_memrange
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim.patch
mm-vmscan-add-more-comments-about-cache_trim_mode.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update.patch
mm-using-swappiness_anon_only-in-mglru.patch
mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange.patch

