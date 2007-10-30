From: akpm@linux-foundation.org
Subject: - libata-pata_it821x-improve-handling-of-poorly-compatible-emulations.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:48 -0700
Message-ID: <200710301806.l9UI6mJd020551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60770 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653AbXJ3SHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:07:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata/pata_it821x: improve handling of poorly compatible emulations
has been removed from the -mm tree.  Its filename was
     libata-pata_it821x-improve-handling-of-poorly-compatible-emulations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata/pata_it821x: improve handling of poorly compatible emulations
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Some it821x RAID firmwares return 0 for the err return off both devices.
A similar issue occurs with the slave returning 0 not 1 if you plug a
gigabyte sata ramdisk into a controller that fakes two SATA ports as
master/slave on an SFF channel.

The patch does the following

- Allow the 'failed diagnostics' case on both master and slave
- Move the HORKAGE_DIAGNOSTIC check after ->dev_config

This second change also allows IT821x to fix up a problem where we report
drive diagnostic failures when in fact the drive is fine but the
microcontroller firmware doesn't appear to get it right. IT821x clears
the flag again to avoid giving the user bogus warnings about their disk.

The other IT821x change is a bit ugly, we slightly abuse the cable type
hook to fiddle with the identify data for the devices. We could add a new
hook for this but as we have only one offender and no more seeming likely
it seems better to keep libata-core clean.

Please let this sit in -mm briefly, just in case the relaxed checking
breaks some other emulated interface.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   34 +++++++++++++++++++---------------
 drivers/ata/pata_it821x.c |   35 +++++++++++++++++++++++++++++++++--
 2 files changed, 52 insertions(+), 17 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-pata_it821x-improve-handling-of-poorly-compatible-emulations drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-pata_it821x-improve-handling-of-poorly-compatible-emulations
+++ a/drivers/ata/libata-core.c
@@ -931,8 +931,8 @@ unsigned int ata_dev_try_classify(struct
 	if (r_err)
 		*r_err = err;
 
-	/* see if device passed diags: if master then continue and warn later */
-	if (err == 0 && dev->devno == 0)
+	/* see if device passed diags: continue and warn later */
+	if (err == 0)
 		/* diagnostic fail : do nothing _YET_ */
 		dev->horkage |= ATA_HORKAGE_DIAGNOSTIC;
 	else if (err == 1)
@@ -2279,19 +2279,8 @@ int ata_dev_configure(struct ata_device 
 			dev->flags |= ATA_DFLAG_DIPM;
 	}
 
-	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
-		/* Let the user know. We don't want to disallow opens for
-		   rescue purposes, or in case the vendor is just a blithering
-		   idiot */
-		if (print_info) {
-			ata_dev_printk(dev, KERN_WARNING,
-"Drive reports diagnostics failure. This may indicate a drive\n");
-			ata_dev_printk(dev, KERN_WARNING,
-"fault or invalid emulation. Contact drive vendor for information.\n");
-		}
-	}
-
-	/* limit bridge transfers to udma5, 200 sectors */
+	/* Limit PATA drive on SATA cable bridge transfers to udma5,
+	   200 sectors */
 	if (ata_dev_knobble(dev)) {
 		if (ata_msg_drv(ap) && print_info)
 			ata_dev_printk(dev, KERN_INFO,
@@ -2314,6 +2303,21 @@ int ata_dev_configure(struct ata_device 
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
+	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
+		/* Let the user know. We don't want to disallow opens for
+		   rescue purposes, or in case the vendor is just a blithering
+		   idiot. Do this after the dev_config call as some controllers
+		   with buggy firmware may want to avoid reporting false device
+		   bugs */
+
+                if (print_info) {
+			ata_dev_printk(dev, KERN_WARNING,
+"Drive reports diagnostics failure. This may indicate a drive\n");
+			ata_dev_printk(dev, KERN_WARNING,
+"fault or invalid emulation. Contact drive vendor for information.\n");
+		}
+	}
+
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: EXIT, drv_stat = 0x%x\n",
 			__FUNCTION__, ata_chk_status(ap));
diff -puN drivers/ata/pata_it821x.c~libata-pata_it821x-improve-handling-of-poorly-compatible-emulations drivers/ata/pata_it821x.c
--- a/drivers/ata/pata_it821x.c~libata-pata_it821x-improve-handling-of-poorly-compatible-emulations
+++ a/drivers/ata/pata_it821x.c
@@ -430,7 +430,7 @@ static unsigned int it821x_smart_qc_issu
 			return ata_qc_issue_prot(qc);
 	}
 	printk(KERN_DEBUG "it821x: can't process command 0x%02X\n", qc->tf.command);
-	return AC_ERR_INVALID;
+	return AC_ERR_DEV;
 }
 
 /**
@@ -516,6 +516,37 @@ static void it821x_dev_config(struct ata
 			printk("(%dK stripe)", adev->id[146]);
 		printk(".\n");
 	}
+	/* This is a controller firmware triggered funny, don't
+	   report the drive faulty! */
+	adev->horkage &= ~ATA_HORKAGE_DIAGNOSTIC;
+}
+
+/**
+ *	it821x_ident_hack	-	Hack identify data up
+ *	@ap: Port
+ *
+ *	Walk the devices on this firmware driven port and slightly
+ *	mash the identify data to stop us and common tools trying to
+ *	use features not firmware supported. The firmware itself does
+ *	some masking (eg SMART) but not enough.
+ *
+ *	This is a bit of an abuse of the cable method, but it is the
+ *	only method called at the right time. We could modify the libata
+ *	core specifically for ident hacking but while we have one offender
+ *	it seems better to keep the fallout localised.
+ */
+
+static int it821x_ident_hack(struct ata_port *ap)
+{
+	struct ata_device *adev;
+	ata_link_for_each_dev(adev, &ap->link) {
+		if (ata_dev_enabled(adev)) {
+			adev->id[84] &= ~(1 << 6);	/* No FUA */
+			adev->id[85] &= ~(1 << 10);	/* No HPA */
+			adev->id[76] = 0;		/* No NCQ/AN etc */
+		}
+	}
+	return ata_cable_unknown(ap);
 }
 
 
@@ -634,7 +665,7 @@ static struct ata_port_operations it821x
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
-	.cable_detect	= ata_cable_unknown,
+	.cable_detect	= it821x_ident_hack,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
libata-pata_it821x-improve-handling-of-poorly-compatible-emulations-checkpatch-fixes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
initio-fix-conflict-when-loading-driver.patch
serial-only-use-pnp-irq-if-its-valid.patch
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
