Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B48158545
	for <mm-commits@vger.kernel.org>; Fri, 18 Apr 2025 03:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945884; cv=none; b=KbwmD1KmC7LK3kixomFAdBB3kSaqPE8sQfpmC3fgCHiWso2HJcUPWYRTM8Qtozty0qYD14X8FvH5h0tmO/8fOSBj7DldCEchPjmuuPzR6vZGZtNQmHCZYUOQnKMZHnRpxu27flCAznXokGUB1RVPrln7pspSsKtRNMXkEtazUIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945884; c=relaxed/simple;
	bh=8g9AWLPOi+HuJdhGfgFYLKrMVtsDKMfDVVbIFP7rrg4=;
	h=Date:To:From:Subject:Message-Id; b=iMuOEXZkgeDIeze09vpUM0s/7mtpfsWLrIk1bEQkYyTF0u6LtZp7UUy3DS+0aUn7Sgdm4cUp2w5qbv07DKAzpg1+/orrEbeaHqhoM86M+lSU80J9uNFlx/f8JJkdC/8mYrxhrih2pbH6hn/uca189OB0Fm+dQI+4j6KgBG41NWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cyFVJO7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cyFVJO7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0727EC4CEE4;
	Fri, 18 Apr 2025 03:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945884;
	bh=8g9AWLPOi+HuJdhGfgFYLKrMVtsDKMfDVVbIFP7rrg4=;
	h=Date:To:From:Subject:From;
	b=cyFVJO7QuD6gb7L8WoX+5O6LHH7XR/qZ7t/lW1A9Ya72g3jmpKDuhw2wnFCtQzmZU
	 IofNX4ZI7d9jTBHqTT6I6JX5VJaCj10NN611zRQ9jpYS2O1Kl3Zy45Ox3vcHCskV/V
	 7sZ7hdGAktq6V87QLDhHiOBGKLcfu+QJkJn6PMoI=
Date: Thu, 17 Apr 2025 20:11:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmscan-fix-kswapd-exit-condition-in-defrag_mode.patch removed from -mm tree
Message-Id: <20250418031124.0727EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: fix kswapd exit condition in defrag_mode
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-kswapd-exit-condition-in-defrag_mode.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: fix kswapd exit condition in defrag_mode
Date: Wed, 16 Apr 2025 09:45:40 -0400

Vlastimil points out an issue with kswapd in defrag_mode not waking up
kcompactd reliably.

Background: When kswapd is woken for any higher-order request, it
initially checks those high-order watermarks to decide if work is
necesary.  However, it cannot (efficiently) meet the contiguity goal of
such a request by itself.  So once it has reclaimed a compaction gap, it
adjusts the request down to check for free order-0 pages, then wakes
kcompactd to coalesce them into larger blocks.

In defrag_mode, the initial watermark check needs to be analogously
against free pageblocks.  However, once kswapd drops the high-order to
hand off contiguity work, it also needs to fall back to base page
watermarks - otherwise it'll keep reclaiming until blocks are freed.

While it appears kcompactd is woken up frequently enough to do most of the
compaction work, kswapd ends up overreclaiming by quite a bit:

                                                     DEFRAGMODE     DEFRAGMODE-thispatch
Hugealloc Time mean                       79381.34 (    +0.00%)    88126.12 (   +11.02%)
Hugealloc Time stddev                     85852.16 (    +0.00%)   135366.75 (   +57.67%)
Kbuild Real time                            249.35 (    +0.00%)      226.71 (    -9.04%)
Kbuild User time                           1249.16 (    +0.00%)     1249.37 (    +0.02%)
Kbuild System time                          171.76 (    +0.00%)      166.93 (    -2.79%)
THP fault alloc                           51666.87 (    +0.00%)    52685.60 (    +1.97%)
THP fault fallback                        16970.00 (    +0.00%)    15951.87 (    -6.00%)
Direct compact fail                         166.53 (    +0.00%)      178.93 (    +7.40%)
Direct compact success                       17.13 (    +0.00%)        4.13 (   -71.69%)
Compact daemon scanned migrate          3095413.33 (    +0.00%)  9231239.53 (  +198.22%)
Compact daemon scanned free             2155966.53 (    +0.00%)  7053692.87 (  +227.17%)
Compact direct scanned migrate           265642.47 (    +0.00%)    68388.33 (   -74.26%)
Compact direct scanned free              130252.60 (    +0.00%)    55634.87 (   -57.29%)
Compact total migrate scanned           3361055.80 (    +0.00%)  9299627.87 (  +176.69%)
Compact total free scanned              2286219.13 (    +0.00%)  7109327.73 (  +210.96%)
Alloc stall                                1890.80 (    +0.00%)     6297.60 (  +232.94%)
Pages kswapd scanned                    9043558.80 (    +0.00%)  5952576.73 (   -34.18%)
Pages kswapd reclaimed                  1891708.67 (    +0.00%)  1030645.00 (   -45.52%)
Pages direct scanned                    1017090.60 (    +0.00%)  2688047.60 (  +164.29%)
Pages direct reclaimed                    92682.60 (    +0.00%)   309770.53 (  +234.22%)
Pages total scanned                    10060649.40 (    +0.00%)  8640624.33 (   -14.11%)
Pages total reclaimed                   1984391.27 (    +0.00%)  1340415.53 (   -32.45%)
Swap out                                 884585.73 (    +0.00%)   417781.93 (   -52.77%)
Swap in                                  287106.27 (    +0.00%)    95589.73 (   -66.71%)
File refaults                            551697.60 (    +0.00%)   426474.80 (   -22.70%)

Link: https://lkml.kernel.org/r/20250416135142.778933-3-hannes@cmpxchg.org
Fixes: a211c6550efc ("mm: page_alloc: defrag_mode kswapd/kcompactd watermarks")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-fix-kswapd-exit-condition-in-defrag_mode
+++ a/mm/vmscan.c
@@ -6747,8 +6747,14 @@ static bool pgdat_balanced(pg_data_t *pg
 		/*
 		 * In defrag_mode, watermarks must be met in whole
 		 * blocks to avoid polluting allocator fallbacks.
+		 *
+		 * However, kswapd usually cannot accomplish this on
+		 * its own and needs kcompactd support. Once it's
+		 * reclaimed a compaction gap, and kswapd_shrink_node
+		 * has dropped order, simply ensure there are enough
+		 * base pages for compaction, wake kcompactd & sleep.
 		 */
-		if (defrag_mode)
+		if (defrag_mode && order)
 			item = NR_FREE_PAGES_BLOCKS;
 		else
 			item = NR_FREE_PAGES;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-tighten-up-find_suitable_fallback.patch

