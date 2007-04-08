From: akpm@linux-foundation.org
Subject: + mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix.patch added to -mm tree
Date: Sun, 08 Apr 2007 13:07:59 -0700
Message-ID: <200704082010.l38KAKdv029539@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbXDHUKc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 8 Apr 2007 16:10:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, bk@suse.de, davej@codemonkey.org.uk


The patch titled
     mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix
has been added to the -mm tree.  Its filename is
     mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix `make headers_check'.

Cc: Andi Kleen <ak@suse.de>
Cc: Bernhard Kaindl <bk@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/main.c |   11 +++++++++++
 include/asm-i386/mtrr.h          |   12 +-----------
 include/asm-x86_64/proto.h       |   12 +-----------
 3 files changed, 13 insertions(+), 22 deletions(-)

diff -puN arch/i386/kernel/smpboot.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix arch/i386/kernel/smpboot.c
diff -puN arch/x86_64/kernel/smpboot.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix arch/x86_64/kernel/smpboot.c
diff -puN include/asm-i386/mtrr.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix include/asm-i386/mtrr.h
--- a/include/asm-i386/mtrr.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix
+++ a/include/asm-i386/mtrr.h
@@ -25,7 +25,6 @@
 
 #include <linux/ioctl.h>
 #include <linux/errno.h>
-#include <linux/smp.h>
 
 #define	MTRR_IOCTL_BASE	'M'
 
@@ -71,16 +70,7 @@ struct mtrr_gentry
 /*  The following functions are for use by other drivers  */
 # ifdef CONFIG_MTRR
 extern void mtrr_save_fixed_ranges(void *);
-/**
- * Save current fixed-range MTRR state of the BSP
- */
-static __inline__ void mtrr_save_state (void)
-{
-	if (smp_processor_id() == 0)
-		mtrr_save_fixed_ranges(NULL);
-	else
-		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
-}
+extern void mtrr_save_state(void);
 extern int mtrr_add (unsigned long base, unsigned long size,
 		     unsigned int type, char increment);
 extern int mtrr_add_page (unsigned long base, unsigned long size,
diff -puN include/asm-x86_64/proto.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix
+++ a/include/asm-x86_64/proto.h
@@ -2,7 +2,6 @@
 #define _ASM_X8664_PROTO_H 1
 
 #include <asm/ldt.h>
-#include <linux/smp.h>
 
 /* misc architecture specific prototypes */
 
@@ -19,16 +18,7 @@ extern void mcheck_init(struct cpuinfo_x
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 extern void mtrr_save_fixed_ranges(void *);
-static __inline__ void mtrr_save_state (void)
-{
-	/*
-	 * Save current fixed-range MTRR state of the BSP:
-	 */
-	if (smp_processor_id() == 0)
-		mtrr_save_fixed_ranges(NULL);
-	else
-		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
-}
+extern void mtrr_save_state(void);
 #else
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
diff -puN arch/i386/kernel/cpu/mtrr/main.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -729,6 +729,17 @@ void mtrr_ap_init(void)
 	local_irq_restore(flags);
 }
 
+/**
+ * Save current fixed-range MTRR state of the BSP
+ */
+void mtrr_save_state(void)
+{
+	if (smp_processor_id() == 0)
+		mtrr_save_fixed_ranges(NULL);
+	else
+		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
+}
+
 static int __init mtrr_init_finialize(void)
 {
 	if (!mtrr_if)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86_64-early-quirks-fix-early_qrk-section-tag.patch
i386-irqbalance_disable-section-fix.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-input-fixup.patch
git-kvm.patch
git-libata-all.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
pata_acpi-restore-driver-fix-2.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
git-ocfs2.patch
git-parisc.patch
git-r8169-fixup.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-git-net.patch
git-wireless-vs-git-net-2.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
fix-x86_64-mm-sched-clock-share.patch
fix-x86_64-mm-fix-amd64-agp-aperture-validation.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix.patch
xfs-clean-up-shrinker-games.patch
pktgen-add-try_to_freeze.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
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
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
undo-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
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
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
