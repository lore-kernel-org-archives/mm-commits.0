From: akpm@linux-foundation.org
Subject: + libata-correct-handling-of-srst-reset-sequences.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:24:41 -0700
Message-ID: <200708232224.l7NMOggO029847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761999AbXHWWZD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:25:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: correct handling of SRST reset sequences
has been added to the -mm tree.  Its filename is
     libata-correct-handling-of-srst-reset-sequences.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: correct handling of SRST reset sequences
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Correct handling of SRST reset sequences.  After an SRST it is undefined
whether the drive has gone back to PIO0.  In order to talk safely we should
talk slowly and carefully until we know.

Thus when we do the reset if the controller has a pio setup method we call it
to flip back to PIO 0 and a known state.  After the reset completes the
identify will then be done at the safe speed and the drive/controller will
pick suitable faster modes and reconfigure the controller to these timings.

As a side effect it means we force the controller to PIO 0 as we bring it up
which fixes funnies on a few systems where the BIOS firmware leaves us in an
interesting choice of modes, or embedded boxes with no firmware which come up
in random states.

For smart controllers there is nothing to do - they know about this internally.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-correct-handling-of-srst-reset-sequences drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-correct-handling-of-srst-reset-sequences
+++ a/drivers/ata/libata-core.c
@@ -3159,6 +3159,8 @@ static int ata_bus_softreset(struct ata_
 			     unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
+	struct ata_device *dev;
+	int i = 0;
 
 	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
 
@@ -3169,6 +3171,25 @@ static int ata_bus_softreset(struct ata_
 	udelay(20);	/* FIXME: flush */
 	iowrite8(ap->ctl, ioaddr->ctl_addr);
 
+	/* If we issued an SRST then an ATA drive (not ATAPI)
+	 * may have changed configuration and be in PIO0 timing. If
+	 * we did a hard reset (or are coming from power on) this is
+	 * true for ATA or ATAPI. Until we've set a suitable controller
+	 * mode we should not touch the bus as we may be talking too fast.
+	 */
+
+	ata_link_for_each_dev(dev, &ap->link)
+		dev->pio_mode = XFER_PIO_0;
+
+	/* If the controller has a pio mode setup function then use
+	   it to set the chipset to rights. Don't touch the DMA setup
+	   as that will be dealt with when revalidating */
+	if (ap->ops->set_piomode) {
+		ata_link_for_each_dev(dev, &ap->link)
+			if (devmask & (1 << i++))
+				ap->ops->set_piomode(ap, dev);
+	}
+
 	/* wait a while before checking status */
 	ata_wait_after_reset(ap, deadline);
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
fix-null-pointer-dereference-in-__vm_enough_memory.patch
m68k-enable-arbitary-speed-tty-support.patch
introduce-config_check_signature-was-re-uninline.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_sis-add-the-fsc-amilo-and-friends.patch
pata_via-add-armia-w730-k8-and-other-rebadgings.patch
pata_marvell-add-more-identifiers.patch
libata-portmap-remove-unused-definitions.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-spot-bridge-chips.patch
libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
kobil_sct-rework-driver.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
pata_it821x-fix-regression-corruptor.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
