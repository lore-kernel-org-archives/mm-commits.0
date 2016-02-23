From: akpm@linux-foundation.org
Subject: +
 mm-numa-quickly-fail-allocations-for-numa-balancing-on-full-nodes.patch
 added to -mm tree
Date: Tue, 23 Feb 2016 13:21:32 -0800
Message-ID: <56cccd5c.VQKEpJ9svJ8UR2re%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbcBWVVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Feb 2016 16:21:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, rientjes@google.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: quickly fail allocations for NUMA balancing on full nodes
has been added to the -mm tree.  Its filename is
     mm-numa-quickly-fail-allocations-for-numa-balancing-on-full-nodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-quickly-fail-allocations-for-numa-balancing-on-full-nodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-quickly-fail-allocations-for-numa-balancing-on-full-nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: numa: quickly fail allocations for NUMA balancing on full nodes

Commit 4167e9b2cf10 ("mm: remove GFP_THISNODE") removed the GFP_THISNODE
flag combination due to confusing semantics.  It noted that
alloc_misplaced_dst_page() was one such user after changes made by commit
e97ca8e5b864 ("mm: fix GFP_THISNODE callers and clarify").  Unfortunately
when GFP_THISNODE was removed, users of alloc_misplaced_dst_page() started
waking kswapd and entering direct reclaim because the wrong GFP flags are
cleared.  The consequence is that workloads that used to fit into memory
now get reclaimed which is addressed by this patch.

The problem can be demonstrated with "mutilate" that exercises memcached
which is software dedicated to memory object caching.  The configuration
uses 80% of memory and is run 3 times for varying numbers of clients.  The
results on a 4-socket NUMA box are

mutilate
                            4.4.0                 4.4.0
                          vanilla           numaswap-v1
Hmean    1      8394.71 (  0.00%)     8395.32 (  0.01%)
Hmean    4     30024.62 (  0.00%)    34513.54 ( 14.95%)
Hmean    7     32821.08 (  0.00%)    70542.96 (114.93%)
Hmean    12    55229.67 (  0.00%)    93866.34 ( 69.96%)
Hmean    21    39438.96 (  0.00%)    85749.21 (117.42%)
Hmean    30    37796.10 (  0.00%)    50231.49 ( 32.90%)
Hmean    47    18070.91 (  0.00%)    38530.13 (113.22%)

The metric is queries/second with the more the better.  The results are
way outside of the noise and the reason for the improvement is obvious
from some of the vmstats

                                 4.4.0       4.4.0
                               vanillanumaswap-v1r1
Minor Faults                1929399272  2146148218
Major Faults                  19746529        3567
Swap Ins                      57307366        9913
Swap Outs                     50623229       17094
Allocation stalls                35909         443
DMA allocs                           0           0
DMA32 allocs                  72976349   170567396
Normal allocs               5306640898  5310651252
Movable allocs                       0           0
Direct pages scanned         404130893      799577
Kswapd pages scanned         160230174           0
Kswapd pages reclaimed        55928786           0
Direct pages reclaimed         1843936       41921
Page writes file                  2391           0
Page writes anon              50623229       17094

The vanilla kernel is swapping like crazy with large amounts of direct
reclaim and kswapd activity.  The figures are aggregate but it's known
that the bad activity is throughout the entire test.

Note that simple streaming anon/file memory consumers also see this
problem but it's not as obvious.  In those cases, kswapd is awake when it
should not be.

As there are at least two reclaim-related bugs out there, it's worth
spelling out the user-visible impact.  This patch only addresses bugs
related to excessive reclaim on NUMA hardware when the working set is
larger than a NUMA node.  There is a bug related to high kswapd CPU usage
but the reports are against laptops and other UMA hardware and is not
addressed by this patch.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[4.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-numa-quickly-fail-allocations-for-numa-balancing-on-full-nodes mm/migrate.c
--- a/mm/migrate.c~mm-numa-quickly-fail-allocations-for-numa-balancing-on-full-nodes
+++ a/mm/migrate.c
@@ -1582,7 +1582,7 @@ static struct page *alloc_misplaced_dst_
 					 (GFP_HIGHUSER_MOVABLE |
 					  __GFP_THISNODE | __GFP_NOMEMALLOC |
 					  __GFP_NORETRY | __GFP_NOWARN) &
-					 ~(__GFP_IO | __GFP_FS), 0);
+					 ~__GFP_RECLAIM, 0);
 
 	return newpage;
 }
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-numa-quickly-fail-allocations-for-numa-balancing-on-full-nodes.patch
mm-filemap-remove-redundant-code-in-do_read_cache_page.patch
mm-filemap-avoid-unnecessary-calls-to-lock_page-when-waiting-for-io-to-complete-during-a-read.patch

