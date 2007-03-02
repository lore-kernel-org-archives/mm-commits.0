From: akpm@linux-foundation.org
Subject: - timer-run-calc_load-halfway-through-each-round_jiffies.patch removed from -mm tree
Date: Fri, 02 Mar 2007 14:16:56 -0800
Message-ID: <200703022216.l22MGuPd020657@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43529 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030608AbXCBWRP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 17:17:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timer: run calc_load halfway through each round_jiffies  second
has been removed from the -mm tree.  Its filename was
     timer-run-calc_load-halfway-through-each-round_jiffies.patch

This patch was dropped because it seems to need more thought

------------------------------------------------------
Subject: timer: run calc_load halfway through each round_jiffies  second
From: Simon Arlott <simon@fire.lp0.eu>

Whenever jiffies is started at a multiple of 5*HZ or wraps, calc_load is
run exactly on the second which is when tasks using round_jiffies will be
scheduled to run.  This has a bad effect on the load average, making it
tend towards 1.00 if a task happens to run every time the load is being
calculated.

This changes calc_load so that it updates load half a second after any
tasks scheduled using round_jiffies.

Without this change or an appropriate equivalent, my change to cxacru
causes the load to stay around 1.00 even when mostly idle since it now
runs every second using round_jiffies:
> [  332.416288] cxacru_poll_status(..), jiffies=5000 [start]
> [  332.417312] calc_load(1), count=-1, jiffies=5001 [start]
> [  332.417322] calc_load(1), count=4999, jiffies=5001 [finish]
> [  332.423382] cxacru_poll_status(..), jiffies=5007, next=993 [finish]

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/timer.c~timer-run-calc_load-halfway-through-each-round_jiffies kernel/timer.c
--- a/kernel/timer.c~timer-run-calc_load-halfway-through-each-round_jiffies
+++ a/kernel/timer.c
@@ -1226,17 +1226,19 @@ EXPORT_SYMBOL(avenrun);
 static inline void calc_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
-	static int count = LOAD_FREQ;
+	static int count = LOAD_FREQ + HZ/2;
 
 	count -= ticks;
-	if (unlikely(count < 0)) {
+	if (unlikely(count <= 0)) {
 		active_tasks = count_active_tasks();
 		do {
 			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
 			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
 			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
 			count += LOAD_FREQ;
-		} while (count < 0);
+		} while (count <= 0);
+
+		count = round_jiffies_relative(count + HZ/2) - HZ/2;
 	}
 }
 
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

usbatm-create-sysfs-link-device-from-atm-class-device.patch
cxacru-export-detailed-device-info-through-sysfs-updated.patch
maintainers-add-myself-for-cxacru-in-drivers-usb-atm.patch
timer-run-calc_load-halfway-through-each-round_jiffies.patch
