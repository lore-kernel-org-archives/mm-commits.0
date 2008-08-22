From: akpm@linux-foundation.org
Subject: - i2c-i801-smbus-patch-for-intel-ibex-peak-deviceids.patch removed from -mm tree
Date: Fri, 22 Aug 2008 15:55:58 -0700
Message-ID: <200808222255.m7MMtwal020870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821AbYHVW4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 18:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seth.heasley@intel.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c-i801: SMBus patch for Intel Ibex Peak DeviceIDs
has been removed from the -mm tree.  Its filename was
     i2c-i801-smbus-patch-for-intel-ibex-peak-deviceids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c-i801: SMBus patch for Intel Ibex Peak DeviceIDs
From: Seth Heasley <seth.heasley@intel.com>

Add the Intel Ibex Peak (PCH) SMBus Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/Kconfig    |    1 +
 drivers/i2c/busses/i2c-i801.c |    3 +++
 2 files changed, 4 insertions(+)

diff -puN drivers/i2c/busses/Kconfig~i2c-i801-smbus-patch-for-intel-ibex-peak-deviceids drivers/i2c/busses/Kconfig
--- a/drivers/i2c/busses/Kconfig~i2c-i801-smbus-patch-for-intel-ibex-peak-deviceids
+++ a/drivers/i2c/busses/Kconfig
@@ -97,6 +97,7 @@ config I2C_I801
 	    ICH9
 	    Tolapai
 	    ICH10
+	    PCH
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff -puN drivers/i2c/busses/i2c-i801.c~i2c-i801-smbus-patch-for-intel-ibex-peak-deviceids drivers/i2c/busses/i2c-i801.c
--- a/drivers/i2c/busses/i2c-i801.c~i2c-i801-smbus-patch-for-intel-ibex-peak-deviceids
+++ a/drivers/i2c/busses/i2c-i801.c
@@ -41,6 +41,7 @@
   Tolapai               0x5032     32     hard     yes     yes     yes
   ICH10                 0x3a30     32     hard     yes     yes     yes
   ICH10                 0x3a60     32     hard     yes     yes     yes
+  PCH                   0x3b30     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -576,6 +577,7 @@ static struct pci_device_id i801_ids[] =
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TOLAPAI_1) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_5) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH_2) },
 	{ 0, }
 };
 
@@ -599,6 +601,7 @@ static int __devinit i801_probe(struct p
 	case PCI_DEVICE_ID_INTEL_TOLAPAI_1:
 	case PCI_DEVICE_ID_INTEL_ICH10_4:
 	case PCI_DEVICE_ID_INTEL_ICH10_5:
+	case PCI_DEVICE_ID_INTEL_PCH_2:
 		i801_features |= FEATURE_I2C_BLOCK_READ;
 		/* fall through */
 	case PCI_DEVICE_ID_INTEL_82801DB_3:
_

Patches currently in -mm which might be from seth.heasley@intel.com are

origin.patch
linux-next.patch

