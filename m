From: akpm@linux-foundation.org
Subject: - x86-bitops-take-an-unsigned-long.patch removed from -mm tree
Date: Tue, 20 May 2008 14:13:58 -0700
Message-ID: <200805202113.m4KLDwjB011418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761338AbYETVO5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:14:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrea@qumranet.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: bitops take an unsigned long *
has been removed from the -mm tree.  Its filename was
     x86-bitops-take-an-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: bitops take an unsigned long *
From: Andrew Morton <akpm@linux-foundation.org>

All (or most) other architectures do this.  So should x86.  Fix.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/bitops.h |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN include/asm-x86/bitops.h~x86-bitops-take-an-unsigned-long include/asm-x86/bitops.h
--- a/include/asm-x86/bitops.h~x86-bitops-take-an-unsigned-long
+++ a/include/asm-x86/bitops.h
@@ -43,7 +43,7 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(int nr, volatile void *addr)
+static inline void set_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile(LOCK_PREFIX "bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
@@ -57,7 +57,7 @@ static inline void set_bit(int nr, volat
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __set_bit(int nr, volatile void *addr)
+static inline void __set_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
@@ -72,7 +72,7 @@ static inline void __set_bit(int nr, vol
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile void *addr)
+static inline void clear_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile(LOCK_PREFIX "btr %1,%0" : ADDR : "Ir" (nr));
 }
@@ -85,13 +85,13 @@ static inline void clear_bit(int nr, vol
  * clear_bit() is atomic and implies release semantics before the memory
  * operation. It can be used for an unlock.
  */
-static inline void clear_bit_unlock(unsigned nr, volatile void *addr)
+static inline void clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
 {
 	barrier();
 	clear_bit(nr, addr);
 }
 
-static inline void __clear_bit(int nr, volatile void *addr)
+static inline void __clear_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
 }
@@ -108,7 +108,7 @@ static inline void __clear_bit(int nr, v
  * No memory barrier is required here, because x86 cannot reorder stores past
  * older loads. Same principle as spin_unlock.
  */
-static inline void __clear_bit_unlock(unsigned nr, volatile void *addr)
+static inline void __clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
 {
 	barrier();
 	__clear_bit(nr, addr);
@@ -126,7 +126,7 @@ static inline void __clear_bit_unlock(un
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __change_bit(int nr, volatile void *addr)
+static inline void __change_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
 }
@@ -140,7 +140,7 @@ static inline void __change_bit(int nr, 
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void change_bit(int nr, volatile void *addr)
+static inline void change_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile(LOCK_PREFIX "btc %1,%0" : ADDR : "Ir" (nr));
 }
@@ -153,7 +153,7 @@ static inline void change_bit(int nr, vo
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_set_bit(int nr, volatile void *addr)
+static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -170,7 +170,7 @@ static inline int test_and_set_bit(int n
  *
  * This is the same as test_and_set_bit on x86.
  */
-static inline int test_and_set_bit_lock(int nr, volatile void *addr)
+static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -184,7 +184,7 @@ static inline int test_and_set_bit_lock(
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_set_bit(int nr, volatile void *addr)
+static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -203,7 +203,7 @@ static inline int __test_and_set_bit(int
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_clear_bit(int nr, volatile void *addr)
+static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -223,7 +223,7 @@ static inline int test_and_clear_bit(int
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_clear_bit(int nr, volatile void *addr)
+static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -235,7 +235,7 @@ static inline int __test_and_clear_bit(i
 }
 
 /* WARNING: non atomic and it can be reordered! */
-static inline int __test_and_change_bit(int nr, volatile void *addr)
+static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -255,7 +255,7 @@ static inline int __test_and_change_bit(
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_change_bit(int nr, volatile void *addr)
+static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -266,13 +266,13 @@ static inline int test_and_change_bit(in
 	return oldbit;
 }
 
-static inline int constant_test_bit(int nr, const volatile void *addr)
+static inline int constant_test_bit(int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
 }
 
-static inline int variable_test_bit(int nr, volatile const void *addr)
+static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
 {
 	int oldbit;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
lguest-use-cpu-capability-accessors.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
git-ubifs.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
sfc-correct-and-expand-some-comments.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
git-vfs-cleanups-reject.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
wireless-airo-waitbusy-wont-delay-checkpatch-fixes.patch
git-xtensa.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes-cleanup.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
spufs-use-the-new-vm_ops-access-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_flush_sem-to-mutex-fix.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
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

