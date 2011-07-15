From: akpm@linux-foundation.org
Subject: + watchdog-fix-hpwdt-kconfig-regression-in-30-rc.patch added to -mm tree
Date: Fri, 15 Jul 2011 14:34:51 -0700
Message-ID: <201107152134.p6FLYpVF002927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897Ab1GOVfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Jul 2011 17:35:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, tcamuso@redhat.com, wim@iguana.be


The patch titled
     watchdog: fix hpwdt Kconfig regression in 3.0-rc
has been added to the -mm tree.  Its filename is
     watchdog-fix-hpwdt-kconfig-regression-in-30-rc.patch

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

watchdog-fix-hpwdt-kconfig-regression-in-30-rc.patch

