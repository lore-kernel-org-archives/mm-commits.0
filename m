From: akpm@linux-foundation.org
Subject: + vmscan-fix-initial-shrinker-size-handling.patch added to -mm tree
Date: Mon, 22 Aug 2011 14:31:52 -0700
Message-ID: <201108222131.p7MLVqY6007667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668Ab1HVVbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 17:31:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, david@fromorbit.com


The patch titled
     vmscan: fix initial shrinker size handling
has been added to the -mm tree.  Its filename is
     vmscan-fix-initial-shrinker-size-handling.patch

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
Subject: vmscan: fix initial shrinker size handling
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

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
@@ -248,14 +248,18 @@ unsigned long shrink_slab(struct shrink_
 
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
@@ -266,7 +270,6 @@ unsigned long shrink_slab(struct shrink_
 		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
 
 		total_scan = nr;
-		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
 		delta = (4 * nr_pages_scanned) / shrinker->seeks;
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

vmscan-fix-initial-shrinker-size-handling.patch

