From: akpm@linux-foundation.org
Subject: + e1000e-add-support-for-the-82567lm-4-device.patch added to -mm tree
Date: Wed, 27 Aug 2008 20:46:23 -0700
Message-ID: <200808280346.m7S3kNBL005724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411AbYH1DqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 23:46:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com


The patch titled
     e1000e: add support for the 82567LM-4 device
has been added to the -mm tree.  Its filename is
     e1000e-add-support-for-the-82567lm-4-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

e1000e-add-support-for-the-82567lm-4-device.patch
e1000e-add-support-for-82567lm-3-and-82567lf-3-ich10d-parts.patch
e1000e-add-support-for-new-82574l-part.patch
e100-fix-iomap-read.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning.patch

