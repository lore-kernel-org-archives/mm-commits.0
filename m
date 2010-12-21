From: akpm@linux-foundation.org
Subject: + led_class-fix-typo-in-blink-api.patch added to -mm tree
Date: Mon, 20 Dec 2010 21:38:59 -0800
Message-ID: <201012210542.oBL5gOTF021164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab0LUFms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 00:42:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes.berg@intel.com, rpurdie@linux.intel.com


The patch titled
     led_class: fix typo in blink API
has been added to the -mm tree.  Its filename is
     led_class-fix-typo-in-blink-api.patch

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
Subject: led_class: fix typo in blink API
From: Johannes Berg <johannes.berg@intel.com>

When I added led_blink_set I had a typo: the return value of the hw
offload is a regular error code that is zero when succesful, and in that
case software emulation should not be used, rather than the other way
around.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/led-class.c~led_class-fix-typo-in-blink-api drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~led_class-fix-typo-in-blink-api
+++ a/drivers/leds/led-class.c
@@ -267,7 +267,7 @@ void led_blink_set(struct led_classdev *
 		   unsigned long *delay_off)
 {
 	if (led_cdev->blink_set &&
-	    led_cdev->blink_set(led_cdev, delay_on, delay_off))
+	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
 		return;
 
 	/* blink with 1 Hz as default if nothing specified */
_

Patches currently in -mm which might be from johannes.berg@intel.com are

linux-next.patch
led_class-fix-typo-in-blink-api.patch

