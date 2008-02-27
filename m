From: akpm@linux-foundation.org
Subject: + ndelay-switch-to-c-function-to-avoid-64-bit-division.patch added to -mm tree
Date: Tue, 26 Feb 2008 22:50:50 -0800
Message-ID: <200802270650.m1R6ooUj030748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909AbYB0Gwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 01:52:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bunk@kernel.org, herbert@gondor.apana.org.au, johnpol@2ka.mipt.ru, mingo@elte.hu, ralf@linux-mips.org, tbm@cyrius.com, tglx@linutronix.de


The patch titled
     ndelay(): switch to C function to avoid 64-bit division
has been added to the -mm tree.  Its filename is
     ndelay-switch-to-c-function-to-avoid-64-bit-division.patch

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
Subject: ndelay(): switch to C function to avoid 64-bit division
From: Andrew Morton <akpm@linux-foundation.org>

We should be able to do ndelay(some_u64), but that can cause a call to
__divdi3() to be emitted because the ndelay() macros does a divide.

Fix it by switching to static inline which will force the u64 arg to be
treated as an unsigned long.  udelay() takes an unsigned long arg.

Cc: Adrian Bunk <bunk@kernel.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Martin Michlmayr <tbm@cyrius.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delay.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN include/linux/delay.h~ndelay-switch-to-c-function-to-avoid-64-bit-division include/linux/delay.h
--- a/include/linux/delay.h~ndelay-switch-to-c-function-to-avoid-64-bit-division
+++ a/include/linux/delay.h
@@ -7,10 +7,12 @@
  * Delay routines, using a pre-computed "loops_per_jiffy" value.
  */
 
-extern unsigned long loops_per_jiffy;
+#include <linux/kernel.h>
 
 #include <asm/delay.h>
 
+extern unsigned long loops_per_jiffy;
+
 /*
  * Using udelay() for intervals greater than a few milliseconds can
  * risk overflow for high loops_per_jiffy (high bogomips) machines. The
@@ -32,7 +34,11 @@ extern unsigned long loops_per_jiffy;
 #endif
 
 #ifndef ndelay
-#define ndelay(x)	udelay(((x)+999)/1000)
+static inline void ndelay(unsigned long x)
+{
+	udelay(DIV_ROUND_UP(x, 1000));
+}
+#define ndelay(x) ndelay(x)
 #endif
 
 void calibrate_delay(void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

rtc-add-support-for-the-s-35390a-rtc-chip.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-sched.patch
tracing-is-borked-on-powerpc.patch
scsi-aic94xx-cleanups.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-x86.patch
git-x86-fixup.patch
git-x86-fix-rejects.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
tridentfb-resource-management-fixes-in-probe-function-fix.patch
add-noinline_for_stack.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
procfs-task-exe-symlink-fix.patch
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
