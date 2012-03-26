From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5521c-ret-may-be-uninitialized.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:38 -0700
Message-ID: <20120326192938.7B88EA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37807 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:40 -0400
Received: by mail-ey0-f202.google.com with SMTP id q10so289891eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinidhi.kasagar@stericsson.com, arun.murthy@stericsson.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lp5521.c: ret may be uninitialized
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5521c-ret-may-be-uninitialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: drivers/leds/leds-lp5521.c: ret may be uninitialized

Fix it by assigning the lp5521_read return value.

Signed-off-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Cc: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-ret-may-be-uninitialized drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-ret-may-be-uninitialized
+++ a/drivers/leds/leds-lp5521.c
@@ -784,7 +784,7 @@ static int __devinit lp5521_probe(struct
 	 * otherwise further access to the R G B channels in the
 	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
-	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
+	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
 	if (buf != LP5521_REG_R_CURR_DEFAULT) {
 		dev_err(&client->dev, "error in resetting chip\n");
 		goto fail2;
_

Patches currently in -mm which might be from srinidhi.kasagar@stericsson.com are

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch

