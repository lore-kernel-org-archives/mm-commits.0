From: akpm@linux-foundation.org
Subject: - e1000e-add-support-for-the-82567lm-4-device.patch removed from -mm tree
Date: Thu, 04 Sep 2008 12:56:15 -0700
Message-ID: <200809041956.m84JuFk5027863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660AbYIDT4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 15:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000e: add support for the 82567LM-4 device
has been removed from the -mm tree.  Its filename was
     e1000e-add-support-for-the-82567lm-4-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: add support for the 82567LM-4 device
From: Bruce Allan <bruce.w.allan@intel.com>

Enable PCI device ID for a new combination of MAC and PHY already supported
in the driver.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/hw.h      |    1 +
 drivers/net/e1000e/ich8lan.c |    1 +
 drivers/net/e1000e/netdev.c  |    1 +
 3 files changed, 3 insertions(+)

diff -puN drivers/net/e1000e/hw.h~e1000e-add-support-for-the-82567lm-4-device drivers/net/e1000e/hw.h
--- a/drivers/net/e1000e/hw.h~e1000e-add-support-for-the-82567lm-4-device
+++ a/drivers/net/e1000e/hw.h
@@ -346,6 +346,7 @@ enum e1e_registers {
 #define E1000_DEV_ID_ICH8_IFE_G			0x10C5
 #define E1000_DEV_ID_ICH8_IGP_M			0x104D
 #define E1000_DEV_ID_ICH9_IGP_AMT		0x10BD
+#define E1000_DEV_ID_ICH9_BM			0x10E5
 #define E1000_DEV_ID_ICH9_IGP_M_AMT		0x10F5
 #define E1000_DEV_ID_ICH9_IGP_M			0x10BF
 #define E1000_DEV_ID_ICH9_IGP_M_V		0x10CB
diff -puN drivers/net/e1000e/ich8lan.c~e1000e-add-support-for-the-82567lm-4-device drivers/net/e1000e/ich8lan.c
--- a/drivers/net/e1000e/ich8lan.c~e1000e-add-support-for-the-82567lm-4-device
+++ a/drivers/net/e1000e/ich8lan.c
@@ -44,6 +44,7 @@
  * 82567LF-2 Gigabit Network Connection
  * 82567V-2 Gigabit Network Connection
  * 82562GT-3 10/100 Network Connection
+ * 82567LM-4 Gigabit Network Connection
  */
 
 #include <linux/netdevice.h>
diff -puN drivers/net/e1000e/netdev.c~e1000e-add-support-for-the-82567lm-4-device drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-add-support-for-the-82567lm-4-device
+++ a/drivers/net/e1000e/netdev.c
@@ -4767,6 +4767,7 @@ static struct pci_device_id e1000_pci_tb
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH9_IFE_GT), board_ich9lan },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH9_IGP_AMT), board_ich9lan },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH9_IGP_C), board_ich9lan },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH9_BM), board_ich9lan },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH9_IGP_M), board_ich9lan },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH9_IGP_M_AMT), board_ich9lan },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH9_IGP_M_V), board_ich9lan },
_

Patches currently in -mm which might be from bruce.w.allan@intel.com are

linux-next.patch
e1000e-prevent-corruption-of-eeprom-nvm.patch

