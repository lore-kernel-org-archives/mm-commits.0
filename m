From: akpm@linux-foundation.org
Subject: - arm-fix-have_clk-merge-goof.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:29:38 -0700
Message-ID: <200807292029.m6TKTc3N019716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbYG2U3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:29:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     arm: fix HAVE_CLK merge goof
has been removed from the -mm tree.  Its filename was
     arm-fix-have_clk-merge-goof.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: fix HAVE_CLK merge goof
From: David Brownell <dbrownell@users.sourceforge.net>

This fixes a merge goof whereby ARCH_EP93XX got the "select HAVE_CLK" line
which belongs instead with ARCH_AT91.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/Kconfig~arm-fix-have_clk-merge-goof arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-fix-have_clk-merge-goof
+++ a/arch/arm/Kconfig
@@ -234,6 +234,7 @@ config ARCH_VERSATILE
 config ARCH_AT91
 	bool "Atmel AT91"
 	select GENERIC_GPIO
+	select HAVE_CLK
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
 	  AT91SAM9 and AT91CAP9 processors.
@@ -267,7 +268,6 @@ config ARCH_EP93XX
 	select ARM_VIC
 	select GENERIC_GPIO
 	select HAVE_CLK
-	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails.patch
linux-next.patch
spi-new-orion_spi-driver.patch
genirq-better-warning-on-irqchip-set_type-failure.patch

