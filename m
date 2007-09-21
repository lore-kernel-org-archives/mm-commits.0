From: akpm@linux-foundation.org
Subject: + pata_acpi-use-ata_sff_port_start.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:45:53 -0700
Message-ID: <200709210645.l8L6jrhB023134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbXIUGqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_acpi: use ata_sff_port_start
has been added to the -mm tree.  Its filename is
     pata_acpi-use-ata_sff_port_start.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_acpi: use ata_sff_port_start
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Purely a stylistic issue currently but best done while I notice it.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/pata_acpi.c~pata_acpi-use-ata_sff_port_start drivers/ata/pata_acpi.c
--- a/drivers/ata/pata_acpi.c~pata_acpi-use-ata_sff_port_start
+++ a/drivers/ata/pata_acpi.c
@@ -270,7 +270,7 @@ static int pacpi_port_start(struct ata_p
 	acpi->mask[0] = pacpi_discover_modes(ap, &ap->device[0]);
 	acpi->mask[1] = pacpi_discover_modes(ap, &ap->device[1]);
 
-	ret = ata_port_start(ap);
+	ret = ata_sff_port_start(ap);
 	if (ret < 0)
 		return ret;
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

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
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
