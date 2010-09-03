From: akpm@linux-foundation.org
Subject: + time-compensate-for-rounding-on-odd-frequency-clocksources.patch added to -mm tree
Date: Fri, 03 Sep 2010 16:48:16 -0700
Message-ID: <201009032348.o83NmGuR019709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab0ICXso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 19:48:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kkp2010@kasperkp.dk, jkacur@redhat.com, johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de, williams@redhat.com


The patch titled
     time: compensate for rounding on odd-frequency clocksources
has been added to the -mm tree.  Its filename is
     time-compensate-for-rounding-on-odd-frequency-clocksources.patch

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
Subject: time: compensate for rounding on odd-frequency clocksources
From: Kasper Pedersen <kkp2010@kasperkp.dk>

When the clocksource is not a multiple of HZ, the clock will be off.  For
acpi_pm, HZ=1000 the error is 127.111 ppm:

The rounding of cycle_interval ends up generating a false error term in
ntp_error accumulation since xtime_interval is not exactly 1/HZ.  So, we
subtract out the error caused by the rounding.

This has been visible since 2.6.32-rc2
	commit a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601
	time: Implement logarithmic time accumulation
That commit raised NTP_INTERVAL_FREQ and exposed the rounding error.

testing tool: http://n1.taur.dk/permanent/testpmt.c
Also tested with ntpd and a frequency counter.

Signed-off-by: Kasper Pedersen <kkp2010@kasperkp.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN kernel/time/timekeeping.c~time-compensate-for-rounding-on-odd-frequency-clocksources kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~time-compensate-for-rounding-on-odd-frequency-clocksources
+++ a/kernel/time/timekeeping.c
@@ -32,6 +32,8 @@ struct timekeeper {
 	cycle_t cycle_interval;
 	/* Number of clock shifted nano seconds in one NTP interval. */
 	u64	xtime_interval;
+	/* shifted nano seconds left over when rounding cycle_interval */
+	s64	xtime_remainder;
 	/* Raw nano seconds accumulated per NTP interval. */
 	u32	raw_interval;
 
@@ -62,7 +64,7 @@ struct timekeeper timekeeper;
 static void timekeeper_setup_internals(struct clocksource *clock)
 {
 	cycle_t interval;
-	u64 tmp;
+	u64 tmp, ntpinterval;
 
 	timekeeper.clock = clock;
 	clock->cycle_last = clock->read(clock);
@@ -70,6 +72,7 @@ static void timekeeper_setup_internals(s
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
 	tmp <<= clock->shift;
+	ntpinterval = tmp;
 	tmp += clock->mult/2;
 	do_div(tmp, clock->mult);
 	if (tmp == 0)
@@ -80,6 +83,7 @@ static void timekeeper_setup_internals(s
 
 	/* Go back from cycles -> shifted ns */
 	timekeeper.xtime_interval = (u64) interval * clock->mult;
+	timekeeper.xtime_remainder = ntpinterval - timekeeper.xtime_interval;
 	timekeeper.raw_interval =
 		((u64) interval * clock->mult) >> clock->shift;
 
@@ -746,7 +750,8 @@ static cycle_t logarithmic_accumulation(
 
 	/* Accumulate error between NTP and clock interval */
 	timekeeper.ntp_error += tick_length << shift;
-	timekeeper.ntp_error -= timekeeper.xtime_interval <<
+	timekeeper.ntp_error -=
+	    (timekeeper.xtime_interval + timekeeper.xtime_remainder) <<
 				(timekeeper.ntp_error_shift + shift);
 
 	return offset;
_

Patches currently in -mm which might be from kkp2010@kasperkp.dk are

time-compensate-for-rounding-on-odd-frequency-clocksources.patch

