From: akpm@linux-foundation.org
Subject: [merged] pps-gpio-client-add-missing-dependency.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:29:22 -0800
Message-ID: <201111072029.pA7KTMPW014642@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5908 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab1KGU3h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, giometti@enneenne.com, jamesnuss@nanometrics.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: pps gpio client: add missing dependency
has been removed from the -mm tree.  Its filename was
     pps-gpio-client-add-missing-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: pps gpio client: add missing dependency

Add "depends on GENERIC_HARDIRQS" to avoid compile breakage on s390:

drivers/built-in.o: In function `pps_gpio_remove':
linux-next/drivers/pps/clients/pps-gpio.c:189: undefined reference to `free_irq'

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Nuss <jamesnuss@nanometrics.ca>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pps/clients/Kconfig~pps-gpio-client-add-missing-dependency drivers/pps/clients/Kconfig
--- a/drivers/pps/clients/Kconfig~pps-gpio-client-add-missing-dependency
+++ a/drivers/pps/clients/Kconfig
@@ -31,7 +31,7 @@ config PPS_CLIENT_PARPORT
 
 config PPS_CLIENT_GPIO
 	tristate "PPS client using GPIO"
-	depends on PPS
+	depends on PPS && GENERIC_HARDIRQS
 	help
 	  If you say yes here you get support for a PPS source using
 	  GPIO. To be useful you must also register a platform device
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
consolidate-config_debug_strict_user_copy_checks.patch
kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch
kdump-add-udev-events-for-memory-online-offline.patch

