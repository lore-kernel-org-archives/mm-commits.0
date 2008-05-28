From: akpm@linux-foundation.org
Subject: + wm97xx-core-fix-race-on-phy-init.patch added to -mm tree
Date: Wed, 28 May 2008 16:03:47 -0700
Message-ID: <200805282303.m4SN3lh8004855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821AbYE1XFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 19:05:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, giometti@enneenne.com


The patch titled
     wm97xx-core: fix race on PHY init
has been added to the -mm tree.  Its filename is
     wm97xx-core-fix-race-on-phy-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wm97xx-core: fix race on PHY init
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

The chip phy_init() function must be called before the dig_enable()
function but dig_enable() is called when the device is opened and we only
call phy_init() after having reigstered the device, meaning the two can
race.  Fix this by doing the phy_init() before we register the input
device.

Thanks to Rodolfo Giometti for the report.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Reported-by: Rodolfo Giometti <giometti@enneenne.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm97xx-core.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/input/touchscreen/wm97xx-core.c~wm97xx-core-fix-race-on-phy-init drivers/input/touchscreen/wm97xx-core.c
--- a/drivers/input/touchscreen/wm97xx-core.c~wm97xx-core-fix-race-on-phy-init
+++ a/drivers/input/touchscreen/wm97xx-core.c
@@ -608,6 +608,17 @@ static int wm97xx_probe(struct device *d
 		goto alloc_err;
 	}
 
+	/* set up physical characteristics */
+	wm->codec->phy_init(wm);
+
+	/* load gpio cache */
+	wm->gpio[0] = wm97xx_reg_read(wm, AC97_GPIO_CFG);
+	wm->gpio[1] = wm97xx_reg_read(wm, AC97_GPIO_POLARITY);
+	wm->gpio[2] = wm97xx_reg_read(wm, AC97_GPIO_STICKY);
+	wm->gpio[3] = wm97xx_reg_read(wm, AC97_GPIO_WAKEUP);
+	wm->gpio[4] = wm97xx_reg_read(wm, AC97_GPIO_STATUS);
+	wm->gpio[5] = wm97xx_reg_read(wm, AC97_MISC_AFE);
+
 	wm->input_dev = input_allocate_device();
 	if (wm->input_dev == NULL) {
 		ret = -ENOMEM;
@@ -635,17 +646,6 @@ static int wm97xx_probe(struct device *d
 	if (ret < 0)
 		goto dev_alloc_err;
 
-	/* set up physical characteristics */
-	wm->codec->phy_init(wm);
-
-	/* load gpio cache */
-	wm->gpio[0] = wm97xx_reg_read(wm, AC97_GPIO_CFG);
-	wm->gpio[1] = wm97xx_reg_read(wm, AC97_GPIO_POLARITY);
-	wm->gpio[2] = wm97xx_reg_read(wm, AC97_GPIO_STICKY);
-	wm->gpio[3] = wm97xx_reg_read(wm, AC97_GPIO_WAKEUP);
-	wm->gpio[4] = wm97xx_reg_read(wm, AC97_GPIO_STATUS);
-	wm->gpio[5] = wm97xx_reg_read(wm, AC97_MISC_AFE);
