From: akpm@linux-foundation.org
Subject: - pata-i-do-not-think-it-means-what-you-think-it-means.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:21:39 -0800
Message-ID: <200803062221.m26MLdxt020735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758160AbYCFWjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:39:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, bzolnier@gmail.com, jeff@garzik.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pata: "I do not think it means, what you think it means."
has been removed from the -mm tree.  Its filename was
     pata-i-do-not-think-it-means-what-you-think-it-means.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata: "I do not think it means, what you think it means."
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

When masking mask out the modes that are unsupported not the ones that are
supported.  This makes life happier.

Bart says: "This patch fixes data corruption for libata PATA ServerWorks and
HPT drivers".

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_hpt366.c      |    6 +++---
 drivers/ata/pata_hpt37x.c      |    6 +++---
 drivers/ata/pata_serverworks.c |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/ata/pata_hpt366.c~pata-i-do-not-think-it-means-what-you-think-it-means drivers/ata/pata_hpt366.c
--- a/drivers/ata/pata_hpt366.c~pata-i-do-not-think-it-means-what-you-think-it-means
+++ a/drivers/ata/pata_hpt366.c
@@ -27,7 +27,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt366"
-#define DRV_VERSION	"0.6.1"
+#define DRV_VERSION	"0.6.2"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -180,9 +180,9 @@ static unsigned long hpt366_filter(struc
 		if (hpt_dma_blacklisted(adev, "UDMA",  bad_ata33))
 			mask &= ~ATA_MASK_UDMA;
 		if (hpt_dma_blacklisted(adev, "UDMA3", bad_ata66_3))
-			mask &= ~(0x07 << ATA_SHIFT_UDMA);
+			mask &= ~(0xF8 << ATA_SHIFT_UDMA);
 		if (hpt_dma_blacklisted(adev, "UDMA4", bad_ata66_4))
-			mask &= ~(0x0F << ATA_SHIFT_UDMA);
+			mask &= ~(0xF0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }
diff -puN drivers/ata/pata_hpt37x.c~pata-i-do-not-think-it-means-what-you-think-it-means drivers/ata/pata_hpt37x.c
--- a/drivers/ata/pata_hpt37x.c~pata-i-do-not-think-it-means-what-you-think-it-means
+++ a/drivers/ata/pata_hpt37x.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.9"
+#define DRV_VERSION	"0.6.11"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -281,7 +281,7 @@ static unsigned long hpt370_filter(struc
 		if (hpt_dma_blacklisted(adev, "UDMA", bad_ata33))
 			mask &= ~ATA_MASK_UDMA;
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
-			mask &= ~(0x1F << ATA_SHIFT_UDMA);
+			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }
@@ -297,7 +297,7 @@ static unsigned long hpt370a_filter(stru
 {
 	if (adev->class == ATA_DEV_ATA) {
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
-			mask &= ~ (0x1F << ATA_SHIFT_UDMA);
+			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }
diff -puN drivers/ata/pata_serverworks.c~pata-i-do-not-think-it-means-what-you-think-it-means drivers/ata/pata_serverworks.c
--- a/drivers/ata/pata_serverworks.c~pata-i-do-not-think-it-means-what-you-think-it-means
+++ a/drivers/ata/pata_serverworks.c
@@ -226,7 +226,7 @@ static unsigned long serverworks_csb_fil
 
 	for (i = 0; (p = csb_bad_ata100[i]) != NULL; i++) {
 		if (!strcmp(p, model_num))
-			mask &= ~(0x1F << ATA_SHIFT_UDMA);
+			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
libata-isolate-and-rework-cable-logic.patch
pata_amd-fix-sparse-warning.patch
drivers-net-8390c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
nozomi-prepare-for-bkl-pushdown.patch
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
put_pid-make-sure-we-dont-free-the-live-pid.patch

