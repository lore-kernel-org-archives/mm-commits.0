From: akpm@osdl.org
Subject: - isdn-fix-warnings.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:55 -0800
Message-ID: <200612082010.kB8KAtvq002864@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58975 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946532AbWLHULG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     ISDN: fix warnings
has been removed from the -mm tree.  Its filename was
     isdn-fix-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ISDN: fix warnings
From: Jeff Garzik <jeff@garzik.org>

* diva, sedlbauer: the 'ready' label is only used in certain configurations
* hfc_pci:
	- cast 'arg' to proper size for testing and printing
	- print out 'void __iomem *' variables with %p,
	  rather than using incorrect casts that throw warnings

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hisax/diva.c      |    4 ++++
 drivers/isdn/hisax/hfc_pci.c   |   10 +++++-----
 drivers/isdn/hisax/sedlbauer.c |    4 ++++
 3 files changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/isdn/hisax/diva.c~isdn-fix-warnings drivers/isdn/hisax/diva.c
--- a/drivers/isdn/hisax/diva.c~isdn-fix-warnings
+++ a/drivers/isdn/hisax/diva.c
@@ -1121,7 +1121,11 @@ setup_diva(struct IsdnCard *card)
 			bytecnt = 32;
 		}
 	}
+
+#ifdef __ISAPNP__
 ready:
+#endif
+
 	printk(KERN_INFO
 		"Diva: %s card configured at %#lx IRQ %d\n",
 		(cs->subtyp == DIVA_PCI) ? "PCI" :
diff -puN drivers/isdn/hisax/hfc_pci.c~isdn-fix-warnings drivers/isdn/hisax/hfc_pci.c
--- a/drivers/isdn/hisax/hfc_pci.c~isdn-fix-warnings
+++ a/drivers/isdn/hisax/hfc_pci.c
@@ -1211,7 +1211,7 @@ HFCPCI_l1hw(struct PStack *st, int pr, v
 			break;
 		case (HW_TESTLOOP | REQUEST):
 			spin_lock_irqsave(&cs->lock, flags);
-			switch ((int) arg) {
+			switch ((long) arg) {
 				case (1):
 					Write_hfc(cs, HFCPCI_B1_SSL, 0x80);	/* tx slot */
 					Write_hfc(cs, HFCPCI_B1_RSL, 0x80);	/* rx slot */
@@ -1229,7 +1229,7 @@ HFCPCI_l1hw(struct PStack *st, int pr, v
 				default:
 					spin_unlock_irqrestore(&cs->lock, flags);
 					if (cs->debug & L1_DEB_WARN)
-						debugl1(cs, "hfcpci_l1hw loop invalid %4x", (int) arg);
+						debugl1(cs, "hfcpci_l1hw loop invalid %4lx", (long) arg);
 					return;
 			}
 			cs->hw.hfcpci.trm |= 0x80;	/* enable IOM-loop */
@@ -1711,9 +1711,9 @@ setup_hfcpci(struct IsdnCard *card)
 		pci_write_config_dword(cs->hw.hfcpci.dev, 0x80, (u_int) virt_to_bus(cs->hw.hfcpci.fifos));
 		cs->hw.hfcpci.pci_io = ioremap((ulong) cs->hw.hfcpci.pci_io, 256);
 		printk(KERN_INFO
-		       "HFC-PCI: defined at mem %#x fifo %#x(%#x) IRQ %d HZ %d\n",
-		       (u_int) cs->hw.hfcpci.pci_io,
-		       (u_int) cs->hw.hfcpci.fifos,
+		       "HFC-PCI: defined at mem %p fifo %p(%#x) IRQ %d HZ %d\n",
+		       cs->hw.hfcpci.pci_io,
+		       cs->hw.hfcpci.fifos,
 		       (u_int) virt_to_bus(cs->hw.hfcpci.fifos),
 		       cs->irq, HZ);
 		spin_lock_irqsave(&cs->lock, flags);
diff -puN drivers/isdn/hisax/sedlbauer.c~isdn-fix-warnings drivers/isdn/hisax/sedlbauer.c
--- a/drivers/isdn/hisax/sedlbauer.c~isdn-fix-warnings
+++ a/drivers/isdn/hisax/sedlbauer.c
@@ -677,7 +677,11 @@ setup_sedlbauer(struct IsdnCard *card)
 		return (0);
 #endif /* CONFIG_PCI */
 	}	
+
+#ifdef __ISAPNP__
 ready:	
+#endif
+
 	/* In case of the sedlbauer pcmcia card, this region is in use,
 	 * reserved for us by the card manager. So we do not check it
 	 * here, it would fail.
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
isdn-fix-warnings.patch
atyfb-rivafb-minor-fixes.patch
git-acpi.patch
git-cpufreq.patch
drm-handle-pci_enable_device-failure.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
ata_piix-ide-mode-sata-patch-for-intel-ich9.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-mtd.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
8139too-force-media-setting-fix.patch
tulip-fix-shutdown-dma-irq-race.patch
git-ioat.patch
via-sb600-sata-quirk.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
usb-fix-ohcih-over-use-warnings.patch
md-conditionalize-some-code.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch

