From: akpm@linux-foundation.org
Subject: + drivers-ata-pata_alic-s-isa_bridge-ali_isa_bridge-to-fix-alpha-build.patch added to -mm tree
Date: Wed, 14 Jan 2009 16:22:09 -0800
Message-ID: <200901150038.n0F0cgVb018255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758392AbZAOAj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 19:39:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, jeff@garzik.org


The patch titled
     drivers/ata/pata_ali.c: s/isa_bridge/ali_isa_bridge/ to fix alpha build
has been added to the -mm tree.  Its filename is
     drivers-ata-pata_alic-s-isa_bridge-ali_isa_bridge-to-fix-alpha-build.patch

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
Subject: drivers/ata/pata_ali.c: s/isa_bridge/ali_isa_bridge/ to fix alpha build
From: Andrew Morton <akpm@linux-foundation.org>

drivers/ata/pata_ali.c:44: error: static declaration of 'isa_bridge' follows non-static declaration
arch/alpha/include/asm/pci.h:274: error: previous declaration of 'isa_bridge' was here

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_ali.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/ata/pata_ali.c~drivers-ata-pata_alic-s-isa_bridge-ali_isa_bridge-to-fix-alpha-build drivers/ata/pata_ali.c
--- a/drivers/ata/pata_ali.c~drivers-ata-pata_alic-s-isa_bridge-ali_isa_bridge-to-fix-alpha-build
+++ a/drivers/ata/pata_ali.c
@@ -41,7 +41,7 @@ static int ali_atapi_dma = 0;
 module_param_named(atapi_dma, ali_atapi_dma, int, 0644);
 MODULE_PARM_DESC(atapi_dma, "Enable ATAPI DMA (0=disable, 1=enable)");
 
-static struct pci_dev *isa_bridge;
+static struct pci_dev *ali_isa_bridge;
 
 /*
  *	Cable special cases
@@ -346,13 +346,13 @@ static void ali_c2_c3_postreset(struct a
 	int port_bit = 4 << link->ap->port_no;
 
 	/* If our bridge is an ALI 1533 then do the extra work */
-	if (isa_bridge) {
+	if (ali_isa_bridge) {
 		/* Tristate and re-enable the bus signals */
-		pci_read_config_byte(isa_bridge, 0x58, &r);
+		pci_read_config_byte(ali_isa_bridge, 0x58, &r);
 		r &= ~port_bit;
-		pci_write_config_byte(isa_bridge, 0x58, r);
+		pci_write_config_byte(ali_isa_bridge, 0x58, r);
 		r |= port_bit;
-		pci_write_config_byte(isa_bridge, 0x58, r);
+		pci_write_config_byte(ali_isa_bridge, 0x58, r);
 	}
 	ata_sff_postreset(link, classes);
 }
@@ -467,14 +467,14 @@ static void ali_init_chipset(struct pci_
 		pci_write_config_byte(pdev, 0x53, tmp);
 	}
 	north = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
-	if (north && north->vendor == PCI_VENDOR_ID_AL && isa_bridge) {
+	if (north && north->vendor == PCI_VENDOR_ID_AL && ali_isa_bridge) {
 		/* Configure the ALi bridge logic. For non ALi rely on BIOS.
 		   Set the south bridge enable bit */
-		pci_read_config_byte(isa_bridge, 0x79, &tmp);
+		pci_read_config_byte(ali_isa_bridge, 0x79, &tmp);
 		if (pdev->revision == 0xC2)
-			pci_write_config_byte(isa_bridge, 0x79, tmp | 0x04);
+			pci_write_config_byte(ali_isa_bridge, 0x79, tmp | 0x04);
 		else if (pdev->revision > 0xC2 && pdev->revision < 0xC5)
-			pci_write_config_byte(isa_bridge, 0x79, tmp | 0x02);
+			pci_write_config_byte(ali_isa_bridge, 0x79, tmp | 0x02);
 	}
 	pci_dev_put(north);
 	ata_pci_bmdma_clear_simplex(pdev);
@@ -571,9 +571,9 @@ static int ali_init_one(struct pci_dev *
 
 	ali_init_chipset(pdev);
 
-	if (isa_bridge && pdev->revision >= 0x20 && pdev->revision < 0xC2) {
+	if (ali_isa_bridge && pdev->revision >= 0x20 && pdev->revision < 0xC2) {
 		/* Are we paired with a UDMA capable chip */
-		pci_read_config_byte(isa_bridge, 0x5E, &tmp);
+		pci_read_config_byte(ali_isa_bridge, 0x5E, &tmp);
 		if ((tmp & 0x1E) == 0x12)
 	        	ppi[0] = &info_20_udma;
 	}
@@ -617,11 +617,11 @@ static struct pci_driver ali_pci_driver 
 static int __init ali_init(void)
 {
 	int ret;
-	isa_bridge = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
+	ali_isa_bridge = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 
 	ret = pci_register_driver(&ali_pci_driver);
 	if (ret < 0)
-		pci_dev_put(isa_bridge);
+		pci_dev_put(ali_isa_bridge);
 	return ret;
 }
 
@@ -629,7 +629,7 @@ static int __init ali_init(void)
 static void __exit ali_exit(void)
 {
 	pci_unregister_driver(&ali_pci_driver);
-	pci_dev_put(isa_bridge);
+	pci_dev_put(ali_isa_bridge);
 }
 
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-upc-omit-it-if-smp=y-use_generic_smp_helpers=n.patch
alpha-fix-vmalloc-breakage-fix.patch
revert-mm-vmalloc-use-mutex-for-purge.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch
hp_accel-do-not-call-acpi-from-invalid-context-fix.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-ata-pata_alic-s-isa_bridge-ali_isa_bridge-to-fix-alpha-build.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

