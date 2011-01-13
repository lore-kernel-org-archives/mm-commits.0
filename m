From: akpm@linux-foundation.org
Subject: [merged] memstick-set-pmos-values-propery-for-jmicron-38x-controllers.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:43 -0800
Message-ID: <201101132012.p0DKCOhk030290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933778Ab1AMUVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:21:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, arieslee@jmicron.com, oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: set PMOS values propery for JMicron 38x controllers
has been removed from the -mm tree.  Its filename was
     memstick-set-pmos-values-propery-for-jmicron-38x-controllers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: set PMOS values propery for JMicron 38x controllers
From: Takashi Iwai <tiwai@suse.de>

Add a function jmb38x_ms_pmos() to enable / disable PMOS setups for
JMicron 38x controllers.

Signed-off-by: Aries Lee <arieslee@jmicron.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/jmb38x_ms.c |   37 ++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff -puN drivers/memstick/host/jmb38x_ms.c~memstick-set-pmos-values-propery-for-jmicron-38x-controllers drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~memstick-set-pmos-values-propery-for-jmicron-38x-controllers
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -758,6 +758,35 @@ static int jmb38x_ms_set_param(struct me
 	return 0;
 }
 
+#define PCI_PMOS0_CONTROL		0xae
+#define  PMOS0_ENABLE			0x01
+#define  PMOS0_OVERCURRENT_LEVEL_2_4V	0x06
+#define  PMOS0_EN_OVERCURRENT_DEBOUNCE	0x40
+#define  PMOS0_SW_LED_POLARITY_ENABLE	0x80
+#define  PMOS0_ACTIVE_BITS (PMOS0_ENABLE | PMOS0_EN_OVERCURRENT_DEBOUNCE | \
+			    PMOS0_OVERCURRENT_LEVEL_2_4V)
+#define PCI_CLOCK_CTL			0xb9
+
+static int jmb38x_ms_pmos(struct pci_dev *pdev, int flag)
+{
+	unsigned char val;
+
+	pci_read_config_byte(pdev, PCI_PMOS0_CONTROL, &val);
+	if (flag)
+		val |= PMOS0_ACTIVE_BITS;
+	else
+		val &= ~PMOS0_ACTIVE_BITS;
+	pci_write_config_byte(pdev, PCI_PMOS0_CONTROL, val);
+	dev_dbg(&pdev->dev, "JMB38x: set PMOS0 val 0x%x\n", val);
+
+	pci_read_config_byte(pdev, PCI_CLOCK_CTL, &val);
+	pci_write_config_byte(pdev, PCI_CLOCK_CTL, val & ~0x0f);
+	pci_write_config_byte(pdev, PCI_CLOCK_CTL, val | 0x01);
+	dev_dbg(&pdev->dev, "Clock Control by PCI config is disabled!\n");
+
+        return 0;
+}
+
 #ifdef CONFIG_PM
 
 static int jmb38x_ms_suspend(struct pci_dev *dev, pm_message_t state)
@@ -790,8 +819,7 @@ static int jmb38x_ms_resume(struct pci_d
 		return rc;
 	pci_set_master(dev);
 
-	pci_read_config_dword(dev, 0xac, &rc);
-	pci_write_config_dword(dev, 0xac, rc | 0x00470000);
+	jmb38x_ms_pmos(dev, 1);
 
 	for (rc = 0; rc < jm->host_cnt; ++rc) {
 		if (!jm->hosts[rc])
@@ -900,8 +928,7 @@ static int jmb38x_ms_probe(struct pci_de
 		goto err_out;
 	}
 
-	pci_read_config_dword(pdev, 0xac, &rc);
-	pci_write_config_dword(pdev, 0xac, rc | 0x00470000);
+	jmb38x_ms_pmos(pdev, 1);
 
 	cnt = jmb38x_ms_count_slots(pdev);
 	if (!cnt) {
@@ -982,6 +1009,8 @@ static void jmb38x_ms_remove(struct pci_
 		jmb38x_ms_free_host(jm->hosts[cnt]);
 	}
 
+	jmb38x_ms_pmos(dev, 0);
+
 	pci_set_drvdata(dev, NULL);
 	pci_release_regions(dev);
 	pci_disable_device(dev);
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch

