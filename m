From: akpm@linux-foundation.org
Subject: + ntp-fix-adjtimex-freq-return-error.patch added to -mm tree
Date: Tue, 19 Aug 2008 20:42:54 -0700
Message-ID: <200808200342.m7K3gsKa022463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143AbYHTDnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 23:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, tglx@linutronix.de, ziegler@uni-freiburg.de, zippel@linux-m68k.org


The patch titled
     ntp: fix adjtimex() freq return error
has been added to the -mm tree.  Its filename is
     ntp-fix-adjtimex-freq-return-error.patch

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
Subject: ntp: fix adjtimex() freq return error
From: john stultz <johnstul@us.ibm.com>

Martin Ziegler reported a bug in adjtimex(), where odd positive
frequencies are reduced by 1 while negative values are correct.

See http://bugzilla.kernel.org/show_bug.cgi?id=11370 for details

The issue was introduced in the following commit that increased time_freq
to a 64bit value and increased its resolution:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=074b3b87941c99bc0ce35385b5817924b1ed0c23;hp=eea83d896e318bda54be2d2770d2c5d6668d11db

The problem is how we convert from our internal high res value back to
userland.  Instead of dividing, we shift, then mult, then shift again,
causing the slight error seen in the bug.

I don't think adjtimex() is a terribly hot path, so this patch simply uses
div_s64() to convert back to the external resolution and removes the
unused shift defines to resolve the issue.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Reported-by: Martin Ziegler <ziegler@uni-freiburg.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable.kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |    3 ---
 kernel/time/ntp.c     |    4 +---
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/timex.h~ntp-fix-adjtimex-freq-return-error include/linux/timex.h
--- a/include/linux/timex.h~ntp-fix-adjtimex-freq-return-error
+++ a/include/linux/timex.h
@@ -82,9 +82,6 @@
  */
 #define SHIFT_USEC 16		/* frequency offset scale (shift) */
 #define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
-#define PPM_SCALE_INV_SHIFT 20
-#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
-		       PPM_SCALE + 1)
 
 #define MAXPHASE 500000000l	/* max phase error (ns) */
 #define MAXFREQ 500000		/* max frequency error (ns/s) */
diff -puN kernel/time/ntp.c~ntp-fix-adjtimex-freq-return-error kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-fix-adjtimex-freq-return-error
+++ a/kernel/time/ntp.c
@@ -402,9 +402,7 @@ int do_adjtimex(struct timex *txc)
 		if (!(time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
-	txc->freq	   = shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
-					 (s64)PPM_SCALE_INV,
-					 NTP_SCALE_SHIFT);
+	txc->freq	   = div_s64(time_freq, PPM_SCALE);
 	txc->maxerror	   = time_maxerror;
 	txc->esterror	   = time_esterror;
 	txc->status	   = time_status;
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

ntp-fix-adjtimex-freq-return-error.patch
timekeeping-fix-rounding-problem-during-clock-update.patch
ntp-fix-adj_offset_ss_read-bug-and-do_adjtimex-cleanup.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
clocksource-keep-track-of-original-clocksource-frequency.patch
clocksource-introduce-clocksource_forward_now.patch
clocksource-introduce-clock_monotonic_raw.patch

