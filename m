From: akpm@linux-foundation.org
Subject: - libata-sff-fix-documentation.patch removed from -mm tree
Date: Fri, 21 Sep 2007 14:08:18 -0700
Message-ID: <200709212108.l8LL8I1E023563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762398AbXIUVJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 17:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata-sff: fix documentation
has been removed from the -mm tree.  Its filename was
     libata-sff-fix-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata-sff: fix documentation
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Code moved to ioread/iowrite but the comment didn't.  Also note a posting
issue.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/ata/libata-sff.c~libata-sff-fix-documentation drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-sff-fix-documentation
+++ a/drivers/ata/libata-sff.c
@@ -257,7 +257,7 @@ void ata_bmdma_start (struct ata_queued_
 	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
 	iowrite8(dmactl | ATA_DMA_START, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
 
-	/* Strictly, one may wish to issue a readb() here, to
+	/* Strictly, one may wish to issue an ioread8() here, to
 	 * flush the mmio write.  However, control also passes
 	 * to the hardware at this point, and it will interrupt
 	 * us when we are to resume control.  So, in effect,
@@ -267,6 +267,9 @@ void ata_bmdma_start (struct ata_queued_
 	 * is expected, so I think it is best to not add a readb()
 	 * without first all the MMIO ATA cards/mobos.
 	 * Or maybe I'm just being paranoid.
+	 *
+	 * FIXME: The posting of this write means I/O starts are
+	 * unneccessarily delayed for MMIO
 	 */
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
dtc-fix-typo.patch
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
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
