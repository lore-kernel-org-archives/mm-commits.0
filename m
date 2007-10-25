From: akpm@linux-foundation.org
Subject: + ips-pci-api-cleanups.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:28:15 -0700
Message-ID: <200710250428.l9P4SF6n031747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbXJYE2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:28:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, jgarzik@redhat.com


The patch titled
     ips: PCI API cleanups
has been added to the -mm tree.  Its filename is
     ips-pci-api-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ips: PCI API cleanups
From: Jeff Garzik <jeff@garzik.org>

* pass Scsi_Host to ips_remove_device() via pci_set_drvdata(),
  allowing us to eliminate the ips_ha[] search loop and call
  ips_release() directly.

* call pci_{request,release}_regions() and eliminate individual
  request/release_[mem_]region() calls

* call pci_disable_device(), paired with pci_enable_device()

* s/0/NULL/ in a few places

* check ioremap() return value

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |   72 ++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 41 deletions(-)

diff -puN drivers/scsi/ips.c~ips-pci-api-cleanups drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~ips-pci-api-cleanups
+++ a/drivers/scsi/ips.c
@@ -702,10 +702,6 @@ ips_release(struct Scsi_Host *sh)
 	/* free extra memory */
 	ips_free(ha);
 
-	/* Free I/O Region */
-	if (ha->io_addr)
-		release_region(ha->io_addr, ha->io_len);
-
 	/* free IRQ */
 	free_irq(ha->pcidev->irq, ha);
 
@@ -4394,8 +4390,6 @@ ips_free(ips_ha_t * ha)
 			ha->mem_ptr = NULL;
 		}
 
-		if (ha->mem_addr)
-			release_mem_region(ha->mem_addr, ha->mem_len);
 		ha->mem_addr = 0;
 
 	}
@@ -6880,20 +6874,14 @@ ips_register_scsi(int index)
 static void __devexit
 ips_remove_device(struct pci_dev *pci_dev)
 {
-	int i;
-	struct Scsi_Host *sh;
-	ips_ha_t *ha;
+	struct Scsi_Host *sh = pci_get_drvdata(pci_dev);
 
-	for (i = 0; i < IPS_MAX_ADAPTERS; i++) {
-		ha = ips_ha[i];
-		if (ha) {
-			if ((pci_dev->bus->number == ha->pcidev->bus->number) &&
-			    (pci_dev->devfn == ha->pcidev->devfn)) {
-				sh = ips_sh[i];
-				ips_release(sh);
-			}
-		}
-	}
+	pci_set_drvdata(pci_dev, NULL);
+
+	ips_release(sh);
+
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
 }
 
 /****************************************************************************/
@@ -6947,12 +6935,17 @@ module_exit(ips_module_exit);
 static int __devinit
 ips_insert_device(struct pci_dev *pci_dev, const struct pci_device_id *ent)
 {
-	int uninitialized_var(index);
+	int index = -1;
 	int rc;
 
 	METHOD_TRACE("ips_insert_device", 1);
-	if (pci_enable_device(pci_dev))
-		return -1;
+	rc = pci_enable_device(pci_dev);
+	if (rc)
+		return rc;
+
+	rc = pci_request_regions(pci_dev, "ips");
+	if (rc)
+		goto err_out;
 
 	rc = ips_init_phase1(pci_dev, &index);
 	if (rc == SUCCESS)
@@ -6968,6 +6961,19 @@ ips_insert_device(struct pci_dev *pci_de
 		ips_num_controllers++;
 
 	ips_next_controller = ips_num_controllers;
+
+	if (rc < 0) {
+		rc = -ENODEV;
+		goto err_out_regions;
+	}
+
+	pci_set_drvdata(pci_dev, ips_sh[index]);
+	return 0;
+
+err_out_regions:
+	pci_release_regions(pci_dev);
+err_out:
+	pci_disable_device(pci_dev);
 	return rc;
 }
 
@@ -7000,7 +7006,7 @@ ips_init_phase1(struct pci_dev *pci_dev,
 	METHOD_TRACE("ips_init_phase1", 1);
 	index = IPS_MAX_ADAPTERS;
 	for (j = 0; j < IPS_MAX_ADAPTERS; j++) {
-		if (ips_ha[j] == 0) {
+		if (ips_ha[j] == NULL) {
 			index = j;
 			break;
 		}
@@ -7037,32 +7043,17 @@ ips_init_phase1(struct pci_dev *pci_dev,
 		uint32_t base;
 		uint32_t offs;
 
-		if (!request_mem_region(mem_addr, mem_len, "ips")) {
-			IPS_PRINTK(KERN_WARNING, pci_dev,
-				   "Couldn't allocate IO Memory space %x len %d.\n",
-				   mem_addr, mem_len);
-			return -1;
-		}
-
 		base = mem_addr & PAGE_MASK;
 		offs = mem_addr - base;
 		ioremap_ptr = ioremap(base, PAGE_SIZE);
+		if (!ioremap_ptr)
+			return -1;
 		mem_ptr = ioremap_ptr + offs;
 	} else {
 		ioremap_ptr = NULL;
 		mem_ptr = NULL;
 	}
 
-	/* setup I/O mapped area (if applicable) */
-	if (io_addr) {
-		if (!request_region(io_addr, io_len, "ips")) {
-			IPS_PRINTK(KERN_WARNING, pci_dev,
-				   "Couldn't allocate IO space %x len %d.\n",
-				   io_addr, io_len);
-			return -1;
-		}
-	}
-
 	/* found a controller */
 	ha = kzalloc(sizeof (ips_ha_t), GFP_KERNEL);
 	if (ha == NULL) {
@@ -7071,7 +7062,6 @@ ips_init_phase1(struct pci_dev *pci_dev,
 		return -1;
 	}
 
-
 	ips_sh[index] = NULL;
 	ips_ha[index] = ha;
 	ha->active = 1;
_

Patches currently in -mm which might be from jeff@garzik.org are

lguest-build-fix.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
drivers-ide-pci-sc1200c-fix-suspend-resume-buglets-and-warnings.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
mac80211-fix-warning-created-by-bit.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
isdn-sc-fix-longstanding-warning.patch
