From: akpm@linux-foundation.org
Subject: - ntp-avoid-time_offset-overflows-fix.patch removed from -mm tree
Date: Mon, 26 Mar 2007 21:20:47 -0800
Message-ID: <200703270520.l2R5KlhL007567@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39338 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933982AbXC0FU7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 01:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     ntp-avoid-time_offset-overflows fix
has been removed from the -mm tree.  Its filename was
     ntp-avoid-time_offset-overflows-fix.patch

This patch was dropped because it was folded into ntp-avoid-time_offset-overflows.patch

------------------------------------------------------
Subject: ntp-avoid-time_offset-overflows fix
From: Thomas Gleixner <tglx@linutronix.de>

This is wrong, time_offset is signed and do_div is unsigned.

Cc: John Stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/time/ntp.c~ntp-avoid-time_offset-overflows-fix kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-avoid-time_offset-overflows-fix
+++ a/kernel/time/ntp.c
@@ -196,7 +196,7 @@ void __attribute__ ((weak)) notify_arch_
  */
 int do_adjtimex(struct timex *txc)
 {
-	long mtemp, save_adjust;
+	long mtemp, save_adjust, rem;
 	s64 freq_adj, temp64;
 	int result;
 
@@ -314,7 +314,9 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
-		    do_div(time_offset, NTP_INTERVAL_FREQ);
+		    time_offset = div_long_long_rem_signed(time_offset,
+							   NTP_INTERVAL_FREQ,
+							   &rem);
 		    time_offset <<= SHIFT_UPDATE;
 		} /* STA_PLL */
 	    } /* txc->modes & ADJ_OFFSET */
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
correct-slow-acpi_pm-rating.patch
ntp-avoid-time_offset-overflows.patch
ntp-avoid-time_offset-overflows-fix.patch
