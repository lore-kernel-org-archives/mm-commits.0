From: akpm@linux-foundation.org
Subject: + scsi-qla4xxx-needs-libiscsio.patch added to -mm tree
Date: Wed, 31 Aug 2011 15:51:24 -0700
Message-ID: <201108312251.p7VMpO5l032176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757022Ab1HaWwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Aug 2011 18:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: qla4xxx needs libiscsi.o
has been added to the -mm tree.  Its filename is
     scsi-qla4xxx-needs-libiscsio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: qla4xxx needs libiscsi.o
From: Randy Dunlap <rdunlap@xenotime.net>

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

numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
linux-next.patch
drm-fix-kconfig-unmet-dependency-warning.patch
scsi-qla4xxx-needs-libiscsio.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
cross-memory-attach-update.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

