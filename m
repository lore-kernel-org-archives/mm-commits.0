From: akpm@google.com
Subject: + pps-gpio-client-add-missing-dependency.patch added to -mm tree
Date: Thu, 22 Sep 2011 15:02:04 -0700
Message-ID: <201109222202.p8MM24q9017764@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:45279 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1IVWCQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Sep 2011 18:02:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, giometti@enneenne.com, jamesnuss@nanometrics.ca


The patch titled
     Subject: pps gpio client: add missing dependency
has been added to the -mm tree.  Its filename is
     pps-gpio-client-add-missing-dependency.patch

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
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: pps gpio client: add missing dependency

Add "depends on GENERIC_HARDIRQS" to avoid compile breakage on s390:

drivers/built-in.o: In function `pps_gpio_remove':
linux-next/drivers/pps/clients/pps-gpio.c:189: undefined reference to `free_irq'

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Nuss <jamesnuss@nanometrics.ca>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@google.com>
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
Subject: Subject: pps gpio client: add missing dependency

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
consolidate-config_debug_strict_user_copy_checks.patch
pps-gpio-client-add-missing-dependency.patch

