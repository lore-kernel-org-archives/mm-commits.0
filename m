From: akpm@linux-foundation.org
Subject: + ata_generic-cenatek-support.patch added to -mm tree
Date: Mon, 21 Jan 2008 23:35:30 -0800
Message-ID: <200801220735.m0M7ZAYq010555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968AbYAVHgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 02:36:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     ata_generic: Cenatek support
has been added to the -mm tree.  Its filename is
     ata_generic-cenatek-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ata_generic: Cenatek support
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Not much to do here. It's an ata memory as disk.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_generic.c |    7 ++++++-
 include/linux/pci_ids.h   |    3 +++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/ata/ata_generic.c~ata_generic-cenatek-support drivers/ata/ata_generic.c
--- a/drivers/ata/ata_generic.c~ata_generic-cenatek-support
+++ a/drivers/ata/ata_generic.c
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "ata_generic"
-#define DRV_VERSION "0.2.13"
+#define DRV_VERSION "0.2.15"
 
 /*
  *	A generic parallel ATA driver using libata
@@ -48,11 +48,15 @@ static int generic_set_mode(struct ata_l
 	struct ata_port *ap = link->ap;
 	int dma_enabled = 0;
 	struct ata_device *dev;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	/* Bits 5 and 6 indicate if DMA is active on master/slave */
 	if (ap->ioaddr.bmdma_addr)
 		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 
+	if (pdev->vendor == PCI_VENDOR_ID_CENATEK)
+		dma_enabled = 0xFF;
+
 	ata_link_for_each_dev(dev, link) {
 		if (!ata_dev_enabled(dev))
 			continue;
@@ -201,6 +205,7 @@ static struct pci_device_id ata_generic[
 	{ PCI_DEVICE(PCI_VENDOR_ID_HINT,   PCI_DEVICE_ID_HINT_VXPROII_IDE), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA,    PCI_DEVICE_ID_VIA_82C561), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
diff -puN include/linux/pci_ids.h~ata_generic-cenatek-support include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~ata_generic-cenatek-support
+++ a/include/linux/pci_ids.h
@@ -2066,6 +2066,9 @@
 #define PCI_VENDOR_ID_NETCELL		0x169c
 #define PCI_DEVICE_ID_REVOLUTION	0x0044
 
+#define PCI_VENDOR_ID_CENATEK		0x16CA
+#define PCI_DEVICE_ID_CENATEK_IDE	0x0001
+
 #define PCI_VENDOR_ID_VITESSE		0x1725
 #define PCI_DEVICE_ID_VITESSE_VSC7174	0x7174
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
keyspan-fix-oops.patch
git-acpi.patch
git-arm.patch
git-libata-all.patch
ata_generic-cenatek-support.patch
pata_legacy-merge-winbond-support.patch
pata_mpc52xx-remove-un-needed-assignment.patch
pata_pdc202xx_old-fix-crashes-with-atapi.patch
pata_serverworks-fix-cable-types-and-cosmetics.patch
pata_winbond-error-return.patch
git-net.patch
resend-8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch
avoid-waking-up-closed-serial-ports-on-resume.patch
serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch
serial-speed-setup-failure-reporting.patch
serial-coding-style.patch
sh-termios-ioctl-definitions.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-ti_usb-termios-cleanups.patch
git-watchdog.patch
git-x86.patch
x86-reboot-remove-inb_p-usage.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
documentation-about-unaligned-memory-access.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
rocket-first-pass-at-termios-reporting.patch
rocket-dont-let-random-users-reset-the-controller.patch
tty_audit-fix-checkpatch-complaint.patch
tty_io-drag-screaming-into-coding-style-compliance.patch
tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
8250_early-coding-style.patch
8250_gsc-coding-style.patch
8250_hp300-coding-style.patch
8250_hub6-codding-style.patch
8250_pci-coding-style.patch
serial8250-coding-style.patch
8250-enable-rate-reporting-via-termios.patch
serial_core-bring-mostly-into-line-with-coding-style.patch
