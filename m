From: akpm@linux-foundation.org
Subject: + multiple-definition-of-queue_pushbutton_work.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:40:08 -0700
Message-ID: <200703212340.l2LNe8Di007150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59266 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbXCUXkR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:40:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, greg@kroah.com


The patch titled
     multiple definition of `queue_pushbutton_work'
has been added to the -mm tree.  Its filename is
     multiple-definition-of-queue_pushbutton_work.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: multiple definition of `queue_pushbutton_work'
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Fix duplicate names in shpchp and pciehp.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/pciehp.h      |    2 +-
 drivers/pci/hotplug/pciehp_core.c |    2 +-
 drivers/pci/hotplug/pciehp_ctrl.c |    2 +-
 drivers/pci/hotplug/shpchp.h      |    2 +-
 drivers/pci/hotplug/shpchp_core.c |    2 +-
 drivers/pci/hotplug/shpchp_ctrl.c |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/pci/hotplug/pciehp.h~multiple-definition-of-queue_pushbutton_work drivers/pci/hotplug/pciehp.h
--- a/drivers/pci/hotplug/pciehp.h~multiple-definition-of-queue_pushbutton_work
+++ a/drivers/pci/hotplug/pciehp.h
@@ -158,7 +158,7 @@ extern u8 pciehp_handle_presence_change(
 extern u8 pciehp_handle_power_fault(u8 hp_slot, struct controller *ctrl);
 extern int pciehp_configure_device(struct slot *p_slot);
 extern int pciehp_unconfigure_device(struct slot *p_slot);
-extern void queue_pushbutton_work(struct work_struct *work);
+extern void pciehp_queue_pushbutton_work(struct work_struct *work);
 int pcie_init(struct controller *ctrl, struct pcie_device *dev);
 
 static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
diff -puN drivers/pci/hotplug/pciehp_core.c~multiple-definition-of-queue_pushbutton_work drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~multiple-definition-of-queue_pushbutton_work
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -229,7 +229,7 @@ static int init_slots(struct controller 
 		slot->hpc_ops = ctrl->hpc_ops;
 		slot->number = ctrl->first_slot;
 		mutex_init(&slot->lock);
-		INIT_DELAYED_WORK(&slot->work, queue_pushbutton_work);
+		INIT_DELAYED_WORK(&slot->work, pciehp_queue_pushbutton_work);
 
 		/* register this slot with the hotplug pci core */
 		hotplug_slot->private = slot;
diff -puN drivers/pci/hotplug/pciehp_ctrl.c~multiple-definition-of-queue_pushbutton_work drivers/pci/hotplug/pciehp_ctrl.c
--- a/drivers/pci/hotplug/pciehp_ctrl.c~multiple-definition-of-queue_pushbutton_work
+++ a/drivers/pci/hotplug/pciehp_ctrl.c
@@ -351,7 +351,7 @@ static void pciehp_power_thread(struct w
 	kfree(info);
 }
 
-void queue_pushbutton_work(struct work_struct *work)
+void pciehp_queue_pushbutton_work(struct work_struct *work)
 {
 	struct slot *p_slot = container_of(work, struct slot, work.work);
 	struct power_work_info *info;
diff -puN drivers/pci/hotplug/shpchp.h~multiple-definition-of-queue_pushbutton_work drivers/pci/hotplug/shpchp.h
--- a/drivers/pci/hotplug/shpchp.h~multiple-definition-of-queue_pushbutton_work
+++ a/drivers/pci/hotplug/shpchp.h
@@ -166,7 +166,7 @@ extern u8 shpchp_handle_power_fault(u8 h
 extern int shpchp_configure_device(struct slot *p_slot);
 extern int shpchp_unconfigure_device(struct slot *p_slot);
 extern void cleanup_slots(struct controller *ctrl);
-extern void queue_pushbutton_work(struct work_struct *work);
+extern void shpchp_queue_pushbutton_work(struct work_struct *work);
 extern int shpc_init( struct controller *ctrl, struct pci_dev *pdev);
 
 #ifdef CONFIG_ACPI
diff -puN drivers/pci/hotplug/shpchp_core.c~multiple-definition-of-queue_pushbutton_work drivers/pci/hotplug/shpchp_core.c
--- a/drivers/pci/hotplug/shpchp_core.c~multiple-definition-of-queue_pushbutton_work
+++ a/drivers/pci/hotplug/shpchp_core.c
@@ -136,7 +136,7 @@ static int init_slots(struct controller 
 		slot->hpc_ops = ctrl->hpc_ops;
 		slot->number = ctrl->first_slot + (ctrl->slot_num_inc * i);
 		mutex_init(&slot->lock);
-		INIT_DELAYED_WORK(&slot->work, queue_pushbutton_work);
+		INIT_DELAYED_WORK(&slot->work, shpchp_queue_pushbutton_work);
 
 		/* register this slot with the hotplug pci core */
 		hotplug_slot->private = slot;
diff -puN drivers/pci/hotplug/shpchp_ctrl.c~multiple-definition-of-queue_pushbutton_work drivers/pci/hotplug/shpchp_ctrl.c
--- a/drivers/pci/hotplug/shpchp_ctrl.c~multiple-definition-of-queue_pushbutton_work
+++ a/drivers/pci/hotplug/shpchp_ctrl.c
@@ -433,7 +433,7 @@ static void shpchp_pushbutton_thread(str
 	kfree(info);
 }
 
-void queue_pushbutton_work(struct work_struct *work)
+void shpchp_queue_pushbutton_work(struct work_struct *work)
 {
 	struct slot *p_slot = container_of(work, struct slot, work.work);
 	struct pushbutton_work_info *info;
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-acpi.patch
multiple-definition-of-queue_pushbutton_work.patch
