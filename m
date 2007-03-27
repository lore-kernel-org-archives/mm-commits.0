From: akpm@linux-foundation.org
Subject: + add-support-for-deferrable-timers-respun-tidy.patch added to -mm tree
Date: Tue, 27 Mar 2007 13:56:30 -0700
Message-ID: <200703272056.l2RKuUQY027571@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42756 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934208AbXC0U4x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 16:56:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davej@codemonkey.org.uk, mingo@elte.hu, oleg@tv-sign.ru, tglx@linutronix.de, venkatesh.pallipadi@intel.com


The patch titled
     add-support-for-deferrable-timers-respun-tidy
has been added to the -mm tree.  Its filename is
     add-support-for-deferrable-timers-respun-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-support-for-deferrable-timers-respun-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Privatise this #define

Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |    6 ------
 kernel/timer.c        |    7 +++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN include/linux/timer.h~add-support-for-deferrable-timers-respun-tidy include/linux/timer.h
--- a/include/linux/timer.h~add-support-for-deferrable-timers-respun-tidy
+++ a/include/linux/timer.h
@@ -9,12 +9,6 @@
 struct tvec_t_base_s;
 
 extern struct tvec_t_base_s boot_tvec_bases;
-/*
- * Note that all tvec_bases is 2 byte aligned and lower bit of
- * base in timer_list is guaranteed to be zero. Use the LSB for
- * the new flag to indicate whether the timer is deferrable
- */
-#define TBASE_DEFERRABLE_FLAG		(0x1)
 
 struct timer_list {
 	struct list_head entry;
diff -puN kernel/timer.c~add-support-for-deferrable-timers-respun-tidy kernel/timer.c
--- a/kernel/timer.c~add-support-for-deferrable-timers-respun-tidy
+++ a/kernel/timer.c
@@ -48,6 +48,13 @@ u64 jiffies_64 __cacheline_aligned_in_sm
 EXPORT_SYMBOL(jiffies_64);
 
 /*
+ * Note that all tvec_bases is 2 byte aligned and lower bit of base in
+ * timer_list is guaranteed to be zero. Use the LSB for the new flag to
+ * indicate whether the timer is deferrable
+ */
+#define TBASE_DEFERRABLE_FLAG		(0x1)
+
+/*
  * per-CPU timer vector definitions:
  */
 #define TVN_BITS (CONFIG_BASE_SMALL ? 4 : 6)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-ieee1394-vs-gregkh-driver-driver-core-use-attribute-groups-in-struct-device_type.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-ubi.patch
git-netdev-all.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-piggy-bus.patch
fix-gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch
git-pciseg.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
add-support-for-deferrable-timers-respun-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
mm-only-hrtimers-debug-patch-fix.patch
