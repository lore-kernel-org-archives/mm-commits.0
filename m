From: akpm@linux-foundation.org
Subject: + libata-cable-detection-fixes.patch added to -mm tree
Date: Sun, 04 Mar 2007 23:39:02 -0800
Message-ID: <200703050739.l257d2Ou012855@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103AbXCEHjX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 02:39:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: cable detection fixes
has been added to the -mm tree.  Its filename is
     libata-cable-detection-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: cable detection fixes
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

2.6.21-rc has horrible problems with libata and PATA cable types (and
thus speeds). This occurs because Tejun fixed a pile of other bugs and
we now do cable detect enforcement for drive side detection properly.

Unfortunately we don't do the process around cable detection right. Tejun
identified the problem and pointed to the right Annex in the spec, this patch
implements the needed changes.

The basic requirement is that we have to identify the slave before the
master.

The patch switches the identify order so that we can do the drive side
detection correctly.

Secondly we add a ->cable_detect() method called after the identify
sequence which allows a host to do host side detection at this point
should it wish, or to modify the results of the drive side identify.

This separate ->cable_detect method also cleans up a lot of code because
many drivers have their own error_handler methods which really just set
the cable type.

If there is no ->cable_detect method the cable type is left alone so a
driver setting it earlier (eg because it has the SATA flags set or
because it uses the old error_handler approach) will still do the right
thing (or at least the same thing) as before.

This patch simply adds the cable_detect method and helpers it doesn't use
them but other follow up patches will (ie Adrian please don't submit
patches to unexport them ;))

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   59 ++++++++++++++++++++++++++++++++++++
 include/linux/libata.h    |    7 ++++
 2 files changed, 66 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-cable-detection-fixes drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-cable-detection-fixes
+++ a/drivers/ata/libata-core.c
@@ -1784,6 +1784,56 @@ err_out_nosup:
 }
 
 /**
+ *	ata_cable_40wire	-	return 40pin cable type
+ *	@ap: port
+ *
+ *	Helper method for drivers which want to hardwire 40 pin cable
+ *	detection.
+ */
+
+int ata_cable_40wire(struct ata_port *ap)
+{
+	return ATA_CBL_PATA40;
+}
+
+/**
+ *	ata_cable_80wire	-	return 40pin cable type
+ *	@ap: port
+ *
+ *	Helper method for drivers which want to hardwire 80 pin cable
+ *	detection.
+ */
+
+int ata_cable_80wire(struct ata_port *ap)
+{
+	return ATA_CBL_PATA80;
+}
+
+/**
+ *	ata_cable_unknown	-	return unknown PATA cable.
+ *	@ap: port
+ *
+ *	Helper method for drivers which have no PATA cable detection.
+ */
+
+int ata_cable_unknown(struct ata_port *ap)
+{
+	return ATA_CBL_PATA_UNK;
+}
+
+/**
+ *	ata_cable_sata	-	return SATA cable type
+ *	@ap: port
+ *
+ *	Helper method for drivers which have SATA cables
+ */
+
+int ata_cable_sata(struct ata_port *ap)
+{
+	return ATA_CBL_SATA;
+}
+
+/**
  *	ata_bus_probe - Reset and probe ATA bus
  *	@ap: Bus to probe
  *
@@ -1853,6 +1903,10 @@ int ata_bus_probe(struct ata_port *ap)
 			goto fail;
 	}
 
+	/* Now ask for the cable type as PDIAG- should have been released */
+	if (ap->ops->cable_detect)
+		ap->cbl = ap->ops->cable_detect(ap);
+
 	/* After the identify sequence we can now set up the devices. We do
 	   this in the normal order so that the user doesn't get confused */
 
@@ -6438,3 +6492,8 @@ EXPORT_SYMBOL_GPL(ata_dummy_irq_on);
 EXPORT_SYMBOL_GPL(ata_irq_ack);
 EXPORT_SYMBOL_GPL(ata_dummy_irq_ack);
 EXPORT_SYMBOL_GPL(ata_dev_try_classify);
+
+EXPORT_SYMBOL_GPL(ata_cable_40wire);
+EXPORT_SYMBOL_GPL(ata_cable_80wire);
+EXPORT_SYMBOL_GPL(ata_cable_unknown);
+EXPORT_SYMBOL_GPL(ata_cable_sata);
diff -puN include/linux/libata.h~libata-cable-detection-fixes include/linux/libata.h
--- a/include/linux/libata.h~libata-cable-detection-fixes
+++ a/include/linux/libata.h
@@ -614,6 +614,8 @@ struct ata_port_operations {
 
 	void (*post_set_mode) (struct ata_port *ap);
 
+	int (*cable_detect) (struct ata_port *ap);
+
 	int  (*check_atapi_dma) (struct ata_queued_cmd *qc);
 
 	void (*bmdma_setup) (struct ata_queued_cmd *qc);
@@ -833,6 +835,11 @@ extern u8 ata_dummy_irq_on(struct ata_po
 extern u8 ata_irq_ack(struct ata_port *ap, unsigned int chk_drq);
 extern u8 ata_dummy_irq_ack(struct ata_port *ap, unsigned int chk_drq);
 
+extern int ata_cable_40wire(struct ata_port *ap);
+extern int ata_cable_80wire(struct ata_port *ap);
+extern int ata_cable_sata(struct ata_port *ap);
+extern int ata_cable_unknown(struct ata_port *ap);
+
 /*
  * Timing helpers
  */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
cyclades-return-closing_wait.patch
git-libata-all.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-cable-detection-fixes.patch
pata_platform-set-a-cable-type-which-to-set.patch
pata_qdi-set-cable-type.patch
pata_sl82c105-missing-methods-cable.patch
ata_generic-remove-lots-of-code-using-the-new-cable_detect.patch
pata_ali-remove-lots-of-code-by-using-the-cable_detect.patch
pata_cs55x0-clean-up-by-using-the-cable_detect-method.patch
pata_cypress-clean-up-by-using-cable_detect-method.patch
pata_isapnp-set-cable-type.patch
pata_ixp4xx_cf-set-cable-type.patch
pata_legacy-fix-missing-methods-and-add-cable-types.patch
pata_netcell-remove-lots-of-crud-by-using-the-cable-method.patch
pata_radisys-switch-to-cable-method-to-cleanup-code.patch
pata_sc1200-set-cable-type-add-freeze-thaw-methods.patch
pata_rz1000-remove-lots-of-crap-by-using-cable-method.patch
pata_winbond-set-cable-type.patch
pata_cmd64x-various-fixes.patch
pata_hpt3x3-clean-up-by-using-cable-method.patch
pata_qdi-fix-initialisation.patch
pata_cmd640-cmd640-pci-support.patch
libata-kconfig-update-the-various-experimentality-levels.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
