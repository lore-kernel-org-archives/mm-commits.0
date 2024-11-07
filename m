Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543BC2178FC
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017725; cv=none; b=OHGTGVR2YkZ+5C5L3ZKMQqkQLUGGIIMLzJt20pGb+Nfs5hjQxK/qsRYDqWB2japqKR4o45lJUNzINt58qLc53hW8PvU2CZFnuSiN+Cvv3JG+yXHhl1nblszphORpyc7RryR4cyDnDH2Y4y33+AhtFalEFITQM1943eTUBAfkRk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017725; c=relaxed/simple;
	bh=EV7vYp2jp72kkW0ovEfu3Kl6lsLEfj4og6//A1AsV8E=;
	h=Date:To:From:Subject:Message-Id; b=fGnlkOjOZuaW9132+5BGirte7/+Wa6FEO3ivjcOSPDGiyEE4sP06Gv6SKtqYf90kTt0kurPXeA1nhgKg+QzhmqUROGIRLOzJZBZ3RfXhRDqOYAofOz1X7tv/zJ1gaf9LaraRx3DobRRk5zI8av039/xhXrYghvvLlxKK1qKPBDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BBLJTAr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BBLJTAr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AAAC4CECC;
	Thu,  7 Nov 2024 22:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017724;
	bh=EV7vYp2jp72kkW0ovEfu3Kl6lsLEfj4og6//A1AsV8E=;
	h=Date:To:From:Subject:From;
	b=BBLJTAr1r2QbzXu87S5qwUk/NpgCpopI+ptWA4WXC1o4Y4b4EmVUiqnbLqKHQfSN5
	 yx9NWip86vMSumCFoghyZO3XanEkI8w3liCNIeVKLvsRE/Dgghh1Qw+pTljAfdBiZD
	 2cfX6GDCvhk5ubhJoC2kwsD7tAO/6nTnEDUpRObI=
Date: Thu, 07 Nov 2024 14:15:24 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rientjes@google.com,linkl@google.com,hannes@cmpxchg.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-keep-track-of-free-highatomic.patch removed from -mm tree
Message-Id: <20241107221524.D3AAAC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: keep track of free highatomic
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-keep-track-of-free-highatomic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/page_alloc: keep track of free highatomic
Date: Mon, 28 Oct 2024 12:26:53 -0600

OOM kills due to vastly overestimated free highatomic reserves were
observed:

  ... invoked oom-killer: gfp_mask=0x100cca(GFP_HIGHUSER_MOVABLE), order=0 ...
  Node 0 Normal free:1482936kB boost:0kB min:410416kB low:739404kB high:1068392kB reserved_highatomic:1073152KB ...
  Node 0 Normal: 1292*4kB (ME) 1920*8kB (E) 383*16kB (UE) 220*32kB (ME) 340*64kB (E) 2155*128kB (UE) 3243*256kB (UE) 615*512kB (U) 1*1024kB (M) 0*2048kB 0*4096kB = 1477408kB

The second line above shows that the OOM kill was due to the following
condition:

  free (1482936kB) - reserved_highatomic (1073152kB) = 409784KB < min (410416kB)

And the third line shows there were no free pages in any
MIGRATE_HIGHATOMIC pageblocks, which otherwise would show up as type 'H'. 
Therefore __zone_watermark_unusable_free() underestimated the usable free
memory by over 1GB, which resulted in the unnecessary OOM kill above.

The comments in __zone_watermark_unusable_free() warns about the potential
risk, i.e.,

  If the caller does not have rights to reserves below the min
  watermark then subtract the high-atomic reserves. This will
  over-estimate the size of the atomic reserve but it avoids a search.

However, it is possible to keep track of free pages in reserved highatomic
pageblocks with a new per-zone counter nr_free_highatomic protected by the
zone lock, to avoid a search when calculating the usable free memory.  And
the cost would be minimal, i.e., simple arithmetics in the highatomic
alloc/free/move paths.

Note that since nr_free_highatomic can be relatively small, using a
per-cpu counter might cause too much drift and defeat its purpose, in
addition to the extra memory overhead.

Dependson e0932b6c1f94 ("mm: page_alloc: consolidate free page accounting") - see [1]

[akpm@linux-foundation.org: s/if/else if/, per Johannes, stealth whitespace tweak]
Link: https://lkml.kernel.org/r/20241028182653.3420139-1-yuzhao@google.com
Link: https://lkml.kernel.org/r/0d0ddb33-fcdc-43e2-801f-0c1df2031afb@suse.cz [1]
Fixes: 0aaa29a56e4f ("mm, page_alloc: reserve pageblocks for high-order atomic allocations on demand")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Link Lin <linkl@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/page_alloc.c        |   10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-keep-track-of-free-highatomic
+++ a/include/linux/mmzone.h
@@ -823,6 +823,7 @@ struct zone {
 	unsigned long watermark_boost;
 
 	unsigned long nr_reserved_highatomic;
+	unsigned long nr_free_highatomic;
 
 	/*
 	 * We don't know if the memory that we're going to allocate will be
--- a/mm/page_alloc.c~mm-page_alloc-keep-track-of-free-highatomic
+++ a/mm/page_alloc.c
@@ -635,6 +635,8 @@ compaction_capture(struct capture_contro
 static inline void account_freepages(struct zone *zone, int nr_pages,
 				     int migratetype)
 {
+	lockdep_assert_held(&zone->lock);
+
 	if (is_migrate_isolate(migratetype))
 		return;
 
@@ -642,6 +644,9 @@ static inline void account_freepages(str
 
 	if (is_migrate_cma(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, nr_pages);
+	else if (is_migrate_highatomic(migratetype))
+		WRITE_ONCE(zone->nr_free_highatomic,
+			   zone->nr_free_highatomic + nr_pages);
 }
 
 /* Used for pages not on another list */
@@ -3079,11 +3084,10 @@ static inline long __zone_watermark_unus
 
 	/*
 	 * If the caller does not have rights to reserves below the min
-	 * watermark then subtract the high-atomic reserves. This will
-	 * over-estimate the size of the atomic reserve but it avoids a search.
+	 * watermark then subtract the free pages reserved for highatomic.
 	 */
 	if (likely(!(alloc_flags & ALLOC_RESERVES)))
-		unusable_free += z->nr_reserved_highatomic;
+		unusable_free += READ_ONCE(z->nr_free_highatomic);
 
 #ifdef CONFIG_CMA
 	/* If allocation can't use CMA areas don't use free CMA pages */
_

Patches currently in -mm which might be from yuzhao@google.com are


