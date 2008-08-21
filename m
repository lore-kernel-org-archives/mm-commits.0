From: akpm@linux-foundation.org
Subject: + ntp-improve-adjtimex-frequency-rounding.patch added to -mm tree
Date: Wed, 20 Aug 2008 20:15:30 -0700
Message-ID: <200808210315.m7L3FUPd014052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756876AbYHUDQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de, ziegler@uni-freiburg.de


The patch titled
     ntp: improve adjtimex frequency rounding
has been added to the -mm tree.  Its filename is
     ntp-improve-adjtimex-frequency-rounding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: improve adjtimex frequency rounding
From: Roman Zippel <zippel@linux-m68k.org>

Change PPM_SCALE_INV_SHIFT so that it doesn't throw away any input bits
(19 is the amount of the factor 2 in PPM_SCALE), the output frequency
can then be calculated back to its input value, as the inverse divide
produce a slightly larger value, which is then correctly rounded by the
final shift.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Reported-by: Martin Ziegler <ziegler@uni-freiburg.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |    2 +-
 kernel/time/ntp.c     |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/timex.h~ntp-improve-adjtimex-frequency-rounding include/linux/timex.h
--- a/include/linux/timex.h~ntp-improve-adjtimex-frequency-rounding
+++ a/include/linux/timex.h
@@ -83,7 +83,7 @@
  */
 #define SHIFT_USEC 16		/* frequency offset scale (shift) */
 #define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
-#define PPM_SCALE_INV_SHIFT 20
+#define PPM_SCALE_INV_SHIFT 19
 #define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
 		       PPM_SCALE + 1)
 
diff -puN kernel/time/ntp.c~ntp-improve-adjtimex-frequency-rounding kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-improve-adjtimex-frequency-rounding
+++ a/kernel/time/ntp.c
@@ -406,9 +406,8 @@ adj_done:
 	if (time_status & (STA_UNSYNC|STA_CLOCKERR))
 		result = TIME_ERROR;
 
-	txc->freq	   = shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
-					 (s64)PPM_SCALE_INV,
-					 NTP_SCALE_SHIFT);
+	txc->freq	   = shift_right((time_freq >> PPM_SCALE_INV_SHIFT) *
+					 (s64)PPM_SCALE_INV, NTP_SCALE_SHIFT);
 	txc->maxerror	   = time_maxerror;
 	txc->esterror	   = time_esterror;
 	txc->status	   = time_status;
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

ntp-let-update_persistent_clock-sleep.patch
timekeeping-fix-rounding-problem-during-clock-update.patch
ntp-fix-adj_offset_ss_read-bug-and-do_adjtimex-cleanup.patch
linux-timexh-cleanup-for-userspace.patch
ntp-improve-adjtimex-frequency-rounding.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
clocksource-keep-track-of-original-clocksource-frequency.patch
clocksource-introduce-clocksource_forward_now.patch
clocksource-introduce-clock_monotonic_raw.patch
hfsplus-quieten-down-mounting-hfsplus-journaled-fs-read-only.patch

