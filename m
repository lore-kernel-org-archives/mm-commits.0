From: akpm@linux-foundation.org
Subject: + x86-bitops-take-an-unsigned-long.patch added to -mm tree
Date: Thu, 08 May 2008 21:18:17 -0700
Message-ID: <200805090418.m494IHBb021663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbYEIESh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 00:18:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andrea@qumranet.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: bitops take an unsigned long *
has been added to the -mm tree.  Its filename is
     x86-bitops-take-an-unsigned-long.patch

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
Subject: x86: bitops take an unsigned long *
From: Andrew Morton <akpm@linux-foundation.org>

All (or most) other architectures do this.  Fix x86.

(lol, trollpatch)

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
@@ -46,7 +46,7 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(int nr, volatile void *addr)
+static inline void set_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile(LOCK_PREFIX "bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
@@ -60,7 +60,7 @@ static inline void set_bit(int nr, volat
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __set_bit(int nr, volatile void *addr)
+static inline void __set_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
@@ -75,7 +75,7 @@ static inline void __set_bit(int nr, vol
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile void *addr)
+static inline void clear_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile(LOCK_PREFIX "btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
 }
@@ -88,13 +88,13 @@ static inline void clear_bit(int nr, vol
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
 	asm volatile("btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
 }
@@ -111,7 +111,7 @@ static inline void __clear_bit(int nr, v
  * No memory barrier is required here, because x86 cannot reorder stores past
  * older loads. Same principle as spin_unlock.
  */
-static inline void __clear_bit_unlock(unsigned nr, volatile void *addr)
+static inline void __clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
 {
 	barrier();
 	__clear_bit(nr, addr);
@@ -129,7 +129,7 @@ static inline void __clear_bit_unlock(un
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __change_bit(int nr, volatile void *addr)
+static inline void __change_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile("btc %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
 }
@@ -143,7 +143,7 @@ static inline void __change_bit(int nr, 
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void change_bit(int nr, volatile void *addr)
+static inline void change_bit(int nr, volatile unsigned long *addr)
 {
 	asm volatile(LOCK_PREFIX "btc %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
 }
@@ -156,7 +156,7 @@ static inline void change_bit(int nr, vo
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_set_bit(int nr, volatile void *addr)
+static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -173,7 +173,7 @@ static inline int test_and_set_bit(int n
  *
  * This is the same as test_and_set_bit on x86.
  */
-static inline int test_and_set_bit_lock(int nr, volatile void *addr)
+static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -187,7 +187,7 @@ static inline int test_and_set_bit_lock(
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_set_bit(int nr, volatile void *addr)
+static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -205,7 +205,7 @@ static inline int __test_and_set_bit(int
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_clear_bit(int nr, volatile void *addr)
+static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -225,7 +225,7 @@ static inline int test_and_clear_bit(int
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_clear_bit(int nr, volatile void *addr)
+static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -236,7 +236,7 @@ static inline int __test_and_clear_bit(i
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
sxc-fix-printk-warnings-on-sparc32.patch
drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
fix-hfsplus-oops-on-image-without-extents-fix.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
atmel_lcdfb-fix-pixclok-divider-calculation-checkpatch-fixes.patch
memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch
mm-define-default-cpu_to_node-checkpatch-fixes.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-vt-fix-background-color-on-line-feed.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86.patch
git-x86-fixup.patch
arch-x86-kernel-setupc-printk-warning-fix.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fix-driver-core-prepare-for-removal-of-20-char-limit-from-struct-device.patch
i2c-renesas-highlander-fpga-smbus-support.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-fix.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
git-jg-misc-git-rejects.patch
revert-git-kbuild.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
revert-git-block.patch
git-unionfs.patch
git-unionfs-fixup.patch
unionfs-broke.patch
git-logfs-fixup.patch
logfs-unbork.patch
logfs-is-busted.patch
drivers-usb-core-sysfsc-fix-types.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
git-v9fs.patch
revert-git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
common-implementation-of-iterative-div-mod-fix-2.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-inotify_init-fix.patch
hysdn-no-longer-broken-on-smp.patch
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
x86-bitops-take-an-unsigned-long.patch

