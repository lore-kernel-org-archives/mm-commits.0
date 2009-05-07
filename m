From: akpm@linux-foundation.org
Subject: [merged] timers-allow-deferrable-timers-for-intervals-tv2-tv5-to-be-deferred.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:37 -0700
Message-ID: <200905071916.n47JGbVZ020542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455AbZEGTVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:21:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jon-hunter@ti.com, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     timers: allow deferrable timers for intervals tv2-tv5 to be deferred
has been removed from the -mm tree.  Its filename was
     timers-allow-deferrable-timers-for-intervals-tv2-tv5-to-be-deferred.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timers: allow deferrable timers for intervals tv2-tv5 to be deferred
From: Jon Hunter <jon-hunter@ti.com>

In the current kernel implementation only kernel timers for time interval
tv1 are being deferred.  This patch allows any timer that is configured as
deferrable to be defer regardless of time interval.

This patch was previously discussed in
http://marc.info/?l=linux-kernel&m=123196343531966&w=2 and was acked by
Venki Pallipadi, the author of the original deferrable timer patch.

Signed-off-by: Jon Hunter <jon-hunter@ti.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/timer.c~timers-allow-deferrable-timers-for-intervals-tv2-tv5-to-be-deferred kernel/timer.c
--- a/kernel/timer.c~timers-allow-deferrable-timers-for-intervals-tv2-tv5-to-be-deferred
+++ a/kernel/timer.c
@@ -1015,6 +1015,9 @@ cascade:
 		index = slot = timer_jiffies & TVN_MASK;
 		do {
 			list_for_each_entry(nte, varp->vec + slot, entry) {
+				if (tbase_get_deferrable(nte->base))
+					continue;
+
 				found = 1;
 				if (time_before(nte->expires, expires))
 					expires = nte->expires;
_

Patches currently in -mm which might be from jon-hunter@ti.com are

linux-next.patch

