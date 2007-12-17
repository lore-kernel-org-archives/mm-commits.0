From: akpm@linux-foundation.org
Subject: - pcie-fix-double-initialization-bug.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:39:45 -0800
Message-ID: <200712172339.lBHNdjVY008146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937467AbXLQXw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:52:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkml@rtr.ca, kristen.c.accardi@intel.com, mlord@pobox.com, mm-commits@vger.kernel.org


The patch titled
     PCIe: fix double initialization bug
has been removed from the -mm tree.  Its filename was
     pcie-fix-double-initialization-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCIe: fix double initialization bug
From: Mark Lord <lkml@rtr.ca>

Earlier patches to split out the hardware init for PCIe hotplug resulted in
some one-time initializations being redone on every resume cycle.  Eg. 
irq/polling initialization.

This patch splits the hardware init into two parts, and separates the
one-time initializations from those so that they only ever get done once,
as intended.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/pciehp.h      |    2 
 drivers/pci/hotplug/pciehp_core.c |    2 
 drivers/pci/hotplug/pciehp_hpc.c  |  119 +++++++++++++++-------------
 3 files changed, 69 insertions(+), 54 deletions(-)

diff -puN drivers/pci/hotplug/pciehp.h~pcie-fix-double-initialization-bug drivers/pci/hotplug/pciehp.h
--- a/drivers/pci/hotplug/pciehp.h~pcie-fix-double-initialization-bug
+++ a/drivers/pci/hotplug/pciehp.h
@@ -163,7 +163,7 @@ extern void pciehp_queue_pushbutton_work
 int pcie_init(struct controller *ctrl, struct pcie_device *dev);
 int pciehp_enable_slot(struct slot *p_slot);
 int pciehp_disable_slot(struct slot *p_slot);
-int pcie_init_hardware(struct controller *ctrl, struct pcie_device *dev);
+int pcie_init_hardware_part2(struct controller *ctrl, struct pcie_device *dev);
 
 static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
 {
diff -puN drivers/pci/hotplug/pciehp_core.c~pcie-fix-double-initialization-bug drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pcie-fix-double-initialization-bug
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -521,7 +521,7 @@ static int pciehp_resume (struct pcie_de
 		u8 status;
 
 		/* reinitialize the chipset's event detection logic */
-		pcie_init_hardware(ctrl, dev);
+		pcie_init_hardware_part2(ctrl, dev);
 
 		t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
 
diff -puN drivers/pci/hotplug/pciehp_hpc.c~pcie-fix-double-initialization-bug drivers/pci/hotplug/pciehp_hpc.c
--- a/drivers/pci/hotplug/pciehp_hpc.c~pcie-fix-double-initialization-bug
+++ a/drivers/pci/hotplug/pciehp_hpc.c
@@ -1067,28 +1067,25 @@ int pciehp_acpi_get_hp_hw_control_from_f
 }
 #endif
 
-int pcie_init_hardware(struct controller *ctrl, struct pcie_device *dev)
+static int pcie_init_hardware_part1(struct controller *ctrl,
+				    struct pcie_device *dev)
 {
 	int rc;
 	u16 temp_word;
-	u16 intr_enable = 0;
 	u32 slot_cap;
 	u16 slot_status;
-	struct pci_dev *pdev;
-
-	pdev = dev->port;
 
 	rc = pciehp_readl(ctrl, SLOTCAP, &slot_cap);
 	if (rc) {
 		err("%s: Cannot read SLOTCAP register\n", __FUNCTION__);
-		goto abort_free_ctlr;
+		return -1;
 	}
 
 	/* Mask Hot-plug Interrupt Enable */
 	rc = pciehp_readw(ctrl, SLOTCTRL, &temp_word);
 	if (rc) {
 		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
-		goto abort_free_ctlr;
+		return -1;
 	}
 
 	dbg("%s: SLOTCTRL %x value read %x\n",
@@ -1099,62 +1096,46 @@ int pcie_init_hardware(struct controller
 	rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 	if (rc) {
 		err("%s: Cannot write to SLOTCTRL register\n", __FUNCTION__);
-		goto abort_free_ctlr;
+		return -1;
 	}
 
 	rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (rc) {
 		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
-		goto abort_free_ctlr;
+		return -1;
 	}
 
 	temp_word = 0x1F; /* Clear all events */
 	rc = pciehp_writew(ctrl, SLOTSTATUS, temp_word);
 	if (rc) {
 		err("%s: Cannot write to SLOTSTATUS register\n", __FUNCTION__);
-		goto abort_free_ctlr;
+		return -1;
 	}
+	return 0;
+}
 
-	if (pciehp_poll_mode) {
-		/* Install interrupt polling timer. Start with 10 sec delay */
-		init_timer(&ctrl->poll_timer);
-		start_int_poll_timer(ctrl, 10);
-	} else {
-		/* Installs the interrupt handler */
-		rc = request_irq(ctrl->pci_dev->irq, pcie_isr, IRQF_SHARED,
-				 MY_NAME, (void *)ctrl);
-		dbg("%s: request_irq %d for hpc%d (returns %d)\n",
-		    __FUNCTION__, ctrl->pci_dev->irq,
-		    atomic_read(&pciehp_num_controllers), rc);
-		if (rc) {
-			err("Can't get irq %d for the hotplug controller\n",
-			    ctrl->pci_dev->irq);
-			goto abort_free_ctlr;
-		}
-	}
-	dbg("pciehp ctrl b:d:f:irq=0x%x:%x:%x:%x\n", pdev->bus->number,
-		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn), dev->irq);
-
-	/*
-	 * If this is the first controller to be initialized,
-	 * initialize the pciehp work queue
-	 */
-	if (atomic_add_return(1, &pciehp_num_controllers) == 1) {
-		pciehp_wq = create_singlethread_workqueue("pciehpd");
-		if (!pciehp_wq) {
-			rc = -ENOMEM;
-			goto abort_free_irq;
-		}
-	}
+int pcie_init_hardware_part2(struct controller *ctrl, struct pcie_device *dev)
+{
+	int rc;
+	u16 temp_word;
+	u16 intr_enable = 0;
+	u32 slot_cap;
+	u16 slot_status;
 
 	rc = pciehp_readw(ctrl, SLOTCTRL, &temp_word);
 	if (rc) {
 		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
-		goto abort_free_irq;
+		goto abort;
 	}
 
 	intr_enable = intr_enable | PRSN_DETECT_ENABLE;
 
+	rc = pciehp_readl(ctrl, SLOTCAP, &slot_cap);
+	if (rc) {
+		err("%s: Cannot read SLOTCAP register\n", __FUNCTION__);
+		goto abort;
+	}
+
 	if (ATTN_BUTTN(slot_cap))
 		intr_enable = intr_enable | ATTN_BUTTN_ENABLE;
 
@@ -1179,7 +1160,7 @@ int pcie_init_hardware(struct controller
 	rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 	if (rc) {
 		err("%s: Cannot write to SLOTCTRL register\n", __FUNCTION__);
-		goto abort_free_irq;
+		goto abort;
 	}
 	rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (rc) {
@@ -1214,14 +1195,7 @@ abort_disable_intr:
 	}
 	if (rc)
 		err("%s : disabling interrupts failed\n", __FUNCTION__);
-
-abort_free_irq:
-	if (pciehp_poll_mode)
-		del_timer_sync(&ctrl->poll_timer);
-	else
-		free_irq(ctrl->pci_dev->irq, ctrl);
-
-abort_free_ctlr:
+abort:
 	return -1;
 }
 
@@ -1318,11 +1292,52 @@ int pcie_init(struct controller *ctrl, s
 	ctrl->first_slot = slot_cap >> 19;
 	ctrl->ctrlcap = slot_cap & 0x0000007f;
 
-	rc = pcie_init_hardware(ctrl, dev);
+	rc = pcie_init_hardware_part1(ctrl, dev);
+	if (rc)
+		goto abort;
+
+	if (pciehp_poll_mode) {
+		/* Install interrupt polling timer. Start with 10 sec delay */
+		init_timer(&ctrl->poll_timer);
+		start_int_poll_timer(ctrl, 10);
+	} else {
+		/* Installs the interrupt handler */
+		rc = request_irq(ctrl->pci_dev->irq, pcie_isr, IRQF_SHARED,
+				 MY_NAME, (void *)ctrl);
+		dbg("%s: request_irq %d for hpc%d (returns %d)\n",
+		    __FUNCTION__, ctrl->pci_dev->irq,
+		    atomic_read(&pciehp_num_controllers), rc);
+		if (rc) {
+			err("Can't get irq %d for the hotplug controller\n",
+			    ctrl->pci_dev->irq);
+			goto abort;
+		}
+	}
+	dbg("pciehp ctrl b:d:f:irq=0x%x:%x:%x:%x\n", pdev->bus->number,
+		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn), dev->irq);
+
+	/*
+	 * If this is the first controller to be initialized,
+	 * initialize the pciehp work queue
+	 */
+	if (atomic_add_return(1, &pciehp_num_controllers) == 1) {
+		pciehp_wq = create_singlethread_workqueue("pciehpd");
+		if (!pciehp_wq) {
+			rc = -ENOMEM;
+			goto abort_free_irq;
+		}
+	}
+
+	rc = pcie_init_hardware_part2(ctrl, dev);
 	if (rc == 0) {
 		ctrl->hpc_ops = &pciehp_hpc_ops;
 		return 0;
 	}
+abort_free_irq:
+	if (pciehp_poll_mode)
+		del_timer_sync(&ctrl->poll_timer);
+	else
+		free_irq(ctrl->pci_dev->irq, ctrl);
 abort:
 	return -1;
 }
_

Patches currently in -mm which might be from lkml@rtr.ca are

origin.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
