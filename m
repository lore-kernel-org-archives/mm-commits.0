From: akpm@linux-foundation.org
Subject: + memstick-add-support-for-jmicron-jmb-385-and-390-controllers.patch added to -mm tree
Date: Tue, 07 Dec 2010 14:35:19 -0800
Message-ID: <201012072235.oB7MZJ1q012075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753422Ab0LGWfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 17:35:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, arieslee@jmicron.com, oakad@yahoo.com


The patch titled
     memstick: add support for JMicron JMB 385 and 390 controllers
has been added to the -mm tree.  Its filename is
     memstick-add-support-for-jmicron-jmb-385-and-390-controllers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: add support for JMicron JMB 385 and 390 controllers
From: Takashi Iwai <tiwai@suse.de>

Signed-off-by: Aries Lee <arieslee@jmicron.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/jmb38x_ms.c |   17 +++++++++++++++--
 include/linux/pci_ids.h           |    2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff -puN drivers/memstick/host/jmb38x_ms.c~memstick-add-support-for-jmicron-jmb-385-and-390-controllers drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~memstick-add-support-for-jmicron-jmb-385-and-390-controllers
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -765,6 +765,8 @@ static int jmb38x_ms_set_param(struct me
 #define  PMOS0_SW_LED_POLARITY_ENABLE	0x80
 #define  PMOS0_ACTIVE_BITS (PMOS0_ENABLE | PMOS0_EN_OVERCURRENT_DEBOUNCE | \
 			    PMOS0_OVERCURRENT_LEVEL_2_4V)
+#define PCI_PMOS1_CONTROL		0xbd
+#define  PMOS1_ACTIVE_BITS		0x4a
 #define PCI_CLOCK_CTL			0xb9
 
 static int jmb38x_ms_pmos(struct pci_dev *pdev, int flag)
@@ -779,6 +781,16 @@ static int jmb38x_ms_pmos(struct pci_dev
 	pci_write_config_byte(pdev, PCI_PMOS0_CONTROL, val);
 	dev_dbg(&pdev->dev, "JMB38x: set PMOS0 val 0x%x\n", val);
 
+	if (pci_resource_flags(pdev, 1)) {
+		pci_read_config_byte(pdev, PCI_PMOS1_CONTROL, &val);
+		if (flag)
+			val |= PMOS1_ACTIVE_BITS;
+		else
+			val &= ~PMOS1_ACTIVE_BITS;
+		pci_write_config_byte(pdev, PCI_PMOS1_CONTROL, val);
+		dev_dbg(&pdev->dev, "JMB38x: set PMOS1 val 0x%x\n", val);
+	}
+
 	pci_read_config_byte(pdev, PCI_CLOCK_CTL, &val);
 	pci_write_config_byte(pdev, PCI_CLOCK_CTL, val & ~0x0f);
 	pci_write_config_byte(pdev, PCI_CLOCK_CTL, val | 0x01);
@@ -1018,8 +1030,9 @@ static void jmb38x_ms_remove(struct pci_
 }
 
 static struct pci_device_id jmb38x_ms_id_tbl [] = {
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB38X_MS, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB38X_MS) },
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB385_MS) },
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB390_MS) },
 	{ }
 };
 
diff -puN include/linux/pci_ids.h~memstick-add-support-for-jmicron-jmb-385-and-390-controllers include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~memstick-add-support-for-jmicron-jmb-385-and-390-controllers
+++ a/include/linux/pci_ids.h
@@ -2368,6 +2368,8 @@
 #define PCI_DEVICE_ID_JMICRON_JMB38X_SD	0x2381
 #define PCI_DEVICE_ID_JMICRON_JMB38X_MMC 0x2382
 #define PCI_DEVICE_ID_JMICRON_JMB38X_MS	0x2383
+#define PCI_DEVICE_ID_JMICRON_JMB385_MS	0x2388
+#define PCI_DEVICE_ID_JMICRON_JMB390_MS	0x2393
 
 #define PCI_VENDOR_ID_KORENIX		0x1982
 #define PCI_DEVICE_ID_KORENIX_JETCARDF0	0x1600
_

Patches currently in -mm which might be from tiwai@suse.de are

linux-next.patch
memstick-fix-setup-for-jmicron-38x-controllers.patch
memstick-set-pmos-values-propery-for-jmicron-38x-controllers.patch
memstick-add-support-for-jmicron-jmb-385-and-390-controllers.patch

