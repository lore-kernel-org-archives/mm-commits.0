From: akpm@linux-foundation.org
Subject: - fix-rtc_aie-with-config_hpet_emulate_rtc.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:40:05 -0800
Message-ID: <200801160140.m0G1e56L014083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52759 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757274AbYAPBuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:50:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, Robert.Picco@hp.com, ak@suse.de, clemens@ladisch.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Fix RTC_AIE with CONFIG_HPET_EMULATE_RTC
has been removed from the -mm tree.  Its filename was
     fix-rtc_aie-with-config_hpet_emulate_rtc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix RTC_AIE with CONFIG_HPET_EMULATE_RTC
From: Bernhard Walle <bwalle@suse.de>

In the current code, RTC_AIE doesn't work if the RTC relies on
CONFIG_HPET_EMULATE_RTC because the code sets the RTC_AIE flag in
hpet_set_rtc_irq_bit().  The interrupt handles does accidentally check for
RTC_PIE and not RTC_AIE when comparing the time which was set in
hpet_set_alarm_time().

I now verified on a test system here that without the patch applied,
the attached test program fails on a system that has HPET with
2.6.24-rc7-default.

Configuration is CONFIG_RTC=y and CONFIG_HPET_EMULATE_RTC=y.


/* simplified test program for RTC_AIE from Documentation/rtc.txt */
#include <stdio.h>
#include <linux/rtc.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>


int main(int argc, char **argv)
{
	int i, fd, retval, irqcount = 0;
	unsigned long tmp, data;
	struct rtc_time rtc_tm;

	if (!argv[1]) {
		fprintf(stderr, "Usage: %s <device>\n", argv[0]);
		return 1;
	}

	fd = open(argv[1], O_RDONLY);
	if (fd ==  -1)
		return 1;

	/* Read the RTC time/date */
	retval = ioctl(fd, RTC_RD_TIME, &rtc_tm);
	if (retval == -1) {
		perror("RTC_RD_TIME ioctl");
		exit(errno);
	}

	fprintf(stderr, "\n\nCurrent RTC date/time is %d-%d-%d, %02d:%02d:%02d.\n",
		rtc_tm.tm_mday, rtc_tm.tm_mon + 1, rtc_tm.tm_year + 1900,
		rtc_tm.tm_hour, rtc_tm.tm_min, rtc_tm.tm_sec);

	/* Set the alarm to 5 sec in the future, and check for rollover */
	rtc_tm.tm_sec += 5;
	if (rtc_tm.tm_sec >= 60) {
		rtc_tm.tm_sec %= 60;
		rtc_tm.tm_min++;
	}
	if  (rtc_tm.tm_min == 60) {
		rtc_tm.tm_min = 0;
		rtc_tm.tm_hour++;
	}
	if  (rtc_tm.tm_hour == 24)
		rtc_tm.tm_hour = 0;

	retval = ioctl(fd, RTC_ALM_SET, &rtc_tm);
	if (retval == -1) {
		if (errno == ENOTTY) {
			fprintf(stderr,
				"\n...Alarm IRQs not supported.\n");
		}
		perror("RTC_ALM_SET ioctl");
		exit(errno);
	}

	/* Read the current alarm settings */
	retval = ioctl(fd, RTC_ALM_READ, &rtc_tm);
	if (retval == -1) {
		perror("RTC_ALM_READ ioctl");
		exit(errno);
	}

	fprintf(stderr, "Alarm time now set to %02d:%02d:%02d.\n",
		rtc_tm.tm_hour, rtc_tm.tm_min, rtc_tm.tm_sec);

	/* Enable alarm interrupts */
	retval = ioctl(fd, RTC_AIE_ON, 0);
	if (retval == -1) {
		perror("RTC_AIE_ON ioctl");
		exit(errno);
	}

	fprintf(stderr, "Waiting 5 seconds for alarm...");
	fflush(stderr);
	/* This blocks until the alarm ring causes an interrupt */
	retval = read(fd, &data, sizeof(unsigned long));
	if (retval == -1) {
		perror("read");
		exit(errno);
	}
	irqcount++;
	fprintf(stderr, " okay. Alarm rang!\n");

	/* Disable alarm interrupts */
	retval = ioctl(fd, RTC_AIE_OFF, 0);
	if (retval == -1) {
		perror("RTC_AIE_OFF ioctl");
		exit(errno);
	}

	close(fd);

	return 0;
}



Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Robert Picco <Robert.Picco@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/hpet.c~fix-rtc_aie-with-config_hpet_emulate_rtc arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~fix-rtc_aie-with-config_hpet_emulate_rtc
+++ a/arch/x86/kernel/hpet.c
@@ -657,7 +657,7 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 		hpet_pie_count = 0;
 	}
 
-	if (hpet_rtc_flags & RTC_PIE &&
+	if (hpet_rtc_flags & RTC_AIE &&
 	    (curr_time.tm_sec == hpet_alarm_time.tm_sec) &&
 	    (curr_time.tm_min == hpet_alarm_time.tm_min) &&
 	    (curr_time.tm_hour == hpet_alarm_time.tm_hour))
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-x86.patch
introduce-flags-for-reserve_bootmem.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
use-bootmem_exclusive-for-kdump.patch
