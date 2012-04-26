From: akpm@linux-foundation.org
Subject: + leds-heartbeat-stop-on-shutdown-v5.patch added to -mm tree
Date: Thu, 26 Apr 2012 14:39:26 -0700
Message-ID: <20120426213926.530D6A0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:44549 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2DZVj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 17:39:27 -0400
Received: by yhgm50 with SMTP id m50so16330yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 14:39:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holler@ahsoftware.de, rpurdie@rpsys.net, shuahkhan@gmail.com


The patch titled
     Subject: leds-heartbeat-stop-on-shutdown-v5
has been added to the -mm tree.  Its filename is
     leds-heartbeat-stop-on-shutdown-v5.patch

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
Subject: leds-heartbeat-stop-on-shutdown-v5

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Cc: Shuah Khan <shuahkhan@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-heartbeat.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/leds/ledtrig-heartbeat.c~leds-heartbeat-stop-on-shutdown-v5 drivers/leds/ledtrig-heartbeat.c
--- a/drivers/leds/ledtrig-heartbeat.c~leds-heartbeat-stop-on-shutdown-v5
+++ a/drivers/leds/ledtrig-heartbeat.c
@@ -115,17 +115,26 @@ static struct notifier_block heartbeat_r
 	.notifier_call = heartbeat_reboot_notifier,
 };
 
+static struct notifier_block heartbeat_panic_nb = {
+	.notifier_call = heartbeat_reboot_notifier,
+};
+
 static int __init heartbeat_trig_init(void)
 {
 	int rc = led_trigger_register(&heartbeat_led_trigger);
-	if( ! rc )
+	if (!rc) {
+		atomic_notifier_chain_register(&panic_notifier_list,
+					       &heartbeat_panic_nb);
 		register_reboot_notifier(&heartbeat_reboot_nb);
+	}
 	return rc;
 }
 
 static void __exit heartbeat_trig_exit(void)
 {
 	unregister_reboot_notifier(&heartbeat_reboot_nb);
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &heartbeat_panic_nb);
 	led_trigger_unregister(&heartbeat_led_trigger);
 }
 
_
Subject: Subject: leds-heartbeat-stop-on-shutdown-v5

Patches currently in -mm which might be from holler@ahsoftware.de are

leds-heartbeat-stop-on-shutdown.patch
leds-heartbeat-stop-on-shutdown-v5.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch

