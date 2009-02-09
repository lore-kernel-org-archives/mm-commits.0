From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:14:52 -0800
Message-ID: <200902092214.n19MEqaP008550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbZBIWPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:15:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     Blackfin SPI Driver: Fix erroneous SPI Clock divisor calculation
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch

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
Subject: Blackfin SPI Driver: Fix erroneous SPI Clock divisor calculation
From: Michael Hennerich <michael.hennerich@analog.com>

Fix erroneous SPI Clock divisor calculation.  Make sure SPI_BAUD is always
>= 2.  Writing a value of 0 or 1 to the SPI_BAUD register disables the
serial clock.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/bfin5xx_spi.h |    2 ++
 drivers/spi/spi_bfin5xx.c               |    3 +++
 2 files changed, 5 insertions(+)

diff -puN arch/blackfin/include/asm/bfin5xx_spi.h~blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation arch/blackfin/include/asm/bfin5xx_spi.h
--- a/arch/blackfin/include/asm/bfin5xx_spi.h~blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation
+++ a/arch/blackfin/include/asm/bfin5xx_spi.h
@@ -11,6 +11,8 @@
 #ifndef _SPI_CHANNEL_H_
 #define _SPI_CHANNEL_H_
 
+#define MIN_SPI_BAUD_VAL	2
+
 #define SPI_READ              0
 #define SPI_WRITE             1
 
diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation
+++ a/drivers/spi/spi_bfin5xx.c
@@ -158,6 +158,9 @@ static u16 hz_to_spi_baud(u32 speed_hz)
 	if ((sclk % (2 * speed_hz)) > 0)
 		spi_baud++;
 
+	if (spi_baud < MIN_SPI_BAUD_VAL)
+		spi_baud = MIN_SPI_BAUD_VAL;
+
 	return spi_baud;
 }
 
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-ad7879-touchscreen-driver.patch
input-ad7879-touchscreen-driver-dont-use-bus_id.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support.patch

