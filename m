From: akpm@linux-foundation.org
Subject: - wm97xx-core-report-a-phys-for-wm97xx-touchscreens.patch removed from -mm tree
Date: Fri, 30 May 2008 15:39:10 -0700
Message-ID: <200805302239.m4UMdAOp014889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbYE3WkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:40:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     wm97xx-core: report a phys for WM97xx touchscreens
has been removed from the -mm tree.  Its filename was
     wm97xx-core-report-a-phys-for-wm97xx-touchscreens.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-regulator.patch

