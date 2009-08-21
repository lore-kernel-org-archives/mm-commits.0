From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 21 Aug 2009 13:51:44 -0700
Message-ID: <200908212051.n7LKpi0T013832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932664AbZHUUwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 16:52:13 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n7LKpjDG029440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2009 13:51:46 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |  133 --------------------------------------
 1 file changed, 133 deletions(-)

diff -puN include/linux/cpumask.h~linux-next-git-rejects include/linux/cpumask.h
--- a/include/linux/cpumask.h~linux-next-git-rejects
+++ a/include/linux/cpumask.h
@@ -3,7 +3,6 @@
 
 /*
  * Cpumasks provide a bitmap suitable for representing the
-<<<<<<< HEAD:include/linux/cpumask.h
  * set of CPU's in a system, one bit position per CPU number.
  *
  * The new cpumask_ ops take a "struct cpumask *"; the old ones
@@ -136,146 +135,14 @@
  *    drivers/block/genhd.c (arch i386, CONFIG_SMP=y).  So use a simple
  *    one-line #define for cpu_isset(), instead of wrapping an inline
  *    inside a macro, the way we do the other calls.
-=======
  * set of CPU's in a system, one bit position per CPU number.  In general,
  * only nr_cpu_ids (<= NR_CPUS) bits are valid.
->>>>>>> FETCH_HEAD:include/linux/cpumask.h
  */
 #include <linux/kernel.h>
 #include <linux/threads.h>
 #include <linux/bitmap.h>
 
 typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
-<<<<<<< HEAD:include/linux/cpumask.h
-extern cpumask_t _unused_cpumask_arg_;
-
-#ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
-#define cpu_set(cpu, dst) __cpu_set((cpu), &(dst))
-static inline void __cpu_set(int cpu, volatile cpumask_t *dstp)
-{
-	set_bit(cpu, dstp->bits);
-}
-
-#define cpu_clear(cpu, dst) __cpu_clear((cpu), &(dst))
-static inline void __cpu_clear(int cpu, volatile cpumask_t *dstp)
-{
-	clear_bit(cpu, dstp->bits);
-}
-
-#define cpus_setall(dst) __cpus_setall(&(dst), NR_CPUS)
-static inline void __cpus_setall(cpumask_t *dstp, int nbits)
-{
-	bitmap_fill(dstp->bits, nbits);
-}
-
-#define cpus_clear(dst) __cpus_clear(&(dst), NR_CPUS)
-static inline void __cpus_clear(cpumask_t *dstp, int nbits)
-{
-	bitmap_zero(dstp->bits, nbits);
-}
-
-/* No static inline type checking - see Subtlety (1) above. */
-#define cpu_isset(cpu, cpumask) test_bit((cpu), (cpumask).bits)
-
-#define cpu_test_and_set(cpu, cpumask) __cpu_test_and_set((cpu), &(cpumask))
-static inline int __cpu_test_and_set(int cpu, cpumask_t *addr)
-{
-	return test_and_set_bit(cpu, addr->bits);
-}
-
-#define cpus_and(dst, src1, src2) __cpus_and(&(dst), &(src1), &(src2), NR_CPUS)
-static inline int __cpus_and(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
-{
-	return bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
-}
-
-#define cpus_or(dst, src1, src2) __cpus_or(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_or(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
-{
-	bitmap_or(dstp->bits, src1p->bits, src2p->bits, nbits);
-}
-
-#define cpus_xor(dst, src1, src2) __cpus_xor(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_xor(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
-{
-	bitmap_xor(dstp->bits, src1p->bits, src2p->bits, nbits);
-}
-
-#define cpus_andnot(dst, src1, src2) \
-				__cpus_andnot(&(dst), &(src1), &(src2), NR_CPUS)
-static inline int __cpus_andnot(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
-{
-	return bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
-}
-
-#define cpus_complement(dst, src) __cpus_complement(&(dst), &(src), NR_CPUS)
-static inline void __cpus_complement(cpumask_t *dstp,
-					const cpumask_t *srcp, int nbits)
-{
-	bitmap_complement(dstp->bits, srcp->bits, nbits);
-}
-
-#define cpus_equal(src1, src2) __cpus_equal(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_equal(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
-{
-	return bitmap_equal(src1p->bits, src2p->bits, nbits);
-}
-
-#define cpus_intersects(src1, src2) __cpus_intersects(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_intersects(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
-{
-	return bitmap_intersects(src1p->bits, src2p->bits, nbits);
-}
-
-#define cpus_subset(src1, src2) __cpus_subset(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_subset(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
-{
-	return bitmap_subset(src1p->bits, src2p->bits, nbits);
-}
-
-#define cpus_empty(src) __cpus_empty(&(src), NR_CPUS)
-static inline int __cpus_empty(const cpumask_t *srcp, int nbits)
-{
-	return bitmap_empty(srcp->bits, nbits);
-}
-
-#define cpus_full(cpumask) __cpus_full(&(cpumask), NR_CPUS)
-static inline int __cpus_full(const cpumask_t *srcp, int nbits)
-{
-	return bitmap_full(srcp->bits, nbits);
-}
-
-#define cpus_weight(cpumask) __cpus_weight(&(cpumask), NR_CPUS)
-static inline int __cpus_weight(const cpumask_t *srcp, int nbits)
-{
-	return bitmap_weight(srcp->bits, nbits);
-}
-
-#define cpus_shift_right(dst, src, n) \
-			__cpus_shift_right(&(dst), &(src), (n), NR_CPUS)
-static inline void __cpus_shift_right(cpumask_t *dstp,
-					const cpumask_t *srcp, int n, int nbits)
-{
-	bitmap_shift_right(dstp->bits, srcp->bits, n, nbits);
-}
-
-#define cpus_shift_left(dst, src, n) \
-			__cpus_shift_left(&(dst), &(src), (n), NR_CPUS)
-static inline void __cpus_shift_left(cpumask_t *dstp,
-					const cpumask_t *srcp, int n, int nbits)
-{
-	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
-}
-#endif /* !CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS */
-=======
->>>>>>> FETCH_HEAD:include/linux/cpumask.h
 
 /**
  * cpumask_bits - get the bits in a cpumask
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-amdc-fix-x86_64-allnoconfig-build.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
video-initial-support-for-adv7180-update-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
leds-gpio-leds-fix-typographics-fault.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch
slram-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
vfs-optimize-touch_time-too.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ummunotify-userspace-support-for-mmu-notifications-v3-fix.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers-checkpatch-fixes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kcore-use-registerd-physmem-information-fix.patch
kcore-use-registerd-physmem-information-checkpatch-fixes.patch
lib-swiotlbc-fix-strange-panic-message-selection-logic-when-swiotlb-fills-up-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

