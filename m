From: akpm@osdl.org
Subject: - make-qla2x00_reg_remote_port-static.patch removed from -mm tree
Date: Thu, 04 Jan 2007 15:43:14 -0800
Message-ID: <200701042343.l04NhEMk002884@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37073 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030287AbXADXqi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:46:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, andrew.vasquez@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     make qla2x00_reg_remote_port() static
has been removed from the -mm tree.  Its filename was
     make-qla2x00_reg_remote_port-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make qla2x00_reg_remote_port() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/qla2xxx/qla_gbl.h  |    1 
 drivers/scsi/qla2xxx/qla_init.c |   68 +++++++++++++++---------------
 2 files changed, 34 insertions(+), 35 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_gbl.h~make-qla2x00_reg_remote_port-static drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h~make-qla2x00_reg_remote_port-static
+++ a/drivers/scsi/qla2xxx/qla_gbl.h
@@ -45,7 +45,6 @@ extern void qla2x00_update_fcports(scsi_
 extern int qla2x00_abort_isp(scsi_qla_host_t *);
 
 extern void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
-extern void qla2x00_reg_remote_port(scsi_qla_host_t *, fc_port_t *);
 
 extern void qla2x00_alloc_fw_dump(scsi_qla_host_t *);
 extern void qla2x00_try_to_stop_firmware(scsi_qla_host_t *);
diff -puN drivers/scsi/qla2xxx/qla_init.c~make-qla2x00_reg_remote_port-static drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c~make-qla2x00_reg_remote_port-static
+++ a/drivers/scsi/qla2xxx/qla_init.c
@@ -2103,40 +2103,7 @@ qla2x00_iidma_fcport(scsi_qla_host_t *ha
 	}
 }
 
-/*
- * qla2x00_update_fcport
- *	Updates device on list.
- *
- * Input:
- *	ha = adapter block pointer.
- *	fcport = port structure pointer.
- *
- * Return:
- *	0  - Success
- *  BIT_0 - error
- *
- * Context:
- *	Kernel context.
- */
-void
-qla2x00_update_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
-{
-	fcport->ha = ha;
-	fcport->login_retry = 0;
-	fcport->port_login_retry_count = ha->port_down_retry_count *
-	    PORT_RETRY_TIME;
-	atomic_set(&fcport->port_down_timer, ha->port_down_retry_count *
-	    PORT_RETRY_TIME);
-	fcport->flags &= ~FCF_LOGIN_NEEDED;
-
-	qla2x00_iidma_fcport(ha, fcport);
-
-	atomic_set(&fcport->state, FCS_ONLINE);
-
-	qla2x00_reg_remote_port(ha, fcport);
-}
-
-void
+static void
 qla2x00_reg_remote_port(scsi_qla_host_t *ha, fc_port_t *fcport)
 {
 	struct fc_rport_identifiers rport_ids;
@@ -2179,6 +2146,39 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 }
 
 /*
+ * qla2x00_update_fcport
+ *	Updates device on list.
+ *
+ * Input:
+ *	ha = adapter block pointer.
+ *	fcport = port structure pointer.
+ *
+ * Return:
+ *	0  - Success
+ *  BIT_0 - error
+ *
+ * Context:
+ *	Kernel context.
+ */
+void
+qla2x00_update_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
+{
+	fcport->ha = ha;
+	fcport->login_retry = 0;
+	fcport->port_login_retry_count = ha->port_down_retry_count *
+	    PORT_RETRY_TIME;
+	atomic_set(&fcport->port_down_timer, ha->port_down_retry_count *
+	    PORT_RETRY_TIME);
+	fcport->flags &= ~FCF_LOGIN_NEEDED;
+
+	qla2x00_iidma_fcport(ha, fcport);
+
+	atomic_set(&fcport->state, FCS_ONLINE);
+
+	qla2x00_reg_remote_port(ha, fcport);
+}
+
+/*
  * qla2x00_configure_fabric
  *      Setup SNS devices with loop ID's.
  *
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
make-usbvision_rvfree-static.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-mtd.patch
drivers-mtd-ubi-vtblc-make-2-functions-static.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
git-scsi-rc-fixes.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
arch-i386-kernel-cpu-mcheck-mcec-should-include-asm-mceh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
