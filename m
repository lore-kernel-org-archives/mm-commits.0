From: akpm@linux-foundation.org
Subject: + kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch.patch added to -mm tree
Date: Thu, 30 Jul 2009 03:59:49 -0700
Message-ID: <200907301059.n6UAxnRT011844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012AbZG3LAs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 07:00:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alek.du@intel.com, david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     kernel/irq: export symbols needed by gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver.patch
has been added to the -mm tree.  Its filename is
     kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch.patch

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
Subject: kernel/irq: export symbols needed by gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver.patch
From: Andrew Morton <akpm@linux-foundation.org>

Export symbols needed by
gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver.patch.

Cc: Alek Du <alek.du@intel.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c   |    2 ++
 kernel/irq/handle.c |    1 +
 2 files changed, 3 insertions(+)

diff -puN kernel/irq/handle.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch kernel/irq/handle.c
--- a/kernel/irq/handle.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch
+++ a/kernel/irq/handle.c
@@ -192,6 +192,7 @@ struct irq_desc *irq_to_desc(unsigned in
 
 	return NULL;
 }
+EXPORT_SYMBOL(irq_to_desc);
 
 struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 {
diff -puN kernel/irq/chip.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch kernel/irq/chip.c
--- a/kernel/irq/chip.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch
+++ a/kernel/irq/chip.c
@@ -340,6 +340,7 @@ handle_simple_irq(unsigned int irq, stru
 out_unlock:
 	spin_unlock(&desc->lock);
 }
+EXPORT_SYMBOL(handle_simple_irq);
 
 /**
  *	handle_level_irq - Level type irq handler
@@ -609,6 +610,7 @@ set_irq_chip_and_handler_name(unsigned i
 	set_irq_chip(irq, chip);
 	__set_irq_handler(irq, handle, 0, name);
 }
+EXPORT_SYMBOL(set_irq_chip_and_handler_name);
 
 void __init set_irq_noprobe(unsigned int irq)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-flexible-array-implementation.patch
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
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
include-linux-clocksourceh-coding-style-tweaks.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ummunotify-userspace-support-for-mmu-notifications-cleanup.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch.patch
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

