From: akpm@linux-foundation.org
Subject: + drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:21:53 -0700
Message-ID: <200710250421.l9P4Lrhm031551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50371 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113AbXJYEWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:22:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, bzolnier@gmail.com, jgarzik@redhat.com


The patch titled
     drivers/ide/pci/sc1200.c: remove pointless hwif lookup loop
has been added to the -mm tree.  Its filename is
     drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/ide/pci/sc1200.c: remove pointless hwif lookup loop
From: Jeff Garzik <jeff@garzik.org>

Store our hwif indices at probe time, in order to eliminate a needless and
ugly loop across all hwifs, searching for our pci device.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/sc1200.c |   76 ++++++++++++++++++++++++-------------
 1 file changed, 51 insertions(+), 25 deletions(-)

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
@@ -330,7 +338,8 @@ static int sc1200_suspend (struct pci_de
 
 static int sc1200_resume (struct pci_dev *dev)
 {
-	ide_hwif_t	*hwif = NULL;
+	ide_hwif_t		*hwif;
+	int			i;
 
 	pci_set_power_state(dev, PCI_D0);	// bring chip back from sleep state
 	dev->current_state = PM_EVENT_ON;
@@ -338,9 +347,15 @@ static int sc1200_resume (struct pci_dev
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
@@ -386,7 +401,18 @@ static const struct ide_port_info sc1200
 
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
