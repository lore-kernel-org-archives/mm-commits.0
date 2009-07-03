From: akpm@linux-foundation.org
Subject: + platform_device_add_data-use-kmemdup.patch added to -mm tree
Date: Fri, 03 Jul 2009 13:07:42 -0700
Message-ID: <200907032007.n63K7gos027935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757179AbZGCUHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jul 2009 16:07:40 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n63K7g8Q004949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 3 Jul 2009 13:07:43 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     platform_device_add_data(): use kmemdup()
has been added to the -mm tree.  Its filename is
     platform_device_add_data-use-kmemdup.patch

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
Subject: platform_device_add_data(): use kmemdup()
From: Andrew Morton <akpm@linux-foundation.org>

Instead of open-coding it.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/base/platform.c~platform_device_add_data-use-kmemdup drivers/base/platform.c
--- a/drivers/base/platform.c~platform_device_add_data-use-kmemdup
+++ a/drivers/base/platform.c
@@ -10,6 +10,7 @@
  * information.
  */
 
+#include <linux/string.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -212,14 +213,13 @@ EXPORT_SYMBOL_GPL(platform_device_add_re
 int platform_device_add_data(struct platform_device *pdev, const void *data,
 			     size_t size)
 {
-	void *d;
+	void *d = kmemdup(data, size, GFP_KERNEL);
 
-	d = kmalloc(size, GFP_KERNEL);
 	if (d) {
-		memcpy(d, data, size);
 		pdev->dev.platform_data = d;
+		return 0;
 	}
-	return d ? 0 : -ENOMEM;
+	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(platform_device_add_data);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sys_sync-fix-16%-performance-regression-in-ffsb-create_4k-test-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
misc-work_on_cpu-acpi-dont-do-local_irq_enable-in-hard-irq.patch
linux-next-temp-hack.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
fix-virt_to_phys-warnings-fix.patch
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
platform_device_add_data-use-kmemdup.patch

