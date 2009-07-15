From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch added to -mm tree
Date: Wed, 15 Jul 2009 14:18:15 -0700
Message-ID: <200907152118.n6FLIFt0022034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbZGOVSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 17:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@linux.intel.com, johnstul@us.ibm.com, mingo@elte.hu, shaohua.li@intel.com, tglx@linutronix.de, wei.chong.tan@intel.com


The patch titled
     arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch

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
Subject: arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#39: FILE: arch/x86/kernel/tsc.c:293:
+		 * how much inb(0x42) MSB is bigger then val when it return from SMI.

WARNING: line over 80 characters
#44: FILE: arch/x86/kernel/tsc.c:298:
+		 * this may skew the average delta variable of quick_pit_calibrate().

total: 0 errors, 2 warnings, 29 lines checked

./patches/arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Chong Tan <wei.chong.tan@intel.com>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/tsc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/x86/kernel/tsc.c~arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes arch/x86/kernel/tsc.c
--- a/arch/x86/kernel/tsc.c~arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes
+++ a/arch/x86/kernel/tsc.c
@@ -285,17 +285,17 @@ static inline int pit_expect_msb(unsigne
 		inb(0x42);
 		if (inb(0x42) != val)
 			break;
-		/* What if an SMI kicks in here when
-		 * count is just slightly over 5 and SMI run long enough
-		 * so that PIT MSB value is way bigger then val?
-		 * Then tscp will have an unreasonably large value,
-		 * since the code has no notion of
-		 * how much inb(0x42) MSB is bigger then val when it return from SMI.
-		 * In addition, since the 2 get_cycles() are near,
-		 * deltap may get a sane value.
-		 * If this happen on the final few readings
-		 * just before (d1+d2 < delta >> 11),
-		 * this may skew the average delta variable of quick_pit_calibrate().
+		/*
+		 * What if an SMI kicks in here when count is just slightly over
+		 * 5 and the SMI run long enough so that PIT MSB value is way
+		 * bigger then val?
+		 * Then tscp will have an unreasonably large value, since the
+		 * code has no notion of how much inb(0x42) MSB is bigger than
+		 * val when it return from SMI.
+		 * In addition, since the 2 get_cycles() are near, deltap may
+		 * get a sane value.  If this happens on the final few readings
+		 * just before (d1+d2 < delta >> 11), this may skew the average
+		 * delta variable of quick_pit_calibrate().
 		 */
 		tsc = get_cycles();
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
include-linux-clocksourceh-coding-style-tweaks.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
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

