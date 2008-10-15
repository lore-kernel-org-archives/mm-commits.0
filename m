From: akpm@linux-foundation.org
Subject: - spi-add-spi-over-gpio-driver-fix-returned-error-code.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:00:54 -0700
Message-ID: <200810152300.m9FN0sMM017805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbYJOXBK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:01:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, david-b@pacbell.net, torgil.svensson@gmail.com, mm-commits@vger.kernel.org


The patch titled
     spi-gpio: fix returned error code
has been removed from the -mm tree.  Its filename was
     spi-add-spi-over-gpio-driver-fix-returned-error-code.patch

This patch was dropped because it was folded into spi-add-spi-over-gpio-driver.patch

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
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-fix-returned-error-code.patch
mmc-add-gpio-based-mmc-sd-driver.patch

