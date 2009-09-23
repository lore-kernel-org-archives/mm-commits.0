From: akpm@linux-foundation.org
Subject: [merged] spi-add-default-selection-of-pl022-for-arm-reference-platforms.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:47 -0700
Message-ID: <200909231957.n8NJvlvI007636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbZIWT6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:58:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@stericsson.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: add default selection of PL022 for ARM reference platforms
has been removed from the -mm tree.  Its filename was
     spi-add-default-selection-of-pl022-for-arm-reference-platforms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

