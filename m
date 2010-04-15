From: akpm@linux-foundation.org
Subject: [merged] ntp-make-time_adjust-static.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:38:43 -0400
Message-ID: <201004151840.o3FIeLXT024414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755501Ab0DOSk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:40:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ntp: make time_adjust static
has been removed from the -mm tree.  Its filename was
     ntp-make-time_adjust-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
arch-x86-kernel-hpetc-make-the-hpet-compare-register-read-back-failed-warning-conditional-on-the-hpet=verbose-boot-option.patch
time-remove-xtime_cache-take-2.patch
hangcheck-timer-fix-x86_32-bugs.patch
time-kill-off-config_generic_time.patch

