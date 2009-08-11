From: akpm@linux-foundation.org
Subject: [merged] pcap-regulator-register-earlier.patch removed from -mm tree
Date: Tue, 11 Aug 2009 12:58:10 -0700
Message-ID: <200908111958.n7BJwAtT022524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbZHKT7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 15:59:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ospite@studenti.unina.it, broonie@opensource.wolfsonmicro.com, dbrownell@users.sourceforge.net, drwyrm@gmail.com, eric.y.miao@gmail.com, lrg@slimlogic.co.uk, sameo@linux.intel.com, mm


The patch titled
     pcap-regulator: register earlier
has been removed from the -mm tree.  Its filename was
     pcap-regulator-register-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcap-regulator: register earlier
From: Antonio Ospite <ospite@studenti.unina.it>

Register pcap-regulator earlier so it can be used with cpufreq

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/pcap-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/regulator/pcap-regulator.c~pcap-regulator-register-earlier drivers/regulator/pcap-regulator.c
--- a/drivers/regulator/pcap-regulator.c~pcap-regulator-register-earlier
+++ a/drivers/regulator/pcap-regulator.c
@@ -310,7 +310,7 @@ static void __exit pcap_regulator_exit(v
 	platform_driver_unregister(&pcap_regulator_driver);
 }
 
-module_init(pcap_regulator_init);
+subsys_initcall(pcap_regulator_init);
 module_exit(pcap_regulator_exit);
 
 MODULE_AUTHOR("Daniel Ribeiro <drwyrm@gmail.com>");
_

Patches currently in -mm which might be from ospite@studenti.unina.it are

linux-next.patch
pxa2xx_spi-register-earlier.patch

