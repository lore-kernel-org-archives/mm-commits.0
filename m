From: akpm@linux-foundation.org
Subject: - kexec-use-a-bitop-for-locking-rather-than-xchg.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:39 -0700
Message-ID: <200808181939.m7IJddFO008346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762669AbYHRTj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, vgoyal@redhat.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     kexec: use a mutex for locking rather than xchg()
has been removed from the -mm tree.  Its filename was
     kexec-use-a-bitop-for-locking-rather-than-xchg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: use a mutex for locking rather than xchg()
From: Andrew Morton <akpm@linux-foundation.org>

Functionally the same, but more conventional.

Cc: Huang Ying <ying.huang@intel.com>
Tested-by: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff -puN kernel/kexec.c~kexec-use-a-bitop-for-locking-rather-than-xchg kernel/kexec.c
--- a/kernel/kexec.c~kexec-use-a-bitop-for-locking-rather-than-xchg
+++ a/kernel/kexec.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/kexec.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
 #include <linux/syscalls.h>
@@ -924,19 +924,14 @@ static int kimage_load_segment(struct ki
  */
 struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
-/*
- * A home grown binary mutex.
- * Nothing can wait so this mutex is safe to use
- * in interrupt context :)
- */
-static int kexec_lock;
+
+static DEFINE_MUTEX(kexec_mutex);
 
 asmlinkage long sys_kexec_load(unsigned long entry, unsigned long nr_segments,
 				struct kexec_segment __user *segments,
 				unsigned long flags)
 {
 	struct kimage **dest_image, *image;
-	int locked;
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
@@ -972,8 +967,7 @@ asmlinkage long sys_kexec_load(unsigned 
 	 *
 	 * KISS: always take the mutex.
 	 */
-	locked = xchg(&kexec_lock, 1);
-	if (locked)
+	if (!mutex_trylock(&kexec_mutex))
 		return -EBUSY;
 
 	dest_image = &kexec_image;
@@ -1015,8 +1009,7 @@ asmlinkage long sys_kexec_load(unsigned 
 	image = xchg(dest_image, image);
 
 out:
-	locked = xchg(&kexec_lock, 0); /* Release the mutex */
-	BUG_ON(!locked);
+	mutex_unlock(&kexec_mutex);
 	kimage_free(image);
 
 	return result;
@@ -1063,10 +1056,7 @@ asmlinkage long compat_sys_kexec_load(un
 
 void crash_kexec(struct pt_regs *regs)
 {
-	int locked;
-
-
-	/* Take the kexec_lock here to prevent sys_kexec_load
+	/* Take the kexec_mutex here to prevent sys_kexec_load
 	 * running on one cpu from replacing the crash kernel
 	 * we are using after a panic on a different cpu.
 	 *
@@ -1074,8 +1064,7 @@ void crash_kexec(struct pt_regs *regs)
 	 * of memory the xchg(&kexec_crash_image) would be
 	 * sufficient.  But since I reuse the memory...
 	 */
-	locked = xchg(&kexec_lock, 1);
-	if (!locked) {
+	if (mutex_trylock(&kexec_mutex)) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 			crash_setup_regs(&fixed_regs, regs);
@@ -1083,8 +1072,7 @@ void crash_kexec(struct pt_regs *regs)
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
-		locked = xchg(&kexec_lock, 0);
-		BUG_ON(!locked);
+		mutex_unlock(&kexec_mutex);
 	}
 }
 
@@ -1434,7 +1422,7 @@ int kernel_kexec(void)
 {
 	int error = 0;
 
-	if (xchg(&kexec_lock, 1))
+	if (!mutex_trylock(&kexec_mutex))
 		return -EBUSY;
 	if (!kexec_image) {
 		error = -EINVAL;
@@ -1498,8 +1486,6 @@ int kernel_kexec(void)
 #endif
 
  Unlock:
-	if (!xchg(&kexec_lock, 0))
-		BUG();
-
+	mutex_unlock(&kexec_mutex);
 	return error;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
drivers-ata-pata_it821xc-fix-warning.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-tweaks.patch
ftrace-printk-formatting-infrastructure.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-watchdog.patch
git-xtensa.patch
drivers-char-ipmi-ipmi_si_intfc-default_find_bmc-fix-leak.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
h8300-generic_bug-support-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

