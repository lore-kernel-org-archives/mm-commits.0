From: akpm@linux-foundation.org
Subject: - libata-spot-bridge-chips.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:41 -0700
Message-ID: <200708311656.l7VGufAf017505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41202 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758443AbXHaRIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 13:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata: spot bridge chips
has been removed from the -mm tree.  Its filename was
     libata-spot-bridge-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: spot bridge chips
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

If we have a PATA cable with a SATA drive on it then we've found a bridge and
we can flip the cable type.  This fixes some cable detect problems with SATA
bridges on chipsets and misdetected cable types.

In theory cable detection and mode limiting is needed if you put a SATA/PATA
bridge on a 40 wire cable, but I see no way to deal with that other than to
point out its not a good idea anyway.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   11 +++++++++++
 1 files changed, 11 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-spot-bridge-chips drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-spot-bridge-chips
+++ a/drivers/ata/libata-core.c
@@ -2182,6 +2182,17 @@ int ata_bus_probe(struct ata_port *ap)
 	if (ap->ops->cable_detect)
 		ap->cbl = ap->ops->cable_detect(ap);
 
+	/* We may have SATA bridge glue hiding here irrespective of the
+	   reported cable types and sensed types */
+	ata_link_for_each_dev(dev, &ap->link) {
+		if (!ata_dev_enabled(dev))
+			continue;
+		/* SATA drives indicate we have a bridge. We don't know which
+		   end of the link the bridge is which is a problem */
+		if (ata_id_is_sata(dev->id))
+			ap->cbl = ATA_CBL_SATA;
+	}
+
 	/* After the identify sequence we can now set up the devices. We do
 	   this in the normal order so that the user doesn't get confused */
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
git-xtensa.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
