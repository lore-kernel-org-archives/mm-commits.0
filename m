From: akpm@osdl.org
Subject: + git-ieee1394-fixup.patch added to -mm tree
Date: Wed, 06 Dec 2006 13:44:10 -0800
Message-ID: <200612062144.kB6LiA1X017394@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44334 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937675AbWLFVoT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 16:44:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, stefanr@s5r6.in-berlin.de


The patch titled
     git-ieee1394-fixup
has been added to the -mm tree.  Its filename is
     git-ieee1394-fixup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-ieee1394-fixup
From: Andrew Morton <akpm@osdl.org>

Probably wrong..

Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ieee1394/sbp2.c |   46 +++++---------------------------------
 drivers/ieee1394/sbp2.h |    6 ----
 2 files changed, 7 insertions(+), 45 deletions(-)

diff -puN drivers/ieee1394/sbp2.c~git-ieee1394-fixup drivers/ieee1394/sbp2.c
--- a/drivers/ieee1394/sbp2.c~git-ieee1394-fixup
+++ a/drivers/ieee1394/sbp2.c
@@ -458,27 +458,20 @@ static void sbp2util_notify_fetch_agent(
 
 static void sbp2util_write_orb_pointer(struct work_struct *work)
 {
-	struct scsi_id_instance_data *scsi_id =
-		container_of(work, struct scsi_id_instance_data,
-			     protocol_work.work);
+	struct sbp2_lu *scsi_id = container_of(work, struct sbp2_lu,
+						protocol_work.work);
 	quadlet_t data[2];
 
-<<<<<<< HEAD/drivers/ieee1394/sbp2.c
 	data[0] = ORB_SET_NODE_ID(scsi_id->hi->host->node_id);
 	data[1] = scsi_id->last_orb_dma;
-=======
-	data[0] = ORB_SET_NODE_ID(((struct sbp2_lu *)p)->hi->host->node_id);
-	data[1] = ((struct sbp2_lu *)p)->last_orb_dma;
->>>>>>> /drivers/ieee1394/sbp2.c
 	sbp2util_cpu_to_be32_buffer(data, 8);
 	sbp2util_notify_fetch_agent(scsi_id, SBP2_ORB_POINTER_OFFSET, data, 8);
 }
 
 static void sbp2util_write_doorbell(struct work_struct *work)
 {
-	struct scsi_id_instance_data *scsi_id =
-		container_of(work, struct scsi_id_instance_data,
-			     protocol_work.work);
+	struct sbp2_lu *scsi_id = container_of(work, struct sbp2_lu,
+						protocol_work.work);
 	sbp2util_notify_fetch_agent(scsi_id, SBP2_DOORBELL_OFFSET, NULL, 4);
 }
 
@@ -738,19 +731,6 @@ static struct sbp2_lu *sbp2_alloc_device
 		goto failed_alloc;
 	}
 
-<<<<<<< HEAD/drivers/ieee1394/sbp2.c
-	scsi_id->ne = ud->ne;
-	scsi_id->ud = ud;
-	scsi_id->speed_code = IEEE1394_SPEED_100;
-	scsi_id->max_payload_size = sbp2_speedto_max_payload[IEEE1394_SPEED_100];
-	scsi_id->status_fifo_addr = CSR1212_INVALID_ADDR_SPACE;
-	INIT_LIST_HEAD(&scsi_id->sbp2_command_orb_inuse);
-	INIT_LIST_HEAD(&scsi_id->sbp2_command_orb_completed);
-	INIT_LIST_HEAD(&scsi_id->scsi_list);
-	spin_lock_init(&scsi_id->sbp2_command_orb_lock);
-	atomic_set(&scsi_id->state, SBP2LU_STATE_RUNNING);
-	INIT_DELAYED_WORK(&scsi_id->protocol_work, NULL);
-=======
 	lu->ne = ud->ne;
 	lu->ud = ud;
 	lu->speed_code = IEEE1394_SPEED_100;
@@ -761,8 +741,7 @@ static struct sbp2_lu *sbp2_alloc_device
 	INIT_LIST_HEAD(&lu->lu_list);
 	spin_lock_init(&lu->cmd_orb_lock);
 	atomic_set(&lu->state, SBP2LU_STATE_RUNNING);
-	INIT_WORK(&lu->protocol_work, NULL, NULL);
->>>>>>> /drivers/ieee1394/sbp2.c
+	INIT_WORK(&lu->protocol_work.work, NULL);
 
 	ud->device.driver_data = lu;
 
@@ -1704,22 +1683,11 @@ static void sbp2_link_orb_command(struct
 		 * the workqueue job will sleep to guaranteedly get a tlabel.
 		 * We do not accept new commands until the job is over.
 		 */
-<<<<<<< HEAD/drivers/ieee1394/sbp2.c
-		scsi_block_requests(scsi_id->scsi_host);
-		PREPARE_DELAYED_WORK(&scsi_id->protocol_work,
-=======
 		scsi_block_requests(lu->shost);
-		PREPARE_WORK(&lu->protocol_work,
->>>>>>> /drivers/ieee1394/sbp2.c
+		PREPARE_DELAYED_WORK(&lu->protocol_work,
 			     last_orb ? sbp2util_write_doorbell:
-<<<<<<< HEAD/drivers/ieee1394/sbp2.c
 					sbp2util_write_orb_pointer);
-		schedule_delayed_work(&scsi_id->protocol_work, 0);
-=======
-					sbp2util_write_orb_pointer,
-			     lu);
-		schedule_work(&lu->protocol_work);
->>>>>>> /drivers/ieee1394/sbp2.c
+		schedule_delayed_work(&lu->protocol_work, 0);
 	}
 }
 
diff -puN drivers/ieee1394/sbp2.h~git-ieee1394-fixup drivers/ieee1394/sbp2.h
--- a/drivers/ieee1394/sbp2.h~git-ieee1394-fixup
+++ a/drivers/ieee1394/sbp2.h
@@ -326,13 +326,7 @@ struct sbp2_lu {
 
 	/* Connection state */
 	atomic_t state;
-<<<<<<< HEAD/drivers/ieee1394/sbp2.h
 	struct delayed_work protocol_work;
-=======
-
-	/* For deferred requests to the fetch agent */
-	struct work_struct protocol_work;
->>>>>>> /drivers/ieee1394/sbp2.h
 };
 
 /* For use in sbp2_lu.state */
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
add-bottom_half.h.patch
drm-sis-linkage-fix.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
git-alsa-arm-fix.patch
git-cpufreq-prep.patch
git-cpufreq.patch
git-cpufreq-fixup.patch
platform_driver_probe-can-save-codespace-save-codespace.patch
git-dvb.patch
git-dvb-fixup.patch
git-gfs2-nmw.patch
git-ia64.patch
git-ieee1394-fixup.patch
git-input.patch
git-input-fixup.patch
git-input-vs-git-alsa.patch
kbuild-fix-rr-is-now-default.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
pata_it8213-add-new-driver-for-the-it8213-card-tidy.patch
git-lxdialog-fixup.patch
git-mtd.patch
git-mtd-ssfdc-build-fix.patch
git-ubi.patch
git-netdev-all.patch
libphy-dont-do-that.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-net.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-fix-multiple-problems-with-via-hardware.patch
fix-gregkh-pci-pci-enable-disable-device-is-nestable.patch
git-s390.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
nokia-e70-is-an-unusual-device.patch
pre-x86_64-mm-i386-reloc-abssym.patch
post-x86_64-mm-i386-reloc-abssym.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy-tidy-2.patch
touchkit-ps-2-touchscreen-driver.patch
get-rid-of-zone_table.patch
new-scheme-to-preempt-swap-token-tidy.patch
balance_pdgat-cleanup.patch
leak-tracking-for-kmalloc_node-fix.patch
add-numa-node-information-to-struct-device-tidy.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
slab-deprecate-kmem_cache-t.patch
mm-make-compound-page-destructor-handling-explicit-tidy.patch
congestion-wait-dont-wait-when-there-are-no-pages-under-writeback.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
radix-tree-rcu-lockless-readside.patch
acx1xx-wireless-driver.patch
swsusp-add-resume_offset-command-line-parameter-rev-2.patch
add-include-linux-freezerh-and-move-definitions-from-ueagle-fix.patch
add-include-linux-freezerh-and-move-definitions-from-ucb1400_ts-fix.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
convert-pm_sem-to-a-mutex-fix.patch
cciss-set-sector_size-to-2048-for-performance-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets-tidy.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
probe_kernel_address-needs-to-do-set_fs.patch
slab-use-probe_kernel_address.patch
exar-quad-port-serial-fix.patch
vfs_getattr-remove-dead-code.patch
ext3-uninline-large-functions.patch
ext4-uninline-large-functions.patch
sleep-profiling-fixes.patch
sleep-profiling-fix.patch
debug-workqueue-locking-sanity-fix.patch
pcengines-wrap-led-support-fix.patch
driver-base-memoryc-remove-warnings-of.patch
remove-kernel-syscalls-x86_64-fix.patch
protect-ext2-ioctl-modifying-append_only-immutable-etc-with-i_mutex.patch
remove-hash_highmem.patch
elf-fix-kcore-note-size-calculation-fix.patch
reiserfs-add-missing-d-cache-flushing-tweak.patch
up-smp_call_function_single-should-disable-interrupts.patch
up-smp_call_function_single-should-disable-interrupts-fix.patch
smp_call_function_single-check-that-local-interrupts-are-enabled.patch
hotplug-cpu-clean-up-hotcpu_notifier-use-vs-gregkh-driver-cpu-topology-consider-sysfs_create_group-return-value.patch
add-return-value-checking-of-get_user-in-fix.patch
handle-per-subsystem-mutexes-for-config_hotplug_cpu-not-set-tidy.patch
dz-fixes-to-make-it-work-fix.patch
ext4-balloc-fix-_with_rsv-freeze-fix.patch
ide_scsi-allow-it-to-be-used-for-non-cd-only-fix.patch
make-8250_pnp-serial-driver-work-after-tidy.patch
gcc-4-1-0-is-bust.patch
cleanup-include-asm-generic-atomich-fix.patch
struct-seq_operations-and-struct-file_operations-constification-fix.patch
struct-seq_operations-and-struct-file_operations-constification-fix-2.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch
bug-test-1.patch
net-use-bitrev8-tidy.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sched-add-option-to-serialize-load-balancing-fix.patch
kernel-schedc-whitespace-cleanups-more.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
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
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
clocksource-small-cleanup-2-fix.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

