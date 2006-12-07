From: akpm@osdl.org
Subject: - include-asm-cris-extern-inline-static-inline.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:25 -0800
Message-ID: <200612072316.kB7NGPLj030834@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54127 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163967AbWLGXTm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     include/asm-cris/: "extern inline" -> "static inline"
has been removed from the -mm tree.  Its filename was
     include-asm-cris-extern-inline-static-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: include/asm-cris/: "extern inline" -> "static inline"
From: Adrian Bunk <bunk@stusta.de>

"extern inline" generates a warning with -Wmissing-prototypes and I'm
currently working on getting the kernel cleaned up for adding this to the
CFLAGS since it will help us to avoid a nasty class of runtime errors.

If there are places that really need a forced inline, __always_inline would be
the correct solution.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-cris/arch-v10/bitops.h  |   10 +++++-----
 include/asm-cris/semaphore-helper.h |    8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/asm-cris/arch-v10/bitops.h~include-asm-cris-extern-inline-static-inline include/asm-cris/arch-v10/bitops.h
--- a/include/asm-cris/arch-v10/bitops.h~include-asm-cris-extern-inline-static-inline
+++ a/include/asm-cris/arch-v10/bitops.h
@@ -10,7 +10,7 @@
  * number.  They differ in that the first function also inverts all bits
  * in the input.
  */
-extern inline unsigned long cris_swapnwbrlz(unsigned long w)
+static inline unsigned long cris_swapnwbrlz(unsigned long w)
 {
 	/* Let's just say we return the result in the same register as the
 	   input.  Saying we clobber the input but can return the result
@@ -26,7 +26,7 @@ extern inline unsigned long cris_swapnwb
 	return res;
 }
 
-extern inline unsigned long cris_swapwbrlz(unsigned long w)
+static inline unsigned long cris_swapwbrlz(unsigned long w)
 {
 	unsigned res;
 	__asm__ ("swapwbr %0 \n\t"
@@ -40,7 +40,7 @@ extern inline unsigned long cris_swapwbr
  * ffz = Find First Zero in word. Undefined if no zero exists,
  * so code should check against ~0UL first..
  */
-extern inline unsigned long ffz(unsigned long w)
+static inline unsigned long ffz(unsigned long w)
 {
 	return cris_swapnwbrlz(w);
 }
@@ -51,7 +51,7 @@ extern inline unsigned long ffz(unsigned
  *
  * Undefined if no bit exists, so code should check against 0 first.
  */
-extern inline unsigned long __ffs(unsigned long word)
+static inline unsigned long __ffs(unsigned long word)
 {
 	return cris_swapnwbrlz(~word);
 }
@@ -65,7 +65,7 @@ extern inline unsigned long __ffs(unsign
  * differs in spirit from the above ffz (man ffs).
  */
 
-extern inline unsigned long kernel_ffs(unsigned long w)
+static inline unsigned long kernel_ffs(unsigned long w)
 {
 	return w ? cris_swapwbrlz (w) + 1 : 0;
 }
diff -puN include/asm-cris/semaphore-helper.h~include-asm-cris-extern-inline-static-inline include/asm-cris/semaphore-helper.h
--- a/include/asm-cris/semaphore-helper.h~include-asm-cris-extern-inline-static-inline
+++ a/include/asm-cris/semaphore-helper.h
@@ -20,12 +20,12 @@
 /*
  * These two _must_ execute atomically wrt each other.
  */
-extern inline void wake_one_more(struct semaphore * sem)
+static inline void wake_one_more(struct semaphore * sem)
 {
 	atomic_inc(&sem->waking);
 }
 
-extern inline int waking_non_zero(struct semaphore *sem)
+static inline int waking_non_zero(struct semaphore *sem)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -40,7 +40,7 @@ extern inline int waking_non_zero(struct
 	return ret;
 }
 
-extern inline int waking_non_zero_interruptible(struct semaphore *sem,
+static inline int waking_non_zero_interruptible(struct semaphore *sem,
 						struct task_struct *tsk)
 {
 	int ret = 0;
@@ -59,7 +59,7 @@ extern inline int waking_non_zero_interr
 	return ret;
 }
 
-extern inline int waking_non_zero_trylock(struct semaphore *sem)
+static inline int waking_non_zero_trylock(struct semaphore *sem)
 {
         int ret = 1;
 	unsigned long flags;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

