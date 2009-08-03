From: akpm@linux-foundation.org
Subject: [merged] include-linux-clocksourceh-coding-style-tweaks.patch removed from -mm tree
Date: Mon, 03 Aug 2009 12:38:38 -0700
Message-ID: <200908031938.n73Jccf0032631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659AbZHCTjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 15:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, damm@igel.co.jp, johnstul@us.ibm.com, lethal@linux-sh.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     include/linux/clocksource.h: coding-style tweaks
has been removed from the -mm tree.  Its filename was
     include-linux-clocksourceh-coding-style-tweaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/clocksource.h: coding-style tweaks
From: Andrew Morton <akpm@linux-foundation.org>

- Use conventional comment layout

- Remove dubious self-referential pathname from comment.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN include/linux/clocksource.h~include-linux-clocksourceh-coding-style-tweaks include/linux/clocksource.h
--- a/include/linux/clocksource.h~include-linux-clocksourceh-coding-style-tweaks
+++ a/include/linux/clocksource.h
@@ -1,5 +1,4 @@
-/*  linux/include/linux/clocksource.h
- *
+/*
  *  This file contains the structure definitions for clocksources.
  *
  *  If you are not a clocksource, or timekeeping code, you should
@@ -226,7 +225,8 @@ extern struct clocksource *clock;	/* cur
  */
 static inline u32 clocksource_khz2mult(u32 khz, u32 shift_constant)
 {
-	/*  khz = cyc/(Million ns)
+	/*
+	 *  khz = cyc/(Million ns)
 	 *  mult/2^shift  = ns/cyc
 	 *  mult = ns/cyc * 2^shift
 	 *  mult = 1Million/khz * 2^shift
@@ -252,7 +252,8 @@ static inline u32 clocksource_khz2mult(u
  */
 static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
 {
-	/*  hz = cyc/(Billion ns)
+	/*
+	 *  hz = cyc/(Billion ns)
 	 *  mult/2^shift  = ns/cyc
 	 *  mult = ns/cyc * 2^shift
 	 *  mult = 1Billion/hz * 2^shift
@@ -293,7 +294,8 @@ static inline int clocksource_enable(str
 	if (cs->enable)
 		ret = cs->enable(cs);
 
-	/* The frequency may have changed while the clocksource
+	/*
+	 * The frequency may have changed while the clocksource
 	 * was disabled. If so the code in ->enable() must update
 	 * the mult value to reflect the new frequency. Make sure
 	 * mult_orig follows this change.
@@ -313,7 +315,8 @@ static inline int clocksource_enable(str
  */
 static inline void clocksource_disable(struct clocksource *cs)
 {
-	/* Save mult_orig in mult so clocksource_enable() can
+	/*
+	 * Save mult_orig in mult so clocksource_enable() can
 	 * restore the value regardless if ->enable() updates
 	 * the value of mult or not.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-pty-rework-the-pty-layer-to-use-the-normal-buffering-logic.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch
x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board-cleanup.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio-checkpatch-fixes.patch
slram-read-buffer-overflow-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse-fix.patch
scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
vfs-optimize-touch_time-too-fix.patch
watchdog-add-sbc-fitpc2-watchdog-driver-fix.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ummunotify-userspace-support-for-mmu-notifications.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
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

