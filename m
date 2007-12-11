From: akpm@linux-foundation.org
Subject: + sata_nv-fix-oops.patch added to -mm tree
Date: Tue, 11 Dec 2007 12:09:30 -0800
Message-ID: <200712112009.lBBK9W43006758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbXLKUKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 15:10:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org, kluo@nvidia.com, peerchen@gmail.com


The patch titled
     sata_nv: fix oops
has been added to the -mm tree.  Its filename is
     sata_nv-fix-oops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_nv: fix oops
From: Andrew Morton <akpm@linux-foundation.org>

"Kuan Luo" <kluo@nvidia.com> said:

The below error happens when i rmmod sata_nv in adma mode on ck804
chipset with 2.6.24 kernel.
I traced the code and found that the driver attempts to write device mem
that has been unmapped.

Only simply removing the code" writew(0, mmio + NV_ADMA_CTL);" in the
nv_adma_port_stop function or remove .port_stop field in nv_adma_ops,
rmmod is ok.

static void nv_adma_port_stop(struct ata_port *ap)
{
	struct nv_adma_port_priv *pp = ap->private_data;
	void __iomem *mmio = pp->ctl_block;

	VPRINTK("ENTER\n");
-	writew(0, mmio + NV_ADMA_CTL);
}

Or
 Place pcim_iomap_regions before ata_pci_prepare_native_host in
nv_init_one function.
This can guarantee that the code "writew(0, mmio + NV_ADMA_CTL) " write
device mem before the device mem is unmapped.

messages:
Dec 19 02:23:24 localhost kernel: ata16.00: disabled
Dec 19 02:23:24 localhost kernel: sd 15:0:0:0: [sda] Synchronizing SCSI
cache
Dec 19 02:23:24 localhost kernel: sd 15:0:0:0: [sda] Result:
hostbyte=0x04 driverbyte=0x00
Dec 19 02:23:24 localhost kernel: sd 15:0:0:0: [sda] Stopping disk
Dec 19 02:23:24 localhost kernel: sd 15:0:0:0: [sda] START_STOP FAILED
Dec 19 02:23:24 localhost kernel: sd 15:0:0:0: [sda] Result:
hostbyte=0x04 driverbyte=0x00
Dec 19 02:23:24 localhost kernel: BUG: unable to handle kernel paging
request at virtual address e881a4c0
Dec 19 02:23:24 localhost kernel: printing eip: e88224e9 *pde = 0180c067
*pte = 00000000 
Dec 19 02:23:24 localhost kernel: Oops: 0002 [#1] SMP 
Dec 19 02:23:24 localhost kernel: Modules linked in: sata_nv libata
Dec 19 02:23:24 localhost kernel: 
Dec 19 02:23:24 localhost kernel: Pid: 4915, comm: rmmod Not tainted
(2.6.24-rc1-ge2e031eb #2)
Dec 19 02:23:24 localhost kernel: EIP: 0060:[<e88224e9>] EFLAGS:
00210292 CPU: 1
Dec 19 02:23:24 localhost kernel: EIP is at nv_adma_port_stop+0x3d/0x53
[sata_nv]
Dec 19 02:23:24 localhost kernel: EAX: 00000015 EBX: e881a480 ECX:
00200046 EDX: 00200046
Dec 19 02:23:24 localhost kernel: ESI: c220b50c EDI: c1979154 EBP:
c197904c ESP: c2429ecc
Dec 19 02:23:24 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033
SS: 0068
Dec 19 02:23:24 localhost kernel: Process rmmod (pid: 4915, ti=c2428000
task=c25e5a40 task.ti=c2428000)
Dec 19 02:23:24 localhost kernel: Stack: e8823e1b e881a480 00000000
e884398e c220b500 c18a3ec0 c1979154 00000000 
Dec 19 02:23:24 localhost kernel:        c02818be c1979154 c197904c
0000000d c18a3ec0 c18a3a40 c197904c e88259d0 
Dec 19 02:23:24 localhost kernel:        e88259d0 c2428000 c0281987
00200286 c197904c c027f8bb c1834600 c197904c 
Dec 19 02:23:24 localhost kernel: Call Trace:
Dec 19 02:23:24 localhost kernel:  [<e884398e>]
ata_host_release+0x2f/0x92 [libata]
Dec 19 02:23:24 localhost kernel:  [<c02818be>]
release_nodes+0x10f/0x12f
Dec 19 02:23:24 localhost kernel:  [<c0281987>]
devres_release_all+0x27/0x2a
Dec 19 02:23:24 localhost kernel:  [<c027f8bb>]
__device_release_driver+0x72/0x88
Dec 19 02:23:24 localhost kernel:  [<c027fccb>] driver_detach+0x76/0xb3
Dec 19 02:23:24 localhost kernel:  [<c027f49f>]
bus_remove_driver+0x63/0x81
Dec 19 02:23:24 localhost kernel:  [<c0228b5a>]
pci_unregister_driver+0xc/0x57
Dec 19 02:23:24 localhost kernel:  [<c0143792>]
sys_delete_module+0x197/0x1bd
Dec 19 02:23:24 localhost kernel:  [<c0417673>]
do_page_fault+0x202/0x581
Dec 19 02:23:24 localhost kernel:  [<c01570ec>] do_munmap+0x193/0x1ac
Dec 19 02:23:24 localhost kernel:  [<c0104e4e>]
sysenter_past_esp+0x5f/0x85
Dec 19 02:23:24 localhost kernel:  =======================
Dec 19 02:23:24 localhost kernel: Code: 3e 82 e8 e8 b8 30 90 d7 89 5c 24
04 c7 04 24 0f 3e 82 e8 e8 a8 30 90 d7 8b 5b 10 c7 04 24 1b 3e 82 e8 89
5c 24 04 e8 95 30 90 d7 <66> c7 43 40 00 00 c7 04 24 29 3e 82 e8 e8 83
30 90 d7 5b 58 5b 
Dec 19 02:23:24 localhost kernel: EIP: [<e88224e9>]
nv_adma_port_stop+0x3d/0x53 [sata_nv] SS:ESP 0068:c2429ecc

Cc: "Kuan Luo" <kluo@nvidia.com>
Cc: "Jeff Garzik" <jeff@garzik.org>
Cc: "peer chen" <peerchen@gmail.com>
Cc: "Robert Hancock" <hancockr@shaw.ca>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-fix-oops drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-fix-oops
+++ a/drivers/ata/sata_nv.c
@@ -1211,7 +1211,7 @@ static void nv_adma_port_stop(struct ata
 	void __iomem *mmio = pp->ctl_block;
 
 	VPRINTK("ENTER\n");
-	writew(0, mmio + NV_ADMA_CTL);
+//	writew(0, mmio + NV_ADMA_CTL);
 }
 
 #ifdef CONFIG_PM
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-hibernation-enter-platform-hibernation-state-in-a-consistent-way.patch
revert-hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
aoe-properly-initialise-the-request_queues-backing_dev_info.patch
revert-dpt_i2o-convert-to-scsi-hotplug-model.patch
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
revert-git-hrt.patch
git-ia64.patch
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
sata_nv-fix-oops.patch
