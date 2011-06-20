From: akpm@linux-foundation.org
Subject: + leds-lp5521-provide-section-tagging.patch added to -mm tree
Date: Mon, 20 Jun 2011 15:00:52 -0700
Message-ID: <201106202200.p5KM0qFo024366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755023Ab1FTWBE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 18:01:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.walleij@linaro.org, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-lp5521.c: provide section tagging
has been added to the -mm tree.  Its filename is
     leds-lp5521-provide-section-tagging.patch

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
Subject: drivers/leds/leds-lp5521.c: provide section tagging
From: Linus Walleij <linus.walleij@linaro.org>

Tag the probe() and remove() function as __devinit and __devexit
respectively.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~leds-lp5521-provide-section-tagging drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-lp5521-provide-section-tagging
+++ a/drivers/leds/leds-lp5521.c
@@ -637,8 +637,8 @@ static int __init lp5521_init_led(struct
 	return 0;
 }
 
-static int lp5521_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int __devinit lp5521_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
 {
 	struct lp5521_chip		*chip;
 	struct lp5521_platform_data	*pdata;
@@ -744,7 +744,7 @@ fail1:
 	return ret;
 }
 
-static int lp5521_remove(struct i2c_client *client)
+static int __devexit lp5521_remove(struct i2c_client *client)
 {
 	struct lp5521_chip *chip = i2c_get_clientdata(client);
 	int i;
@@ -775,7 +775,7 @@ static struct i2c_driver lp5521_driver =
 		.name	= "lp5521",
 	},
 	.probe		= lp5521_probe,
-	.remove		= lp5521_remove,
+	.remove		= __devexit_p(lp5521_remove),
 	.id_table	= lp5521_id,
 };
 
_

Patches currently in -mm which might be from linus.walleij@linaro.org are

origin.patch
linux-next.patch
leds-lp5521-provide-section-tagging.patch

