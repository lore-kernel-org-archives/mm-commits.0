From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:05:47 -0700
Message-ID: <53e3dc1b.eilEsCSQL5jC5EKs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50687 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaHGUFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:48 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so611067vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: only update per-cpu thresholds for online CPU
has been removed from the -mm tree.  Its filename was
     mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: only update per-cpu thresholds for online CPU

When kswapd is awake reclaiming, the per-cpu stat thresholds are lowered
to get more accurate counts to avoid breaching watermarks.  This threshold
update iterates over all possible CPUs which is unnecessary.  Only online
CPUs need to be updated.  If a new CPU is onlined,
refresh_zone_stat_thresholds() will set the thresholds correctly.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu mm/vmstat.c
--- a/mm/vmstat.c~mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu
+++ a/mm/vmstat.c
@@ -200,7 +200,7 @@ void set_pgdat_percpu_threshold(pg_data_
 			continue;
 
 		threshold = (*calculate_pressure)(zone);
-		for_each_possible_cpu(cpu)
+		for_each_online_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
 							= threshold;
 	}
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

