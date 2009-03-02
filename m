From: akpm@linux-foundation.org
Subject: [merged] w1-add-missing-kconfig-makefile-entries-for-ds2431-slave-driver.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:22:57 -0800
Message-ID: <200903021922.n22JMvPW014349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753577AbZCBTXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:23:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herton@mandriva.com.br, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     w1: add missing Kconfig/Makefile entries for DS2431 slave driver
has been removed from the -mm tree.  Its filename was
     w1-add-missing-kconfig-makefile-entries-for-ds2431-slave-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: add missing Kconfig/Makefile entries for DS2431 slave driver
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/Kconfig  |    6 ++++++
 drivers/w1/slaves/Makefile |    1 +
 2 files changed, 7 insertions(+)

diff -puN drivers/w1/slaves/Kconfig~w1-add-missing-kconfig-makefile-entries-for-ds2431-slave-driver drivers/w1/slaves/Kconfig
--- a/drivers/w1/slaves/Kconfig~w1-add-missing-kconfig-makefile-entries-for-ds2431-slave-driver
+++ a/drivers/w1/slaves/Kconfig
@@ -16,6 +16,12 @@ config W1_SLAVE_SMEM
 	  Say Y here if you want to connect 1-wire
 	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to your wire.
 
+config W1_SLAVE_DS2431
+	tristate "1kb EEPROM family support (DS2431)"
+	help
+	  Say Y here if you want to use a 1-wire
+	  1kb EEPROM family device (DS2431)
+
 config W1_SLAVE_DS2433
 	tristate "4kb EEPROM family support (DS2433)"
 	help
diff -puN drivers/w1/slaves/Makefile~w1-add-missing-kconfig-makefile-entries-for-ds2431-slave-driver drivers/w1/slaves/Makefile
--- a/drivers/w1/slaves/Makefile~w1-add-missing-kconfig-makefile-entries-for-ds2431-slave-driver
+++ a/drivers/w1/slaves/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm.o
 obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
+obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
 obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
 obj-$(CONFIG_W1_SLAVE_BQ27000)	+= w1_bq27000.o
_

Patches currently in -mm which might be from herton@mandriva.com.br are

origin.patch
linux-next.patch
n411-add-missing-makefile-entry.patch

