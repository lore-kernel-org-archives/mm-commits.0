Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7368E170854;
	Wed, 21 Aug 2024 20:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724270873; cv=none; b=qa07Exop2F0behE978VWIy2uBJTgshrHSb2jHWuw/J/DrsPQpdw1Hfdnu7mUvL/+M9L0lshN/9DzEozZMb5SgFteNUMc+o5BIjK3fPwfrY/jQYe/+U+ZmbgNnQapG8t9RpNbpqAZLvABhLPvm8KoZqlpon7NJ1TeuB5IrBQcZK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724270873; c=relaxed/simple;
	bh=GNVLiZ5ygNrXffL6ds9GHFULUnbe5MiagZ6/faSJb90=;
	h=Date:To:From:Subject:Message-Id; b=WDrhQ1VpV6TDOQsMDELrPbVvxxXSleBphTHjrl9ajsH/bnS11om/J+ebJzw4ckYZrKHU3N8onCS52RXVBW8SV6LSQCBw/kBUCLPJtmk7cN0iKv3IhtgYoxANxf+T6/CYzfi9xC+M/fAqhlbtHL4zc4qwcpRJcdlmK/jtyuN4WsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aok85hY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aok85hY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7CEC32781;
	Wed, 21 Aug 2024 20:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724270873;
	bh=GNVLiZ5ygNrXffL6ds9GHFULUnbe5MiagZ6/faSJb90=;
	h=Date:To:From:Subject:From;
	b=aok85hY9t6f8jVCWoUUFEakGQTMdfQStPxa2Bc86ZPev9TuXOtojndFyJUf1uYRZI
	 LhXix4Go9WiELUMNeGC+Jv1jyowZB4RAfIITv0mE27gPgIs5OT+W+MGGHEHk6qgUu3
	 YQy9d8+wLLDpQHkAY15po3mR3Tmzf1XkC0IwvqgQ=
Date: Wed, 21 Aug 2024 13:07:55 -0700
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,yuzhao@google.com,willy@infradead.org,vbabka@suse.cz,stable@vger.kernel.org,riel@surriel.com,leitao@debian.org,huangzhaoyang@gmail.com,hannes@cmpxchg.org,david@redhat.com,bharata@amd.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-skip-cma-pages-when-they-are-not-available.patch added to mm-hotfixes-unstable branch
Message-Id: <20240821200752.DC7CEC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm: skip CMA pages when they are not available"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-skip-cma-pages-when-they-are-not-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-skip-cma-pages-when-they-are-not-available.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: Revert "mm: skip CMA pages when they are not available"
Date: Wed, 21 Aug 2024 20:26:07 +0100

This reverts commit 5da226dbfce3a2f44978c2c7cf88166e69a6788b.

lruvec->lru_lock is highly contended and is held when calling
isolate_lru_folios.  If the lru has a large number of CMA folios
consecutively, while the allocation type requested is not MIGRATE_MOVABLE,
isolate_lru_folios can hold the lock for a very long time while it skips
those.  For FIO workload, ~150million order=0 folios were skipped to
isolate a few ZONE_DMA folios [1].  This can cause lockups [1] and high
memory pressure for extended periods of time [2].

[1] https://lore.kernel.org/all/CAOUHufbkhMZYz20aM_3rHZ3OcK4m2puji2FGpUpn_-DevGk3Kg@mail.gmail.com/
[2] https://lore.kernel.org/all/ZrssOrcJIDy8hacI@gmail.com/

Link: https://lkml.kernel.org/r/9060a32d-b2d7-48c0-8626-1db535653c54@gmail.com
Fixes: 5da226dbfce3 ("mm: skip CMA pages when they are not available")
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/mm/vmscan.c~revert-mm-skip-cma-pages-when-they-are-not-available
+++ a/mm/vmscan.c
@@ -1604,25 +1604,6 @@ static __always_inline void update_lru_s
 
 }
 
-#ifdef CONFIG_CMA
-/*
- * It is waste of effort to scan and reclaim CMA pages if it is not available
- * for current allocation context. Kswapd can not be enrolled as it can not
- * distinguish this scenario by using sc->gfp_mask = GFP_KERNEL
- */
-static bool skip_cma(struct folio *folio, struct scan_control *sc)
-{
-	return !current_is_kswapd() &&
-			gfp_migratetype(sc->gfp_mask) != MIGRATE_MOVABLE &&
-			folio_migratetype(folio) == MIGRATE_CMA;
-}
-#else
-static bool skip_cma(struct folio *folio, struct scan_control *sc)
-{
-	return false;
-}
-#endif
-
 /*
  * Isolating page from the lruvec to fill in @dst list by nr_to_scan times.
  *
@@ -1669,8 +1650,7 @@ static unsigned long isolate_lru_folios(
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		if (folio_zonenum(folio) > sc->reclaim_idx ||
-				skip_cma(folio, sc)) {
+		if (folio_zonenum(folio) > sc->reclaim_idx) {
 			nr_skipped[folio_zonenum(folio)] += nr_pages;
 			move_to = &folios_skipped;
 			goto move;
@@ -4273,6 +4253,25 @@ void lru_gen_soft_reclaim(struct mem_cgr
 
 #endif /* CONFIG_MEMCG */
 
+#ifdef CONFIG_CMA
+/*
+ * It is waste of effort to scan and reclaim CMA pages if it is not available
+ * for current allocation context. Kswapd can not be enrolled as it can not
+ * distinguish this scenario by using sc->gfp_mask = GFP_KERNEL
+ */
+static bool skip_cma(struct folio *folio, struct scan_control *sc)
+{
+	return !current_is_kswapd() &&
+			gfp_migratetype(sc->gfp_mask) != MIGRATE_MOVABLE &&
+			folio_migratetype(folio) == MIGRATE_CMA;
+}
+#else
+static bool skip_cma(struct folio *folio, struct scan_control *sc)
+{
+	return false;
+}
+#endif
+
 /******************************************************************************
  *                          the eviction
  ******************************************************************************/
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

revert-mm-skip-cma-pages-when-they-are-not-available.patch

