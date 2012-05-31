From: akpm@linux-foundation.org
Subject: [merged] leds-heartbeat-stop-on-shutdown.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:47 -0700
Message-ID: <20120531191947.5DACEA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48699 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab2EaTTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:49 -0400
Received: by faaa25 with SMTP id a25so75403faa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holler@ahsoftware.de, bryan.wu@canonical.com, rpurdie@rpsys.net, shuahkhan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: heartbeat: stop on shutdown
has been removed from the -mm tree.  Its filename was
     leds-heartbeat-stop-on-shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexander Holler <holler@ahsoftware.de>
Subject: leds: heartbeat: stop on shutdown

A halted kernel should not show a heartbeat.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Cc: Shuah Khan <shuahkhan@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-heartbeat.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN drivers/leds/ledtrig-heartbeat.c~leds-heartbeat-stop-on-shutdown drivers/leds/ledtrig-heartbeat.c
--- a/drivers/leds/ledtrig-heartbeat.c~leds-heartbeat-stop-on-shutdown
+++ a/drivers/leds/ledtrig-heartbeat.c
@@ -18,6 +18,7 @@
 #include <linux/timer.h>
 #include <linux/sched.h>
 #include <linux/leds.h>
+#include <linux/reboot.h>
 #include "leds.h"
 
 struct heartbeat_trig_data {
@@ -103,13 +104,38 @@ static struct led_trigger heartbeat_led_
 	.deactivate = heartbeat_trig_deactivate,
 };
 
+static int heartbeat_reboot_notifier(struct notifier_block *nb,
+				     unsigned long code, void *unused)
+{
+	led_trigger_unregister(&heartbeat_led_trigger);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block heartbeat_reboot_nb = {
+	.notifier_call = heartbeat_reboot_notifier,
+};
+
+static struct notifier_block heartbeat_panic_nb = {
+	.notifier_call = heartbeat_reboot_notifier,
+};
+
 static int __init heartbeat_trig_init(void)
 {
-	return led_trigger_register(&heartbeat_led_trigger);
+	int rc = led_trigger_register(&heartbeat_led_trigger);
+
+	if (!rc) {
+		atomic_notifier_chain_register(&panic_notifier_list,
+					       &heartbeat_panic_nb);
+		register_reboot_notifier(&heartbeat_reboot_nb);
+	}
+	return rc;
 }
 
 static void __exit heartbeat_trig_exit(void)
 {
+	unregister_reboot_notifier(&heartbeat_reboot_nb);
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &heartbeat_panic_nb);
 	led_trigger_unregister(&heartbeat_led_trigger);
 }
 
_

Patches currently in -mm which might be from holler@ahsoftware.de are

origin.patch

