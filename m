From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5521c-ret-may-be-uninitialized.patch added to -mm tree
Date: Mon, 27 Feb 2012 15:29:05 -0800
Message-ID: <20120227232905.B9B84A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40684 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab2B0X3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 18:29:06 -0500
Received: by yenq2 with SMTP id q2so151923yen.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 15:29:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srinidhi.kasagar@stericsson.com, arun.murthy@stericsson.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/leds/leds-lp5521.c: ret may be uninitialized
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5521c-ret-may-be-uninitialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/leds/leds-lp5521.c: ret may be uninitialized

Patches currently in -mm which might be from srinidhi.kasagar@stericsson.com are

linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
leds-lp5521-add-name-in-the-lp5521_led_config.patch
leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch
leds-lp5521-support-led-pattern-data.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
leds-lp5521-redefinition-of-register-bits.patch
drivers-leds-leds-lp5521c-ret-may-be-uninitialized.patch

