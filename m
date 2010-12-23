From: akpm@linux-foundation.org
Subject: [merged] led_class-fix-typo-in-blink-api.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:46 -0800
Message-ID: <201012232240.oBNMeXsv015460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980Ab0LWWkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes.berg@intel.com, rpurdie@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     led_class: fix typo in blink API
has been removed from the -mm tree.  Its filename was
     led_class-fix-typo-in-blink-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

