From: akpm@linux-foundation.org
Subject: [wrecked] ntp-apply-frequency-tick-changes-immediately.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:13:18 -0800
Message-ID: <200903061913.n26JDIx1021270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583AbZCFTOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:14:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, tglx@linutronix.de, williams@redhat.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     ntp: apply frequency/tick changes immediately
has been removed from the -mm tree.  Its filename was
     ntp-apply-frequency-tick-changes-immediately.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: apply frequency/tick changes immediately
From: john stultz <johnstul@us.ibm.com>

Since the GENERIC_TIME changes landed, the adjtimex behavior changed for
struct timex.tick and .freq changed.  When the tick or freq value is set,
we adjust the tick_length_base in ntp_update_frequency().  However, this
new value doesn't get applied to tick_length until the next second (via
second_overflow).

This means some applications that do quick time tweaking do not see the
requested change made as quickly as expected.

This patch patch makes it so changes to timex.tick and .freq are
immediately applied to the next NTP_INTERVAL_LENGTH.

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

linux-next.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
ntp-apply-frequency-tick-changes-immediately.patch

