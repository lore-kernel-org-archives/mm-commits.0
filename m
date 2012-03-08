From: akpm@linux-foundation.org
Subject: [merged] cs5535-clockevt-dont-ignore-mfgpt-on-smp-capable-kernels.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:51 -0800
Message-ID: <20120308191751.65587A06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35115 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263Ab2CHTRx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:53 -0500
Received: by mail-ee0-f74.google.com with SMTP id c41so30194eek.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JRottmann@LiPPERTEmbedded.de, dilinger@queued.net, john.stultz@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: cs5535-clockevt: don't ignore MFGPT on SMP-capable kernels
has been removed from the -mm tree.  Its filename was
     cs5535-clockevt-dont-ignore-mfgpt-on-smp-capable-kernels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Subject: cs5535-clockevt: don't ignore MFGPT on SMP-capable kernels

On SMP-capable kernels (e.g.  generic distro kernel) the cs5535-clockevt
driver loads but is not actually used.

Setting cpumask to cpu_all_mask works for UP-only kernels, but if compiled
for SMP - though still running on the same UP hardware -
kernel/time/tick-common.c:tick_check_new_device() reads this as
"non-cpu-local" and silently ignores the device.

If we leave cpumask unset clockevents_register_device() will initialize it
and the cs5535-clockevt driver will be used no matter how the kernel was
compiled.  Should anyone ever manage to stick a CS553x in an SMP system
(is this even possible?) then a warning will be printed.  This is fine as
the cs5535-clockevt driver was never written/tested for SMP.

If bisecting led you here this patch may have exposed a pre-existing MFGPT
problem.  Configure for UP-only and re-check.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/cs5535-clockevt.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/clocksource/cs5535-clockevt.c~cs5535-clockevt-dont-ignore-mfgpt-on-smp-capable-kernels drivers/clocksource/cs5535-clockevt.c
--- a/drivers/clocksource/cs5535-clockevt.c~cs5535-clockevt-dont-ignore-mfgpt-on-smp-capable-kernels
+++ a/drivers/clocksource/cs5535-clockevt.c
@@ -100,7 +100,6 @@ static struct clock_event_device cs5535_
 	.set_mode = mfgpt_set_mode,
 	.set_next_event = mfgpt_next_event,
 	.rating = 250,
-	.cpumask = cpu_all_mask,
 	.shift = 32
 };
 
_

Patches currently in -mm which might be from JRottmann@LiPPERTEmbedded.de are

linux-next.patch

