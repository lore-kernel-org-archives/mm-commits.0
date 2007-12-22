From: akpm@linux-foundation.org
Subject: + fix-rtc_aie-with-config_hpet_emulate_rtc.patch added to -mm tree
Date: Sat, 22 Dec 2007 00:23:58 -0800
Message-ID: <200712220823.lBM8NwwT024510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbXLVI0L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 03:26:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, Robert.Picco@hp.com, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Fix RTC_AIE with CONFIG_HPET_EMULATE_RTC
has been added to the -mm tree.  Its filename is
     fix-rtc_aie-with-config_hpet_emulate_rtc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix RTC_AIE with CONFIG_HPET_EMULATE_RTC
From: Bernhard Walle <bwalle@suse.de>

In the current code, RTC_AIE doesn't work if the RTC relies on
CONFIG_HPET_EMULATE_RTC because the code sets the RTC_AIE flag in
hpet_set_rtc_irq_bit().  The interrupt handles does accidentally check for
RTC_PIE and not RTC_AIE when comparing the time which was set in
hpet_set_alarm_time().

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Robert Picco <Robert.Picco@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
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

git-x86.patch
fix-rtc_aie-with-config_hpet_emulate_rtc.patch
introduce-flags-for-reserve_bootmem.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
use-bootmem_exclusive-for-kdump.patch
