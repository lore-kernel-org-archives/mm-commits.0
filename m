Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCEC1494A8
	for <mm-commits@vger.kernel.org>; Sun, 16 Mar 2025 04:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742098505; cv=none; b=uIdc1jViCoQmgASStVOLHFyUq994w2h0V9pGOU3pRPToLQY7JNBPpb5LBCnZBvLM/Gv51cdB67SUQ7FnJcIcs3yCcAAKibh6z1vdBDorT98G01CG8EZNkTA3lRSZrXnMX+d/qvWGPtSmckIY2/k0HhnZkeKuR3whqO9PMTITB5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742098505; c=relaxed/simple;
	bh=2SaStNoePFYy0IrOpb84oKUJZCEEGn/h6wibgB0khYw=;
	h=Date:To:From:Subject:Message-Id; b=TBzHWrs9Zar905tFTF0XMx8ekckwuEvNv6YRR9AFOWUwxb+Sk3wr/b2iG2V3NYuyjCac4UbPXxwzWTkQJJcpiY5CrV4SxiHnDhbHBKQvFUBphxSwym2p+AUu8fpLQL4I/MdJxzO8QIdWRm39Jx/2CjmP2A7a5Qa2Utl3bi9zne0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jJ5vNp5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jJ5vNp5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC575C4CEDD;
	Sun, 16 Mar 2025 04:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742098504;
	bh=2SaStNoePFYy0IrOpb84oKUJZCEEGn/h6wibgB0khYw=;
	h=Date:To:From:Subject:From;
	b=jJ5vNp5XSUdlTdbMEOVhiLOnBwZHFwyUTViO6sYdACvVsjKFGmWeZ6f712BZTi2NK
	 2EuyjHsZzZ1n3pe4sSboTw638bPIpYJi6GjSANdDUM6BA81dAKxEpaRFrZZKPNbuj7
	 UGoVBuEWyQ3AmpjfVhT8ZNOOIPaZYD13/npQHBv8=
Date: Sat, 15 Mar 2025 21:15:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks-fix.patch added to mm-unstable branch
Message-Id: <20250316041504.CC575C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: defrag_mode kswapd/kcompactd watermarks fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks-fix.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: defrag_mode kswapd/kcompactd watermarks fix
Date: Fri, 14 Mar 2025 11:38:41 -0400

Fix squawks from rebasing that affect the behavior of !defrag_mode.

FWIW, it seems to actually have slightly helped the vanilla kernel in
the benchmark. But the point was to not change the default behavior:

                                                VANILLA        WMARKFIX-VANILLA
Hugealloc Time mean               52739.45 (    +0.00%)   62758.21 (   +19.00%)
Hugealloc Time stddev             56541.26 (    +0.00%)   76253.41 (   +34.86%)
Kbuild Real time                    197.47 (    +0.00%)     197.25 (    -0.11%)
Kbuild User time                   1240.49 (    +0.00%)    1241.33 (    +0.07%)
Kbuild System time                   70.08 (    +0.00%)      71.00 (    +1.28%)
THP fault alloc                   46727.07 (    +0.00%)   41492.73 (   -11.20%)
THP fault fallback                21910.60 (    +0.00%)   27146.53 (   +23.90%)
Direct compact fail                 195.80 (    +0.00%)     260.93 (   +33.10%)
Direct compact success                7.93 (    +0.00%)       6.67 (   -14.18%)
Direct compact success rate %         3.51 (    +0.00%)       2.76 (   -16.78%)
Compact daemon scanned migrate  3369601.27 (    +0.00%) 3827734.27 (   +13.60%)
Compact daemon scanned free     5075474.47 (    +0.00%) 5910839.73 (   +16.46%)
Compact direct scanned migrate   161787.27 (    +0.00%)  168271.13 (    +4.01%)
Compact direct scanned free      163467.53 (    +0.00%)  222558.33 (   +36.15%)
Compact total migrate scanned   3531388.53 (    +0.00%) 3996005.40 (   +13.16%)
Compact total free scanned      5238942.00 (    +0.00%) 6133398.07 (   +17.07%)
Alloc stall                        2371.07 (    +0.00%)    2478.00 (    +4.51%)
Pages kswapd scanned            2160926.73 (    +0.00%) 1726204.67 (   -20.12%)
Pages kswapd reclaimed           533191.07 (    +0.00%)  537963.73 (    +0.90%)
Pages direct scanned             400450.33 (    +0.00%)  450004.87 (   +12.37%)
Pages direct reclaimed            94441.73 (    +0.00%)   99193.07 (    +5.03%)
Pages total scanned             2561377.07 (    +0.00%) 2176209.53 (   -15.04%)
Pages total reclaimed            627632.80 (    +0.00%)  637156.80 (    +1.52%)
Swap out                          47959.53 (    +0.00%)   45186.20 (    -5.78%)
Swap in                            7276.00 (    +0.00%)    7109.40 (    -2.29%)
File refaults                    138043.00 (    +0.00%)  145238.73 (    +5.21%)

Link: https://lkml.kernel.org/r/20250314210558.GD1316033@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks-fix
+++ a/mm/compaction.c
@@ -3075,6 +3075,8 @@ static bool kcompactd_node_suitable(pg_d
 	struct zone *zone;
 	enum zone_type highest_zoneidx = pgdat->kcompactd_highest_zoneidx;
 	enum compact_result ret;
+	unsigned int alloc_flags = defrag_mode ?
+		ALLOC_WMARK_HIGH : ALLOC_WMARK_MIN;
 
 	for (zoneid = 0; zoneid <= highest_zoneidx; zoneid++) {
 		zone = &pgdat->node_zones[zoneid];
@@ -3084,7 +3086,7 @@ static bool kcompactd_node_suitable(pg_d
 
 		ret = compaction_suit_allocation_order(zone,
 				pgdat->kcompactd_max_order,
-				highest_zoneidx, ALLOC_WMARK_MIN,
+				highest_zoneidx, alloc_flags,
 				false, true);
 		if (ret == COMPACT_CONTINUE)
 			return true;
@@ -3108,7 +3110,7 @@ static void kcompactd_do_work(pg_data_t
 		.mode = MIGRATE_SYNC_LIGHT,
 		.ignore_skip_hint = false,
 		.gfp_mask = GFP_KERNEL,
-		.alloc_flags = ALLOC_WMARK_HIGH,
+		.alloc_flags = defrag_mode ? ALLOC_WMARK_HIGH : ALLOC_WMARK_MIN,
 	};
 	enum compact_result ret;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch
mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch
mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch
mm-page_alloc-dont-steal-single-pages-from-biggest-buddy.patch
mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates.patch
mm-page_alloc-group-fallback-functions-together.patch
mm-swap_cgroup-remove-double-initialization-of-locals.patch
mm-compaction-push-watermark-into-compaction_suitable-callers.patch
mm-page_alloc-trace-type-pollution-from-compaction-capturing.patch
mm-page_alloc-defrag_mode.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-assistance.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks-fix.patch

