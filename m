From: akpm@linux-foundation.org
Subject: [merged] ezx-pcap-register-earlier.patch removed from -mm tree
Date: Tue, 04 Aug 2009 12:35:30 -0700
Message-ID: <200908041935.n74JZUX5029436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089AbZHDTgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 15:36:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ospite@studenti.unina.it, broonie@opensource.wolfsonmicro.com, dbrownell@users.sourceforge.net, drwyrm@gmail.com, eric.y.miao@gmail.com, lrg@slimlogic.co.uk, sameo@linux.intel.com, mm


The patch titled
     ezx-pcap: register earlier
has been removed from the -mm tree.  Its filename was
     ezx-pcap-register-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ezx-pcap: register earlier
From: Antonio Ospite <ospite@studenti.unina.it>

Register ezx-pcap earlier so it can be used with cpufreq

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

 drivers/mfd/ezx-pcap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/ezx-pcap.c~ezx-pcap-register-earlier drivers/mfd/ezx-pcap.c
--- a/drivers/mfd/ezx-pcap.c~ezx-pcap-register-earlier
+++ a/drivers/mfd/ezx-pcap.c
@@ -542,7 +542,7 @@ static void __exit ezx_pcap_exit(void)
 	spi_unregister_driver(&ezxpcap_driver);
 }
 
-module_init(ezx_pcap_init);
+subsys_initcall(ezx_pcap_init);
 module_exit(ezx_pcap_exit);
 
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from ospite@studenti.unina.it are

linux-next.patch
pcap-regulator-register-earlier.patch
pxa2xx_spi-register-earlier.patch

