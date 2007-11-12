From: akpm@linux-foundation.org
Subject: + libata-implement-ata_acpi_init_gtm.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:16:50 -0800
Message-ID: <200711122116.lACLGoRN009399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbXKLV0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:26:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com


The patch titled
     libata: implement ata_acpi_init_gtm()
has been added to the -mm tree.  Its filename is
     libata-implement-ata_acpi_init_gtm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: implement ata_acpi_init_gtm()
From: Tejun Heo <htejun@gmail.com>

Add dev->__acpi_init_gtm and store initial GTM values on host initialization. 
If the field is valid, ata_acpi_init_gtm() returns pointer to the saved GTM
structure; otherwise, NULL.  This is to remember BIOS/firmware programmed
initial timing for later use before reset and mode configuration modify it. 
The accessor is there to make building w/o ACPI easy dev->__acpi_init doesn't
exist if ACPI is not enabled.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-acpi.c |    3 +++
 include/linux/libata.h    |   14 +++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/ata/libata-acpi.c~libata-implement-ata_acpi_init_gtm drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~libata-implement-ata_acpi_init_gtm
+++ a/drivers/ata/libata-acpi.c
@@ -94,6 +94,9 @@ static void ata_acpi_associate_ide_port(
 
 		dev->acpi_handle = acpi_get_child(ap->acpi_handle, i);
 	}
+
+	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
+		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
 static void ata_acpi_handle_hotplug(struct ata_port *ap, struct kobject *kobj,
diff -puN include/linux/libata.h~libata-implement-ata_acpi_init_gtm include/linux/libata.h
--- a/include/linux/libata.h~libata-implement-ata_acpi_init_gtm
+++ a/include/linux/libata.h
@@ -212,6 +212,7 @@ enum {
 	ATA_PFLAG_SUSPENDED	= (1 << 17), /* port is suspended (power) */
 	ATA_PFLAG_PM_PENDING	= (1 << 18), /* PM operation pending */
 	ATA_PFLAG_GTM_VALID	= (1 << 19), /* acpi_gtm data valid */
+	ATA_PFLAG_INIT_GTM_VALID = (1 << 20), /* initial gtm data valid */
 
 	/* struct ata_queued_cmd flags */
 	ATA_QCFLAG_ACTIVE	= (1 << 0), /* cmd not yet ack'd to scsi lyer */
@@ -656,6 +657,7 @@ struct ata_port {
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
 	struct ata_acpi_gtm	acpi_gtm;
+	struct ata_acpi_gtm	__acpi_init_gtm; /* use ata_acpi_init_gtm() */
 #endif
 	u8			sector_buf[ATA_SECT_SIZE]; /* owned by EH */
 };
@@ -953,13 +955,23 @@ enum {
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
+static inline const struct ata_acpi_gtm *ata_acpi_init_gtm(struct ata_port *ap)
+{
+	if (ap->pflags & ATA_PFLAG_INIT_GTM_VALID)
+		return &ap->__acpi_init_gtm;
+	return NULL;
+}
 extern int ata_acpi_cbl_80wire(struct ata_port *ap);
 int ata_acpi_stm(const struct ata_port *ap, struct ata_acpi_gtm *stm);
 int ata_acpi_gtm(const struct ata_port *ap, struct ata_acpi_gtm *stm);
 unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
 				   const struct ata_acpi_gtm *gtm);
-
 #else
+static inline const struct ata_acpi_gtm *ata_acpi_init_gtm(struct ata_port *ap)
+{
+	return NULL;
+}
+
 static inline int ata_acpi_cbl_80wire(struct ata_port *ap) { return 0; }
 
 static inline int ata_acpi_stm(const struct ata_port *ap,
_

Patches currently in -mm which might be from htejun@gmail.com are

git-libata-all.patch
ata_generic-unindent-loop-in-generic_set_mode.patch
libata-export-xfermode--pata-timing-related-functions.patch
libata-clean-up-xfermode--pata-timing-related-stuff.patch
libata-kill-ata_id_to_dma_mode.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
libata-fix-ata_acpi_gtm_xfermask.patch
libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
libata-implement-ata_acpi_init_gtm.patch
libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
libata-add-ata_cbl_pata_ign.patch
pata_amd-update-mode-selection-for-nv-patas.patch
scsi-early-detection-of-medium-not-present-updated.patch
