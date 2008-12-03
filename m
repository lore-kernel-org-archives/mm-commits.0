From: akpm@linux-foundation.org
Subject: + leds-ams-delta-fix-wrong-loop-direction-on-removal.patch added to -mm tree
Date: Tue, 02 Dec 2008 20:44:40 -0800
Message-ID: <200812030444.mB34ieNR020836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbYLCEpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 23:45:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sven.wegener@stealer.net, rpurdie@rpsys.net


The patch titled
     leds-ams-delta: fix wrong loop direction on removal
has been added to the -mm tree.  Its filename is
     leds-ams-delta-fix-wrong-loop-direction-on-removal.patch

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
leds-pca9532-fix-memory-leak-and-properly-handle-errors.patch
leds-ams-delta-fix-wrong-loop-direction-on-removal.patch

