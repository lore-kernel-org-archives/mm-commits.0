From: akpm@linux-foundation.org
Subject: - jdelvare-i2c-i2c-piix4-fix-ati-pci-ids.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:27 -0700
Message-ID: <200708311656.l7VGuRQ9017487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932325AbXHaRIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 13:08:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shane.huang@amd.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c-piix4: Fix SB700 PCI device ID
has been removed from the -mm tree.  Its filename was
     jdelvare-i2c-i2c-piix4-fix-ati-pci-ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i2c-piix4: Fix SB700 PCI device ID
From: Shane Huang <shane.huang@amd.com>
Subject: i2c-piix4: Fix SB700 PCI device ID

We find that SB700 and SB800 use the same SMBus device ID as SB600,
which is 0x4385, instead of the already submitted 0x4395.

Besides removing the wrong SB700 device ID, add SB800 support
to kernel, by renaming the PCI_DEVICE_ID_ATI_IXP600_SMBUS
into PCI_DEVICE_ID_ATI_SBX00_SMBUS.

Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 Documentation/i2c/busses/i2c-piix4 |    2 +-
 drivers/i2c/busses/Kconfig         |    1 +
 drivers/i2c/busses/i2c-piix4.c     |    6 ++----
 include/linux/pci_ids.h            |    3 +--
 4 files changed, 5 insertions(+), 7 deletions(-)

--- linux-2.6.23-rc3.orig/Documentation/i2c/busses/i2c-piix4	2007-08-23 19:41:25.000000000 +0200
+++ linux-2.6.23-rc3/Documentation/i2c/busses/i2c-piix4	2007-08-25 10:52:17.000000000 +0200
@@ -6,7 +6,7 @@ Supported adapters:
     Datasheet: Publicly available at the Intel website
   * ServerWorks OSB4, CSB5, CSB6 and HT-1000 southbridges
     Datasheet: Only available via NDA from ServerWorks
-  * ATI IXP200, IXP300, IXP400, SB600 and SB700 southbridges
+  * ATI IXP200, IXP300, IXP400, SB600, SB700 and SB800 southbridges
     Datasheet: Not publicly available
   * Standard Microsystems (SMSC) SLC90E66 (Victory66) southbridge
     Datasheet: Publicly available at the SMSC website http://www.smsc.com
--- linux-2.6.23-rc3.orig/drivers/i2c/busses/i2c-piix4.c	2007-08-23 19:41:25.000000000 +0200
+++ linux-2.6.23-rc3/drivers/i2c/busses/i2c-piix4.c	2007-08-25 10:52:17.000000000 +0200
@@ -23,7 +23,7 @@
    Supports:
 	Intel PIIX4, 440MX
 	Serverworks OSB4, CSB5, CSB6, HT-1000
-	ATI IXP200, IXP300, IXP400, SB600, SB700
+	ATI IXP200, IXP300, IXP400, SB600, SB700, SB800
 	SMSC Victory66
 
    Note: we assume there can only be one device, with one SMBus interface.
@@ -397,9 +397,7 @@ static struct pci_device_id piix4_ids[] 
 	  .driver_data = 0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS),
 	  .driver_data = 0 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SMBUS),
-	  .driver_data = 0 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SMBUS),
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS),
 	  .driver_data = 0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_OSB4),
 	  .driver_data = 0 },
--- linux-2.6.23-rc3.orig/drivers/i2c/busses/Kconfig	2007-08-23 19:41:25.000000000 +0200
+++ linux-2.6.23-rc3/drivers/i2c/busses/Kconfig	2007-08-25 10:52:17.000000000 +0200
@@ -208,6 +208,7 @@ config I2C_PIIX4
 	    ATI IXP400
 	    ATI SB600
 	    ATI SB700
+	    ATI SB800
 	    Serverworks OSB4
 	    Serverworks CSB5
 	    Serverworks CSB6
--- linux-2.6.23-rc3.orig/include/linux/pci_ids.h	2007-08-25 10:52:03.000000000 +0200
+++ linux-2.6.23-rc3/include/linux/pci_ids.h	2007-08-25 10:52:17.000000000 +0200
@@ -374,10 +374,9 @@
 #define PCI_DEVICE_ID_ATI_IXP400_SATA   0x4379
 #define PCI_DEVICE_ID_ATI_IXP400_SATA2	0x437a
 #define PCI_DEVICE_ID_ATI_IXP600_SATA	0x4380
-#define PCI_DEVICE_ID_ATI_IXP600_SMBUS	0x4385
+#define PCI_DEVICE_ID_ATI_SBX00_SMBUS	0x4385
 #define PCI_DEVICE_ID_ATI_IXP600_IDE	0x438c
 #define PCI_DEVICE_ID_ATI_IXP700_SATA	0x4390
-#define PCI_DEVICE_ID_ATI_IXP700_SMBUS	0x4395
 #define PCI_DEVICE_ID_ATI_IXP700_IDE	0x439c
 
 #define PCI_VENDOR_ID_VLSI		0x1004

Patches currently in -mm which might be from shane.huang@amd.com are

origin.patch
