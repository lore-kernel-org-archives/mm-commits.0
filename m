From: akpm@linux-foundation.org
Subject: + icom-add-new-sub-device-id-to-support-new-adapter.patch added to -mm tree
Date: Tue, 15 May 2007 09:51:00 -0700
Message-ID: <200705151650.l4FGoxG1012671@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbXEORDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 13:03:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wendyx@us.ibm.com


The patch titled
     icom: add new sub-device-id to support new adapter
has been added to the -mm tree.  Its filename is
     icom-add-new-sub-device-id-to-support-new-adapter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: icom: add new sub-device-id to support new adapter
From: wendy xiong <wendyx@us.ibm.com>

This patch add new sub-device-id to support new adapter and changed the
interrupt irq number for unsigned char to unsigned int.

[akpm@osdl.org: fix whitespace in device table]
Signed-off by: Wendy Xiong <wendyx@us.ibm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/icom.c   |   55 +++++++++++++++++++++-----------------
 include/linux/pci_ids.h |    1 
 2 files changed, 32 insertions(+), 24 deletions(-)

diff -puN drivers/serial/icom.c~icom-add-new-sub-device-id-to-support-new-adapter drivers/serial/icom.c
--- a/drivers/serial/icom.c~icom-add-new-sub-device-id-to-support-new-adapter
+++ a/drivers/serial/icom.c
@@ -69,33 +69,40 @@
 
 static const struct pci_device_id icom_pci_table[] = {
 	{
-	      .vendor = PCI_VENDOR_ID_IBM,
-	      .device = PCI_DEVICE_ID_IBM_ICOM_DEV_ID_1,
-	      .subvendor = PCI_ANY_ID,
-	      .subdevice = PCI_ANY_ID,
-	      .driver_data = ADAPTER_V1,
-	 },
+		.vendor = PCI_VENDOR_ID_IBM,
+		.device = PCI_DEVICE_ID_IBM_ICOM_DEV_ID_1,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.driver_data = ADAPTER_V1,
+	},
 	{
-	      .vendor = PCI_VENDOR_ID_IBM,
-	      .device = PCI_DEVICE_ID_IBM_ICOM_DEV_ID_2,
-	      .subvendor = PCI_VENDOR_ID_IBM,
-	      .subdevice = PCI_DEVICE_ID_IBM_ICOM_V2_TWO_PORTS_RVX,
-	      .driver_data = ADAPTER_V2,
-	 },
+		.vendor = PCI_VENDOR_ID_IBM,
+		.device = PCI_DEVICE_ID_IBM_ICOM_DEV_ID_2,
+		.subvendor = PCI_VENDOR_ID_IBM,
+		.subdevice = PCI_DEVICE_ID_IBM_ICOM_V2_TWO_PORTS_RVX,
+		.driver_data = ADAPTER_V2,
+	},
 	{
-	      .vendor = PCI_VENDOR_ID_IBM,
-	      .device = PCI_DEVICE_ID_IBM_ICOM_DEV_ID_2,
-	      .subvendor = PCI_VENDOR_ID_IBM,
-	      .subdevice = PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM,
-	      .driver_data = ADAPTER_V2,
-	 },
+		.vendor = PCI_VENDOR_ID_IBM,
+		.device = PCI_DEVICE_ID_IBM_ICOM_DEV_ID_2,
+		.subvendor = PCI_VENDOR_ID_IBM,
+		.subdevice = PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM,
+		.driver_data = ADAPTER_V2,
+	},
 	{
-	      .vendor = PCI_VENDOR_ID_IBM,
-	      .device = PCI_DEVICE_ID_IBM_ICOM_DEV_ID_2,
-	      .subvendor = PCI_VENDOR_ID_IBM,
-	      .subdevice = PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL,
-	      .driver_data = ADAPTER_V2,
-	 },
+		.vendor = PCI_VENDOR_ID_IBM,
+		.device = PCI_DEVICE_ID_IBM_ICOM_DEV_ID_2,
+		.subvendor = PCI_VENDOR_ID_IBM,
+		.subdevice = PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL,
+		.driver_data = ADAPTER_V2,
+	},
+	{
+		.vendor = PCI_VENDOR_ID_IBM,
+		.device = PCI_DEVICE_ID_IBM_ICOM_DEV_ID_2,
+		.subvendor = PCI_VENDOR_ID_IBM,
+		.subdevice = PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE,
+		.driver_data = ADAPTER_V2,
+	},
 	{}
 };
 
diff -puN include/linux/pci_ids.h~icom-add-new-sub-device-id-to-support-new-adapter include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~icom-add-new-sub-device-id-to-support-new-adapter
+++ a/include/linux/pci_ids.h
@@ -471,6 +471,7 @@
 #define PCI_DEVICE_ID_IBM_ICOM_DEV_ID_2	0x0219
 #define PCI_DEVICE_ID_IBM_ICOM_V2_TWO_PORTS_RVX		0x021A
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM	0x0251
+#define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE 0x0361
 #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x252
 
 #define PCI_VENDOR_ID_COMPEX2		0x101a /* pci.ids says "AT&T GIS (NCR)" */
_

Patches currently in -mm which might be from wendyx@us.ibm.com are

icom-add-new-sub-device-id-to-support-new-adapter.patch
