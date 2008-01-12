From: akpm@linux-foundation.org
Subject: + pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch added to -mm tree
Date: Fri, 11 Jan 2008 16:25:33 -0800
Message-ID: <200801120025.m0C0PXG2005431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbYALA0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 19:26:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, rjw@sisk.pl, stern@rowland.harvard.edu


The patch titled
     pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes
=46rom: Andrew Morton <akpm@linux-foundation.org>

ERROR: Invalid UTF-8
#175: FILE: drivers/base/core.c:1201:
+ * It can only be called within the scope of a system sleep transition=
=2E =A0In

ERROR: Invalid UTF-8
#260: FILE: drivers/base/power/main.c:87:
+	 * lead to a deadlock. =A0In that case we want to print a warning.

ERROR: need space after that ',' (ctx:VxV)
#352: FILE: drivers/base/power/main.c:175:
+		dev_dbg(dev,"EARLY resume\n");
 		           ^

ERROR: use tabs not spaces
#490: FILE: drivers/base/power/main.c:285:
+ ^Iwhile (!list_empty(&dpm_locked)) {$

ERROR: use tabs not spaces
#491: FILE: drivers/base/power/main.c:286:
+ ^I^Istruct list_head *entry =3D dpm_locked.prev;$

ERROR: use tabs not spaces
#492: FILE: drivers/base/power/main.c:287:
+ ^I^Istruct device *dev =3D to_device(entry);$

ERROR: use tabs not spaces
#494: FILE: drivers/base/power/main.c:289:
+ ^I^Ilist_move(entry, &dpm_active);$

ERROR: use tabs not spaces
#495: FILE: drivers/base/power/main.c:290:
+ ^I^Iup(&dev->sem);$

ERROR: use tabs not spaces
#496: FILE: drivers/base/power/main.c:291:
+ ^I}$

ERROR: use tabs not spaces
#770: FILE: drivers/base/power/main.c:486:
+ ^I^I^Ilist_add(&dev->power.entry, &dpm_off);$

total: 10 errors, 0 warnings, 843 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/base/power/main.c~pm-acquire-device-locks-on-suspend-=
rev-3-checkpatch-fixes drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-acquire-device-locks-on-suspend-rev-=
3-checkpatch-fixes
+++ a/drivers/base/power/main.c
@@ -172,7 +172,7 @@ static int resume_device_early(struct de
 	TRACE_RESUME(0);
=20
 	if (dev->bus && dev->bus->resume_early) {
-		dev_dbg(dev,"EARLY resume\n");
+		dev_dbg(dev, "EARLY resume\n");
 		error =3D dev->bus->resume_early(dev);
 	}
=20
@@ -282,13 +282,13 @@ static void dpm_resume(void)
 static void unlock_all_devices(void)
 {
 	mutex_lock(&dpm_list_mtx);
- 	while (!list_empty(&dpm_locked)) {
- 		struct list_head *entry =3D dpm_locked.prev;
- 		struct device *dev =3D to_device(entry);
-
- 		list_move(entry, &dpm_active);
- 		up(&dev->sem);
- 	}
+	while (!list_empty(&dpm_locked)) {
+		struct list_head *entry =3D dpm_locked.prev;
+		struct device *dev =3D to_device(entry);
+
+		list_move(entry, &dpm_active);
+		up(&dev->sem);
+	}
 	mutex_unlock(&dpm_list_mtx);
 }
=20
@@ -483,7 +483,7 @@ static int dpm_suspend(pm_message_t stat
 		}
 		mutex_lock(&dpm_list_mtx);
 		if (list_empty(&dev->power.entry))
- 			list_add(&dev->power.entry, &dpm_off);
+			list_add(&dev->power.entry, &dpm_off);
 	}
 	mutex_unlock(&dpm_list_mtx);
=20
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

hugetlbfs-fix-quota-leak.patch
pl2303-fix-mode-switching-regression-fix.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-t=
ime-till-the-next-expiration-checkpatch-fixes.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-agpgart-intel-agp-dont-zero-an-already-registered-resource-during-r=
esume.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
kernel-auditc-warning-fix.patch
git-cifs.patch
git-cpufreq.patch
git-powerpc.patch
git-powerpc-fixup.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.p=
atch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
intel-agp-enable-i915-recognition.patch
drm-convert-from-nopage-to-fault-checkpatch-fixes.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
git-hid.patch
revert-git-hrt.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-versus-driver-tree.patch
git-kbuild.patch
git-kvm.patch
kvm-ist-kaput.patch
git-libata-all.patch
git-libata-all-fix-pata_winbond-borkage.patch
git-libata-all-wtf.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-che=
ckpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-md-accel.patch
git-mmc.patch
git-mtd.patch
git-net.patch
git-net-vs-git-lblnet.patch
git-net-vs-git-lblnet-2.patch
git-netdev-all.patch
git-net-vs-git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
backlight-omap1-backlight-driver.patch
git-battery.patch
bluetooth-uninlining.patch
net-sunrpc-schedc-revert-git-net-changes.patch
net-sunrpc-schedc-reapply-git-net-changes.patch
net-sunrpc-svcsockc-revert-git-nfs-changes.patch
git-nfsd.patch
net-sunrpc-svcsockc-reapply-git-nfs-changes.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh-c=
heckpatch-fixes.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-=
resources.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fi=
xes.patch
9p-util-fix-semaphore-handling.patch
git-watchdog.patch
git-watchdog-fixup.patch
wdt-fix-locking-checkpatch-fixes.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-x86-makefile-revert-git-kvm-change.patch
git-x86.patch
arch-x86-makefile-reapply-git-kvm-change.patch
git-x86-fixup.patch
git-x86-fix-doubly-merged-patch.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
bonding-locking-fix.patch
usbtouchscreen-fix-buffer-overflow-make-more-egalax-work-checkpatch-fix=
es.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fi=
x.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fi=
x-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fix=
es.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.=
patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-t=
he-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.p=
atch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warni=
ng-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warni=
ng-message-fix.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking=
-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatc=
h-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patc=
h
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.pa=
tch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-express=
card-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
avoid-overflows-in-kernel-timec-fix.patch
export-iov_shorten-for-ext4s-use-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz=3D=3Duser_hz.patch
add-have_oprofile.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.pa=
tch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-c=
hange-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch=
-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-=
fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.=
patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_=
page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cg=
roup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember=
-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies=
-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.pat=
ch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patc=
h
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patc=
h
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patc=
h
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patc=
h
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patc=
h
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.pat=
ch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patc=
h
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patc=
h
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-check=
patch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.pat=
ch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-=
checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-=
fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-=
fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-=
fix-3.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-=
x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sani=
tize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
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
