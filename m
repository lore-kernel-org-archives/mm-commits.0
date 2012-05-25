From: akpm@linux-foundation.org
Subject: [folded] leds-add-led-driver-for-lm3556-chip-fix.patch removed from -mm tree
Date: Fri, 25 May 2012 16:04:34 -0700
Message-ID: <20120525230434.87B79A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:40994 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2EYXEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 19:04:36 -0400
Received: by faaa25 with SMTP id a25so73561faa.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 16:04:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, gshark.jeong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: lm3556: don't call kfree for the memory allocated by devm_kzalloc
has been removed from the -mm tree.  Its filename was
     leds-add-led-driver-for-lm3556-chip-fix.patch

This patch was dropped because it was folded into leds-add-led-driver-for-lm3556-chip.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: leds: lm3556: don't call kfree for the memory allocated by devm_kzalloc

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

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
leds-add-led-driver-for-lm3556-chip.patch

