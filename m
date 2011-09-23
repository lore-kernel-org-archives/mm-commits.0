From: akpm@google.com
Subject: [merged] scsi-qla4xxx-needs-libiscsio.patch removed from -mm tree
Date: Fri, 23 Sep 2011 13:12:00 -0700
Message-ID: <201109232012.p8NKC12b027675@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:49812 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab1IWUMH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Sep 2011 16:12:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: qla4xxx needs libiscsi.o
has been removed from the -mm tree.  Its filename was
     scsi-qla4xxx-needs-libiscsio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: scsi: qla4xxx needs libiscsi.o

qla4xxx driver needs to be linked with libiscsi.o to fix build errors. 
This happens when no other drivers that use libiscsi.o are enabled.

Found in linux-next but applies to mainline also.

ERROR: "iscsi_conn_stop" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_get_addr_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_teardown" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_host_alloc" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_start" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_send_pdu" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_get_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_get_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_set_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_failure" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_complete_pdu" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_setup" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_bind" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_setup" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_itt_to_task" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/Makefile~scsi-qla4xxx-needs-libiscsio drivers/scsi/Makefile
--- a/drivers/scsi/Makefile~scsi-qla4xxx-needs-libiscsio
+++ a/drivers/scsi/Makefile
@@ -88,7 +88,7 @@ obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicf
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogicfas408.o
 obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o 
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
-obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
+obj-$(CONFIG_SCSI_QLA_ISCSI)	+= libiscsi.o qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
 obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
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

