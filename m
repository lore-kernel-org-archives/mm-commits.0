From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721-add-pcie-mrrs-override-parameter.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:14:25 -0700
Message-ID: <57a23481.PS/qz8dHkiDZc1cw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758035AbcHCSO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: add PCIe MRRS override parameter
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-add-pcie-mrrs-override-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: add PCIe MRRS override parameter

Add PCIe Maximum Read Request Size (MRRS) adjustment parameter to allow
users to override configuration register value set during PCIe bus
initialization.

Performance of Tsi721 device as PCIe bus master can be improved if MRRS is
set to its maximum value (4096 bytes).  Some platforms have limitations
for supported MRRS and therefore the default value should be preserved,
unless it is known that given platform supports full set of MRRS values
defined by PCI Express specification.

Link: http://lkml.kernel.org/r/1469125134-16523-6-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rapidio/tsi721.txt |    7 +++++++
 drivers/rapidio/devices/tsi721.c |   16 +++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff -puN Documentation/rapidio/tsi721.txt~rapidio-tsi721-add-pcie-mrrs-override-parameter Documentation/rapidio/tsi721.txt
--- a/Documentation/rapidio/tsi721.txt~rapidio-tsi721-add-pcie-mrrs-override-parameter
+++ a/Documentation/rapidio/tsi721.txt
@@ -39,6 +39,13 @@ fully compatible with RIONET driver (Eth
         DMA channels not selected by this mask will not be used by this device
         driver. Default value is 0x7f (use all channels).
 
+- 'pcie_mrrs' - override value for PCIe Maximum Read Request Size (MRRS).
+        This parameter gives an ability to override MRRS value set during PCIe
+        configuration process. Tsi721 supports read request sizes up to 4096B.
+        Value for this parameter must be set as defined by PCIe specification:
+        0 = 128B, 1 = 256B, 2 = 512B, 3 = 1024B, 4 = 2048B and 5 = 4096B.
+        Default value is '-1' (= keep platform setting).
+
 II. Known problems
 
   None.
diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-pcie-mrrs-override-parameter drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-pcie-mrrs-override-parameter
+++ a/drivers/rapidio/devices/tsi721.c
@@ -37,11 +37,15 @@
 #include "tsi721.h"
 
 #ifdef DEBUG
-u32 dbg_level = DBG_INIT | DBG_EXIT;
+u32 dbg_level;
 module_param(dbg_level, uint, S_IWUSR | S_IRUGO);
 MODULE_PARM_DESC(dbg_level, "Debugging output level (default 0 = none)");
 #endif
 
+static int pcie_mrrs = -1;
+module_param(pcie_mrrs, int, S_IRUGO);
+MODULE_PARM_DESC(pcie_mrrs, "PCIe MRRS override value (0...5)");
+
 static void tsi721_omsg_handler(struct tsi721_device *priv, int ch);
 static void tsi721_imsg_handler(struct tsi721_device *priv, int ch);
 
@@ -2840,6 +2844,16 @@ static int tsi721_probe(struct pci_dev *
 	pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
 		PCI_EXP_DEVCTL_RELAX_EN | PCI_EXP_DEVCTL_NOSNOOP_EN, 0);
 
+	/* Override PCIe Maximum Read Request Size setting if requested */
+	if (pcie_mrrs >= 0) {
+		if (pcie_mrrs <= 5)
+			pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
+					PCI_EXP_DEVCTL_READRQ, pcie_mrrs << 12);
+		else
+			tsi_info(&pdev->dev,
+				 "Invalid MRRS override value %d", pcie_mrrs);
+	}
+
 	/* Adjust PCIe completion timeout. */
 	pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL2, 0xf, 0x2);
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


