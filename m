From: akpm@linux-foundation.org
Subject: - leds-ams-delta-fix-wrong-loop-direction-on-removal.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:43 -0800
Message-ID: <200812070005.mB705hff021538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753560AbYLGAF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven.wegener@stealer.net, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds-ams-delta: fix wrong loop direction on removal
has been removed from the -mm tree.  Its filename was
     leds-ams-delta-fix-wrong-loop-direction-on-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-ams-delta: fix wrong loop direction on removal
From: Sven Wegener <sven.wegener@stealer.net>

We want to go upwards, not downwards.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-ams-delta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-ams-delta.c~leds-ams-delta-fix-wrong-loop-direction-on-removal drivers/leds/leds-ams-delta.c
--- a/drivers/leds/leds-ams-delta.c~leds-ams-delta-fix-wrong-loop-direction-on-removal
+++ a/drivers/leds/leds-ams-delta.c
@@ -127,7 +127,7 @@ static int ams_delta_led_remove(struct p
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(ams_delta_leds); i--)
+	for (i = 0; i < ARRAY_SIZE(ams_delta_leds); i++)
 		led_classdev_unregister(&ams_delta_leds[i].cdev);
 
 	return 0;
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

linux-next.patch

