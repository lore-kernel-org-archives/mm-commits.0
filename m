From: akpm@linux-foundation.org
Subject: - jsm-add-new-supported-board-to-jsm-serial-driver.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:56 -0700
Message-ID: <200805021942.m42JguT8011241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758288AbYEBTn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scottk@digi.com, avenkat@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jsm: add new supported board to jsm serial driver
has been removed from the -mm tree.  Its filename was
     jsm-add-new-supported-board-to-jsm-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jsm: add new supported board to jsm serial driver
From: Scott Kilau <scottk@digi.com>

Add new PCI Express Neo/JSM board to the supported list of drivers in
the JSM driver.

Signed-off-by: Scott Kilau <scottk@digi.com>
Acked-by: Ananda V <avenkat@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm.h        |    1 +
 drivers/serial/jsm/jsm_driver.c |    6 +++++-
 include/linux/pci_ids.h         |    1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/serial/jsm/jsm.h~jsm-add-new-supported-board-to-jsm-serial-driver drivers/serial/jsm/jsm.h
--- a/drivers/serial/jsm/jsm.h~jsm-add-new-supported-board-to-jsm-serial-driver
+++ a/drivers/serial/jsm/jsm.h
@@ -373,6 +373,7 @@ struct neo_uart_struct {
 #define PCI_DEVICE_NEO_2DB9PRI_PCI_NAME		"Neo 2 - DB9 Universal PCI - Powered Ring Indicator"
 #define PCI_DEVICE_NEO_2RJ45_PCI_NAME		"Neo 2 - RJ45 Universal PCI"
 #define PCI_DEVICE_NEO_2RJ45PRI_PCI_NAME	"Neo 2 - RJ45 Universal PCI - Powered Ring Indicator"
+#define PCIE_DEVICE_NEO_IBM_PCI_NAME		"Neo 4 - PCI Express - IBM"
 
 /*
  * Our Global Variables.
diff -puN drivers/serial/jsm/jsm_driver.c~jsm-add-new-supported-board-to-jsm-serial-driver drivers/serial/jsm/jsm_driver.c
--- a/drivers/serial/jsm/jsm_driver.c~jsm-add-new-supported-board-to-jsm-serial-driver
+++ a/drivers/serial/jsm/jsm_driver.c
@@ -82,7 +82,10 @@ static int jsm_probe_one(struct pci_dev 
 	/* store the info for the board we've found */
 	brd->boardnum = adapter_count++;
 	brd->pci_dev = pdev;
-	brd->maxports = 2;
+	if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM)
+		brd->maxports = 4;
+	else
+		brd->maxports = 2;
 
 	spin_lock_init(&brd->bd_lock);
 	spin_lock_init(&brd->bd_intr_lock);
@@ -208,6 +211,7 @@ static struct pci_device_id jsm_pci_tbl[
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2DB9PRI), 0, 0, 1 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45), 0, 0, 2 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45PRI), 0, 0, 3 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4_IBM), 0, 0, 4 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, jsm_pci_tbl);
diff -puN include/linux/pci_ids.h~jsm-add-new-supported-board-to-jsm-serial-driver include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~jsm-add-new-supported-board-to-jsm-serial-driver
+++ a/include/linux/pci_ids.h
@@ -1429,6 +1429,7 @@
 #define PCI_DEVICE_ID_NEO_2DB9PRI       0x00C9
 #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA
 #define PCI_DEVICE_ID_NEO_2RJ45PRI      0x00CB
+#define PCIE_DEVICE_ID_NEO_4_IBM        0x00F4
 
 #define PCI_VENDOR_ID_XIRCOM		0x115d
 #define PCI_DEVICE_ID_XIRCOM_RBM56G	0x0101
_

Patches currently in -mm which might be from scottk@digi.com are

origin.patch

