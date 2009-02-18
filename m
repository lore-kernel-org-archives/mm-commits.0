From: akpm@linux-foundation.org
Subject: + spi-gpio-sanitize-miso-bitvalue.patch added to -mm tree
Date: Wed, 18 Feb 2009 13:06:17 -0800
Message-ID: <200902182106.n1IL6H1N028696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbZBRVLA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 16:11:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, dbrownell@users.sourceforge.net


The patch titled
     spi-gpio: sanitize MISO bitvalue
has been added to the -mm tree.  Its filename is
     spi-gpio-sanitize-miso-bitvalue.patch

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
Subject: spi-gpio: sanitize MISO bitvalue
From: Michael Buesch <mb@bu3sch.de>

gpio_get_value() returns 0 or nonzero, but getmiso() expects 0 or 1.
Sanitize the value to a 0/1 boolean.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_gpio.c~spi-gpio-sanitize-miso-bitvalue drivers/spi/spi_gpio.c
--- a/drivers/spi/spi_gpio.c~spi-gpio-sanitize-miso-bitvalue
+++ a/drivers/spi/spi_gpio.c
@@ -114,7 +114,7 @@ static inline void setmosi(const struct 
 
 static inline int getmiso(const struct spi_device *spi)
 {
-	return gpio_get_value(SPI_MISO_GPIO);
+	return !!gpio_get_value(SPI_MISO_GPIO);
 }
 
 #undef pdata
_

Patches currently in -mm which might be from mb@bu3sch.de are

linux-next.patch
bcm47xx-fix-gpio-api-return-codes.patch
spi-gpio-sanitize-miso-bitvalue.patch

