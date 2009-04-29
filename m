From: akpm@linux-foundation.org
Subject: + mutex-add-atomic_dec_and_mutex_lock-fix.patch added to -mm tree
Date: Wed, 29 Apr 2009 15:59:58 -0700
Message-ID: <200904292318.n3TNIsi6028340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651AbZD2XVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 19:21:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, eparis@redhat.com, hch@lst.de, mingo@elte.hu, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     mutex-add-atomic_dec_and_mutex_lock-fix
has been added to the -mm tree.  Its filename is
     mutex-add-atomic_dec_and_mutex_lock-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mutex-add-atomic_dec_and_mutex_lock-fix
From: Andrew Morton <akpm@linux-foundation.org>

include/linux/mutex.h:136: warning: 'mutex_lock' declared inline after being called
include/linux/mutex.h:136: warning: previous declaration of 'mutex_lock' was here

uninline it.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mutex.h |   24 +-----------------------
 kernel/mutex.c        |   25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 24 deletions(-)

diff -puN include/linux/mutex.h~mutex-add-atomic_dec_and_mutex_lock-fix include/linux/mutex.h
--- a/include/linux/mutex.h~mutex-add-atomic_dec_and_mutex_lock-fix
+++ a/include/linux/mutex.h
@@ -150,28 +150,6 @@ extern int __must_check mutex_lock_killa
  */
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
-
-/**
- * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
- * @cnt: the atomic which we are to dec
- * @lock: the mutex to return holding if we dec to 0
- *
- * return true and hold lock if we dec to 0, return false otherwise
- */
-static inline int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock)
-{
-	/* dec if we can't possibly hit 0 */
-	if (atomic_add_unless(cnt, -1, 1))
-		return 0;
-	/* we might hit 0, so take the lock */
-	mutex_lock(lock);
-	if (!atomic_dec_and_test(cnt)) {
-		/* when we actually did the dec, we didn't hit 0 */
-		mutex_unlock(lock);
-		return 0;
-	}
-	/* we hit 0, and we hold the lock */
-	return 1;
-}
+extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
 #endif
diff -puN kernel/mutex.c~mutex-add-atomic_dec_and_mutex_lock-fix kernel/mutex.c
--- a/kernel/mutex.c~mutex-add-atomic_dec_and_mutex_lock-fix
+++ a/kernel/mutex.c
@@ -473,5 +473,28 @@ int __sched mutex_trylock(struct mutex *
 
 	return ret;
 }
-
 EXPORT_SYMBOL(mutex_trylock);
+
+/**
+ * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
+ * @cnt: the atomic which we are to dec
+ * @lock: the mutex to return holding if we dec to 0
+ *
+ * return true and hold lock if we dec to 0, return false otherwise
+ */
+int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock)
+{
+	/* dec if we can't possibly hit 0 */
+	if (atomic_add_unless(cnt, -1, 1))
+		return 0;
+	/* we might hit 0, so take the lock */
+	mutex_lock(lock);
+	if (!atomic_dec_and_test(cnt)) {
+		/* when we actually did the dec, we didn't hit 0 */
+		mutex_unlock(lock);
+		return 0;
+	}
+	/* we hit 0, and we hold the lock */
+	return 1;
+}
+EXPORT_SYMBOL(atomic_dec_and_mutex_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-close-page_mkwrite-races-try-3.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
forcedeth-add-clock-gating-feature-checkpatch-fixes.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
eliminate-thousands-of-warnings-with-gcc-32-build-cleanup.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-borked-on-non-x86.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
mutex-add-atomic_dec_and_mutex_lock-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

