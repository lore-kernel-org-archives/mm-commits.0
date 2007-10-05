From: akpm@linux-foundation.org
Subject: - libata-correct-handling-of-srst-reset-sequences.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:58 -0700
Message-ID: <200710051956.l95Juwgk022420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763038AbXJEUB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata: correct handling of SRST reset sequences
has been removed from the -mm tree.  Its filename was
     libata-correct-handling-of-srst-reset-sequences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 21 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-correct-handling-of-srst-reset-sequences drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-correct-handling-of-srst-reset-sequences
+++ a/drivers/ata/libata-core.c
@@ -3258,6 +3258,8 @@ static int ata_bus_softreset(struct ata_
 			     unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
+	struct ata_device *dev;
+	int i = 0;
 
 	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
 
@@ -3268,6 +3270,25 @@ static int ata_bus_softreset(struct ata_
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
git-libata-all.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
git-scsi-misc.patch
initio-fix-conflict-when-loading-driver.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
fs-correct-sus-compliance-for-open-of-large-file-without.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
funsoft-fix-termios.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
visor-termios-bits.patch
