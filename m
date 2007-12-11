From: akpm@linux-foundation.org
Subject: - revert-dpt_i2o-convert-to-scsi-hotplug-model.patch removed from -mm tree
Date: Tue, 11 Dec 2007 14:41:39 -0800
Message-ID: <200712112241.lBBMfdZ8012546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311AbXLKWms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 17:42:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@SteelEye.com, anders.henke@1und1.de, fujita.tomonori@lab.ntt.co.jp, mark_salyzyn@adaptec.com, matthew@wil.cx, stable@kernel.org, mm-commits@


The patch titled
     revert "dpt_i2o: convert to SCSI hotplug model"
has been removed from the -mm tree.  Its filename was
     revert-dpt_i2o-convert-to-scsi-hotplug-model.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: revert "dpt_i2o: convert to SCSI hotplug model"
From: Andrew Morton <akpm@linux-foundation.org>

revert

    commit 55d9fcf57ba5ec427544fca7abc335cf3da78160
    Author: Matthew Wilcox <matthew@wil.cx>
    Date:   Mon Jul 30 15:19:18 2007 -0600

        [SCSI] dpt_i2o: convert to SCSI hotplug model
    
         - Delete refereces to HOSTS_C
         - Switch to module_init/module_exit instead of detect/release
         - Don't pass around the host template and rename it to adpt_template
         - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
           scsi_add_host, scsi_scan_host and scsi_host_put.

Because it caused (for unknown reasons) Andres' all-data-reads-as-zeroes
problem, reported at
http://groups.google.com/group/fa.linux.kernel/msg/083a9acff0330234

Cc: Matthew Wilcox <matthew@wil.cx>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Anders Henke <anders.henke@1und1.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dpt_i2o.c |  132 ++++++++++++++++++---------------------
 drivers/scsi/dpti.h    |    9 ++
 2 files changed, 68 insertions(+), 73 deletions(-)

diff -puN drivers/scsi/dpt_i2o.c~revert-dpt_i2o-convert-to-scsi-hotplug-model drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~revert-dpt_i2o-convert-to-scsi-hotplug-model
+++ a/drivers/scsi/dpt_i2o.c
@@ -173,20 +173,20 @@ static struct pci_device_id dptids[] = {
 };
 MODULE_DEVICE_TABLE(pci,dptids);
 
-static void adpt_exit(void);
-
-static int adpt_detect(void)
+static int adpt_detect(struct scsi_host_template* sht)
 {
 	struct pci_dev *pDev = NULL;
 	adpt_hba* pHba;
 
+	adpt_init();
+
 	PINFO("Detecting Adaptec I2O RAID controllers...\n");
 
         /* search for all Adatpec I2O RAID cards */
 	while ((pDev = pci_get_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
 		if(pDev->device == PCI_DPT_DEVICE_ID ||
 		   pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
-			if(adpt_install_hba(pDev) ){
+			if(adpt_install_hba(sht, pDev) ){
 				PERROR("Could not Init an I2O RAID device\n");
 				PERROR("Will not try to detect others.\n");
 				return hba_count-1;
@@ -248,33 +248,34 @@ rebuild_sys_tab:
 	}
 
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
-		if (adpt_scsi_register(pHba) < 0) {
+		if( adpt_scsi_register(pHba,sht) < 0){
 			adpt_i2o_delete_hba(pHba);
 			continue;
 		}
 		pHba->initialized = TRUE;
 		pHba->state &= ~DPTI_STATE_RESET;
-		scsi_scan_host(pHba->host);
 	}
 
 	// Register our control device node
 	// nodes will need to be created in /dev to access this
 	// the nodes can not be created from within the driver
 	if (hba_count && register_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER, &adpt_fops)) {
-		adpt_exit();
+		adpt_i2o_sys_shutdown();
 		return 0;
 	}
 	return hba_count;
 }
 
 
-static int adpt_release(adpt_hba *pHba)
+/*
+ * scsi_unregister will be called AFTER we return.
+ */
+static int adpt_release(struct Scsi_Host *host)
 {
-	struct Scsi_Host *shost = pHba->host;
-	scsi_remove_host(shost);
+	adpt_hba* pHba = (adpt_hba*) host->hostdata[0];
 //	adpt_i2o_quiesce_hba(pHba);
 	adpt_i2o_delete_hba(pHba);
-	scsi_host_put(shost);
+	scsi_unregister(host);
 	return 0;
 }
 
@@ -881,7 +882,7 @@ static int adpt_reboot_event(struct noti
 #endif
 
 
-static int adpt_install_hba(struct pci_dev* pDev)
+static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev)
 {
 
 	adpt_hba* pHba = NULL;
@@ -1028,6 +1029,8 @@ static void adpt_i2o_delete_hba(adpt_hba
 
 
 	mutex_lock(&adpt_configuration_lock);
+	// scsi_unregister calls our adpt_release which
+	// does a quiese
 	if(pHba->host){
 		free_irq(pHba->host->irq, pHba);
 	}
@@ -1079,6 +1082,17 @@ static void adpt_i2o_delete_hba(adpt_hba
 }
 
 
+static int adpt_init(void)
+{
+	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
+#ifdef REBOOT_NOTIFIER
+	register_reboot_notifier(&adpt_reboot_notifier);
+#endif
+
+	return 0;
+}
+
+
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun)
 {
 	struct adpt_device* d;
@@ -2164,6 +2178,37 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pH
 }
 
 
+static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht)
+{
+	struct Scsi_Host *host = NULL;
+
+	host = scsi_register(sht, sizeof(adpt_hba*));
+	if (host == NULL) {
+		printk ("%s: scsi_register returned NULL\n",pHba->name);
+		return -1;
+	}
+	host->hostdata[0] = (unsigned long)pHba;
+	pHba->host = host;
+
+	host->irq = pHba->pDev->irq;
+	/* no IO ports, so don't have to set host->io_port and
+	 * host->n_io_port
+	 */
+	host->io_port = 0;
+	host->n_io_port = 0;
+				/* see comments in scsi_host.h */
+	host->max_id = 16;
+	host->max_lun = 256;
+	host->max_channel = pHba->top_scsi_channel + 1;
+	host->cmd_per_lun = 1;
+	host->unique_id = (uint) pHba;
+	host->sg_tablesize = pHba->sg_tablesize;
+	host->can_queue = pHba->post_fifo_size;
+
+	return 0;
+}
+
+
 static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 {
 	adpt_hba* pHba;
@@ -3279,10 +3324,12 @@ static static void adpt_delay(int millis
 
 #endif
 
-static struct scsi_host_template adpt_template = {
+static struct scsi_host_template driver_template = {
 	.name			= "dpt_i2o",
 	.proc_name		= "dpt_i2o",
 	.proc_info		= adpt_proc_info,
+	.detect			= adpt_detect,
+	.release		= adpt_release,
 	.info			= adpt_info,
 	.queuecommand		= adpt_queue,
 	.eh_abort_handler	= adpt_abort,
@@ -3297,62 +3344,5 @@ static struct scsi_host_template adpt_te
 	.use_clustering		= ENABLE_CLUSTERING,
 	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
-
-static s32 adpt_scsi_register(adpt_hba* pHba)
-{
-	struct Scsi_Host *host;
-
-	host = scsi_host_alloc(&adpt_template, sizeof(adpt_hba*));
-	if (host == NULL) {
-		printk ("%s: scsi_host_alloc returned NULL\n",pHba->name);
-		return -1;
-	}
-	host->hostdata[0] = (unsigned long)pHba;
-	pHba->host = host;
-
-	host->irq = pHba->pDev->irq;
-	/* no IO ports, so don't have to set host->io_port and
-	 * host->n_io_port
-	 */
-	host->io_port = 0;
-	host->n_io_port = 0;
-				/* see comments in scsi_host.h */
-	host->max_id = 16;
-	host->max_lun = 256;
-	host->max_channel = pHba->top_scsi_channel + 1;
-	host->cmd_per_lun = 1;
-	host->unique_id = (uint) pHba;
-	host->sg_tablesize = pHba->sg_tablesize;
-	host->can_queue = pHba->post_fifo_size;
-
-	if (scsi_add_host(host, &pHba->pDev->dev)) {
-		scsi_host_put(host);
-		return -1;
-	}
-
-	return 0;
-}
-
-static int __init adpt_init(void)
-{
-	int count;
-
-	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
-#ifdef REBOOT_NOTIFIER
-	register_reboot_notifier(&adpt_reboot_notifier);
-#endif
-
-	count = adpt_detect();
-
-	return count > 0 ? 0 : -ENODEV;
-}
-
-static void adpt_exit(void)
-{
-	while (hba_chain)
-		adpt_release(hba_chain);
-}
-
-module_init(adpt_init);
-module_exit(adpt_exit);
+#include "scsi_module.c"
 MODULE_LICENSE("GPL");
diff -puN drivers/scsi/dpti.h~revert-dpt_i2o-convert-to-scsi-hotplug-model drivers/scsi/dpti.h
--- a/drivers/scsi/dpti.h~revert-dpt_i2o-convert-to-scsi-hotplug-model
+++ a/drivers/scsi/dpti.h
@@ -28,9 +28,11 @@
  * SCSI interface function Prototypes
  */
 
+static int adpt_detect(struct scsi_host_template * sht);
 static int adpt_queue(struct scsi_cmnd * cmd, void (*cmdcomplete) (struct scsi_cmnd *));
 static int adpt_abort(struct scsi_cmnd * cmd);
 static int adpt_reset(struct scsi_cmnd* cmd);
+static int adpt_release(struct Scsi_Host *host);
 static int adpt_slave_configure(struct scsi_device *);
 
 static const char *adpt_info(struct Scsi_Host *pSHost);
@@ -47,6 +49,8 @@ static int adpt_device_reset(struct scsi
 
 #define DPT_DRIVER_NAME	"Adaptec I2O RAID"
 
+#ifndef HOSTS_C
+
 #include "dpt/sys_info.h"
 #include <linux/wait.h>
 #include "dpt/dpti_i2o.h"
@@ -285,7 +289,7 @@ static s32 adpt_i2o_init_outbound_q(adpt
 static s32 adpt_i2o_hrt_get(adpt_hba* pHba);
 static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_device* dptdevice);
 static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd);
-static s32 adpt_scsi_register(adpt_hba* pHba);
+static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht);
 static s32 adpt_hba_reset(adpt_hba* pHba);
 static s32 adpt_i2o_reset_hba(adpt_hba* pHba);
 static s32 adpt_rescan(adpt_hba* pHba);
@@ -295,7 +299,7 @@ static void adpt_i2o_delete_hba(adpt_hba
 static void adpt_inquiry(adpt_hba* pHba);
 static void adpt_fail_posted_scbs(adpt_hba* pHba);
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun);
-static int adpt_install_hba(struct pci_dev* pDev) ;
+static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev) ;
 static int adpt_i2o_online_hba(adpt_hba* pHba);
 static void adpt_i2o_post_wait_complete(u32, int);
 static int adpt_i2o_systab_send(adpt_hba* pHba);
@@ -339,4 +343,5 @@ static void adpt_i386_info(sysInfo_S* si
 #define FW_DEBUG_BLED_OFFSET       8
 
 #define FW_DEBUG_FLAGS_NO_HEADERS_B    0x01
+#endif				/* !HOSTS_C */
 #endif				/* _DPT_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-acpi-ia64-build-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-agpgart.patch
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
git-drm.patch
git-drm-oops-fix.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
git-hid.patch
revert-git-hrt.patch
ia64-slim-down-__clear_bit_unlock.patch
git-infiniband.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long-fix.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-mmc.patch
git-mtd.patch
git-net.patch
git-net-vs-git-lblnet.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
quirk-enable-msi-mapping-on-ht1000.patch
kernel-time-make-tick_do_broadcast-static.patch
git-sh.patch
git-scsi-misc-fixup.patch
ips-trim-trailing-whitespace.patch
scsi-gdth-kill-unneeded-irq-argument.patch
drivers-scsi-sgiwd93c-export-sgiwd93_reset.patch
hptiop-add-more-adapter-models-and-other-fixes-fix.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
git-watchdog.patch
add-support-for-sb1-hardware-watchdog-fix.patch
git-wireless.patch
bcm43xx_debugfs-sscanf-fix.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-__vdso_getcpu-warning-fix.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
bonding-locking-fix.patch
sata_nv-fix-oops.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-optimise-the-clearing-of-__gfp_zero.patch
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
kernel-printkc-concerns-about-the-console-handover.patch
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
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-kprobes-examples-to-samples-resend-vs-git-x86.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
64-bit-i_version-afs-fixes.patch
ext4-add-block-bitmap-validation.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks-fix.patch
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
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
