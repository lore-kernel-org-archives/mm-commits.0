From: akpm@osdl.org
Subject: - sata_nv-cleanup-adma-error-handling-v2-cleanup.patch removed from -mm tree
Date: Tue, 30 Jan 2007 00:57:57 -0800
Message-ID: <200701300857.l0U8vvRm013927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49306 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965067AbXA3I6P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 03:58:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, AMartin@nvidia.com, hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sata_nv-cleanup-adma-error-handling-v2-cleanup
has been removed from the -mm tree.  Its filename was
     sata_nv-cleanup-adma-error-handling-v2-cleanup.patch

This patch was dropped because it was folded into sata_nv-cleanup-adma-error-handling-v2.patch

------------------------------------------------------
Subject: sata_nv-cleanup-adma-error-handling-v2-cleanup
From: Andrew Morton <akpm@osdl.org>

Many coding-style fixes...

Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Allen Martin <AMartin@nvidia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/sata_nv.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-cleanup-adma-error-handling-v2-cleanup drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-cleanup-adma-error-handling-v2-cleanup
+++ a/drivers/ata/sata_nv.c
@@ -653,34 +653,32 @@ static int nv_adma_check_cpb(struct ata_
 
 	VPRINTK("CPB %d, flags=0x%x\n", cpb_num, flags);
 
-	if(unlikely((force_err ||
+	if (unlikely((force_err ||
 		     flags & (NV_CPB_RESP_ATA_ERR |
 			      NV_CPB_RESP_CMD_ERR |
 			      NV_CPB_RESP_CPB_ERR)))) {
 		struct ata_eh_info *ehi = &ap->eh_info;
 		int freeze = 0;
+
 		ata_ehi_clear_desc(ehi);
 		ata_ehi_push_desc(ehi, "CPB resp_flags 0x%x", flags );
-		if(flags & NV_CPB_RESP_ATA_ERR) {
+		if (flags & NV_CPB_RESP_ATA_ERR) {
 			ata_ehi_push_desc(ehi, ": ATA error");
 			ehi->err_mask |= AC_ERR_DEV;
-		}
-		else if(flags & NV_CPB_RESP_CMD_ERR) {
+		} else if (flags & NV_CPB_RESP_CMD_ERR) {
 			ata_ehi_push_desc(ehi, ": CMD error");
 			ehi->err_mask |= AC_ERR_DEV;
-		}
-		else if(flags & NV_CPB_RESP_CPB_ERR) {
+		} else if (flags & NV_CPB_RESP_CPB_ERR) {
 			ata_ehi_push_desc(ehi, ": CPB error");
 			ehi->err_mask |= AC_ERR_SYSTEM;
 			freeze = 1;
-		}
-		else {
+		} else {
 			/* notifier error, but no error in CPB flags? */
 			ehi->err_mask |= AC_ERR_OTHER;
 			freeze = 1;
 		}
 		/* Kill all commands. EH will determine what actually failed. */
-		if(freeze)
+		if (freeze)
 			ata_port_freeze(ap);
 		else
 			ata_port_abort(ap);
@@ -690,11 +688,11 @@ static int nv_adma_check_cpb(struct ata_
 	if (flags & NV_CPB_RESP_DONE) {
 		struct ata_queued_cmd *qc = ata_qc_from_tag(ap, cpb_num);
 		VPRINTK("CPB flags done, flags=0x%x\n", flags);
-		if(likely(qc)) {
+		if (likely(qc)) {
 			/* Grab the ATA port status for non-NCQ commands.
 			   For NCQ commands the current status may have nothing to do with
 			   the command just completed. */
-			if(qc->tf.protocol != ATA_PROT_NCQ) {
+			if (qc->tf.protocol != ATA_PROT_NCQ) {
 				u8 ata_status = readb(pp->ctl_block + (ATA_REG_STATUS * 4));
 				qc->err_mask |= ac_err_mask(ata_status);
 			}
@@ -789,17 +787,16 @@ static irqreturn_t nv_adma_interrupt(int
 					       NV_ADMA_STAT_HOTUNPLUG |
 					       NV_ADMA_STAT_TIMEOUT))) {
 				struct ata_eh_info *ehi = &ap->eh_info;
+
 				ata_ehi_clear_desc(ehi);
 				ata_ehi_push_desc(ehi, "ADMA status 0x%08x", status );
-				if(status & NV_ADMA_STAT_TIMEOUT) {
+				if (status & NV_ADMA_STAT_TIMEOUT) {
 					ehi->err_mask |= AC_ERR_SYSTEM;
 					ata_ehi_push_desc(ehi, ": timeout");
-				}
-				else if(status & NV_ADMA_STAT_HOTPLUG) {
+				} else if (status & NV_ADMA_STAT_HOTPLUG) {
 					ata_ehi_hotplugged(ehi);
 					ata_ehi_push_desc(ehi, ": hotplug");
-				}
-				else if(status & NV_ADMA_STAT_HOTUNPLUG) {
+				} else if (status & NV_ADMA_STAT_HOTUNPLUG) {
 					ata_ehi_hotplugged(ehi);
 					ata_ehi_push_desc(ehi, ": hot unplug");
 				}
@@ -811,14 +808,15 @@ static irqreturn_t nv_adma_interrupt(int
 				      NV_ADMA_STAT_CPBERR)) {
 				/** Check CPBs for completed commands */
 
-				if(ata_tag_valid(ap->active_tag))
+				if (ata_tag_valid(ap->active_tag)) {
 					/* Non-NCQ command */
 					nv_adma_check_cpb(ap, ap->active_tag,
 						notifier_error & (1 << ap->active_tag));
-				else {
+				} else {
 					int pos, error = 0;
 					u32 active = ap->sactive;
-					while( (pos = ffs(active)) && !error) {
+
+					while ((pos = ffs(active)) && !error) {
 						pos--;
 						error = nv_adma_check_cpb(ap, pos,
 							notifier_error & (1 << pos) );
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
m68k-uaccessh-needs-schedh.patch
x86-fix-vdso-mapping-for-aout-executables.patch
mm-show-bounce-pages-in-oom-killer-output.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled-tidy.patch
acpi-updates-rtc-cmos-device-platform_data-vs-git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
agpgart-allow-drm-populated-agp-memory-types-tidy.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
powerpc-make-it-compile.patch
git-dvb.patch
dvb-video_buf-depends-on-pci.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-input.patch
git-libata-all.patch
pata_platform-set_mode-fix.patch
sata_nv-cleanup-adma-error-handling-v2.patch
sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
mm-ide-ide-acpi-support-warning-fix.patch
git-lxdialog-fixup.patch
git-mips-kconfig-fix.patch
git-mips-prom_free_prom_memory-borkage.patch
git-mmc.patch
git-mmc-fixup.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-atl1-build-fix.patch
git-netdev-all-atl1-pm-fix.patch
82596-warning-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls-fix.patch
dccp-warning-fixes.patch
netfilter-warning-fix.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
nfs-fix-congestion-control-v4-tweaks.patch
r8169-warning-fixes.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix.patch
sh-add-kconfig-default.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-block-fixup.patch
git-block-borkage.patch
git-block-atomicity-fix.patch
fix-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
nokia-e70-is-an-unusual-device.patch
revert-x86_64-mm-msr-on-cpu.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
use-zvc-for-inactive-and-active-counts-up-fix.patch
drop-free_pages-fix.patch
drop-free_pages-sparc64-fix.patch
get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied-fix.patch
optional-zone_dma-in-the-vm-tidy.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2.patch
remove-invalidate_inode_pages.patch
add-an-rcu-version-of-list-splicing-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
block_write_full_page-handle-enospc.patch
sysctl-warning-fix.patch
proc_misc-warning-fix.patch
rtc-framework-driver-for-cmos-rtcs-fix.patch
rtc-framework-driver-for-cmos-rtcs-fix-2.patch
return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
introduce-and-use-get_task_mnt_ns-tweaks.patch
user-ns-implement-user-ns-unshare-tidy.patch
ipc-namespace-remove-config_ipc_ns-linkage-fix.patch
ipc-namespace-remove-config_ipc_ns-linkage-fix-fix.patch
dynamic-kernel-command-line-ia64-fix.patch
rcu-preemptible-rcu-fix.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
_proc_do_string-fix-short-reads.patch
git-netdev-all-chelsio-fix.patch
