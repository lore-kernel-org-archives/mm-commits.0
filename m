From: akpm@linux-foundation.org
Subject: [merged] watchdog-fix-hpwdt-kconfig-regression-in-30-rc.patch removed from -mm tree
Date: Mon, 18 Jul 2011 12:15:53 -0700
Message-ID: <201107181915.p6IJFJEp022156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab1GRTPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jul 2011 15:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, tcamuso@redhat.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog: fix hpwdt Kconfig regression in 3.0-rc
has been removed from the -mm tree.  Its filename was
     watchdog-fix-hpwdt-kconfig-regression-in-30-rc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: fix hpwdt Kconfig regression in 3.0-rc
From: Olaf Hering <olaf@aepfle.de>

Remove Kconfig regression caused by commit
a4616153deae053b29a2b7dd9ec4b2a225accfc5 ("watchdog: hpwdt: build hpwdt as
module by default with NMI_DECODING enabled").

With the above change applied, hpwdt will be enabled unconditionally by
just entering the Watchdog subscreen in menuconfig.  Since this driver is
not essential to boot any box it should remain disabled until it gets
manually enabled, just like all other drivers.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: Tony Camuso <tcamuso@redhat.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/watchdog/Kconfig~watchdog-fix-hpwdt-kconfig-regression-in-30-rc drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~watchdog-fix-hpwdt-kconfig-regression-in-30-rc
+++ a/drivers/watchdog/Kconfig
@@ -609,7 +609,6 @@ config IT87_WDT
 config HP_WATCHDOG
 	tristate "HP ProLiant iLO2+ Hardware Watchdog Timer"
 	depends on X86
-	default m
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
 	  will detect lockups and provide a stack trace. This is a driver that
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
linux-next.patch

