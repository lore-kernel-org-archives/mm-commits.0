From: akpm@linux-foundation.org
Subject: + spi-add-default-selection-of-pl022-for-arm-reference-platforms.patch added to -mm tree
Date: Wed, 22 Jul 2009 13:48:12 -0700
Message-ID: <200907222048.n6MKmCJ3000566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbZGVUsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Jul 2009 16:48:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.walleij@stericsson.com, dbrownell@users.sourceforge.net


The patch titled
     spi: add default selection of PL022 for ARM reference platforms
has been added to the -mm tree.  Its filename is
     spi-add-default-selection-of-pl022-for-arm-reference-platforms.patch

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
Subject: spi: add default selection of PL022 for ARM reference platforms
From: Linus Walleij <Linus Walleij linus.walleij@stericsson.com>

This makes the PL022 driver a default choice for any RealView and
Versatile boards plus the integrator IMPD1 which all contain the PL022
PrimeCell.  This will make it a default choice if and only if a user
selects SPI support for their board.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/spi/Kconfig~spi-add-default-selection-of-pl022-for-arm-reference-platforms drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-add-default-selection-of-pl022-for-arm-reference-platforms
+++ a/drivers/spi/Kconfig
@@ -166,6 +166,9 @@ config SPI_PL022
 	tristate "ARM AMBA PL022 SSP controller (EXPERIMENTAL)"
 	depends on ARM_AMBA && EXPERIMENTAL
 	default y if MACH_U300
+	default y if ARCH_REALVIEW
+	default y if INTEGRATOR_IMPD1
+	default y if ARCH_VERSATILE
 	help
 	  This selects the ARM(R) AMBA(R) PrimeCell PL022 SSP
 	  controller. If you have an embedded system with an AMBA(R)
_

Patches currently in -mm which might be from linus.walleij@stericsson.com are

origin.patch
linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-update.patch
mtd-sst25l-non-jedec-spi-flash-driver-fix.patch
spi-add-default-selection-of-pl022-for-arm-reference-platforms.patch
rtc-u300-coh-901-331-rtc-driver-v3.patch

