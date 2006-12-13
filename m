From: akpm@osdl.org
Subject: - procfs-build-fix.patch removed from -mm tree
Date: Wed, 13 Dec 2006 12:24:16 -0800
Message-ID: <200612132024.kBDKOJKt018819@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38221 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbWLMUYW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 15:24:22 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kBDKOKID023270
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2006 12:24:20 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, torvalds@osdl.org, mm-commits@vger.kernel.org


The patch titled
     procfs build fix
has been removed from the -mm tree.  Its filename was
     procfs-build-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: procfs build fix
From: Andrew Morton <akpm@osdl.org>

Builds fail after mrproper because fs/procfs/proc_misc.c needs compile.h,
which hasn't been made yet.

Compile the new SLES code in init/version.c, after we've created compile.h.

Cc: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/proc_misc.c     |   20 +-------------------
 include/linux/proc_fs.h |    6 ++++++
 init/version.c          |   21 +++++++++++++++++++++
 3 files changed, 28 insertions(+), 19 deletions(-)

diff -puN fs/proc/proc_misc.c~procfs-build-fix fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~procfs-build-fix
+++ a/fs/proc/proc_misc.c
@@ -47,7 +47,6 @@
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
-#include <linux/compile.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -70,7 +69,7 @@ extern int get_exec_domain_list(char *);
 extern int get_dma_list(char *);
 extern int get_locks_status (char *, char **, off_t, int);
 
-static int proc_calc_metrics(char *page, char **start, off_t off,
+int proc_calc_metrics(char *page, char **start, off_t off,
 				 int count, int *eof, int len)
 {
 	if (len <= off+count) *eof = 1;
@@ -249,23 +248,6 @@ static struct file_operations proc_zonei
 	.release	= seq_release,
 };
 
-static int version_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
-{
-	int len;
-
-	/* FIXED STRING! Don't touch! */
-	len = snprintf(page, PAGE_SIZE,
-		"%s version %s"
-		" (" LINUX_COMPILE_BY "@" LINUX_COMPILE_HOST ")"
-		" (" LINUX_COMPILER ")"
-		" %s\n",
-		utsname()->sysname,
-		utsname()->release,
-		utsname()->version);
-	return proc_calc_metrics(page, start, off, count, eof, len);
-}
-
 extern struct seq_operations cpuinfo_op;
 static int cpuinfo_open(struct inode *inode, struct file *file)
 {
diff -puN include/linux/proc_fs.h~procfs-build-fix include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~procfs-build-fix
+++ a/include/linux/proc_fs.h
@@ -275,4 +275,10 @@ struct proc_maps_private {
 #endif
 };
 
+int proc_calc_metrics(char *page, char **start, off_t off,
+				 int count, int *eof, int len);
+
+int version_read_proc(char *page, char **start, off_t off,
+				 int count, int *eof, void *data);
+
 #endif /* _LINUX_PROC_FS_H */
diff -puN init/version.c~procfs-build-fix init/version.c
--- a/init/version.c~procfs-build-fix
+++ a/init/version.c
@@ -13,6 +13,8 @@
 #include <linux/utsrelease.h>
 #include <linux/version.h>
 #include <linux/sched.h>
+#include <linux/proc_fs.h>
+#include <linux/compile.h>
 
 #define version(a) Version_ ## a
 #define version_string(a) version(a)
@@ -33,3 +35,22 @@ struct uts_namespace init_uts_ns = {
 	},
 };
 EXPORT_SYMBOL_GPL(init_uts_ns);
+
+#ifdef CONFIG_PROC_FS
+int version_read_proc(char *page, char **start, off_t off,
+				 int count, int *eof, void *data)
+{
+	int len;
+
+	/* FIXED STRING! Don't touch! */
+	len = snprintf(page, PAGE_SIZE,
+		"%s version %s"
+		" (" LINUX_COMPILE_BY "@" LINUX_COMPILE_HOST ")"
+		" (" LINUX_COMPILER ")"
+		" %s\n",
+		utsname()->sysname,
+		utsname()->release,
+		utsname()->version);
+	return proc_calc_metrics(page, start, off, count, eof, len);
+}
+#endif
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
x86-smp-export-smp_num_siblings-for-oprofile.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support.patch
optimize-o_direct-on-block-device-v3.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
procfs-build-fix.patch
build-compileh-earlier.patch
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
git-drm.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input-vs-git-alsa.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
driver-for-silan-sc92031-netdev-include-fix.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-legacy-resource-fix-tidy.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
fix-gregkh-usb-usb-ehci-hcd-add-shadow-budget-code.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
touchkit-ps-2-touchscreen-driver.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
lumpy-reclaim-v2-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
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

