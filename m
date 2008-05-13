From: akpm@linux-foundation.org
Subject: + s390-uninline-spinlock-functions-which-use-smp_processor_id.patch added to -mm tree
Date: Mon, 12 May 2008 23:17:22 -0700
Message-ID: <200805130628.m4D6SNkh028771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756018AbYEMG34 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 02:29:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, heiko.carstens@de.ibm.com, jens.axboe@oracle.com, schwidefsky@de.ibm.com


The patch titled
     s390: uninline spinlock functions which use smp_processor_id()
has been added to the -mm tree.  Its filename is
     s390-uninline-spinlock-functions-which-use-smp_processor_id.patch

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
Subject: s390: uninline spinlock functions which use smp_processor_id()
From: Andrew Morton <akpm@linux-foundation.org>

git-block.patch somehow triggers this:

I don't see why and I don't have time/inclination to unpick the mess.  Just
uninline them.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/Makefile   |    2 -
 arch/s390/kernel/spinlock.c |   37 ++++++++++++++++++++++++++++++++++
 include/asm-s390/spinlock.h |   33 ++----------------------------
 3 files changed, 41 insertions(+), 31 deletions(-)

diff -puN arch/s390/kernel/Makefile~s390-uninline-spinlock-functions-which-use-smp_processor_id arch/s390/kernel/Makefile
--- a/arch/s390/kernel/Makefile~s390-uninline-spinlock-functions-which-use-smp_processor_id
+++ a/arch/s390/kernel/Makefile
@@ -22,7 +22,7 @@ obj-y	+= $(if $(CONFIG_64BIT),reipl64.o,
 extra-y				+= head.o init_task.o vmlinux.lds
 
 obj-$(CONFIG_MODULES)		+= s390_ksyms.o module.o
-obj-$(CONFIG_SMP)		+= smp.o topology.o
+obj-$(CONFIG_SMP)		+= smp.o topology.o spinlock.o
 
 obj-$(CONFIG_AUDIT)		+= audit.o
 compat-obj-$(CONFIG_AUDIT)	+= compat_audit.o
diff -puN /dev/null arch/s390/kernel/spinlock.c
--- /dev/null
+++ a/arch/s390/kernel/spinlock.c
@@ -0,0 +1,37 @@
+
+#include <linux/spinlock.h>
+#include <linux/module.h>
+
+void __raw_spin_lock(raw_spinlock_t *lp)
+{
+	int old;
+
+	old = _raw_compare_and_swap(&lp->owner_cpu, 0, ~smp_processor_id());
+	if (likely(old == 0))
+		return;
+	_raw_spin_lock_wait(lp);
+}
+EXPORT_SYMBOL(__raw_spin_lock);
+
+void __raw_spin_lock_flags(raw_spinlock_t *lp, unsigned long flags)
+{
+	int old;
+
+	old = _raw_compare_and_swap(&lp->owner_cpu, 0, ~smp_processor_id());
+	if (likely(old == 0))
+		return;
+	_raw_spin_lock_wait_flags(lp, flags);
+}
+EXPORT_SYMBOL(__raw_spin_lock_flags);
+
+int __raw_spin_trylock(raw_spinlock_t *lp)
+{
+	int old;
+
+	old = _raw_compare_and_swap(&lp->owner_cpu, 0, ~smp_processor_id());
+	if (likely(old == 0))
+		return 1;
+	return _raw_spin_trylock_retry(lp);
+}
+EXPORT_SYMBOL(__raw_spin_trylock);
+
diff -puN include/asm-s390/spinlock.h~s390-uninline-spinlock-functions-which-use-smp_processor_id include/asm-s390/spinlock.h
--- a/include/asm-s390/spinlock.h~s390-uninline-spinlock-functions-which-use-smp_processor_id
+++ a/include/asm-s390/spinlock.h
@@ -62,36 +62,9 @@ extern void _raw_spin_lock_wait_flags(ra
 extern int _raw_spin_trylock_retry(raw_spinlock_t *);
 extern void _raw_spin_relax(raw_spinlock_t *lock);
 
-static inline void __raw_spin_lock(raw_spinlock_t *lp)
-{
-	int old;
-
-	old = _raw_compare_and_swap(&lp->owner_cpu, 0, ~smp_processor_id());
-	if (likely(old == 0))
-		return;
-	_raw_spin_lock_wait(lp);
-}
-
-static inline void __raw_spin_lock_flags(raw_spinlock_t *lp,
-					 unsigned long flags)
-{
-	int old;
-
-	old = _raw_compare_and_swap(&lp->owner_cpu, 0, ~smp_processor_id());
-	if (likely(old == 0))
-		return;
-	_raw_spin_lock_wait_flags(lp, flags);
-}
-
-static inline int __raw_spin_trylock(raw_spinlock_t *lp)
-{
-	int old;
-
-	old = _raw_compare_and_swap(&lp->owner_cpu, 0, ~smp_processor_id());
-	if (likely(old == 0))
-		return 1;
-	return _raw_spin_trylock_retry(lp);
-}
+void __raw_spin_lock(raw_spinlock_t *lp);
+void __raw_spin_lock_flags(raw_spinlock_t *lp, unsigned long flags);
+int __raw_spin_trylock(raw_spinlock_t *lp);
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lp)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off.patch
fix-hfsplus-oops-on-image-without-extents.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch
atmel_lcdfb-fix-pixclok-divider-calculation.patch
memcg-fix-possible-panic-when-config_mm_owner=y.patch
drivers-char-synclink_gtc-dont-return-an-uninitialised-local.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
ia64-kvm-dont-delete-files-which-we-need.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-early_init_centaur-use-set_cpu_cap.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
audit_send_reply-fix-error-path-memory-leak.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fix-gregkh-driver-core-read-dev_name-instead-of-bus_id.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
git-mmc.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix-2.patch
git-ubifs.patch
hysdn-no-longer-broken-on-smp.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
git-block-ia64-build-fix.patch
git-block-fix-s390-build.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
unionfs-broke.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-i1480-dfu-macc-fix-min-warning.patch
drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion.patch
git-v9fs.patch
revert-git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
git-orion-git-rejects.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
common-implementation-of-iterative-div-mod-fix-2.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
mm-verify-the-page-links-and-memory-model-fix.patch
mm-verify-the-page-links-and-memory-model-fix-fix.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
reiser4-semaphore-fix.patch
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

