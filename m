From: akpm@linux-foundation.org
Subject: + libata-handle-broken-cable-reporting.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:44:26 -0800
Message-ID: <200711060244.lA62iQnl032367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867AbXKFCol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:44:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: handle broken cable reporting
has been added to the -mm tree.  Its filename is
     libata-handle-broken-cable-reporting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: handle broken cable reporting
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

One or two ancient drives predated the cable spec and didn't sent the valid
bits for the field.  I had hoped to leave this out of libata as a piece of
historical annoyance but a recent CD drive shows the same bug so we have to
import support for it.

Same concept as Bartlomiej's changes old IDE except that as we have
centralised blacklists we can avoid keeping another private table of stuff

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   21 ++++++++++++++++++++-
 include/linux/ata.h       |    9 +++++++++
 include/linux/libata.h    |    1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~libata-handle-broken-cable-reporting drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-handle-broken-cable-reporting
+++ a/drivers/ata/libata-core.c
@@ -4255,6 +4255,10 @@ static const struct ata_blacklist_entry 
 	{ "ST340823A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
 	{ "ST320413A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
 
+	/* Devices which get the IVB wrong */
+	{ "QUANTUM FIREBALLlct10 05", "A03.0900", ATA_HORKAGE_IVB, },
+	{ "TSSTcorp CDDVDW SH-S202J", "SB00",	  ATA_HORKAGE_IVB, },
+
 	/* End Marker */
 	{ }
 };
@@ -4316,6 +4320,21 @@ static int ata_dma_blacklisted(const str
 }
 
 /**
+ *	ata_is_40wire		-	check drive side detection
+ *	@dev: device
+ *
+ *	Perform drive side detection decoding, allowing for device vendors
+ *	who can't follow the documentation.
+ */
+
+static int ata_is_40wire(struct ata_device *dev)
+{
+	if (dev->horkage & ATA_HORKAGE_IVB)
+		return ata_drive_40wire_relaxed(dev->id);
+	return ata_drive_40wire(dev->id);
+}
+
+/**
  *	ata_dev_xfermask - Compute supported xfermask of the given device
  *	@dev: Device to compute xfermask for
  *
@@ -4384,7 +4403,7 @@ static void ata_dev_xfermask(struct ata_
 	if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
 		/* UDMA/44 or higher would be available */
 		if ((ap->cbl == ATA_CBL_PATA40) ||
-		    (ata_drive_40wire(dev->id) &&
+   		    (ata_is_40wire(dev) &&
 		    (ap->cbl == ATA_CBL_PATA_UNK ||
 		     ap->cbl == ATA_CBL_PATA80))) {
 			ata_dev_printk(dev, KERN_WARNING,
diff -puN include/linux/ata.h~libata-handle-broken-cable-reporting include/linux/ata.h
--- a/include/linux/ata.h~libata-handle-broken-cable-reporting
+++ a/include/linux/ata.h
@@ -557,6 +557,15 @@ static inline int ata_drive_40wire(const
 	return 1;
 }
 
+static inline int ata_drive_40wire_relaxed(const u16 *dev_id)
+{
+	if (ata_id_is_sata(dev_id))
+		return 0;	/* SATA */
+	if ((dev_id[93] & 0x2000) == 0x2000)
+		return 0;	/* 80 wire */
+	return 1;
+}
+
 static inline int atapi_cdb_len(const u16 *dev_id)
 {
 	u16 tmp = dev_id[0] & 0x3;
diff -puN include/linux/libata.h~libata-handle-broken-cable-reporting include/linux/libata.h
--- a/include/linux/libata.h~libata-handle-broken-cable-reporting
+++ a/include/linux/libata.h
@@ -339,6 +339,7 @@ enum {
 	ATA_HORKAGE_SKIP_PM	= (1 << 5),	/* Skip PM operations */
 	ATA_HORKAGE_HPA_SIZE	= (1 << 6),	/* native size off by one */
 	ATA_HORKAGE_IPM		= (1 << 7),	/* Link PM problems */
+	ATA_HORKAGE_IVB		= ( 1<< 8),	/* validity bit bugs on cable detect */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-handle-broken-cable-reporting.patch
piix-add-support-for-ich7-on-acer-5602awlmi.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
initio-fix-conflict-when-loading-driver.patch
serial-only-use-pnp-irq-if-its-valid.patch
keyspan-init-termios-properly.patch
geode-lists-are-subscriber-only.patch
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
