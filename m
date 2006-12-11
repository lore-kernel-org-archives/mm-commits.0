From: akpm@osdl.org
Subject: + dont-run-userspace-until-initcalls-have-completed.patch added to -mm tree
Date: Mon, 11 Dec 2006 02:27:51 -0800
Message-ID: <200612111027.kBBARpBS021742@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38736 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762761AbWLKK14 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 05:27:56 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kBBARpID032011
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2006 02:27:54 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org


The patch titled
     dont-run-userspace-until-initcalls-have-completed
has been added to the -mm tree.  Its filename is
     dont-run-userspace-until-initcalls-have-completed.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dont-run-userspace-until-initcalls-have-completed
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-generic/vmlinux.lds.h |    6 +++++-
 include/linux/init.h              |    5 +++++
 init/initramfs.c                  |    3 ++-
 init/main.c                       |    7 -------
 4 files changed, 12 insertions(+), 9 deletions(-)

diff -puN init/main.c~dont-run-userspace-until-initcalls-have-completed init/main.c
--- a/init/main.c~dont-run-userspace-until-initcalls-have-completed
+++ a/init/main.c
@@ -94,7 +94,6 @@ extern void pidmap_init(void);
 extern void prio_tree_init(void);
 extern void radix_tree_init(void);
 extern void free_initmem(void);
-extern void populate_rootfs(void);
 extern void driver_init(void);
 extern void prepare_namespace(void);
 #ifdef	CONFIG_ACPI
@@ -739,12 +738,6 @@ static int init(void * unused)
 
 	cpuset_init_smp();
 
-	/*
-	 * Do this before initcalls, because some drivers want to access
-	 * firmware files.
-	 */
-	populate_rootfs();
-
 	do_basic_setup();
 
 	/*
diff -puN include/linux/init.h~dont-run-userspace-until-initcalls-have-completed include/linux/init.h
--- a/include/linux/init.h~dont-run-userspace-until-initcalls-have-completed
+++ a/include/linux/init.h
@@ -115,6 +115,11 @@ extern void setup_arch(char **);
 #define device_initcall_sync(fn)	__define_initcall("6s",fn,6s)
 #define late_initcall(fn)		__define_initcall("7",fn,7)
 #define late_initcall_sync(fn)		__define_initcall("7s",fn,7s)
+#define populate_rootfs_initcall(fn)	__define_initcall("8",fn,8)
+#define populate_rootfs_initcall_sync(fn) __define_initcall("8s",fn,8s)
+#define rootfs_neeeded_initcall(fn)	__define_initcall("9",fn,9)
+#define rootfs_neeeded_initcall_sync(fn) __define_initcall("9s",fn,9s)
+
 
 #define __initcall(fn) device_initcall(fn)
 
diff -puN include/asm-generic/vmlinux.lds.h~dont-run-userspace-until-initcalls-have-completed include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~dont-run-userspace-until-initcalls-have-completed
+++ a/include/asm-generic/vmlinux.lds.h
@@ -245,5 +245,9 @@
   	*(.initcall6.init)						\
   	*(.initcall6s.init)						\
   	*(.initcall7.init)						\
-  	*(.initcall7s.init)
+  	*(.initcall7s.init)						\
+  	*(.initcall8.init)						\
+  	*(.initcall8s.init)						\
+  	*(.initcall9.init)						\
+  	*(.initcall9s.init)
 
diff -puN init/initramfs.c~dont-run-userspace-until-initcalls-have-completed init/initramfs.c
--- a/init/initramfs.c~dont-run-userspace-until-initcalls-have-completed
+++ a/init/initramfs.c
@@ -526,7 +526,7 @@ static void __init free_initrd(void)
 
 #endif
 
-void __init populate_rootfs(void)
+static int __init populate_rootfs(void)
 {
 	char *err = unpack_to_rootfs(__initramfs_start,
 			 __initramfs_end - __initramfs_start, 0);
@@ -566,3 +566,4 @@ void __init populate_rootfs(void)
 	}
 #endif
 }
+populate_rootfs_initcall(populate_rootfs);
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
x86-smp-export-smp_num_siblings-for-oprofile.patch
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
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
alsa-workqueue-fixes.patch
git-cpufreq-prep.patch
git-cpufreq.patch
git-cpufreq-fixup.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input-vs-git-alsa.patch
git-libata-all-fixup.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-mtd-build-fix.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
driver-for-silan-sc92031-netdev-include-fix.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-net.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-legacy-resource-fix-tidy.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
revert-git-block.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
fix-gregkh-usb-usb-ehci-hcd-add-shadow-budget-code.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
touchkit-ps-2-touchscreen-driver.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
ecryptfs-public-key-packet-management-slab-fix.patch
optimize-o_direct-on-block-device-v3-tweak.patch
add-retain_initrd-boot-option-tweak.patch
lockdep-fix-possible-races-while-disabling-lock-debugging-fix.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
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
slim-main-include-fix.patch
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
squash-ipc-warnings.patch
squash-udf-warnings.patch
dont-run-userspace-until-initcalls-have-completed.patch

