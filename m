From: akpm@linux-foundation.org
Subject: + spi-add-spi-over-gpio-driver-fix-returned-error-code.patch added to -mm tree
Date: Sat, 26 Jul 2008 12:13:22 -0700
Message-ID: <200807261913.m6QJDM0a015178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbYGZTNf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 15:13:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, david-b@pacbell.net, torgil.svensson@gmail.com


The patch titled
     spi-gpio: fix returned error code
has been added to the -mm tree.  Its filename is
     spi-add-spi-over-gpio-driver-fix-returned-error-code.patch

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
Subject: spi-gpio: fix returned error code
From: Michael Buesch <mb@bu3sch.de>

This fixes the returned error code in case spi_new_device failed.

Reviewed-by: Torgil Svensson <torgil.svensson@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_gpio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/spi/spi_gpio.c~spi-add-spi-over-gpio-driver-fix-returned-error-code drivers/spi/spi_gpio.c
--- a/drivers/spi/spi_gpio.c~spi-add-spi-over-gpio-driver-fix-returned-error-code
+++ a/drivers/spi/spi_gpio.c
@@ -167,6 +167,7 @@ static int spi_gpio_probe(struct platfor
 	if (err)
 		goto err_bi_setup;
 	sp->bi.controller_data = sp;
+	err = -ENOMEM;
 	spidev = spi_new_device(master, &sp->bi);
 	if (!spidev)
 		goto err_new_dev;
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch
gpiolib-fix-typo-in-comment.patch
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-fix-returned-error-code.patch
mmc-add-gpio-based-mmc-sd-driver.patch

