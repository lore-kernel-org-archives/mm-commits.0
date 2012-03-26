From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:26 -0700
Message-ID: <20120326192926.60F74A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37807 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:27 -0400
Received: by mail-ey0-f202.google.com with SMTP id q10so289891eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, neilb@suse.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-tca6507.c: cleanup error handling in tca6507_probe()
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/leds/leds-tca6507.c: cleanup error handling in tca6507_probe()

Just a small tidy-up.

1) There is a NULL dereference if the tca allocation fails.
2) The call to cancel_work_sync() isn't needed because we haven't
   scheduled any work.
3) The call to i2c_set_clientdata() isn't needed because the core
   handles that automatically if probe() fails.
4) I added some curly braces for style reasons.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-tca6507.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-tca6507.c~drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe drivers/leds/leds-tca6507.c
--- a/drivers/leds/leds-tca6507.c~drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe
+++ a/drivers/leds/leds-tca6507.c
@@ -687,10 +687,9 @@ static int __devinit tca6507_probe(struc
 			NUM_LEDS);
 		return -ENODEV;
 	}
-	err = -ENOMEM;
 	tca = kzalloc(sizeof(*tca), GFP_KERNEL);
 	if (!tca)
-		goto exit;
+		return -ENOMEM;
 
 	tca->client = client;
 	INIT_WORK(&tca->work, tca6507_work);
@@ -724,11 +723,10 @@ static int __devinit tca6507_probe(struc
 
 	return 0;
 exit:
-	while (i--)
+	while (i--) {
 		if (tca->leds[i].led_cdev.name)
 			led_classdev_unregister(&tca->leds[i].led_cdev);
-	cancel_work_sync(&tca->work);
-	i2c_set_clientdata(client, NULL);
+	}
 	kfree(tca);
 	return err;
 }
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch

