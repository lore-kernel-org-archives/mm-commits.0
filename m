From: akpm@linux-foundation.org
Subject: [merged] vmscan-fix-initial-shrinker-size-handling.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:07:40 -0800
Message-ID: <201112092007.pB9K7eBM020191@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38322 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1LIUHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:07:44 -0500
Received: by eekc14 with SMTP id c14so73205eek.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:07:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: fix initial shrinker size handling
has been removed from the -mm tree.  Its filename was
     vmscan-fix-initial-shrinker-size-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: vmscan: fix initial shrinker size handling

A shrinker function can return -1, means that it cannot do anything
without a risk of deadlock.  For example prune_super() does this if it
cannot grab a superblock refrence, even if nr_to_scan=0.  Currently we
interpret this -1 as a ULONG_MAX size shrinker and evaluate `total_scan'
according to this.  So the next time around this shrinker can cause really
big pressure.  Let's skip such shrinkers instead.

Also make total_scan signed, otherwise the check (total_scan < 0) below
never works.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~vmscan-fix-initial-shrinker-size-handling mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-initial-shrinker-size-handling
+++ a/mm/vmscan.c
@@ -247,14 +247,18 @@ unsigned long shrink_slab(struct shrink_
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
 		unsigned long long delta;
-		unsigned long total_scan;
-		unsigned long max_pass;
+		long total_scan;
+		long max_pass;
 		int shrink_ret = 0;
 		long nr;
 		long new_nr;
 		long batch_size = shrinker->batch ? shrinker->batch
 						  : SHRINK_BATCH;
 
+		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
+		if (max_pass <= 0)
+			continue;
+
 		/*
 		 * copy the current shrinker scan count into a local variable
 		 * and zero it so that other concurrent shrinker invocations
@@ -265,7 +269,6 @@ unsigned long shrink_slab(struct shrink_
 		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
 
 		total_scan = nr;
-		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
 		delta = (4 * nr_pages_scanned) / shrinker->seeks;
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-account-reaped-page-cache-on-inode-cache-pruning.patch

