From: akpm@linux-foundation.org
Subject: - geode-mfgpt-clock-event-device-support-update.patch removed from -mm tree
Date: Mon, 09 Jul 2007 12:37:44 -0700
Message-ID: <200707091937.l69JbiWB004904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493AbXGIThw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 15:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, mm-commits@vger.kernel.org


The patch titled
     geode-mfgpt-clock-event-device-support update
has been removed from the -mm tree.  Its filename was
     geode-mfgpt-clock-event-device-support-update.patch

This patch was dropped because it was folded into geode-mfgpt-clock-event-device-support.patch

------------------------------------------------------
Subject: geode-mfgpt-clock-event-device-support update
From: Andres Salomon <dilinger@queued.net>

Here's an updated version of this patch which makes scripts/checkpatch.pl
happy, and documents 'mfgpt_irq'.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 ++++
 arch/i386/kernel/mfgpt.c            |   21 ++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff -puN Documentation/kernel-parameters.txt~geode-mfgpt-clock-event-device-support-update Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~geode-mfgpt-clock-event-device-support-update
+++ a/Documentation/kernel-parameters.txt
@@ -1018,6 +1018,10 @@ and is between 256 and 4096 characters. 
 	meye.*=		[HW] Set MotionEye Camera parameters
 			See Documentation/video4linux/meye.txt.
 
+	mfgpt_irq=	[IA-32] Specify the IRQ to use for the
+			Multi-Function General Purpose Timers on AMD Geode
+			platforms.
+
 	mga=		[HW,DRM]
 
 	migration_cost=
diff -puN arch/i386/kernel/mfgpt.c~geode-mfgpt-clock-event-device-support-update arch/i386/kernel/mfgpt.c
--- a/arch/i386/kernel/mfgpt.c~geode-mfgpt-clock-event-device-support-update
+++ a/arch/i386/kernel/mfgpt.c
@@ -312,9 +312,11 @@ static int __init mfgpt_timer_setup(void
 	int timer, ret;
 	u16 val;
 
-	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING, THIS_MODULE);
+	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING,
+			THIS_MODULE);
 	if (timer < 0) {
-		printk(KERN_ERR "mfgpt-timer:  Could not allocate a MFPGT timer\n");
+		printk(KERN_ERR "mfgpt-timer:  Could not allocate a MFPGT "
+				"timer\n");
 		return -ENODEV;
 	}
 
@@ -334,23 +336,28 @@ static int __init mfgpt_timer_setup(void
 	ret = setup_irq(irq, &mfgptirq);
 
 	if (ret) {
-		printk(KERN_ERR "mfgpt-timer:  Unable to set up the interrupt.\n");
+		printk(KERN_ERR "mfgpt-timer:  Unable to set up the "
+				"interrupt.\n");
 		goto err;
 	}
 
 	/* Set up the clock event */
 	mfgpt_clockevent.mult = div_sc(MFGPT_HZ, NSEC_PER_SEC, 32);
-	mfgpt_clockevent.min_delta_ns = clockevent_delta2ns(0xF, &mfgpt_clockevent);
-	mfgpt_clockevent.max_delta_ns = clockevent_delta2ns(0xFFFE, &mfgpt_clockevent);
+	mfgpt_clockevent.min_delta_ns = clockevent_delta2ns(0xF,
+			&mfgpt_clockevent);
+	mfgpt_clockevent.max_delta_ns = clockevent_delta2ns(0xFFFE,
+			&mfgpt_clockevent);
 
-	printk("mfgpt-timer:  registering the MFGT timer as a clock event.\n");
+	printk(KERN_INFO "mfgpt-timer:  registering the MFGT timer as a "
+			"clock event.\n");
 	clockevents_register_device(&mfgpt_clockevent);
 
 	return 0;
 
 err:
 	geode_mfgpt_release_irq(mfgpt_event_clock, MFGPT_CMP2, irq);
-	printk(KERN_ERR "mfgpt-timer:  Unable to set up the MFGPT clock source\n");
+	printk(KERN_ERR "mfgpt-timer:  Unable to set up the MFGPT clock "
+			"source\n");
 	return -EIO;
 }
 
_

Patches currently in -mm which might be from dilinger@queued.net are

geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
geode-mfgpt-clock-event-device-support-update.patch
