From: akpm@linux-foundation.org
Subject: + pata_atiixp-audit-notes-on-locking.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:45:55 -0700
Message-ID: <200709262245.l8QMjtDD007804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760398AbXIZWqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:46:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_atiixp: Audit notes on locking
has been added to the -mm tree.  Its filename is
     pata_atiixp-audit-notes-on-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_atiixp: Audit notes on locking
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ata/pata_atiixp.c~pata_atiixp-audit-notes-on-locking drivers/ata/pata_atiixp.c
--- a/drivers/ata/pata_atiixp.c~pata_atiixp-audit-notes-on-locking
+++ a/drivers/ata/pata_atiixp.c
@@ -173,6 +173,9 @@ static void atiixp_set_dmamode(struct at
  *
  *	When DMA begins we need to ensure that the UDMA control
  *	register for the channel is correctly set.
+ *
+ *	Note: The host lock held by the libata layer protects
+ *	us from two channels both trying to set DMA bits at once
  */
 
 static void atiixp_bmdma_start(struct ata_queued_cmd *qc)
@@ -199,6 +202,9 @@ static void atiixp_bmdma_start(struct at
  *
  *	DMA has completed. Clear the UDMA flag as the next operations will
  *	be PIO ones not UDMA data transfer.
+ *
+ *	Note: The host lock held by the libata layer protects
+ *	us from two channels both trying to set DMA bits at once
  */
 
 static void atiixp_bmdma_stop(struct ata_queued_cmd *qc)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
pata_pdc202xx_old-fix-timings.patch
pata_ns87415-initial-cut-at-87415-87560-ide-support.patch
fix-hpa-handling-regression.patch
libata_scsi-fix-transfer-lengths.patch
pata_atiixp-audit-notes-on-locking.patch
pata_hpt3x2n-clean-up-dpll-stuff.patch
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
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
