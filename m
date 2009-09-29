From: akpm@linux-foundation.org
Subject: + timecompare-fix-half-y2k38-problem-in-timecompare_update-while-calculating-offset.patch added to -mm tree
Date: Tue, 29 Sep 2009 13:37:18 -0700
Message-ID: <200909292037.n8TKbIHX004123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbZI2UiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 16:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 21cnbao@gmail.com, davem@davemloft.net, johnstul@us.ibm.com, mingo@elte.hu, patrick.ohly@intel.com, tglx@linutronix.de


The patch titled
     timecompare: fix half-Y2K38 problem in timecompare_update while calculating offset
has been added to the -mm tree.  Its filename is
     timecompare-fix-half-y2k38-problem-in-timecompare_update-while-calculating-offset.patch

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
Subject: timecompare: fix half-Y2K38 problem in timecompare_update while calculating offset
From: Barry Song <21cnbao@gmail.com>

ktime will overflow from 03:14:07 UTC on Tuesday, 19 January 2038,
ktime_add() in timecompare_update() will overflow a half earlier.  As a
result, wrong offset will be gotten, then cause some strange problems.

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

timecompare-fix-half-y2k38-problem-in-timecompare_update-while-calculating-offset.patch

