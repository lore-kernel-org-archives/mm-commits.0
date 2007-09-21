From: akpm@linux-foundation.org
Subject: + libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:57:53 -0700
Message-ID: <200709210657.l8L6vrfc023485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129AbXIUG6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: add a horkage entry for DRQ mishandling (atapi tapes)
has been added to the -mm tree.  Its filename is
     libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: add a horkage entry for DRQ mishandling (atapi tapes)
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This will allow us to handle the tape drive problems Mark Lord reported

On Thu, 20 Sep 2007 22:42:17 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > According to information I have received, some ATA (and possibly ATAPI?) 
> > devices intentionally return some data in these cases.  In the case of 
> > certain ATA devices, this returned data permits inspection of the 
> > incorrected data.
> 
> News to me. ATA like ST-506/ST-412 exposes error data on I/O READ/WRITE
> via the READ_BUFFER functionality but its basically useless without a lot
> of knowledge of the drive on anything post ST-412 era.
> 
> Got any references ?
> 
> The other possibility is to whine but accept it happens - on the other
> hand being lax about HSM errors is asking for corruption and it seems
> to be unique to this tape device.
> 
> (and someone please don't tell me early pre ATAPI standard devices are
> trying to return the sense data in this way or I'll be ill)

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    9 +++++++--
 include/linux/libata.h    |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-add-a-horkage-entry-for-drq-mishandling-atapi drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-add-a-horkage-entry-for-drq-mishandling-atapi
+++ a/drivers/ata/libata-core.c
@@ -5097,8 +5097,13 @@ fsm_start:
 		if (unlikely(status & (ATA_ERR | ATA_DF))) {
 			ata_port_printk(ap, KERN_WARNING, "DRQ=1 with device "
 					"error, dev_stat 0x%X\n", status);
-			qc->err_mask |= AC_ERR_HSM;
-			ap->hsm_task_state = HSM_ST_ERR;
+
+			/* Some tape drives muck this up so don't explode
+			   in those cases */
+			if (!(qc->dev->horkage & ATA_HORKAGE_DRQ)) {
+				qc->err_mask |= AC_ERR_HSM;
+				ap->hsm_task_state = HSM_ST_ERR;
+			}
 			goto fsm_start;
 		}
 
diff -puN include/linux/libata.h~libata-add-a-horkage-entry-for-drq-mishandling-atapi include/linux/libata.h
--- a/include/linux/libata.h~libata-add-a-horkage-entry-for-drq-mishandling-atapi
+++ a/include/linux/libata.h
@@ -316,6 +316,7 @@ enum {
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
 	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
 	ATA_HORKAGE_HPA_SIZE	= (1 << 5), 	/* Reports native size off by one */
+	ATA_HORKAGE_DRQ		= (1 << 6),	/* Device forgets to clear DRQ on error */
 
 	/* DMA mask for user DMA control: User visible values do not
 	   renumber */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

dtc-fix-typo.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-update-experimental-tags-to-reflect-reality-better.patch
libata-sff-fix-documentation.patch
st340823a-hpa-and-libata.patch
libata-update-the-blacklist-with-a-few-more-devices.patch
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
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
