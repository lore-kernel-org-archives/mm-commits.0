From: akpm@linux-foundation.org
Subject: [merged] vmscan-fix-a-livelock-in-kswapd.patch removed from -mm tree
Date: Thu, 21 Jul 2011 12:12:22 -0700
Message-ID: <201107211912.p6LJCFmB032236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab1GUTMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 15:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, mgorman@suse.de, minchan.kim@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vmscan: fix a livelock in kswapd
has been removed from the -mm tree.  Its filename was
     vmscan-fix-a-livelock-in-kswapd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: fix a livelock in kswapd
From: Shaohua Li <shaohua.li@intel.com>

I'm running a workload which triggers a lot of swap in a machine with 4 nodes.
After I kill the workload, I found a kswapd livelock. Sometimes kswapd3 or
kswapd2 are keeping running and I can't access filesystem, but most memory is
free.

This looks like a regression since commit 08951e545918c159 ("mm: vmscan:
correct check for kswapd sleeping in sleeping_prematurely").

Node 2 and 3 have only ZONE_NORMAL, but balance_pgdat() will return 0 for
classzone_idx.  The reason is end_zone in balance_pgdat() is 0 by default,
if all zones have watermark ok, end_zone will keep 0.

Later sleeping_prematurely() always returns true.  Because this is an
order 3 wakeup, and if classzone_idx is 0, both balanced_pages and
present_pages in pgdat_balanced() are 0.  We add a special case here.  If
a zone has no page, we think it's balanced.  This fixes the livelock.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-fix-a-livelock-in-kswapd mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-a-livelock-in-kswapd
+++ a/mm/vmscan.c
@@ -2310,7 +2310,8 @@ static bool pgdat_balanced(pg_data_t *pg
 	for (i = 0; i <= classzone_idx; i++)
 		present_pages += pgdat->node_zones[i].present_pages;
 
-	return balanced_pages > (present_pages >> 2);
+	/* A special case here: if zone has no page, we think it's balanced */
+	return balanced_pages >= (present_pages >> 2);
 }
 
 /* is kswapd sleeping prematurely? */
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
acpi-add-missing-_osi-strings-resend.patch
tmpfs-simplify-prealloc_page.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch

