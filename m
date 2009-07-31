From: akpm@linux-foundation.org
Subject: + pxa2xx_spi-register-earlier.patch added to -mm tree
Date: Fri, 31 Jul 2009 15:55:43 -0700
Message-ID: <200907312255.n6VMthou011422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbZGaW4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 18:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ospite@studenti.unina.it, broonie@opensource.wolfsonmicro.com, dbrownell@users.sourceforge.net, drwyrm@gmail.com, eric.y.miao@gmail.com, lrg@slimlogic.co.uk, sameo@linux.intel.com


The patch titled
     pxa2xx_spi: register earlier
has been added to the -mm tree.  Its filename is
     pxa2xx_spi-register-earlier.patch

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
Subject: pxa2xx_spi: register earlier
From: Antonio Ospite <ospite@studenti.unina.it>

Register pxa2xx_spi earlier so it can be used with cpufreq

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-register-earlier drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-register-earlier
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1729,7 +1729,7 @@ static int __init pxa2xx_spi_init(void)
 {
 	return platform_driver_probe(&driver, pxa2xx_spi_probe);
 }
-module_init(pxa2xx_spi_init);
+subsys_initcall(pxa2xx_spi_init);
 
 static void __exit pxa2xx_spi_exit(void)
 {
_

Patches currently in -mm which might be from ospite@studenti.unina.it are

pxa2xx_spi-register-earlier.patch
ezx-pcap-register-earlier.patch
pcap-regulator-register-earlier.patch

