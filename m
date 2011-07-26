From: akpm@linux-foundation.org
Subject: [merged] leds-lp5521-provide-section-tagging.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:42 -0700
Message-ID: <201107260754.p6Q7sjl3003380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab1GZHzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@linaro.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lp5521.c: provide section tagging
has been removed from the -mm tree.  Its filename was
     leds-lp5521-provide-section-tagging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lp5521.c: provide section tagging
From: Linus Walleij <linus.walleij@linaro.org>

Tag the and remove() function as __devexit respectively.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~leds-lp5521-provide-section-tagging drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-lp5521-provide-section-tagging
+++ a/drivers/leds/leds-lp5521.c
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

