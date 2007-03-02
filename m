From: akpm@linux-foundation.org
Subject: - timer-add-an-initial-05s-delay-to-calc_load.patch removed from -mm tree
Date: Thu, 01 Mar 2007 17:19:33 -0800
Message-ID: <200703020119.l221JYrY028555@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33736 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422672AbXCBBT6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:19:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timer: add an initial 0.5s delay to calc_load
has been removed from the -mm tree.  Its filename was
     timer-add-an-initial-05s-delay-to-calc_load.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: timer: add an initial 0.5s delay to calc_load
From: Simon Arlott <simon@fire.lp0.eu>

This adds an initial 0.5s delay to calc_load so that it avoids updating
load at the same time as tasks scheduled using round_jiffies, otherwise the
load average is badly affected by tasks that run every time calc_load does
(currently every 5s).

I'm assuming this change doesn't affect the intention of round_jiffies, to
avoid tasks waking the cpu at different times, because calc_load is already
run very often by a call from update_times(ticks) on every timer interrupt.

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

 kernel/timer.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/timer.c~timer-add-an-initial-05s-delay-to-calc_load kernel/timer.c
--- a/kernel/timer.c~timer-add-an-initial-05s-delay-to-calc_load
+++ a/kernel/timer.c
@@ -1226,7 +1226,7 @@ EXPORT_SYMBOL(avenrun);
 static inline void calc_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
-	static int count = LOAD_FREQ;
+	static int count = LOAD_FREQ + HZ/2;
 
 	count -= ticks;
 	if (unlikely(count < 0)) {
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

usbatm-create-sysfs-link-device-from-atm-class-device.patch
cxacru-export-detailed-device-info-through-sysfs-updated.patch
maintainers-add-myself-for-cxacru-in-drivers-usb-atm.patch
timer-add-an-initial-05s-delay-to-calc_load.patch
