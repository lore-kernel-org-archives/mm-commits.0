From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:20 -0700
Message-ID: <200904071906.n37J6KWo010779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756401AbZDGTLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: Fix erroneous SPI Clock divisor calculation
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

