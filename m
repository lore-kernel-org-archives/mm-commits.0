From: akpm@linux-foundation.org
Subject: [merged] mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:16:38 -0700
Message-ID: <20120801201638.E6EDE1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2HAUQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:16:40 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:16:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: account for the number of times direct reclaimers get throttled
has been removed from the -mm tree.  Its filename was
     mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: account for the number of times direct reclaimers get throttled

Under significant pressure when writing back to network-backed storage,
direct reclaimers may get throttled.  This is expected to be a short-lived
event and the processes get woken up again but processes do get stalled. 
This patch counts how many times such stalling occurs.  It's up to the
administrator whether to reduce these stalls by increasing
min_free_kbytes.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 +
 mm/vmscan.c                   |    3 +++
 mm/vmstat.c                   |    1 +
 3 files changed, 5 insertions(+)

diff -puN include/linux/vm_event_item.h~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled
+++ a/include/linux/vm_event_item.h
@@ -30,6 +30,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSTEAL_DIRECT),
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
+		PGSCAN_DIRECT_THROTTLE,
 #ifdef CONFIG_NUMA
 		PGSCAN_ZONE_RECLAIM_FAILED,
 #endif
diff -puN mm/vmscan.c~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled mm/vmscan.c
--- a/mm/vmscan.c~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled
+++ a/mm/vmscan.c
@@ -2167,6 +2167,9 @@ static void throttle_direct_reclaim(gfp_
 	if (pfmemalloc_watermark_ok(pgdat))
 		return;
 
+	/* Account for the throttling */
+	count_vm_event(PGSCAN_DIRECT_THROTTLE);
+
 	/*
 	 * If the caller cannot enter the filesystem, it's possible that it
 	 * is due to the caller holding an FS lock or performing a journal
diff -puN mm/vmstat.c~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled mm/vmstat.c
--- a/mm/vmstat.c~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled
+++ a/mm/vmstat.c
@@ -745,6 +745,7 @@ const char * const vmstat_text[] = {
 	TEXTS_FOR_ZONES("pgsteal_direct")
 	TEXTS_FOR_ZONES("pgscan_kswapd")
 	TEXTS_FOR_ZONES("pgscan_direct")
+	"pgscan_direct_throttle",
 
 #ifdef CONFIG_NUMA
 	"zone_reclaim_failed",
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

