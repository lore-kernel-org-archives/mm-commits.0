From: akpm@linux-foundation.org
Subject: + mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch added to -mm tree
Date: Tue, 16 Nov 2010 14:44:53 -0800
Message-ID: <201011162244.oAGMirDr012308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754840Ab0KPWp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 17:45:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low-update
has been added to the -mm tree.  Its filename is
     mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch

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
Subject: mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low-update
From: Mel Gorman <mel@csn.ul.ie>

mm: vmscan: Comment on why kswapd reduces the per-cpu vmstat threshold

While kswapd is awake, the per-cpu vmstat threshold is reduced to
reduce per-cpu drift to acceptable levels. Add a comment explaining
why.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/vmscan.c~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update mm/vmscan.c
--- a/mm/vmscan.c~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update
+++ a/mm/vmscan.c
@@ -2441,6 +2441,19 @@ static int kswapd(void *p)
 				 */
 				if (!sleeping_prematurely(pgdat, order, remaining)) {
 					trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
+
+					/*
+					 * vmstat counters are not perfectly
+					 * accurate and the estimated value
+					 * for counters such as NR_FREE_PAGES
+					 * can deviate from the true value by
+					 * nr_online_cpus * threshold. To
+					 * avoid the zone watermarks being
+					 * breached while under pressure, we
+					 * reduce the per-cpu vmstat threshold
+					 * while kswapd is awake and restore
+					 * them before going back to sleep.
+					 */
 					set_pgdat_percpu_threshold(pgdat,
 						calculate_normal_threshold);
 					schedule();
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
factor-out-kswapd-sleeping-logic-from-kswapd.patch
add-debugging-aid-for-memory-initialisation-problems.patch

