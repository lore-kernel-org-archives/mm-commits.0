From: akpm@google.com
Subject: [merged] scsi-fix-qla2xxx-printk-format-warning.patch removed from -mm tree
Date: Mon, 26 Sep 2011 12:21:59 -0700
Message-ID: <201109261922.p8QJM0Fa023478@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:38319 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab1IZTWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2011 15:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, James.Bottomley@HansenPartnership.com, andrew.vasquez@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: fix qla2xxx printk format warning
has been removed from the -mm tree.  Its filename was
     scsi-fix-qla2xxx-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: scsi: fix qla2xxx printk format warning

sector_t can be different types, so cast it to its largest
possible type.

drivers/scsi/qla2xxx/qla_isr.c:1509:5: warning: format '%lx' expects type 'long unsigned int', but argument 5 has type 'sector_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_isr.c~scsi-fix-qla2xxx-printk-format-warning drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c~scsi-fix-qla2xxx-printk-format-warning
+++ a/drivers/scsi/qla2xxx/qla_isr.c
@@ -1507,8 +1507,8 @@ qla2x00_handle_dif_error(srb_t *sp, stru
 
 			if (k != blocks_done) {
 				qla_printk(KERN_WARNING, sp->fcport->vha->hw,
-				    "unexpected tag values tag:lba=%x:%lx)\n",
-				    e_ref_tag, lba_s);
+				    "unexpected tag values tag:lba=%x:%llx)\n",
+				    e_ref_tag, (unsigned long long)lba_s);
 				return 1;
 			}
 
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
drm-fix-kconfig-unmet-dependency-warning.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
cross-memory-attach-update.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
dynamic_debug-fix-undefined-reference-to-__netdev_printk.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

