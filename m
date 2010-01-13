From: akpm@linux-foundation.org
Subject: + led-classc-quiet-boot-messages.patch added to -mm tree
Date: Wed, 13 Jan 2010 13:36:12 -0800
Message-ID: <201001132136.o0DLaC9p029914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755411Ab0AMVgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 16:36:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com, rpurdie@rpsys.net


The patch titled
     led-class.c: quiet boot messages
has been added to the -mm tree.  Its filename is
     led-classc-quiet-boot-messages.patch

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

linux-next.patch
led-classc-quiet-boot-messages.patch
init-initramfsc-fix-symbol-shadows-an-earlier-one-noise.patch
nodemaskh-remove-macro-any_online_node.patch

