From: akpm@linux-foundation.org
Subject: + i386-uaccess-debugging.patch added to -mm tree
Date: Fri, 27 Apr 2007 13:27:42 -0700
Message-ID: <200704272027.l3RKRgfq006958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757200AbXD0U1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 16:27:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au


The patch titled
     i386 uaccess debugging
has been added to the -mm tree.  Its filename is
     i386-uaccess-debugging.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 uaccess debugging
From: Andrew Morton <akpm@linux-foundation.org>

It's a bug to run uaccess functions while holding mmap_sem.  Make noises.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lib/usercopy.c   |   18 ++++++++++++++++++
 include/asm-i386/uaccess.h |   10 ++++++++++
 2 files changed, 28 insertions(+)

diff -puN include/asm-i386/uaccess.h~i386-uaccess-debugging include/asm-i386/uaccess.h
--- a/include/asm-i386/uaccess.h~i386-uaccess-debugging
+++ a/include/asm-i386/uaccess.h
@@ -33,6 +33,8 @@
 
 #define segment_eq(a,b)	((a).seg == (b).seg)
 
+void no_mmap_sem(void);
+
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
@@ -149,6 +151,7 @@ extern void __get_user_4(void);
 ({	int __ret_gu;							\
 	unsigned long __val_gu;						\
 	__chk_user_ptr(ptr);						\
+	no_mmap_sem();							\
 	switch(sizeof (*(ptr))) {					\
 	case 1:  __get_user_x(1,__ret_gu,__val_gu,ptr); break;		\
 	case 2:  __get_user_x(2,__ret_gu,__val_gu,ptr); break;		\
@@ -198,6 +201,7 @@ extern void __put_user_8(void);
 ({	int __ret_pu;						\
 	__typeof__(*(ptr)) __pu_val;				\
 	__chk_user_ptr(ptr);					\
+	no_mmap_sem();						\
 	__pu_val = x;						\
 	switch(sizeof(*(ptr))) {				\
 	case 1: __put_user_1(__pu_val, ptr); break;		\
@@ -215,6 +219,7 @@ extern void __put_user_8(void);
  	int __ret_pu;						\
 	__typeof__(*(ptr)) __pus_tmp = x;			\
 	__ret_pu=0;						\
+	no+_mmap_sem();						\
 	if(unlikely(__copy_to_user_ll(ptr, &__pus_tmp,		\
 				sizeof(*(ptr))) != 0))		\
  		__ret_pu=-EFAULT;				\
@@ -301,6 +306,7 @@ extern void __put_user_8(void);
 do {									\
 	retval = 0;							\
 	__chk_user_ptr(ptr);						\
+	no_mmap_sem();							\
 	switch (size) {							\
 	case 1: __put_user_asm(x,ptr,retval,"b","b","iq",errret);break;	\
 	case 2: __put_user_asm(x,ptr,retval,"w","w","ir",errret);break; \
@@ -316,6 +322,7 @@ do {									\
 do {									\
 	__typeof__(*(ptr)) __pus_tmp = x;				\
 	retval = 0;							\
+	no_mmap_sem();							\
 									\
 	if(unlikely(__copy_to_user_ll(ptr, &__pus_tmp, size) != 0))	\
 		retval = errret;					\
@@ -361,6 +368,7 @@ extern long __get_user_bad(void);
 do {									\
 	retval = 0;							\
 	__chk_user_ptr(ptr);						\
+	no_mmap_sem();							\
 	switch (size) {							\
 	case 1: __get_user_asm(x,ptr,retval,"b","b","=q",errret);break;	\
 	case 2: __get_user_asm(x,ptr,retval,"w","w","=r",errret);break;	\
@@ -407,6 +415,7 @@ unsigned long __must_check __copy_from_u
 static __always_inline unsigned long __must_check
 __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 {
+	no_mmap_sem();
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
@@ -454,6 +463,7 @@ __copy_from_user_inatomic(void *to, cons
 	 * but as the zeroing behaviour is only significant when n is not
 	 * constant, that shouldn't be a problem.
 	 */
+	no_mmap_sem();
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
diff -puN arch/i386/lib/usercopy.c~i386-uaccess-debugging arch/i386/lib/usercopy.c
--- a/arch/i386/lib/usercopy.c~i386-uaccess-debugging
+++ a/arch/i386/lib/usercopy.c
@@ -717,6 +717,7 @@ unsigned long __copy_to_user_ll(void __u
 				unsigned long n)
 {
 	BUG_ON((long) n < 0);
+	no_mmap_sem();
 #ifndef CONFIG_X86_WP_WORKS_OK
 	if (unlikely(boot_cpu_data.wp_works_ok == 0) &&
 			((unsigned long )to) < TASK_SIZE) {
@@ -786,6 +787,7 @@ unsigned long __copy_from_user_ll(void *
 					unsigned long n)
 {
 	BUG_ON((long)n < 0);
+	no_mmap_sem();
 	if (movsl_is_ok(to, from, n))
 		__copy_user_zeroing(to, from, n);
 	else
@@ -798,6 +800,7 @@ unsigned long __copy_from_user_ll_nozero
 					 unsigned long n)
 {
 	BUG_ON((long)n < 0);
+	no_mmap_sem();
 	if (movsl_is_ok(to, from, n))
 		__copy_user(to, from, n);
 	else
@@ -811,6 +814,7 @@ unsigned long __copy_from_user_ll_nocach
 					unsigned long n)
 {
 	BUG_ON((long)n < 0);
+	no_mmap_sem();
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if ( n > 64 && cpu_has_xmm2)
                 n = __copy_user_zeroing_intel_nocache(to, from, n);
@@ -826,6 +830,7 @@ unsigned long __copy_from_user_ll_nocach
 					unsigned long n)
 {
 	BUG_ON((long)n < 0);
+	no_mmap_sem();
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if ( n > 64 && cpu_has_xmm2)
                 n = __copy_user_intel_nocache(to, from, n);
@@ -887,3 +892,16 @@ copy_from_user(void *to, const void __us
 	return n;
 }
 EXPORT_SYMBOL(copy_from_user);
+
+void no_mmap_sem(void)
+{
+	struct mm_struct *mm;
+
+	if (in_atomic())
+		return;		/* We won't take pagefaults */
+	mm = current->mm;
+	if (!mm)
+		return;
+	WARN_ON(rwsem_is_locked(&mm->mmap_sem))
+}
+EXPORT_SYMBOL(no_mmap_sem);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slab-introduce-krealloc.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-agp-build-fix.patch
git-cpufreq-borkage-fix.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
fix-gregkh-driver-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
define-platform-wakeup-hook-use-in-pci_enable_wake.patch
dev_dbg-check-dev_dbg-arguments.patch
sysfs-binc-printk-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
fix-jdelvare-i2c-i2c-del-driver-returns-void-on-powerpc.patch
git-gfs2-nmw.patch
gfs2-printk-warning-fixes.patch
git-ieee1394.patch
sbp2-include-fixes.patch
fw-device-printk-fix.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-input-fixup.patch
git-kvm.patch
git-libata-all.patch
ata-printk-warning-fixes.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-build-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-mtd-build-fix.patch
git-ubi.patch
git-ubi-fixup.patch
revert-gitpowerpc-ehea-changes.patch
git-netdev-all.patch
reapply-gitpowerpc-ehea-changes.patch
git-netdev-all-export-ieee80211_debug_level.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage-fix.patch
sctp_getsockopt_local_addrs-type-fix.patch
git-net-fix-yamc.patch
irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
rfcomm_worker-fix-wakeup-race.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-ocfs2.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-s390-fixup.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
s390-net-lcs-convert-to-the-kthread-api.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
fix-x86_64-mm-nmi-watchdog-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
x86_64-unexport-cpu_llc_id.patch
xfs-clean-up-shrinker-games.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
smaps-add-clear_refs-file-to-clear-reference.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
slab-mark-set_up_list3s-__init.patch
extend-print_symbol-capability.patch
slub-core.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation-fix.patch
mm-optimize-kill_bdev-fix.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-sparc-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
driver_bfin_serial_core-update.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
enhance-initcall_debug-measure-latency-fix.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
upper-32-bits.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-build-hack.patch
lguest-build-hack-2.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
i386-uaccess-debugging.patch
