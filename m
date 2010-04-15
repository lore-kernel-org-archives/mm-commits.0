From: akpm@linux-foundation.org
Subject: [merged] ntp-remove-tickadj.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:38:45 -0400
Message-ID: <201004151840.o3FIeNMw024417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754848Ab0DOSpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ntp: remove tickadj
has been removed from the -mm tree.  Its filename was
     ntp-remove-tickadj.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: remove tickadj
From: John Stultz <johnstul@us.ibm.com>

There are zero users of tickadj.  So remove it.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/timex.h~ntp-remove-tickadj include/linux/timex.h
--- a/include/linux/timex.h~ntp-remove-tickadj
+++ a/include/linux/timex.h
@@ -232,7 +232,6 @@ struct timex {
  */
 extern unsigned long tick_usec;		/* USER_HZ period (usec) */
 extern unsigned long tick_nsec;		/* ACTHZ          period (nsec) */
-extern int tickadj;			/* amount of adjustment per tick */
 
 /*
  * phase-lock loop variables
@@ -270,9 +269,6 @@ extern void second_overflow(void);
 extern void update_ntp_one_tick(void);
 extern int do_adjtimex(struct timex *);
 
-/* Don't use! Compatibility define for existing users. */
-#define tickadj	(500/HZ ? : 1)
