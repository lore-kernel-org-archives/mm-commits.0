From: akpm@linux-foundation.org
Subject: + wm97xx-core-report-a-phys-for-wm97xx-touchscreens.patch added to -mm tree
Date: Wed, 28 May 2008 16:04:40 -0700
Message-ID: <200805282304.m4SN4eCk004868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698AbYE1XFx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 19:05:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, giometti@enneenne.com


The patch titled
     wm97xx-core: report a phys for WM97xx touchscreens
has been added to the -mm tree.  Its filename is
     wm97xx-core-report-a-phys-for-wm97xx-touchscreens.patch

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
Subject: wm97xx-core: report a phys for WM97xx touchscreens
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

phys is displayed in diagnostic output like that from evbug so ensure
that it is set to something.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm97xx-core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/touchscreen/wm97xx-core.c~wm97xx-core-report-a-phys-for-wm97xx-touchscreens drivers/input/touchscreen/wm97xx-core.c
--- a/drivers/input/touchscreen/wm97xx-core.c~wm97xx-core-report-a-phys-for-wm97xx-touchscreens
+++ a/drivers/input/touchscreen/wm97xx-core.c
@@ -616,6 +616,7 @@ static int wm97xx_probe(struct device *d
 
 	/* set up touch configuration */
 	wm->input_dev->name = "wm97xx touchscreen";
+	wm->input_dev->phys = "wm97xx";
 	wm->input_dev->open = wm97xx_ts_input_open;
 	wm->input_dev->close = wm97xx_ts_input_close;
 	set_bit(EV_ABS, wm->input_dev->evbit);
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
wm97xx-core-report-a-phys-for-wm97xx-touchscreens.patch
wm97xx-core-fix-driver-name.patch
wm97xx-core-fix-race-on-phy-init.patch
wm9713-support-five-wire-panels.patch
git-regulator.patch

