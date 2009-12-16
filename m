From: akpm@linux-foundation.org
Subject: [merged] timecompare-fix-half-y2k38-problem-in-timecompare_update-while-calculating-offset.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:33:26 -0800
Message-ID: <200912162033.nBGKXQkt012933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbZLPUd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:33:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 21cnbao@gmail.com, davem@davemloft.net, johnstul@us.ibm.com, mingo@elte.hu, patrick.ohly@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timecompare: fix half-Y2K38 problem in timecompare_update while calculating offset
has been removed from the -mm tree.  Its filename was
     timecompare-fix-half-y2k38-problem-in-timecompare_update-while-calculating-offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timecompare: fix half-Y2K38 problem in timecompare_update while calculating offset
From: Barry Song <21cnbao@gmail.com>

ktime will overflow from 03:14:07 UTC on Tuesday, 19 January 2038,
ktime_add() in timecompare_update() will overflow a half earlier.  As a
result, wrong offset will be gotten, then cause some strange problems.

Signed-off-by: Barry Song <21cnbao@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Patrick Ohly <patrick.ohly@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timecompare.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/timecompare.c~timecompare-fix-half-y2k38-problem-in-timecompare_update-while-calculating-offset kernel/time/timecompare.c
--- a/kernel/time/timecompare.c~timecompare-fix-half-y2k38-problem-in-timecompare_update-while-calculating-offset
+++ a/kernel/time/timecompare.c
@@ -89,7 +89,7 @@ int timecompare_offset(struct timecompar
 			 * source time
 			 */
 			sample.offset =
-				ktime_to_ns(ktime_add(end, start)) / 2 -
+				(ktime_to_ns(end) + ktime_to_ns(start)) / 2 -
 				ts;
 
 			/* simple insertion sort based on duration */
_

Patches currently in -mm which might be from 21cnbao@gmail.com are

origin.patch

