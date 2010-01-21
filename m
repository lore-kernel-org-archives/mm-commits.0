From: akpm@linux-foundation.org
Subject: [merged] led-classc-quiet-boot-messages.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:28:40 -0800
Message-ID: <201001212128.o0LLSeMD030729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755343Ab0AUV2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     led-class.c: quiet boot messages
has been removed from the -mm tree.  Its filename was
     led-classc-quiet-boot-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: led-class.c: quiet boot messages
From: H Hartley Sweeten <hartleys@visionengravers.com>

As each led device gets registered a kernel message gets printed.  In an
embedded system with a number of leds this can produce a lot of output
that just looks like noise.

Change the message type to KERN_DEBUG since it might be useful in the
dmesg output "after" booting.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/led-class.c~led-classc-quiet-boot-messages drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~led-classc-quiet-boot-messages
+++ a/drivers/leds/led-class.c
@@ -164,7 +164,7 @@ int led_classdev_register(struct device 
 	led_trigger_set_default(led_cdev);
 #endif
 
-	printk(KERN_INFO "Registered led device: %s\n",
+	printk(KERN_DEBUG "Registered led device: %s\n",
 			led_cdev->name);
 
 	return 0;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
init-initramfsc-fix-symbol-shadows-an-earlier-one-noise.patch
nodemaskh-remove-macro-any_online_node.patch

