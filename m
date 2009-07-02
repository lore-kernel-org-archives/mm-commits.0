From: akpm@linux-foundation.org
Subject: + misc-work_on_cpu-acpi-dont-do-local_irq_enable-in-hard-irq.patch added to -mm tree
Date: Thu, 02 Jul 2009 12:50:38 -0700
Message-ID: <200907021950.n62JocWf007404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbZGBTvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 15:51:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, lenb@kernel.org, rusty@rustcorp.com.au


The patch titled
     "misc:work_on_cpu-acpi": don't do local_irq_enable() in hard IRQ
has been added to the -mm tree.  Its filename is
     misc-work_on_cpu-acpi-dont-do-local_irq_enable-in-hard-irq.patch

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
Subject: "misc:work_on_cpu-acpi": don't do local_irq_enable() in hard IRQ
From: Andrew Morton <akpm@linux-foundation.org>

Reported-by: <Valdis.Kletnieks@vt.edu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~misc-work_on_cpu-acpi-dont-do-local_irq_enable-in-hard-irq drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~misc-work_on_cpu-acpi-dont-do-local_irq_enable-in-hard-irq
+++ a/drivers/acpi/processor_throttling.c
@@ -616,6 +616,8 @@ static int acpi_processor_get_throttling
 	u32 duty_mask = 0;
 	u32 duty_value = 0;
 
+	WARN_ON_ONCE(!irqs_disabled());
+
 	if (!pr)
 		return -EINVAL;
 
@@ -628,8 +630,6 @@ static int acpi_processor_get_throttling
 
 	duty_mask <<= pr->throttling.duty_offset;
 
-	local_irq_disable();
-
 	value = inl(pr->throttling.address);
 
 	/*
@@ -646,8 +646,6 @@ static int acpi_processor_get_throttling
 
 	pr->throttling.state = state;
 
-	local_irq_enable();
-
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			  "Throttling state is T%d (%d%% throttling applied)\n",
 			  state, pr->throttling.states[state].performance));
@@ -919,6 +917,8 @@ static int acpi_processor_set_throttling
 	u32 duty_mask = 0;
 	u32 duty_value = 0;
 
+	WARN_ON_ONCE(!irqs_disabled());
+
 	if (!pr)
 		return -EINVAL;
 
@@ -948,8 +948,6 @@ static int acpi_processor_set_throttling
 		duty_mask = ~duty_mask;
 	}
 
-	local_irq_disable();
-
 	/*
 	 * Disable throttling by writing a 0 to bit 4.  Note that we must
 	 * turn it off before you can change the duty_value.
@@ -975,8 +973,6 @@ static int acpi_processor_set_throttling
 
 	pr->throttling.state = state;
 
-	local_irq_enable();
-
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			  "Throttling state set to T%d (%d%%)\n", state,
 			  (pr->throttling.states[state].performance ? pr->
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
misc-work_on_cpu-acpi-dont-do-local_irq_enable-in-hard-irq.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
sys_sync-fix-16%-performance-regression-in-ffsb-create_4k-test-fix.patch
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
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
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

