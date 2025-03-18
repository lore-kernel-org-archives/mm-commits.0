Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BE31DB361
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274665; cv=none; b=XLRjpzte/PrsO348l4X6jVHMBpGbDYYkj20bj4z7P2C6Tj9EYRTk4uJXIDjsg5+2iAkwAXtu1cXpiaEic0+Z8K68ibmxu17C7pNHMMWzo0MMc3wWvEzwnwiIOmwxv7kvizM+MZYGNhOUccsCbK/+OiYVefBwJ/MKyubyRpeMzDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274665; c=relaxed/simple;
	bh=LDf7ucPbgRIFCCuSnRBQEOUnKWeeq78L9cRgyiFDKEU=;
	h=Date:To:From:Subject:Message-Id; b=pWmWqFMw86govDB4MrS0dttZ1MA2bGQXTwZSDrTXilPhYI9ub70vEL4TWEFrA+1pLq0d4ULVkuwo/EFu83ruKJ87zhfL9nIGkHbxUPNU0RVQyFK5E34SjRulf7ZFvE+H474AjitK1LcUbdso6WH4NiEmZHY416cQpQ3fjAKr92c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ftqshC+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ftqshC+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7B4C4CEDD;
	Tue, 18 Mar 2025 05:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274665;
	bh=LDf7ucPbgRIFCCuSnRBQEOUnKWeeq78L9cRgyiFDKEU=;
	h=Date:To:From:Subject:From;
	b=ftqshC+X13dKSTVG/HHcTAqWS4v/kVcGNjf3U01YghaA0kuqZkLEQoj91CMPGrxfR
	 rRd+6BPY6DuDHnmlXsw/QYBwkE7yOVKdYoGNZ8oRP6U4+4zDq4fgQ8qmOwWXGOLtV7
	 m5oG25Wcxt8HlrdQDY4URYzeEn6I8NADdJcZcU+Q=
Date: Mon, 17 Mar 2025 22:11:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-defrag_mode-kswapd-kcompactd-assistance.patch removed from -mm tree
Message-Id: <20250318051105.5B7B4C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: defrag_mode kswapd/kcompactd assistance
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-defrag_mode-kswapd-kcompactd-assistance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: defrag_mode kswapd/kcompactd assistance
Date: Thu, 13 Mar 2025 17:05:35 -0400

When defrag_mode is enabled, allocation fallbacks strongly prefer whole
block conversions instead of polluting or stealing partially used blocks. 
This means there is a demand for pageblocks even from sub-block requests. 
Let kswapd/kcompactd help produce them.

By the time kswapd gets woken up, normal rmqueue and block conversion
fallbacks have been attempted and failed.  So always wake kswapd with the
block order; it will take care of producing a suitable compaction gap and
then chain-wake kcompactd with the block order when its done.

                                                VANILLA        DEFRAGMODE-ASYNC
Hugealloc Time mean               52739.45 (    +0.00%)   34300.36 (   -34.96%)
Hugealloc Time stddev             56541.26 (    +0.00%)   36390.42 (   -35.64%)
Kbuild Real time                    197.47 (    +0.00%)     196.13 (    -0.67%)
Kbuild User time                   1240.49 (    +0.00%)    1234.74 (    -0.46%)
Kbuild System time                   70.08 (    +0.00%)      62.62 (   -10.50%)
THP fault alloc                   46727.07 (    +0.00%)   57054.53 (   +22.10%)
THP fault fallback                21910.60 (    +0.00%)   11581.40 (   -47.14%)
Direct compact fail                 195.80 (    +0.00%)     107.80 (   -44.72%)
Direct compact success                7.93 (    +0.00%)       4.53 (   -38.06%)
Direct compact success rate %         3.51 (    +0.00%)       3.20 (    -6.89%)
Compact daemon scanned migrate  3369601.27 (    +0.00%) 5461033.93 (   +62.07%)
Compact daemon scanned free     5075474.47 (    +0.00%) 5824897.93 (   +14.77%)
Compact direct scanned migrate   161787.27 (    +0.00%)   58336.93 (   -63.94%)
Compact direct scanned free      163467.53 (    +0.00%)   32791.87 (   -79.94%)
Compact total migrate scanned   3531388.53 (    +0.00%) 5519370.87 (   +56.29%)
Compact total free scanned      5238942.00 (    +0.00%) 5857689.80 (   +11.81%)
Alloc stall                        2371.07 (    +0.00%)    2424.60 (    +2.26%)
Pages kswapd scanned            2160926.73 (    +0.00%) 2657018.33 (   +22.96%)
Pages kswapd reclaimed           533191.07 (    +0.00%)  559583.07 (    +4.95%)
Pages direct scanned             400450.33 (    +0.00%)  722094.07 (   +80.32%)
Pages direct reclaimed            94441.73 (    +0.00%)  107257.80 (   +13.57%)
Pages total scanned             2561377.07 (    +0.00%) 3379112.40 (   +31.93%)
Pages total reclaimed            627632.80 (    +0.00%)  666840.87 (    +6.25%)
Swap out                          47959.53 (    +0.00%)   77238.20 (   +61.05%)
Swap in                            7276.00 (    +0.00%)   11712.80 (   +60.97%)
File refaults                    138043.00 (    +0.00%)  143438.80 (    +3.91%)

With this patch, defrag_mode=1 beats the vanilla kernel in THP success
rates and allocation latencies.  The trend holds over time:

  thp_fault_alloc

      VANILLA        DEFRAGMODE-ASYNC
        61988                   52066
        56474                   58844
        57258                   58233
        50187                   58476
        52388                   54516
        55409                   59938
        52925                   57204
        47648                   60238
        43669                   55733
        40621                   56211
        36077                   59861
        41721                   57771
        36685                   58579
        34641                   51868
        33215                   56280

DEFRAGMODE-ASYNC also wins on %sys as ~3/4 of the direct compaction work
is shifted to kcompactd.

Reclaim activity is higher.  Part of that is simply due to the increased
memory footprint from higher THP use.  The other aspect is that *direct*
reclaim/compaction are still going for requested orders rather than
targeting the page blocks required for fallbacks, which is less efficient
than it could be.  However, this is already a useful tradeoff to make, as
in many environments peak periods are short and retaining the ability to
produce THP through them is more important.

Link: https://lkml.kernel.org/r/20250313210647.1314586-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-defrag_mode-kswapd-kcompactd-assistance
+++ a/mm/page_alloc.c
@@ -4076,15 +4076,21 @@ static void wake_all_kswapds(unsigned in
 	struct zone *zone;
 	pg_data_t *last_pgdat = NULL;
 	enum zone_type highest_zoneidx = ac->highest_zoneidx;
+	unsigned int reclaim_order;
+
+	if (defrag_mode)
+		reclaim_order = max(order, pageblock_order);
+	else
+		reclaim_order = order;
 
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, highest_zoneidx,
 					ac->nodemask) {
 		if (!managed_zone(zone))
 			continue;
-		if (last_pgdat != zone->zone_pgdat) {
-			wakeup_kswapd(zone, gfp_mask, order, highest_zoneidx);
-			last_pgdat = zone->zone_pgdat;
-		}
+		if (last_pgdat == zone->zone_pgdat)
+			continue;
+		wakeup_kswapd(zone, gfp_mask, reclaim_order, highest_zoneidx);
+		last_pgdat = zone->zone_pgdat;
 	}
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


