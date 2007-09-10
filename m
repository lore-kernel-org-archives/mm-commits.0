From: akpm@linux-foundation.org
Subject: + i2c-i801-smbus-patch-for-intel-tolapai.patch added to -mm tree
Date: Mon, 10 Sep 2007 02:41:15 -0700
Message-ID: <200709100941.l8A9fFDV017706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448AbXIJJl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 05:41:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jason.d.gaston@intel.com, khali@linux-fr.org


The patch titled
     i2c-i801: SMBus patch for Intel Tolapai
has been added to the -mm tree.  Its filename is
     i2c-i801-smbus-patch-for-intel-tolapai.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2c-i801: SMBus patch for Intel Tolapai
From: Jason Gaston <jason.d.gaston@intel.com>

Add the Intel Tolapai LPC and SMBus Controller DID's.

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/Kconfig    |    1 +
 drivers/i2c/busses/i2c-i801.c |    3 +++
 2 files changed, 4 insertions(+)

diff -puN drivers/i2c/busses/Kconfig~i2c-i801-smbus-patch-for-intel-tolapai drivers/i2c/busses/Kconfig
--- a/drivers/i2c/busses/Kconfig~i2c-i801-smbus-patch-for-intel-tolapai
+++ a/drivers/i2c/busses/Kconfig
@@ -169,6 +169,7 @@ config I2C_I801
 	    ESB2
 	    ICH8
 	    ICH9
+	    Tolapai
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff -puN drivers/i2c/busses/i2c-i801.c~i2c-i801-smbus-patch-for-intel-tolapai drivers/i2c/busses/i2c-i801.c
--- a/drivers/i2c/busses/i2c-i801.c~i2c-i801-smbus-patch-for-intel-tolapai
+++ a/drivers/i2c/busses/i2c-i801.c
@@ -34,6 +34,7 @@
     ESB2		269B
     ICH8		283E
     ICH9		2930
+    Tolapai		5032
     This driver supports several versions of Intel's I/O Controller Hubs (ICH).
     For SMBus support, they are similar to the PIIX4 and are part
     of Intel's '810' and other chipsets.
@@ -543,6 +544,7 @@ static struct pci_device_id i801_ids[] =
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_17) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_5) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_6) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_Tolapai_1) },
 	{ 0, }
 };
 
@@ -563,6 +565,7 @@ static int __devinit i801_probe(struct p
 	case PCI_DEVICE_ID_INTEL_ESB2_17:
 	case PCI_DEVICE_ID_INTEL_ICH8_5:
 	case PCI_DEVICE_ID_INTEL_ICH9_6:
+	case PCI_DEVICE_ID_INTEL_Tolapai_1:
 		isich4 = 1;
 		break;
 	default:
_

Patches currently in -mm which might be from jason.d.gaston@intel.com are

irq-irq-and-pci_ids-patch-for-intel-tolapai.patch
irq-irq-and-pci_ids-patch-for-intel-tolapai-fix.patch
i2c-i801-documentation-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
ata_piix-ide-mode-sata-patch-for-intel-tolapai.patch
ahci-raid-mode-sata-patch-for-intel-tolapai.patch
