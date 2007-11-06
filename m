From: akpm@linux-foundation.org
Subject: - drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:44:19 -0800
Message-ID: <200711060544.lA65iJ4Y006138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbXKFFpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:45:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, bzolnier@gmail.com, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drivers/ide/pci/sc1200.c: remove pointless hwif lookup loop
has been removed from the -mm tree.  Its filename was
     drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch

This patch was dropped because of rejects

------------------------------------------------------
Subject: drivers/ide/pci/sc1200.c: remove pointless hwif lookup loop
From: Jeff Garzik <jeff@garzik.org>

Store our hwif indices at probe time, in order to eliminate a needless and
ugly loop across all hwifs, searching for our pci device.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/sc1200.c |   75 ++++++++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 25 deletions(-)

diff -puN drivers/ide/pci/sc1200.c~drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop drivers/ide/pci/sc1200.c
--- a/drivers/ide/pci/sc1200.c~drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop
+++ a/drivers/ide/pci/sc1200.c
@@ -41,6 +41,8 @@
 #define PCI_CLK_66	0x02
 #define PCI_CLK_33A	0x03
 
+#define SC1200_IFS	4
+
 static unsigned short sc1200_get_pci_clock (void)
 {
 	unsigned char chip_id, silicon_revision;
@@ -261,31 +263,32 @@ static void sc1200_set_pio_mode(ide_driv
 }
 
 #ifdef CONFIG_PM
-static ide_hwif_t *lookup_pci_dev (ide_hwif_t *prev, struct pci_dev *dev)
-{
-	int	h;
-
-	for (h = 0; h < MAX_HWIFS; h++) {
-		ide_hwif_t *hwif = &ide_hwifs[h];
-		if (prev) {
-			if (hwif == prev)
-				prev = NULL;	// found previous, now look for next match
-		} else {
-			if (hwif && hwif->pci_dev == dev)
-				return hwif;	// found next match
-		}
-	}
-	return NULL;	// not found
-}
-
 typedef struct sc1200_saved_state_s {
 	__u32		regs[4];
 } sc1200_saved_state_t;
 
+static unsigned int pack_hwif_idx(u8 *idx)
+{
+	return	(((unsigned int) idx[0]) << 0) |
+		(((unsigned int) idx[1]) << 8) |
+		(((unsigned int) idx[2]) << 16) |
+		(((unsigned int) idx[3]) << 24);
+}
+
+static ide_hwif_t *sc1200_hwif(struct pci_dev *pdev, unsigned int iface)
+{
+	unsigned int packed_hwifs, idx;
+
+	packed_hwifs = (unsigned long) pci_get_drvdata(pdev);
+	idx = (packed_hwifs >> (iface * 8)) & 0xff;
+
+	return (idx == 0xff) ? NULL : &ide_hwifs[idx];
+}
 
 static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 {
-	ide_hwif_t		*hwif = NULL;
+	ide_hwif_t		*hwif;
+	int			i;
 
 	printk("SC1200: suspend(%u)\n", state.event);
 
@@ -295,9 +298,14 @@ static int sc1200_suspend (struct pci_de
 		//
 		// Loop over all interfaces that are part of this PCI device:
 		//
-		while ((hwif = lookup_pci_dev(hwif, dev)) != NULL) {
+		for (i = 0; i < SC1200_IFS; i++) {
 			sc1200_saved_state_t	*ss;
 			unsigned int		basereg, r;
+
+			hwif = sc1200_hwif(dev, i);
+			if (!hwif)
+				continue;
+
 			//
 			// allocate a permanent save area, if not already allocated
 			//
@@ -310,7 +318,7 @@ static int sc1200_suspend (struct pci_de
 			}
 			ss = (sc1200_saved_state_t *)hwif->config_data;
 			//
-			// Save timing registers:  this may be unnecessary if 
+			// Save timing registers:  this may be unnecessary if
 			// BIOS also does it
 			//
 			basereg = hwif->channel ? 0x50 : 0x40;
@@ -320,7 +328,7 @@ static int sc1200_suspend (struct pci_de
 		}
 	}
 
-	/* You don't need to iterate over disks -- sysfs should have done that for you already */ 
+	/* You don't need to iterate over disks -- sysfs should have done that for you already */
 
 	pci_disable_device(dev);
 	pci_set_power_state(dev, pci_choose_state(dev, state));
@@ -329,7 +337,7 @@ static int sc1200_suspend (struct pci_de
 
 static int sc1200_resume (struct pci_dev *dev)
 {
-	ide_hwif_t	*hwif = NULL;
+	ide_hwif_t	*hwif;
 	int		i;
 
 	i = pci_enable_device(dev);
@@ -339,9 +347,15 @@ static int sc1200_resume (struct pci_dev
 	//
 	// loop over all interfaces that are part of this pci device:
 	//
-	while ((hwif = lookup_pci_dev(hwif, dev)) != NULL) {
+	for (i = 0; i < SC1200_IFS; i++) {
 		unsigned int		basereg, r;
-		sc1200_saved_state_t	*ss = (sc1200_saved_state_t *)hwif->config_data;
+		sc1200_saved_state_t	*ss;
+
+		hwif = sc1200_hwif(dev, i);
+		if (!hwif)
+			continue;
+
+		ss = (sc1200_saved_state_t *)hwif->config_data;
 
 		//
 		// Restore timing registers:  this may be unnecessary if BIOS also does it
@@ -387,7 +401,18 @@ static const struct ide_port_info sc1200
 
 static int __devinit sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &sc1200_chipset);
+	unsigned int packed_hwifs;
+	int rc;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+
+	rc = __ide_setup_pci_device(dev, &sc1200_chipset, &idx[0]);
+	if (rc)
+		return rc;
+
+	packed_hwifs = pack_hwif_idx(&idx[0]);
+
+	pci_set_drvdata(dev, (void *)(unsigned long) packed_hwifs);
+	return 0;
 }
 
 static const struct pci_device_id sc1200_pci_tbl[] = {
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
acpi-sbs-fix-retval-warning.patch
git-arm.patch
git-dvb.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
sunhme-fix-missing-netif_f_vlan_challenged-on-pci-happy-meals.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
scsi-gdth-kill-unneeded-irq-argument.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
scsi-ncr5380-minor-irq-handler-cleanups.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
git-wireless.patch
sundance-siocdevprivate-pollution.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
