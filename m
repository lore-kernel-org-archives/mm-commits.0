From: akpm@linux-foundation.org
Subject: + include-linux-clocksourceh-coding-style-tweaks.patch added to -mm tree
Date: Tue, 30 Jun 2009 12:21:56 -0700
Message-ID: <200906301921.n5UJLuxl013405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbZF3TW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 15:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, damm@igel.co.jp, johnstul@us.ibm.com, lethal@linux-sh.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     include/linux/clocksource.h: coding-style tweaks
has been added to the -mm tree.  Its filename is
     include-linux-clocksourceh-coding-style-tweaks.patch

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

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
drivers-usb-serial-ti_usb_3410_5052c-fix-uninitialied-var-warning.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
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
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

