From: akpm@linux-foundation.org
Subject: + vmscan-add-block-plug-for-page-reclaim.patch added to -mm tree
Date: Wed, 27 Jul 2011 16:45:33 -0700
Message-ID: <201107272345.p6RNjXrg015644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144Ab1G0Xph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 19:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, axboe@kernel.dk, minchan.kim@gmail.com


The patch titled
     vmscan: add block plug for page reclaim
has been added to the -mm tree.  Its filename is
     vmscan-add-block-plug-for-page-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: add block plug for page reclaim
From: Shaohua Li <shaohua.li@intel.com>

per-task block plug can reduce block queue lock contention and increase
request merge.  Currently page reclaim doesn't support it.  I originally
thought page reclaim doesn't need it, because kswapd thread count is
limited and file cache write is done at flusher mostly.

When I test a workload with heavy swap in a 4-node machine, each CPU is
doing direct page reclaim and swap.  This causes block queue lock
contention.  In my test, without below patch, the CPU utilization is about
2% ~ 7%.  With the patch, the CPU utilization is about 1% ~ 3%.  Disk
throughput isn't changed.  This should improve normal kswapd write and
file cache write too (increase request merge for example), but might not
be so obvious as I explain above.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/vmscan.c~vmscan-add-block-plug-for-page-reclaim mm/vmscan.c
--- a/mm/vmscan.c~vmscan-add-block-plug-for-page-reclaim
+++ a/mm/vmscan.c
@@ -2022,12 +2022,14 @@ static void shrink_zone(int priority, st
 	enum lru_list l;
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
+	struct blk_plug plug;
 
 restart:
 	nr_reclaimed = 0;
 	nr_scanned = sc->nr_scanned;
 	get_scan_count(zone, sc, nr, priority);
 
+	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
 		for_each_evictable_lru(l) {
@@ -2051,6 +2053,7 @@ restart:
 		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
 			break;
 	}
+	blk_finish_plug(&plug);
 	sc->nr_reclaimed += nr_reclaimed;
 
 	/*
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
acpi-add-missing-_osi-strings-resend.patch
vmscan-add-block-plug-for-page-reclaim.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

