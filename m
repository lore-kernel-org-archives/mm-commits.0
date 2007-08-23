From: akpm@linux-foundation.org
Subject: + add-device-id-for-p4m900-to-via-agp-module.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:46:32 -0700
Message-ID: <200708232246.l7NMkWWT030950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47145 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934750AbXHWWql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xavier@bachelot.org, airlied@linux.ie


The patch titled
     Add device id for P4M900 to via-agp module
has been added to the -mm tree.  Its filename is
     add-device-id-for-p4m900-to-via-agp-module.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add device id for P4M900 to via-agp module
From: Xavier Bachelot <xavier@bachelot.org>

This is a new VIA chipset that works with the existing code. It only
needs the device id to be added for detection.

Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/via-agp.c |    5 +++++
 include/linux/pci_ids.h    |    1 +
 2 files changed, 6 insertions(+)

diff -puN drivers/char/agp/via-agp.c~add-device-id-for-p4m900-to-via-agp-module drivers/char/agp/via-agp.c
--- a/drivers/char/agp/via-agp.c~add-device-id-for-p4m900-to-via-agp-module
+++ a/drivers/char/agp/via-agp.c
@@ -399,6 +399,11 @@ static struct agp_device_ids via_agp_dev
 		.device_id  = PCI_DEVICE_ID_VIA_P4M890,
 		.chipset_name   = "P4M890",
 	},
+	/* P4M900 */
+	{
+		.device_id  = PCI_DEVICE_ID_VIA_VT3364,
+		.chipset_name   = "P4M900",
+	},
 	{ }, /* dummy final entry, always present */
 };
 
diff -puN include/linux/pci_ids.h~add-device-id-for-p4m900-to-via-agp-module include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~add-device-id-for-p4m900-to-via-agp-module
+++ a/include/linux/pci_ids.h
@@ -1287,6 +1287,7 @@
 #define PCI_DEVICE_ID_VIA_VT3324	0x0324
 #define PCI_DEVICE_ID_VIA_VT3336	0x0336
 #define PCI_DEVICE_ID_VIA_VT3351	0x0351
+#define PCI_DEVICE_ID_VIA_VT3364	0x0364
 #define PCI_DEVICE_ID_VIA_8371_0	0x0391
 #define PCI_DEVICE_ID_VIA_8501_0	0x0501
 #define PCI_DEVICE_ID_VIA_82C561	0x0561
_

Patches currently in -mm which might be from xavier@bachelot.org are

add-device-id-for-p4m900-to-via-agp-module.patch
