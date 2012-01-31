From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch added to -mm tree
Date: Mon, 30 Jan 2012 16:34:46 -0800
Message-ID: <20120131003446.AFECAA018F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:40107 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab2AaAeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 19:34:50 -0500
Received: by wgbgn7 with SMTP id gn7so222996wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2012 16:34:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, neilb@suse.de, rpurdie@rpsys.net


The patch titled
     Subject: drivers/leds/leds-tca6507.c: cleanup error handling in tca6507_probe()
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: NeilBrown <neilb@suse.de>
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
Subject: Subject: drivers/leds/leds-tca6507.c: cleanup error handling in tca6507_probe()

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch
sysctl-remove-an-unused-variable.patch
sysctl-fix-memset-parameters-in-setup_sysctl_set.patch

