From: akpm@linux-foundation.org
Subject: + ide-add-helper-__ide_setup_pci_device.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:21:45 -0700
Message-ID: <200710250421.l9P4LjPX031548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39855 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620AbXJYEWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, bzolnier@gmail.com, jgarzik@redhat.com


The patch titled
     IDE: add helper __ide_setup_pci_device()
has been added to the -mm tree.  Its filename is
     ide-add-helper-__ide_setup_pci_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IDE: add helper __ide_setup_pci_device()
From: Jeff Garzik <jeff@garzik.org>

Like ide_setup_pci_device(), except with additional array argument 'u8
*idx' that permits low-level driver to become aware of its assigned hwifs.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/setup-pci.c |   17 ++++++++++++-----
 include/linux/ide.h     |    1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/ide/setup-pci.c~ide-add-helper-__ide_setup_pci_device drivers/ide/setup-pci.c
--- a/drivers/ide/setup-pci.c~ide-add-helper-__ide_setup_pci_device
+++ a/drivers/ide/setup-pci.c
@@ -666,12 +666,10 @@ out:
 	return ret;
 }
 
-int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
+int __ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d,
+			   u8 *idx)
 {
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	int ret;
-
-	ret = do_ide_setup_pci_device(dev, d, &idx[0], 1);
+	int ret = do_ide_setup_pci_device(dev, d, idx, 1);
 
 	if (ret >= 0)
 		ide_device_add(idx);
@@ -679,6 +677,15 @@ int ide_setup_pci_device(struct pci_dev 
 	return ret;
 }
 
+EXPORT_SYMBOL_GPL(__ide_setup_pci_device);
+
+int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
+{
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+
+	return __ide_setup_pci_device(dev, d, &idx[0]);
+}
+
 EXPORT_SYMBOL_GPL(ide_setup_pci_device);
 
 int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
diff -puN include/linux/ide.h~ide-add-helper-__ide_setup_pci_device include/linux/ide.h
--- a/include/linux/ide.h~ide-add-helper-__ide_setup_pci_device
+++ a/include/linux/ide.h
@@ -1291,6 +1291,7 @@ struct ide_port_info {
 	u8			udma_mask;
 };
 
+int __ide_setup_pci_device(struct pci_dev *, const struct ide_port_info *, u8 *);
 int ide_setup_pci_device(struct pci_dev *, const struct ide_port_info *);
 int ide_setup_pci_devices(struct pci_dev *, struct pci_dev *, const struct ide_port_info *);
 
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
drivers-ide-pci-sc1200c-fix-suspend-resume-buglets-and-warnings.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
hptiop-fix-type-mismatch-warning.patch
git-wireless.patch
mac80211-fix-warning-created-by-bit.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
isdn-sc-fix-longstanding-warning.patch
