From: akpm@linux-foundation.org
Subject: - uml-clocksource-support.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:48 -0700
Message-ID: <200710162038.l9GKcmGd015483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760190AbXJPVWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     uml: clocksource support
has been removed from the -mm tree.  Its filename was
     uml-clocksource-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: clocksource support
From: Jeff Dike <jdike@addtoit.com>

Add clocksource support.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/time.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN arch/um/kernel/time.c~uml-clocksource-support arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-clocksource-support
+++ a/arch/um/kernel/time.c
@@ -97,6 +97,21 @@ static irqreturn_t um_timer(int irq, voi
 	return IRQ_HANDLED;
 }
 
+static cycle_t itimer_read(void)
+{
+	return os_nsecs();
+}
+
+static struct clocksource itimer_clocksource = {
+	.name		= "itimer",
+	.rating		= 300,
+	.read		= itimer_read,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.mult		= 1,
+	.shift		= 0,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
 static void __init setup_itimer(void)
 {
 	int err;
@@ -111,6 +126,11 @@ static void __init setup_itimer(void)
 		clockevent_delta2ns(60 * HZ, &itimer_clockevent);
 	itimer_clockevent.min_delta_ns =
 		clockevent_delta2ns(1, &itimer_clockevent);
+	err = clocksource_register(&itimer_clocksource);
+	if (err) {
+		printk(KERN_ERR "clocksource_register returned %d\n", err);
+		return;
+	}
 	clockevents_register_device(&itimer_clockevent);
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
