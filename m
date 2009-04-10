From: akpm@linux-foundation.org
Subject: + pca953x-support-gpiolib-gpio-naming.patch added to -mm tree
Date: Fri, 10 Apr 2009 14:38:41 -0700
Message-ID: <200904102138.n3ALcfBK002657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865AbZDJVnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 17:43:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsilvers@simtec.co.uk, bgardner@wabtec.com, david-b@pacbell.net, khali@linux-fr.org


The patch titled
     pca953x: support GPIOLIB GPIO naming
has been added to the -mm tree.  Its filename is
     pca953x-support-gpiolib-gpio-naming.patch

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
Subject: pca953x: support GPIOLIB GPIO naming
From: Daniel Silverstone <dsilvers@simtec.co.uk>

Add support to the PCA953x driver to use the GPIOLIB naming facility for
GPIOs.

Signed-off-by: Daniel Silverstone <dsilvers@simtec.co.uk>
Cc: Ben Gardner <bgardner@wabtec.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c      |    4 ++++
 include/linux/i2c/pca953x.h |    1 +
 2 files changed, 5 insertions(+)

diff -puN drivers/gpio/pca953x.c~pca953x-support-gpiolib-gpio-naming drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~pca953x-support-gpiolib-gpio-naming
+++ a/drivers/gpio/pca953x.c
@@ -50,6 +50,7 @@ struct pca953x_chip {
 
 	struct i2c_client *client;
 	struct gpio_chip gpio_chip;
+	char **names;
 };
 
 static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
@@ -192,6 +193,7 @@ static void pca953x_setup_gpio(struct pc
 	gc->label = chip->client->name;
 	gc->dev = &chip->client->dev;
 	gc->owner = THIS_MODULE;
+	gc->names = chip->names;
 }
 
 static int __devinit pca953x_probe(struct i2c_client *client,
@@ -215,6 +217,8 @@ static int __devinit pca953x_probe(struc
 
 	chip->gpio_start = pdata->gpio_base;
 
+	chip->names = pdata->names;
+
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
 	 */
diff -puN include/linux/i2c/pca953x.h~pca953x-support-gpiolib-gpio-naming include/linux/i2c/pca953x.h
--- a/include/linux/i2c/pca953x.h~pca953x-support-gpiolib-gpio-naming
+++ a/include/linux/i2c/pca953x.h
@@ -15,4 +15,5 @@ struct pca953x_platform_data {
 	int		(*teardown)(struct i2c_client *client,
 				unsigned gpio, unsigned ngpio,
 				void *context);
+	char		**names;
 };
_

Patches currently in -mm which might be from dsilvers@simtec.co.uk are

pca953x-support-gpiolib-gpio-naming.patch

