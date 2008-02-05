From: akpm@linux-foundation.org
Subject: + git-v9fs-fix-git-conflicts.patch added to -mm tree
Date: Mon, 04 Feb 2008 19:13:11 -0800
Message-ID: <200802050312.m153CqFe032262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57820 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbYBEDNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 22:13:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ericvh@hera.kernel.org, rusty@rustcorp.com.au


The patch titled
     git-v9fs-fix-git-conflicts
has been added to the -mm tree.  Its filename is
     git-v9fs-fix-git-conflicts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-v9fs-fix-git-conflicts
From: Andrew Morton <akpm@linux-foundation.org>

rusty trashed eric's stuff!

Cc: Rusty Russell <rusty@rustcorp.com.au>
CC: Eric Van Hensbergen <ericvh@hera.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/trans_virtio.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

diff -puN net/9p/trans_virtio.c~git-v9fs-fix-git-conflicts net/9p/trans_virtio.c
--- a/net/9p/trans_virtio.c~git-v9fs-fix-git-conflicts
+++ a/net/9p/trans_virtio.c
@@ -257,23 +257,12 @@ p9_virtio_rpc(struct p9_trans *t, struct
 	}
 #endif
 
-<<<<<<< HEAD:net/9p/trans_virtio.c
 static void p9_virtio_intr(struct virtqueue *q)
 {
 	struct virtio_chan *chan = q->vdev->priv;
-=======
-	if (n != P9_NOTAG && p9_idpool_check(n, chan->tagpool))
-		p9_idpool_put(n, chan->tagpool);
->>>>>>> FETCH_HEAD:net/9p/trans_virtio.c
 
-<<<<<<< HEAD:net/9p/trans_virtio.c
 	P9_DPRINTK(P9_DEBUG_TRANS, "9p poll_wakeup: %p\n", &chan->wq);
 	wake_up_interruptible(&chan->wq);
-=======
-	req->status = REQ_STATUS_IDLE;
-
-	return 0;
->>>>>>> FETCH_HEAD:net/9p/trans_virtio.c
 }
 
 static int p9_virtio_probe(struct virtio_device *vdev)
@@ -294,30 +283,12 @@ static int p9_virtio_probe(struct virtio
 		goto fail;
 	}
 
-<<<<<<< HEAD:net/9p/trans_virtio.c
-	/* Find the input queue. */
-	dev->priv = chan;
-	chan->in_vq = dev->config->find_vq(dev, 0, p9_virtio_intr);
-	if (IS_ERR(chan->in_vq)) {
-		err = PTR_ERR(chan->in_vq);
-		goto free;
-	}
-=======
 	chan->vdev = vdev;
->>>>>>> FETCH_HEAD:net/9p/trans_virtio.c
 
-<<<<<<< HEAD:net/9p/trans_virtio.c
 	chan->out_vq = dev->config->find_vq(dev, 1, NULL);
 	if (IS_ERR(chan->out_vq)) {
 		err = PTR_ERR(chan->out_vq);
 		goto free_in_vq;
-=======
-	/* We expect one virtqueue, for requests. */
-	chan->vq = vdev->config->find_vq(vdev, req_done);
-	if (IS_ERR(chan->vq)) {
-		err = PTR_ERR(chan->vq);
-		goto out_free_vq;
->>>>>>> FETCH_HEAD:net/9p/trans_virtio.c
 	}
 	chan->vq->vdev->priv = chan;
 	spin_lock_init(&chan->lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kvm-i386-fix.patch
drivers-net-wireless-b43-mainc-needs-ioh.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
timerfd-v3-new-timerfd-api.patch
include-asm-powerpc-nvramh-needs-listh.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
bufferhead-revert-constructor-removal.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
maps4-rework-task_size-macros.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
page-allocator-clean-up-pcp-draining-functions.patch
add-mm-argument-to-pte-pmd-pud-pgd_free.patch
mm-page-writeback-highmem_is_dirtyable-option.patch
mm-remove-fastcall-from-mm.patch
page-migraton-handle-orphaned-pages.patch
revert-capabilities-clean-up-file-capability-reading.patch
add-64-bit-capability-support-to-the-kernel.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
dio-array_size-cleanup.patch
uml-get-rid-of-asmlinkage.patch
uml-improve-detection-of-host-cmov.patch
uml-further-bugsc-tidying.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements-checkpatch-fixes.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
acpi-backlight-reset-brightness-on-resume-checkpatch-fixes.patch
git-alsa-disable-sound-pci-ice1712-ice1724c.patch
git-agpgart.patch
git-agpgart-fix.patch
git-audit-printk-warning-fix.patch
cifs-fix-warning.patch
git-cpufreq.patch
revert-agk-dm-dm-loop.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-drm-fix.patch
drm-convert-from-nopage-to-fault-checkpatch-fixes.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip-fix.patch
revert-git-hrt.patch
git-ia64.patch
i8042-non-x86-build-fix.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
ata-drivers-ata-sata_mvc-needs-dmapoolh.patch
drivers-ide-ide-acpic-fix-uninitialized-var-warning.patch
drivers-ide-legacy-hdc-fix-uninitialized-var-warning.patch
git-md-accel.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
memstick-disable-busted-code.patch
git-mmc.patch
git-mtd.patch
drivers-mtd-maps-physmapc-fix-compile-remove-ifdef.patch
git-netdev-all-fix-conflicts-fix.patch
drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
bluetooth-uninlining.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
scsi-fix-isa-pcmcia-compile-problem-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
git-v9fs-fix-git-conflicts.patch
9p-fix-p9_printfcall-export.patch
git-watchdog.patch
git-watchdog-fixup.patch
b43-fix-build-with-config_ssb_pcihost=n.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
x86-amd-thermal-interrupt-support-fix-2.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
git-xtensa.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
md-change-interate_mddev-to-for_each_mddev-fix.patch
md-change-iterate_rdev-to-rdev_for_each-fix.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext3-fix-lock-inversion-in-direct-io-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on-fix.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file-fix.patch
memcontrol-move-mm_cgroup-to-header-file-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-powerpc-fix.patch
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
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
page-owner-tracking-leak-detector-broken-on-s390.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
