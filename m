Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED3538FA6
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 04:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273474; cv=none; b=IfppiZjVmOPrLzwvdI7/Rc/NvUVEqz247NBq37m3mgErlroILhDhYOAuT8XmbEeeTI54TG0f1MAP/DRet2LaDjUbVSwuae//YckZWeqingiPsu2tvYDc+fLuD5cBwV2wlR3gciszo/6II2be85fAMw8Lw9moG0tmWRAWzzlej6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273474; c=relaxed/simple;
	bh=LMRWUGqFFXREKc5NdVBbUKoYB0dcG+XzGZwr0MwPwB4=;
	h=Date:To:From:Subject:Message-Id; b=GvSwmlnrk1/5ZtVnaZ23G/2dTBa3ua/sQgLeAL6p6X+ngym3N620aNaVSGcyMu31M8HLOktfMJwLAY+hmTTiYRuvr9UbZaOJJxdnkCAQIPzeZAWMAg/tKB9fz6OLG8bGj3rNPQbLAKBJ/y1CycBbI0jW6rtM9eJxSvvieukGnLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r1K7F28X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r1K7F28X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5BCC4CEDD;
	Tue, 18 Mar 2025 04:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742273473;
	bh=LMRWUGqFFXREKc5NdVBbUKoYB0dcG+XzGZwr0MwPwB4=;
	h=Date:To:From:Subject:From;
	b=r1K7F28XBhVdnsadRTWb6Ij0wUyC0ubWRi3IX54XvJD6kjfnZHyTBwWItyvpZe4bR
	 A6+TypNjlnCM95rzO6iJu+4KC6vs2nBd33eBUfyRddByK9t/TBKC+fBlZBWORMm3rf
	 IlBTcwjgt4aY+Fiwsu9QZ6djbhAwasSYPeDX23S4=
Date: Mon, 17 Mar 2025 21:51:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks-fix.patch removed from -mm tree
Message-Id: <20250318045113.5D5BCC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: defrag_mode kswapd/kcompactd watermarks fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks-fix.patch

This patch was dropped because it was folded into mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks.patch

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
@@ -3074,6 +3074,8 @@ static bool kcompactd_node_suitable(pg_d
 	struct zone *zone;
 	enum zone_type highest_zoneidx = pgdat->kcompactd_highest_zoneidx;
 	enum compact_result ret;
+	unsigned int alloc_flags = defrag_mode ?
+		ALLOC_WMARK_HIGH : ALLOC_WMARK_MIN;
 
 	for (zoneid = 0; zoneid <= highest_zoneidx; zoneid++) {
 		zone = &pgdat->node_zones[zoneid];
@@ -3083,7 +3085,7 @@ static bool kcompactd_node_suitable(pg_d
 
 		ret = compaction_suit_allocation_order(zone,
 				pgdat->kcompactd_max_order,
-				highest_zoneidx, ALLOC_WMARK_MIN,
+				highest_zoneidx, alloc_flags,
 				false, true);
 		if (ret == COMPACT_CONTINUE)
 			return true;
@@ -3107,7 +3109,7 @@ static void kcompactd_do_work(pg_data_t
 		.mode = MIGRATE_SYNC_LIGHT,
 		.ignore_skip_hint = false,
 		.gfp_mask = GFP_KERNEL,
-		.alloc_flags = ALLOC_WMARK_HIGH,
+		.alloc_flags = defrag_mode ? ALLOC_WMARK_HIGH : ALLOC_WMARK_MIN,
 	};
 	enum compact_result ret;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-swap_cgroup-remove-double-initialization-of-locals.patch
mm-compaction-push-watermark-into-compaction_suitable-callers.patch
mm-page_alloc-trace-type-pollution-from-compaction-capturing.patch
mm-page_alloc-defrag_mode.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-assistance.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks.patch

