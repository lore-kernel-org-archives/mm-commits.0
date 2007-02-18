From: akpm@linux-foundation.org
Subject: - atl1-add-l1-device-id-to-pci_ids-then-use-it.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:02 -0800
Message-ID: <200702180215.l1I2F28L008351@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55660 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993108AbXBRCPS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: csnook@redhat.com, jacliburn@bellsouth.net, mm-commits@vger.kernel.org


The patch titled
     atl1: add L1 device id to pci_ids, then use it
has been removed from the -mm tree.  Its filename was
     atl1-add-l1-device-id-to-pci_ids-then-use-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atl1: add L1 device id to pci_ids, then use it
From: Chris Snook <csnook@redhat.com>

Add device id for the Attansic L1 chip to pci_ids.h, then use it.

Signed-off-by: Chris Snook <csnook@redhat.com>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c |    2 +-
 include/linux/pci_ids.h      |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/atl1/atl1_main.c~atl1-add-l1-device-id-to-pci_ids-then-use-it drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1-add-l1-device-id-to-pci_ids-then-use-it
+++ a/drivers/net/atl1/atl1_main.c
@@ -99,7 +99,7 @@ MODULE_VERSION(DRIVER_VERSION);
  * atl1_pci_tbl - PCI Device ID Table
  */
 static const struct pci_device_id atl1_pci_tbl[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_ATTANSIC, 0x1048)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ATTANSIC, PCI_DEVICE_ID_ATTANSIC_L1)},
 	/* required last entry */
 	{0,}
 };
diff -puN include/linux/pci_ids.h~atl1-add-l1-device-id-to-pci_ids-then-use-it include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~atl1-add-l1-device-id-to-pci_ids-then-use-it
+++ a/include/linux/pci_ids.h
@@ -2089,6 +2089,7 @@
 #define PCI_VENDOR_ID_PASEMI		0x1959
 
 #define PCI_VENDOR_ID_ATTANSIC		0x1969
+#define PCI_DEVICE_ID_ATTANSIC_L1	0x1048
 
 #define PCI_VENDOR_ID_JMICRON		0x197B
 #define PCI_DEVICE_ID_JMICRON_JMB360	0x2360
_

Patches currently in -mm which might be from csnook@redhat.com are

git-netdev-all.patch
