From: akpm@linux-foundation.org
Subject: + ntp-remove-tickadj.patch added to -mm tree
Date: Mon, 22 Mar 2010 15:11:14 -0700
Message-ID: <201003222211.o2MMBEZ4030418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755512Ab0CVWLy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 18:11:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     ntp: remove tickadj
has been added to the -mm tree.  Its filename is
     ntp-remove-tickadj.patch

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
