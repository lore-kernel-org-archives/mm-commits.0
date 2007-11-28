From: akpm@linux-foundation.org
Subject: + revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d.patch added to -mm tree
Date: Wed, 28 Nov 2007 15:33:38 -0800
Message-ID: <200711282333.lASNXcBw024670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756524AbXK1Xdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Nov 2007 18:33:42 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id lASNXd16021462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2007 15:33:40 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     a
has been added to the -mm tree.  Its filename is
     revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: a
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi.c        |   20 +++-----------------
 drivers/scsi/scsi_error.c  |    1 +
 drivers/scsi/scsi_lib.c    |   14 ++++++++++++++
 drivers/scsi/scsi_priv.h   |    1 -
 drivers/scsi/sd.c          |   28 ++++++++++------------------
 drivers/scsi/sr.c          |   21 +++++++++++++++------
 include/scsi/scsi_cmnd.h   |    2 ++
 include/scsi/scsi_driver.h |    1 -
 include/scsi/sd.h          |   13 +++++++++++++
 9 files changed, 58 insertions(+), 43 deletions(-)

diff -puN drivers/scsi/scsi.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
+++ a/drivers/scsi/scsi.c
@@ -59,7 +59,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
@@ -379,8 +378,9 @@ void scsi_log_send(struct scsi_cmnd *cmd
 			scsi_print_command(cmd);
 			if (level > 3) {
 				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
-				       " queuecommand 0x%p\n",
+				       " done = 0x%p, queuecommand 0x%p\n",
 					scsi_sglist(cmd), scsi_bufflen(cmd),
+					cmd->done,
 					cmd->device->host->hostt->queuecommand);
 
 			}
@@ -667,12 +667,6 @@ void __scsi_done(struct scsi_cmnd *cmd)
 	blk_complete_request(rq);
 }
 
-/* Move this to a header if it becomes more generally useful */
-static struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
-{
-	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
-}
-
 /**
  * scsi_finish_command - cleanup and pass command back to upper layer
  * @cmd: the command
@@ -685,8 +679,6 @@ void scsi_finish_command(struct scsi_cmn
 {
 	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
-	struct scsi_driver *drv;
-	unsigned int good_bytes;
 
 	scsi_device_unbusy(sdev);
 
@@ -712,13 +704,7 @@ void scsi_finish_command(struct scsi_cmn
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
-	good_bytes = scsi_bufflen(cmd);
-        if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
-		drv = scsi_cmd_to_driver(cmd);
-		if (drv->done)
-			good_bytes = drv->done(cmd);
-	}
-	scsi_io_completion(cmd, good_bytes);
+	cmd->done(cmd);
 }
 EXPORT_SYMBOL(scsi_finish_command);
 
diff -puN drivers/scsi/scsi_error.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
+++ a/drivers/scsi/scsi_error.c
@@ -1697,6 +1697,7 @@ scsi_reset_provider(struct scsi_device *
     
 	scmd->scsi_done		= scsi_reset_provider_done_command;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
+	scmd->done			= NULL;
 
 	scmd->cmd_len			= 0;
 
diff -puN drivers/scsi/scsi_lib.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
+++ a/drivers/scsi/scsi_lib.c
@@ -944,6 +944,7 @@ void scsi_end_bidi_request(struct scsi_c
 
 	scsi_finalize_request(cmd, 1);
 }
+EXPORT_SYMBOL(scsi_io_completion);
 
 /*
  * Function:    scsi_io_completion()
@@ -1238,6 +1239,18 @@ static struct scsi_cmnd *scsi_get_cmd_fr
 	return cmd;
 }
 
+static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
+{
+	BUG_ON(!blk_pc_request(cmd->request));
+	/*
+	 * This will complete the whole command with uptodate=1 so
+	 * as far as the block layer is concerned the command completed
+	 * successfully. Since this is a REQ_BLOCK_PC command the
+	 * caller should check the request's errors value
+	 */
+	scsi_io_completion(cmd, cmd->request_bufflen);
+}
+
 int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd;
@@ -1285,6 +1298,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
 	cmd->transfersize = req->data_len;
 	cmd->allowed = req->retries;
 	cmd->timeout_per_command = req->timeout;
+	cmd->done = scsi_blk_pc_done;
 	return BLKPREP_OK;
 }
 EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
diff -puN drivers/scsi/scsi_priv.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
+++ a/drivers/scsi/scsi_priv.h
@@ -68,7 +68,6 @@ extern int scsi_maybe_unblock_host(struc
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
-extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
 extern void scsi_free_queue(struct request_queue *q);
diff -puN drivers/scsi/sd.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
+++ a/drivers/scsi/sd.c
@@ -86,19 +86,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 
-static int  sd_revalidate_disk(struct gendisk *);
-static int  sd_probe(struct device *);
-static int  sd_remove(struct device *);
-static void sd_shutdown(struct device *);
-static int sd_suspend(struct device *, pm_message_t state);
-static int sd_resume(struct device *);
-static void sd_rescan(struct device *);
-static int sd_done(struct scsi_cmnd *);
-static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
-static void scsi_disk_release(struct class_device *cdev);
-static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
-static void sd_print_result(struct scsi_disk *, int);
-
 static DEFINE_IDR(sd_index_idr);
 static DEFINE_SPINLOCK(sd_index_lock);
 
@@ -253,7 +240,6 @@ static struct scsi_driver sd_template = 
 		.shutdown	= sd_shutdown,
 	},
 	.rescan			= sd_rescan,
-	.done			= sd_done,
 };
 
 /*
@@ -520,6 +506,12 @@ static int sd_prep_fn(struct request_que
 	SCpnt->timeout_per_command = timeout;
 
 	/*
+	 * This is the completion routine we use.  This is matched in terms
+	 * of capability to this function.
+	 */
+	SCpnt->done = sd_rw_intr;
+
+	/*
 	 * This indicates that the command is ready from our end to be
 	 * queued.
 	 */
@@ -898,13 +890,13 @@ static struct block_device_operations sd
 };
 
 /**
- *	sd_done - bottom half handler: called when the lower level
+ *	sd_rw_intr - bottom half handler: called when the lower level
  *	driver has completed (successfully or otherwise) a scsi command.
  *	@SCpnt: mid-level's per command structure.
  *
  *	Note: potentially run from within an ISR. Must not block.
  **/
-static int sd_done(struct scsi_cmnd *SCpnt)
+static void sd_rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
 	unsigned int xfer_size = scsi_bufflen(SCpnt);
@@ -925,7 +917,7 @@ static int sd_done(struct scsi_cmnd *SCp
 	SCSI_LOG_HLCOMPLETE(1, scsi_print_result(SCpnt));
 	if (sense_valid) {
 		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
-						   "sd_done: sb[respc,sk,asc,"
+						   "sd_rw_intr: sb[respc,sk,asc,"
 						   "ascq]=%x,%x,%x,%x\n",
 						   sshdr.response_code,
 						   sshdr.sense_key, sshdr.asc,
@@ -997,7 +989,7 @@ static int sd_done(struct scsi_cmnd *SCp
 		break;
 	}
  out:
-	return good_bytes;
+	scsi_io_completion(SCpnt, good_bytes);
 }
 
 static int media_not_present(struct scsi_disk *sdkp,
diff -puN drivers/scsi/sr.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
+++ a/drivers/scsi/sr.c
@@ -78,7 +78,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
-static int sr_done(struct scsi_cmnd *);
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -87,7 +86,6 @@ static struct scsi_driver sr_template = 
 		.probe		= sr_probe,
 		.remove		= sr_remove,
 	},
-	.done			= sr_done,
 };
 
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
@@ -221,12 +219,12 @@ out:
 }
  
 /*
- * sr_done is the interrupt routine for the device driver.
+ * rw_intr is the interrupt routine for the device driver.
  *
- * It will be notified on the end of a SCSI read / write, and will take one
+ * It will be notified on the end of a SCSI read / write, and will take on
  * of several actions based on success or failure.
  */
-static int sr_done(struct scsi_cmnd *SCpnt)
+static void rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
 	int this_count = scsi_bufflen(SCpnt);
@@ -299,7 +297,12 @@ static int sr_done(struct scsi_cmnd *SCp
 		}
 	}
 
-	return good_bytes;
+	/*
+	 * This calls the generic completion function, now that we know
+	 * how many actual sectors finished, and how many sectors we need
+	 * to say have failed.
+	 */
+	scsi_io_completion(SCpnt, good_bytes);
 }
 
 static int sr_prep_fn(struct request_queue *q, struct request *rq)
@@ -434,6 +437,12 @@ static int sr_prep_fn(struct request_que
 	SCpnt->timeout_per_command = timeout;
 
 	/*
+	 * This is the completion routine we use.  This is matched in terms
+	 * of capability to this function.
+	 */
+	SCpnt->done = rw_intr;
+
+	/*
 	 * This indicates that the command is ready from our end to be
 	 * queued.
 	 */
diff -puN include/scsi/scsi_cmnd.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
+++ a/include/scsi/scsi_cmnd.h
@@ -41,6 +41,7 @@ struct scsi_cmnd {
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 	struct list_head eh_entry; /* entry for the host eh_cmd_q */
 	int eh_eflags;		/* Used by error handlr */
+	void (*done) (struct scsi_cmnd *);	/* Mid-level done function */
 
 	/*
 	 * A SCSI Command is assigned a nonzero serial_number before passed
@@ -121,6 +122,7 @@ extern struct scsi_cmnd *__scsi_get_comm
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
 			       struct device *);
+extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
 
diff -puN include/scsi/scsi_driver.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d include/scsi/scsi_driver.h
--- a/include/scsi/scsi_driver.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
+++ a/include/scsi/scsi_driver.h
@@ -15,7 +15,6 @@ struct scsi_driver {
 	struct device_driver	gendrv;
 
 	void (*rescan)(struct device *);
-	int (*done)(struct scsi_cmnd *);
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
diff -puN include/scsi/sd.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d include/scsi/sd.h
--- a/include/scsi/sd.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
+++ a/include/scsi/sd.h
@@ -48,6 +48,19 @@ struct scsi_disk {
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,cdev)
 
+static int  sd_revalidate_disk(struct gendisk *disk);
+static void sd_rw_intr(struct scsi_cmnd * SCpnt);
+static int  sd_probe(struct device *);
+static int  sd_remove(struct device *);
+static void sd_shutdown(struct device *dev);
+static int sd_suspend(struct device *dev, pm_message_t state);
+static int sd_resume(struct device *dev);
+static void sd_rescan(struct device *);
+static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
+static void scsi_disk_release(struct class_device *cdev);
+static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
+static void sd_print_result(struct scsi_disk *, int);
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
file-capabilities-allow-sigcont-within-session-v2.patch
pnp-increase-the-maximum-number-of-resources-fix.patch
fix-linux-kdh-usage-in-userspace-checkpatch-fixes.patch
imacfb-remove-reference-to-otherwise-unused-non-existent-screen_infoimacpm_seg.patch
revert-keyspan-init-termios-properly.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
git-acpi-ia64-build-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
kernel-auditc-warning-fix.patch
git-cpufreq.patch
git-cpufreq-query_current_values_with_pending_wait-build-fix.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
dm-persistent_read_metadata-warning-fix.patch
ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
git-drm-oops-fix.patch
git-drm-warning-fix.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
revert-git-hrt.patch
ia64-slim-down-__clear_bit_unlock.patch
git-infiniband.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
git-mmc.patch
git-mtd.patch
xfrm_policy-warning-fix.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
quirk-enable-msi-mapping-on-ht1000.patch
git-sh.patch
git-sh-fixup.patch
git-scsi-misc-fixup.patch
ips-trim-trailing-whitespace.patch
scsi-gdth-kill-unneeded-irq-argument.patch
bidi-support-scsi_data_buffer-broke-qla1280.patch
bidi-support-scsi_data_buffer-broke-lots-of-stuff.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-build-fix.patch
git-cryptodev.patch
git-xtensa.patch
ia64-increase-datapatch-offset.patch
ia64-dont-assume-that-unwcheckpy-is-executable.patch
ia64-export-copy_page-to-modules.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
alpha-atomic_add_return-should-return-int.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
kernel-printkc-concerns-about-the-console-handover.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
mm-prevent-dereferencing-non-allocated-per_cpu-variables-fix.patch
sync_sb_inodes-propagate-errors.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
64-bit-i_version-afs-fixes.patch
ext4-add-block-bitmap-validation-fix.patch
ext4-fix-up-ext4fs_debug-builds-checkpatch-fixes.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page-warning-fix.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d.patch
