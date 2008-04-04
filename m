From: akpm@linux-foundation.org
Subject: - libata-isolate-and-rework-cable-logic.patch removed from -mm tree
Date: Fri, 04 Apr 2008 12:00:21 -0700
Message-ID: <200804041900.m34J0LcW004263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759439AbYDDTAj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:00:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata: isolate and rework cable logic
has been removed from the -mm tree.  Its filename was
     libata-isolate-and-rework-cable-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata: isolate and rework cable logic
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   48 +++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 4 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-isolate-and-rework-cable-logic drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-isolate-and-rework-cable-logic
+++ a/drivers/ata/libata-core.c
@@ -4536,6 +4536,49 @@ static int ata_is_40wire(struct ata_devi
 }
 
 /**
+ *	cable_is_40wire		-	40/80/SATA decider
+ *	@ap: port to consider
+ *
+ *	This function encapsulates the policy for speed management
+ *	in one place. At the moment we don't cache the result but
+ *	there is a good case for setting ap->cbl to the result when
+ *	we are called with unknown cables (and figuring out if it
+ *	impacts hotplug at all).
+ *
+ *	Return 1 if the cable appears to be 40 wire.
+ */
+
+static int cable_is_40wire(struct ata_port *ap)
+{
+	struct ata_link *link;
+	struct ata_device *dev;
+
+	/* If the controller thinks we are 40 wire, we are */
+	if (ap->cbl == ATA_CBL_PATA40)
+		return 1;
+	/* If the controller thinks we are 80 wire, we are */
+	if (ap->cbl == ATA_CBL_PATA80 || ap->cbl == ATA_CBL_SATA)
+		return 0;
+	/* If the controller doesn't know we scan
+
+	   - Note: We look for all 40 wire detects at this point.
+	     Any 80 wire detect is taken to be 80 wire cable
+	     because
+	     - In many setups only the one drive (slave if present)
+               will give a valid detect
+             - If you have a non detect capable drive you don't
+               want it to colour the choice
+        */
+	ata_port_for_each_link(link, ap) {
+		ata_link_for_each_dev(dev, link) {
+			if (!ata_is_40wire(dev))
+				return 0;
+		}
+	}
+	return 1;
+}
+
+/**
  *	ata_dev_xfermask - Compute supported xfermask of the given device
  *	@dev: Device to compute xfermask for
  *
@@ -4603,10 +4646,7 @@ static void ata_dev_xfermask(struct ata_
 	 */
 	if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
 		/* UDMA/44 or higher would be available */
-		if ((ap->cbl == ATA_CBL_PATA40) ||
-		    (ata_is_40wire(dev) &&
-		    (ap->cbl == ATA_CBL_PATA_UNK ||
-		     ap->cbl == ATA_CBL_PATA80))) {
+		if (cable_is_40wire(ap)) {
 			ata_dev_printk(dev, KERN_WARNING,
 				 "limited to UDMA/33 due to 40-wire cable\n");
 			xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-libata-all.patch
pata_atiixp-simplex-clear.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
parisc-new-termios-definitions.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
serial-8250-tighten-test-for-using-backup-timer.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch
sxc-fix-printk-warnings-on-sparc32.patch
istallion-tiocg-ssoftcar-handling-removal.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

