From: akpm@linux-foundation.org
Subject: - drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:23 -0700
Message-ID: <200708201913.l7KJDN4e018436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33823 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758022AbXHTTVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, James.Smart@Emulex.Com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/lpfc/lpfc_debugfs.c: kmalloc + memset conversion to kcalloc
has been removed from the -mm tree.  Its filename was
     drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/lpfc/lpfc_debugfs.c: kmalloc + memset conversion to kcalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_debugfs.c | 13809 -> 13716 (-93 bytes)
 drivers/scsi/lpfc/lpfc_debugfs.o | 146124 -> 146124 (0 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: James Smart <James.Smart@Emulex.Com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_debugfs.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_debugfs.c~drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c~drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc
+++ a/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -901,7 +901,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 		}
 	}
 
-	vport->disc_trc = kmalloc(
+	vport->disc_trc = kzalloc(
 		(sizeof(struct lpfc_debugfs_trc) * lpfc_debugfs_max_disc_trc),
 		GFP_KERNEL);
 
@@ -912,8 +912,6 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 		goto debug_failed;
 	}
 	atomic_set(&vport->disc_trc_cnt, 0);
-	memset(vport->disc_trc, 0,
-		(sizeof(struct lpfc_debugfs_trc) * lpfc_debugfs_max_disc_trc));
 
 	snprintf(name, sizeof(name), "discovery_trace");
 	vport->debug_disc_trc =
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
git-scsi-misc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
