From: akpm@linux-foundation.org
Subject: + ntp-apply-frequency-tick-changes-immediately.patch added to -mm tree
Date: Thu, 19 Feb 2009 14:12:38 -0800
Message-ID: <200902192212.n1JMCcml026504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014AbZBSWNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 17:13:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, tglx@linutronix.de, williams@redhat.com, zippel@linux-m68k.org


The patch titled
     ntp: apply frequency/tick changes immediately
has been added to the -mm tree.  Its filename is
     ntp-apply-frequency-tick-changes-immediately.patch

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
Subject: ntp: apply frequency/tick changes immediately
From: john stultz <johnstul@us.ibm.com>

Apply NTP tick/frequency adjustments immediately instead of waiting for
the next second to pass.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Clark Williams <williams@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/time/ntp.c~ntp-apply-frequency-tick-changes-immediately kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-apply-frequency-tick-changes-immediately
+++ a/kernel/time/ntp.c
@@ -51,6 +51,7 @@ static long ntp_tick_adj;
 
 static void ntp_update_frequency(void)
 {
+	u64 old_tick_length_base = tick_length_base;
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
 				<< NTP_SCALE_SHIFT;
 	second_length += (s64)ntp_tick_adj << NTP_SCALE_SHIFT;
@@ -60,6 +61,11 @@ static void ntp_update_frequency(void)
 
 	tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
 	tick_length_base = div_u64(tick_length_base, NTP_INTERVAL_FREQ);
+
+	/* Don't wait for the next second_overflow, apply
+	 * the change to the tick length immediately
+	 */
+	tick_length += tick_length_base - old_tick_length_base;
 }
 
 static void ntp_update_offset(long offset)
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
linux-next.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
ntp-apply-frequency-tick-changes-immediately.patch

