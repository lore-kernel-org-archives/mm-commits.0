From: akpm@linux-foundation.org
Subject: [folded] leds-heartbeat-stop-on-shutdown-v5.patch removed from -mm tree
Date: Tue, 29 May 2012 14:53:58 -0700
Message-ID: <20120529215358.66C63A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37986 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2E2VyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:54:00 -0400
Received: by eaao13 with SMTP id o13so266319eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:53:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holler@ahsoftware.de, rpurdie@rpsys.net, shuahkhan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-heartbeat-stop-on-shutdown-v5
has been removed from the -mm tree.  Its filename was
     leds-heartbeat-stop-on-shutdown-v5.patch

This patch was dropped because it was folded into leds-heartbeat-stop-on-shutdown.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from holler@ahsoftware.de are

leds-heartbeat-stop-on-shutdown.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch

