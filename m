From: akpm@linux-foundation.org
Subject: + leds-add-led-driver-for-lm3556-chip-fix.patch added to -mm tree
Date: Mon, 23 Apr 2012 14:35:34 -0700
Message-ID: <20120423213534.CBE8EA018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:61734 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab2DWVfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Apr 2012 17:35:37 -0400
Received: by bkcjk7 with SMTP id jk7so69bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Apr 2012 14:35:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, gshark.jeong@gmail.com


The patch titled
     From: Axel Lin <axel.lin@gmail.com>
has been added to the -mm tree.  Its filename is
     leds-add-led-driver-for-lm3556-chip-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: leds: lm3556: Don't call kfree for the memory allocated by devm_kzalloc

The devm_* functions eliminate the need for manual resource releasing
and simplify error handling. Resources allocated by devm_* are freed
automatically on driver detach.

Thus adding kfree calls here will introduce double free bug.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Geon Si Jeong <gshark.jeong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3556.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-fix drivers/leds/leds-lm3556.c
--- a/drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-fix
+++ a/drivers/leds/leds-lm3556.c
@@ -360,9 +360,8 @@ static int lm3556_probe(struct i2c_clien
 		return -ENODATA;
 	}
 
-	chip =
-	    devm_kzalloc(&client->dev, sizeof(struct lm3556_chip_data),
-			 GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof(struct lm3556_chip_data),
+			    GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -416,7 +415,6 @@ err_create_torch_file:
 err_create_flash_file:
 err_chip_init:
 	i2c_set_clientdata(client, NULL);
-	kfree(chip);
 	return err;
 }
 
@@ -430,7 +428,6 @@ static int lm3556_remove(struct i2c_clie
 	led_classdev_unregister(&chip->cdev_flash);
 	lm3556_write_reg(client, REG_ENABLE, 0);
 
-	kfree(chip);
 	return 0;
 }
 
_
Subject: From: Axel Lin <axel.lin@gmail.com>

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
leds-add-led-driver-for-lm3556-chip-fix.patch

