From: akpm@linux-foundation.org
Subject: + cs5535-clockevt-dont-ignore-mfgpt-on-smp-capable-kernels.patch added to -mm tree
Date: Mon, 06 Feb 2012 14:55:28 -0800
Message-ID: <20120206225529.4A149A0110@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:57541 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2BFWza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 17:55:30 -0500
Received: by yhgm50 with SMTP id m50so701492yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 14:55:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JRottmann@LiPPERTEmbedded.de, dilinger@queued.net, john.stultz@linaro.org, tglx@linutronix.de


The patch titled
     Subject: cs5535-clockevt: don't ignore MFGPT on SMP-capable kernels
has been added to the -mm tree.  Its filename is
     cs5535-clockevt-dont-ignore-mfgpt-on-smp-capable-kernels.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: cs5535-clockevt: don't ignore MFGPT on SMP-capable kernels

Patches currently in -mm which might be from JRottmann@LiPPERTEmbedded.de are

cs5535-clockevt-dont-ignore-mfgpt-on-smp-capable-kernels.patch
cs5535-clockevt-allow-the-mfgpt-irq-to-be-shared.patch

