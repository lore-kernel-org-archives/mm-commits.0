From: akpm@linux-foundation.org
Subject: - drivers-scsi-qla4xxx-possible-cleanups.patch removed from -mm tree
Date: Sun, 06 May 2007 23:52:07 -0700
Message-ID: <200705070652.l476q7R6020604@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102AbXEGGw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ravi.anand@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/qla4xxx/: possible cleanups
has been removed from the -mm tree.  Its filename was
     drivers-scsi-qla4xxx-possible-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/qla4xxx/: possible cleanups
From: Adrian Bunk <bunk@stusta.de>

- make needlessly global code static
- #if 0 unused functions

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla4xxx/ql4_dbg.c  |    4 ++++
 drivers/scsi/qla4xxx/ql4_glbl.h |    9 ---------
 drivers/scsi/qla4xxx/ql4_init.c |   18 +++++++++---------
 drivers/scsi/qla4xxx/ql4_iocb.c |   18 +++++++++---------
 drivers/scsi/qla4xxx/ql4_mbx.c  |   19 ++++++++++++++-----
 drivers/scsi/qla4xxx/ql4_os.c   |    9 ++++-----
 6 files changed, 40 insertions(+), 37 deletions(-)

diff -puN drivers/scsi/qla4xxx/ql4_dbg.c~drivers-scsi-qla4xxx-possible-cleanups drivers/scsi/qla4xxx/ql4_dbg.c
--- a/drivers/scsi/qla4xxx/ql4_dbg.c~drivers-scsi-qla4xxx-possible-cleanups
+++ a/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -8,6 +8,8 @@
 #include "ql4_def.h"
 #include <scsi/scsi_dbg.h>
 
+#if 0
+
 static void qla4xxx_print_srb_info(struct srb * srb)
 {
 	printk("%s: srb = 0x%p, flags=0x%02x\n", __func__, srb, srb->flags);
@@ -195,3 +197,5 @@ void qla4xxx_dump_buffer(void *b, uint32
 	if (cnt % 16)
 		printk(KERN_DEBUG "\n");
 }
+
+#endif  /*  0  */
diff -puN drivers/scsi/qla4xxx/ql4_glbl.h~drivers-scsi-qla4xxx-possible-cleanups drivers/scsi/qla4xxx/ql4_glbl.h
--- a/drivers/scsi/qla4xxx/ql4_glbl.h~drivers-scsi-qla4xxx-possible-cleanups
+++ a/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -43,8 +43,6 @@ int qla4xxx_get_fwddb_entry(struct scsi_
 			    uint16_t *tcp_source_port_num,
 			    uint16_t *connection_id);
 
-struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host * ha,
-				     uint32_t fw_ddb_index);
 int qla4xxx_set_ddb_entry(struct scsi_qla_host * ha, uint16_t fw_ddb_index,
 			  dma_addr_t fw_ddb_entry_dma);
 
@@ -55,18 +53,11 @@ void qla4xxx_get_crash_record(struct scs
 struct ddb_entry *qla4xxx_alloc_sess(struct scsi_qla_host *ha);
 int qla4xxx_add_sess(struct ddb_entry *);
 void qla4xxx_destroy_sess(struct ddb_entry *ddb_entry);
-int qla4xxx_conn_close_sess_logout(struct scsi_qla_host * ha,
-				   uint16_t fw_ddb_index,
-				   uint16_t connection_id,
-				   uint16_t option);
-int qla4xxx_clear_database_entry(struct scsi_qla_host * ha,
-				 uint16_t fw_ddb_index);
 int qla4xxx_is_nvram_configuration_valid(struct scsi_qla_host * ha);
 int qla4xxx_get_fw_version(struct scsi_qla_host * ha);
 void qla4xxx_interrupt_service_routine(struct scsi_qla_host * ha,
 				       uint32_t intr_status);
 int qla4xxx_init_rings(struct scsi_qla_host * ha);
-void qla4xxx_dump_buffer(void *b, uint32_t size);
 struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha, uint32_t index);
 void qla4xxx_srb_compl(struct scsi_qla_host *ha, struct srb *srb);
 int qla4xxx_reinitialize_ddb_list(struct scsi_qla_host * ha);
diff -puN drivers/scsi/qla4xxx/ql4_init.c~drivers-scsi-qla4xxx-possible-cleanups drivers/scsi/qla4xxx/ql4_init.c
--- a/drivers/scsi/qla4xxx/ql4_init.c~drivers-scsi-qla4xxx-possible-cleanups
+++ a/drivers/scsi/qla4xxx/ql4_init.c
@@ -7,9 +7,8 @@
 
 #include "ql4_def.h"
 
-/*
- * QLogic ISP4xxx Hardware Support Function Prototypes.
- */
+static struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host *ha,
+					    uint32_t fw_ddb_index);
 
 static void ql4xxx_set_mac_number(struct scsi_qla_host *ha)
 {
@@ -48,7 +47,8 @@ static void ql4xxx_set_mac_number(struct
  * This routine deallocates and unlinks the specified ddb_entry from the
  * adapter's
  **/
-void qla4xxx_free_ddb(struct scsi_qla_host *ha, struct ddb_entry *ddb_entry)
+static void qla4xxx_free_ddb(struct scsi_qla_host *ha,
+			     struct ddb_entry *ddb_entry)
 {
 	/* Remove device entry from list */
 	list_del_init(&ddb_entry->list);
@@ -370,9 +370,9 @@ static struct ddb_entry* qla4xxx_get_ddb
  * must be initialized prior to	calling this routine
  *
  **/
-int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
-			     struct ddb_entry *ddb_entry,
-			     uint32_t fw_ddb_index)
+static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
+				    struct ddb_entry *ddb_entry,
+				    uint32_t fw_ddb_index)
 {
 	struct dev_db_entry *fw_ddb_entry = NULL;
 	dma_addr_t fw_ddb_entry_dma;
@@ -450,8 +450,8 @@ int qla4xxx_update_ddb_entry(struct scsi
  * This routine allocates a ddb_entry, ititializes some values, and
  * inserts it into the ddb list.
  **/
-struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host *ha,
-				     uint32_t fw_ddb_index)
+static struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host *ha,
+					    uint32_t fw_ddb_index)
 {
 	struct ddb_entry *ddb_entry;
 
diff -puN drivers/scsi/qla4xxx/ql4_iocb.c~drivers-scsi-qla4xxx-possible-cleanups drivers/scsi/qla4xxx/ql4_iocb.c
--- a/drivers/scsi/qla4xxx/ql4_iocb.c~drivers-scsi-qla4xxx-possible-cleanups
+++ a/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -19,8 +19,8 @@
  *	- advances the request_in pointer
  *	- checks for queue full
  **/
-int qla4xxx_get_req_pkt(struct scsi_qla_host *ha,
-			struct queue_entry **queue_entry)
+static int qla4xxx_get_req_pkt(struct scsi_qla_host *ha,
+			       struct queue_entry **queue_entry)
 {
 	uint16_t request_in;
 	uint8_t status = QLA_SUCCESS;
@@ -62,8 +62,8 @@ int qla4xxx_get_req_pkt(struct scsi_qla_
  *
  * This routine issues a marker IOCB.
  **/
-int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
-			     struct ddb_entry *ddb_entry, int lun)
+static int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
+				    struct ddb_entry *ddb_entry, int lun)
 {
 	struct marker_entry *marker_entry;
 	unsigned long flags = 0;
@@ -96,7 +96,7 @@ exit_send_marker:
 	return status;
 }
 
-struct continuation_t1_entry* qla4xxx_alloc_cont_entry(
+static struct continuation_t1_entry* qla4xxx_alloc_cont_entry(
 	struct scsi_qla_host *ha)
 {
 	struct continuation_t1_entry *cont_entry;
@@ -120,7 +120,7 @@ struct continuation_t1_entry* qla4xxx_al
 	return cont_entry;
 }
 
-uint16_t qla4xxx_calc_request_entries(uint16_t dsds)
+static uint16_t qla4xxx_calc_request_entries(uint16_t dsds)
 {
 	uint16_t iocbs;
 
@@ -133,9 +133,9 @@ uint16_t qla4xxx_calc_request_entries(ui
 	return iocbs;
 }
 
-void qla4xxx_build_scsi_iocbs(struct srb *srb,
-			      struct command_t3_entry *cmd_entry,
-			      uint16_t tot_dsds)
+static void qla4xxx_build_scsi_iocbs(struct srb *srb,
+				     struct command_t3_entry *cmd_entry,
+				     uint16_t tot_dsds)
 {
 	struct scsi_qla_host *ha;
 	uint16_t avail_dsds;
diff -puN drivers/scsi/qla4xxx/ql4_mbx.c~drivers-scsi-qla4xxx-possible-cleanups drivers/scsi/qla4xxx/ql4_mbx.c
--- a/drivers/scsi/qla4xxx/ql4_mbx.c~drivers-scsi-qla4xxx-possible-cleanups
+++ a/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -20,9 +20,9 @@
  * If outCount is 0, this routine completes successfully WITHOUT waiting
  * for the mailbox command to complete.
  **/
-int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
-			    uint8_t outCount, uint32_t *mbx_cmd,
-			    uint32_t *mbx_sts)
+static int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
+				   uint8_t outCount, uint32_t *mbx_cmd,
+				   uint32_t *mbx_sts)
 {
 	int status = QLA_ERROR;
 	uint8_t i;
@@ -170,6 +170,8 @@ mbox_exit:
 }
 
 
+#if 0
+
 /**
  * qla4xxx_issue_iocb - issue mailbox iocb command
  * @ha: adapter state pointer.
@@ -243,6 +245,8 @@ int qla4xxx_clear_database_entry(struct 
 	return QLA_SUCCESS;
 }
 
+#endif  /*  0  */
+
 /**
  * qla4xxx_initialize_fw_cb - initializes firmware control block.
  * @ha: Pointer to host adapter structure.
@@ -570,6 +574,7 @@ int qla4xxx_set_ddb_entry(struct scsi_ql
 	return qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]);
 }
 
+#if 0
 int qla4xxx_conn_open_session_login(struct scsi_qla_host * ha,
 				    uint16_t fw_ddb_index)
 {
@@ -594,6 +599,7 @@ int qla4xxx_conn_open_session_login(stru
 
 		return status;
 }
+#endif  /*  0  */
 
 /**
  * qla4xxx_get_crash_record - retrieves crash record.
@@ -649,6 +655,7 @@ exit_get_crash_record:
 				  crash_record, crash_record_dma);
 }
 
+#if 0
 /**
  * qla4xxx_get_conn_event_log - retrieves connection event log
  * @ha: Pointer to host adapter structure.
@@ -738,6 +745,7 @@ exit_get_event_log:
 		dma_free_coherent(&ha->pdev->dev, event_log_size, event_log,
 				  event_log_dma);
 }
+#endif  /*  0  */
 
 /**
  * qla4xxx_reset_lun - issues LUN Reset
@@ -834,7 +842,8 @@ int qla4xxx_get_fw_version(struct scsi_q
 	return QLA_SUCCESS;
 }
 
-int qla4xxx_get_default_ddb(struct scsi_qla_host *ha, dma_addr_t dma_addr)
+static int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
+				   dma_addr_t dma_addr)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
@@ -855,7 +864,7 @@ int qla4xxx_get_default_ddb(struct scsi_
 	return QLA_SUCCESS;
 }
 
-int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t *ddb_index)
+static int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t *ddb_index)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
diff -puN drivers/scsi/qla4xxx/ql4_os.c~drivers-scsi-qla4xxx-possible-cleanups drivers/scsi/qla4xxx/ql4_os.c
--- a/drivers/scsi/qla4xxx/ql4_os.c~drivers-scsi-qla4xxx-possible-cleanups
+++ a/drivers/scsi/qla4xxx/ql4_os.c
@@ -14,7 +14,7 @@
 /*
  * Driver version
  */
-char qla4xxx_version_str[40];
+static char qla4xxx_version_str[40];
 
 /*
  * SRB allocation cache
@@ -45,8 +45,7 @@ int ql4_mod_unload = 0;
 /*
  * SCSI host template entry points
  */
-
-void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha);
+static void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha);
 
 /*
  * iSCSI template entry points
@@ -1352,7 +1351,7 @@ static void __devexit qla4xxx_remove_ada
  * At exit, the @ha's flags.enable_64bit_addressing set to indicated
  * supported addressing method.
  */
-void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha)
+static void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha)
 {
 	int retval;
 
@@ -1627,7 +1626,7 @@ static struct pci_device_id qla4xxx_pci_
 };
 MODULE_DEVICE_TABLE(pci, qla4xxx_pci_tbl);
 
-struct pci_driver qla4xxx_pci_driver = {
+static struct pci_driver qla4xxx_pci_driver = {
 	.name		= DRIVER_NAME,
 	.id_table	= qla4xxx_pci_tbl,
 	.probe		= qla4xxx_probe_adapter,
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
git-acpi.patch
git-alsa.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
ibmtr_cs-fix-hang-on-eject.patch
git-r8169.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
apple-smc-driver-hardware-monitoring-and-control-cleanup.patch
the-scheduled-removal-of-obsolete_oss-options.patch
add-file-position-info-to-proc.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
rtc-remove-sys-class-rtc-dev-fix.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
compiler-introduce-__used-and-__maybe_unused.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
drivers-video-sis-remove-more-kernel-24-code.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
