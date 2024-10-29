Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB292BAF9;
	Tue, 29 Oct 2024 00:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730163486; cv=none; b=HRnGH0kl6sYVeEYWRXYDJkej1UqyX0HgNf+YrfXJ+HGuQPPweVbfWPk977PMniKGrw+rW/NHFxOyNDLuJW8dOnr5E+HK/E1cNlI5FfDuqaGNT4mjnO7E5d9UA28GcKcohy9gyRtUKI/4Webug1B7Y0iARnaNQAZquXtf2YcUEOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730163486; c=relaxed/simple;
	bh=la4JUGIrjRPsfL/hd6gTQpOEO0qZV8/H3WHRzJr5VHA=;
	h=Date:To:From:Subject:Message-Id; b=sQqzbt01Isy5qPKQeyrPmvXBURT1NILpElDBR7915bKqZu8pu06OtjYSzy83K7gwQG0RnC7HdlOFOJ0LvM1QQzOoMAcAFYW9N15OyDCQgKbDqJKX+nnE2IjwUYiJ5CxQJg9kw+c0Wxyjk1XqCnnmBdhlDCLdLJewnPovnf5oCXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MXP99Dmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MXP99Dmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEF2C4CEC3;
	Tue, 29 Oct 2024 00:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730163485;
	bh=la4JUGIrjRPsfL/hd6gTQpOEO0qZV8/H3WHRzJr5VHA=;
	h=Date:To:From:Subject:From;
	b=MXP99DmhLNqjS9mTxHyvZb+hDv7Vwkr4pWpR8dsKP8kuDqFltbpPSsiFS2SWFPGkj
	 EQehsA1hUtXTMn4jbQKzTwBxSRjoKPRNU4pLpNtDEYgqJR/XHvibtiMCkeF3rkBFcB
	 BU+iPUZRP6oKPgFM6r1wk9LDcYZbISrhmI5I7Txk=
Date: Mon, 28 Oct 2024 17:58:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,rientjes@google.com,linkl@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-keep-track-of-free-highatomic.patch added to mm-hotfixes-unstable branch
Message-Id: <20241029005805.9BEF2C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: keep track of free highatomic
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-keep-track-of-free-highatomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-keep-track-of-free-highatomic.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

Link: https://lkml.kernel.org/r/20241028182653.3420139-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Link Lin <linkl@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.12+]
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
+
+	if (is_migrate_highatomic(migratetype))
+		WRITE_ONCE(zone->nr_free_highatomic, zone->nr_free_highatomic + nr_pages);
 }
 
 /* Used for pages not on another list */
@@ -3081,11 +3086,10 @@ static inline long __zone_watermark_unus
 
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

mm-allow-set-clear-page_type-again.patch
mm-multi-gen-lru-remove-mm_leaf_old-and-mm_nonleaf_total-stats.patch
mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch
mm-page_alloc-keep-track-of-free-highatomic.patch

