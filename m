From: akpm@linux-foundation.org
Subject: + x86-olpc-xo1-sci-propagate-power-supply-battery-events.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:29:30 -0700
Message-ID: <201106292129.p5TLTUga013107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831Ab1F2V3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, dilinger@queued.net, grant.likely@secretlab.ca, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86, olpc-xo1-sci: propagate power supply/battery events
has been added to the -mm tree.  Its filename is
     x86-olpc-xo1-sci-propagate-power-supply-battery-events.patch

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
Subject: x86, olpc-xo1-sci: propagate power supply/battery events
From: Daniel Drake <dsd@laptop.org>

EC events indicate change in AC power connectivity, battery state of
charge, battery error, battery presence, etc.  Send notifications to the
power supply subsystem when changes are detected.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                      |    4 +-
 arch/x86/platform/olpc/olpc-xo1-sci.c |   37 ++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff -puN arch/x86/Kconfig~x86-olpc-xo1-sci-propagate-power-supply-battery-events arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-olpc-xo1-sci-propagate-power-supply-battery-events
+++ a/arch/x86/Kconfig
@@ -2098,7 +2098,7 @@ config ALIX
 
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
-	depends on OLPC && OLPC_XO1_PM
+	depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
 	select GPIO_CS5535
 	select MFD_CORE
 	---help---
@@ -2107,6 +2107,8 @@ config OLPC_XO1_SCI
 	   - Power button
 	   - Ebook switch
 	   - Lid switch
+	   - AC adapter status updates
+	   - Battery status updates
 
 endif # X86_32
 
diff -puN arch/x86/platform/olpc/olpc-xo1-sci.c~x86-olpc-xo1-sci-propagate-power-supply-battery-events arch/x86/platform/olpc/olpc-xo1-sci.c
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c~x86-olpc-xo1-sci-propagate-power-supply-battery-events
+++ a/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/mfd/core.h>
+#include <linux/power_supply.h>
 #include <linux/suspend.h>
 #include <linux/workqueue.h>
 
@@ -52,6 +53,26 @@ static const char * const lid_wake_mode_
 	[LID_WAKE_CLOSE] = "close",
 };
 
+static void battery_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-battery");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
+static void ac_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-ac");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
 /* Report current ebook switch state through input layer */
 static void send_ebook_state(void)
 {
@@ -151,6 +172,18 @@ static void process_sci_queue(bool propa
 
 		pr_debug(PFX "SCI 0x%x received\n", data);
 
+		switch (data) {
+		case EC_SCI_SRC_BATERR:
+		case EC_SCI_SRC_BATSOC:
+		case EC_SCI_SRC_BATTERY:
+		case EC_SCI_SRC_BATCRIT:
+			battery_status_changed();
+			break;
+		case EC_SCI_SRC_ACPWR:
+			ac_status_changed();
+			break;
+		}
+
 		if (data == EC_SCI_SRC_EBOOK && propagate_events)
 			send_ebook_state();
 	} while (data);
@@ -240,6 +273,10 @@ static int xo1_sci_resume(struct platfor
 
 	/* Enable all EC events */
 	olpc_ec_mask_write(EC_SCI_SRC_ALL);
+
+	/* Power/battery status might have changed too */
+	battery_status_changed();
+	ac_status_changed();
 	return 0;
 }
 
_

Patches currently in -mm which might be from dsd@laptop.org are

linux-next.patch
x86-olpc-add-missing-elements-to-device-tree.patch
x86-olpc-move-cs5536-related-constants-to-cs5535h.patch
x86-olpc-rename-olpc-xo1-to-olpc-xo1-pm.patch
x86-olpc-add-xo-1-suspend-resume-support.patch
x86-olpc-add-xo-1-sci-driver-and-power-button-control.patch
x86-olpc-ec-sci-wakeup-mask-functionality.patch
x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality.patch
x86-olpc-xo1-sci-add-lid-switch-functionality.patch
x86-olpc-xo1-sci-propagate-power-supply-battery-events.patch
x86-olpc-add-xo-1-rtc-driver.patch
x86-olpc-add-xo-15-sci-driver.patch

