From: akpm@linux-foundation.org
Subject: + ntp-make-time_adjust-static.patch added to -mm tree
Date: Mon, 22 Mar 2010 15:11:12 -0700
Message-ID: <201003222211.o2MMBCfH030415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755512Ab0CVWLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 18:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     ntp: make time_adjust static
has been added to the -mm tree.  Its filename is
     ntp-make-time_adjust-static.patch

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
Subject: ntp: make time_adjust static
From: John Stultz <johnstul@us.ibm.com>

Now that no arches are accessing time_adjust directly, make it static.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |    1 -
 kernel/time/ntp.c     |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/timex.h~ntp-make-time_adjust-static include/linux/timex.h
--- a/include/linux/timex.h~ntp-make-time_adjust-static
+++ a/include/linux/timex.h
@@ -238,7 +238,6 @@ extern int tickadj;			/* amount of adjus
  * phase-lock loop variables
  */
 extern int time_status;		/* clock synchronization status bits */
-extern long time_adjust;	/* The amount of adjtime left */
 
 extern void ntp_init(void);
 extern void ntp_clear(void);
diff -puN kernel/time/ntp.c~ntp-make-time_adjust-static kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-make-time_adjust-static
+++ a/kernel/time/ntp.c
@@ -69,7 +69,7 @@ static s64			time_freq;
 /* time at last adjustment (secs):					*/
 static long			time_reftime;
 
-long				time_adjust;
+static long			time_adjust;
 
 /* constant (boot-param configurable) NTP tick adjustment (upscaled)	*/
 static s64			ntp_tick_adj;
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

linux-next.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch
time-clean-up-warp_clock.patch
time-clean-up-direct-xtime-usage-in-xen.patch
ntp-make-time_adjust-static.patch
ntp-remove-tickadj.patch
xtensa-fix-unnecessary-setting-of-xtime.patch
time-kill-off-config_generic_time.patch

