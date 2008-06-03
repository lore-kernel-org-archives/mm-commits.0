From: akpm@linux-foundation.org
Subject: - mmc_spih-should-include-linux-interruptsh.patch removed from -mm tree
Date: Tue, 03 Jun 2008 12:02:28 -0700
Message-ID: <200806031902.m53J2SMY014803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbYFCTIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, drzeus-mmc@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     spi: mmc_spi.h should include linux/interrupts.h
has been removed from the -mm tree.  Its filename was
     mmc_spih-should-include-linux-interruptsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: mmc_spi.h should include linux/interrupts.h
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Since mmc_spi.h uses irqreturn_t type, it should include appropriate
header, otherwise build will break if users didn't include it (some of
them do not use interrupts).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spi/mmc_spi.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/spi/mmc_spi.h~mmc_spih-should-include-linux-interruptsh include/linux/spi/mmc_spi.h
--- a/include/linux/spi/mmc_spi.h~mmc_spih-should-include-linux-interruptsh
+++ a/include/linux/spi/mmc_spi.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_SPI_MMC_SPI_H
 #define __LINUX_SPI_MMC_SPI_H
 
+#include <linux/interrupt.h>
+
 struct device;
 struct mmc_host;
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
serial-fix-driver_name-conflicts.patch
linux-next.patch
git-leds.patch

