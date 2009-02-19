From: akpm@linux-foundation.org
Subject: [merged] spi-gpio-sanitize-miso-bitvalue.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:24 -0800
Message-ID: <200902191917.n1JJHOrh016372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537AbZBSTRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi-gpio: sanitize MISO bitvalue
has been removed from the -mm tree.  Its filename was
     spi-gpio-sanitize-miso-bitvalue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
bcm47xx-fix-gpio-api-return-codes.patch

