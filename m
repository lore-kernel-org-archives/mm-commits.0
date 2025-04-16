Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E712DFA42
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 22:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744842166; cv=none; b=pvQx1YzwNymOSwnTYpTL7pZxzqsXxQVNhoDLxm4P05rCg2qVrYQbiXsEpHkpx/o+TSFaOGs5EJbQD3GW+OiG4dD5enjN6ztNKxhEeUrObMikqJ7iPA5p3KBgVyctyNx5rOMIHok9WM5IF7cmv9YXrHjEpQnDU7abCfpoxgyA8Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744842166; c=relaxed/simple;
	bh=al0pHmBsYMgzq4H32EyjczaRTnXJposHnVY2de26JDI=;
	h=Date:To:From:Subject:Message-Id; b=IQs2x4uZnjISRRQ0LN/9G1IluDdXXD+xjtTvqzdZlfSTlr/vNVuY3orXSA17LzRAboJoZvVB1hyk7I132NqJSuFXJ4MTzXOUEhyQoUIpkd9/YfDso7Pxv0aKIMgeFDG8pGUd2XTPehPY6gzeshxkHLO9d6t8lxi2nvcEVlKToIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h32JBlbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h32JBlbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E372AC4CEE2;
	Wed, 16 Apr 2025 22:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744842166;
	bh=al0pHmBsYMgzq4H32EyjczaRTnXJposHnVY2de26JDI=;
	h=Date:To:From:Subject:From;
	b=h32JBlbJOik+rC18A4gWMaTxr4lXXuk8BMhTbi3Hka9Vl9z85jujSXFKc4LhptWp6
	 bEwp7dtIiuVdoIDBij/Uapnoq1CyUtgHoPekacJMeOwDKIzxbtq5/Lk3tS0Uw4Og/j
	 60925y0jCbR3Hv4CkA9BExmU9lpynJbnYvrzXhxk=
Date: Wed, 16 Apr 2025 15:22:44 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-restore-high-cpu-watermark-safety-in-kswapd.patch added to mm-hotfixes-unstable branch
Message-Id: <20250416222245.E372AC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: restore high-cpu watermark safety in kswapd
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-restore-high-cpu-watermark-safety-in-kswapd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-restore-high-cpu-watermark-safety-in-kswapd.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: restore high-cpu watermark safety in kswapd
Date: Wed, 16 Apr 2025 09:45:39 -0400

Vlastimil points out that commit a211c6550efc ("mm: page_alloc:
defrag_mode kswapd/kcompactd watermarks") switched kswapd from
zone_watermark_ok_safe() to the standard, percpu-cached version of reading
free pages, thus dropping the watermark safety precautions for systems
with high CPU counts (e.g.  >212 cpus on 64G).  Restore them.

Since zone_watermark_ok_safe() is no longer the right interface, and this
was the last caller of the function anyway, open-code the
zone_page_state_snapshot() conditional and delete the function.

Link: https://lkml.kernel.org/r/20250416135142.778933-2-hannes@cmpxchg.org
Fixes: a211c6550efc ("mm: page_alloc: defrag_mode kswapd/kcompactd watermarks")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 --
 mm/page_alloc.c        |   12 ------------
 mm/vmscan.c            |   21 +++++++++++++++++++--
 3 files changed, 19 insertions(+), 16 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-restore-high-cpu-watermark-safety-in-kswapd
+++ a/include/linux/mmzone.h
@@ -1502,8 +1502,6 @@ bool __zone_watermark_ok(struct zone *z,
 bool zone_watermark_ok(struct zone *z, unsigned int order,
 		unsigned long mark, int highest_zoneidx,
 		unsigned int alloc_flags);
-bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
-		unsigned long mark, int highest_zoneidx);
 /*
  * Memory initialization context, use to differentiate memory added by
  * the platform statically or via memory hotplug interface.
--- a/mm/page_alloc.c~mm-vmscan-restore-high-cpu-watermark-safety-in-kswapd
+++ a/mm/page_alloc.c
@@ -3470,18 +3470,6 @@ static inline bool zone_watermark_fast(s
 	return false;
 }
 
-bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
-			unsigned long mark, int highest_zoneidx)
-{
-	long free_pages = zone_page_state(z, NR_FREE_PAGES);
-
-	if (z->percpu_drift_mark && free_pages < z->percpu_drift_mark)
-		free_pages = zone_page_state_snapshot(z, NR_FREE_PAGES);
-
-	return __zone_watermark_ok(z, order, mark, highest_zoneidx, 0,
-								free_pages);
-}
-
 #ifdef CONFIG_NUMA
 int __read_mostly node_reclaim_distance = RECLAIM_DISTANCE;
 
--- a/mm/vmscan.c~mm-vmscan-restore-high-cpu-watermark-safety-in-kswapd
+++ a/mm/vmscan.c
@@ -6736,6 +6736,7 @@ static bool pgdat_balanced(pg_data_t *pg
 	 * meet watermarks.
 	 */
 	for_each_managed_zone_pgdat(zone, pgdat, i, highest_zoneidx) {
+		enum zone_stat_item item;
 		unsigned long free_pages;
 
 		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
@@ -6748,9 +6749,25 @@ static bool pgdat_balanced(pg_data_t *pg
 		 * blocks to avoid polluting allocator fallbacks.
 		 */
 		if (defrag_mode)
-			free_pages = zone_page_state(zone, NR_FREE_PAGES_BLOCKS);
+			item = NR_FREE_PAGES_BLOCKS;
 		else
-			free_pages = zone_page_state(zone, NR_FREE_PAGES);
+			item = NR_FREE_PAGES;
+
+		/*
+		 * When there is a high number of CPUs in the system,
+		 * the cumulative error from the vmstat per-cpu cache
+		 * can blur the line between the watermarks. In that
+		 * case, be safe and get an accurate snapshot.
+		 *
+		 * TODO: NR_FREE_PAGES_BLOCKS moves in steps of
+		 * pageblock_nr_pages, while the vmstat pcp threshold
+		 * is limited to 125. On many configurations that
+		 * counter won't actually be per-cpu cached. But keep
+		 * things simple for now; revisit when somebody cares.
+		 */
+		free_pages = zone_page_state(zone, item);
+		if (zone->percpu_drift_mark && free_pages < zone->percpu_drift_mark)
+			free_pages = zone_page_state_snapshot(zone, item);
 
 		if (__zone_watermark_ok(zone, order, mark, highest_zoneidx,
 					0, free_pages))
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-restore-high-cpu-watermark-safety-in-kswapd.patch
mm-vmscan-fix-kswapd-exit-condition-in-defrag_mode.patch
mm-page_alloc-tighten-up-find_suitable_fallback.patch

