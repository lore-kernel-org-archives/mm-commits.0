From: akpm@linux-foundation.org
Subject: + leds-heartbeat-stop-on-shutdown.patch added to -mm tree
Date: Tue, 24 Apr 2012 14:05:51 -0700
Message-ID: <20120424210552.2E1BEA009E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:63865 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab2DXVF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Apr 2012 17:05:57 -0400
Received: by bkcjk7 with SMTP id jk7so55920bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Apr 2012 14:05:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holler@ahsoftware.de, rpurdie@rpsys.net, shuahkhan@gmail.com


The patch titled
     Subject: leds: heartbeat: stop on shutdown
has been added to the -mm tree.  Its filename is
     leds-heartbeat-stop-on-shutdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Holler <holler@ahsoftware.de>
Subject: leds: heartbeat: stop on shutdown

A halted kernel should not show a heartbeat.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Cc: Shuah Khan <shuahkhan@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-heartbeat.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

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
@@ -103,13 +104,28 @@ static struct led_trigger heartbeat_led_
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
 static int __init heartbeat_trig_init(void)
 {
-	return led_trigger_register(&heartbeat_led_trigger);
+	int rc = led_trigger_register(&heartbeat_led_trigger);
+	if( ! rc )
+		register_reboot_notifier(&heartbeat_reboot_nb);
+	return rc;
 }
 
 static void __exit heartbeat_trig_exit(void)
 {
+	unregister_reboot_notifier(&heartbeat_reboot_nb);
 	led_trigger_unregister(&heartbeat_led_trigger);
 }
 
_
Subject: Subject: leds: heartbeat: stop on shutdown

Patches currently in -mm which might be from holler@ahsoftware.de are

leds-heartbeat-stop-on-shutdown.patch

