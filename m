From: akpm@linux-foundation.org
Subject: [merged] mmc-atmel-host-kconfig-cleanup-for-everyone-else.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:48 -0800
Message-ID: <201003091907.o29J7mUJ031384__26672.1523636535$1268162560$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756002Ab0CITWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, jic23@cam.ac.uk, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc: Atmel host kconfig cleanup for everyone else
has been removed from the -mm tree.  Its filename was
     mmc-atmel-host-kconfig-cleanup-for-everyone-else.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: Atmel host kconfig cleanup for everyone else
From: Nicolas Ferre <nicolas.ferre@atmel.com>

This prevents those without an Atmel chip having a line in kernel
configuration which says "Atmel SD/MMC Driver" without any option.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/host/Kconfig~mmc-atmel-host-kconfig-cleanup-for-everyone-else drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~mmc-atmel-host-kconfig-cleanup-for-everyone-else
+++ a/drivers/mmc/host/Kconfig
@@ -189,6 +189,7 @@ config MMC_AU1X
 
 choice
 	prompt "Atmel SD/MMC Driver"
+	depends on AVR32 || ARCH_AT91
 	default MMC_ATMELMCI if AVR32
 	help
 	  Choose which driver to use for the Atmel MCI Silicon
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are


