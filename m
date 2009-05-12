From: akpm@linux-foundation.org
Subject: [obsolete] leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch removed from -mm tree
Date: Tue, 12 May 2009 14:31:43 -0700
Message-ID: <200905122131.n4CLVh2x026488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595AbZELVgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 17:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, grant.likely@secretlab.ca, rpurdie@linux.intel.com, smaclennan@pikatech.com, tpiepho@freescale.com, mm-commits@vger.kernel.org


The patch titled
     leds: of_register_platform_driver() doesn't exist on sparc64
has been removed from the -mm tree.  Its filename was
     leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: of_register_platform_driver() doesn't exist on sparc64
From: Andrew Morton <akpm@linux-foundation.org>

drivers/leds/leds-gpio.c: In function `gpio_led_init':
drivers/leds/leds-gpio.c:295: error: implicit declaration of function `of_register_platform_driver'
drivers/leds/leds-gpio.c: In function `gpio_led_exit':
drivers/leds/leds-gpio.c:311: error: implicit declaration of function `of_unregister_platform_driver'

So fix this by disabling CONFIG_LEDS_GPIO_OF on non-powerpc architectures.

Cc: Sean MacLennan <smaclennan@pikatech.com>
Cc: Trent Piepho <tpiepho@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/leds/Kconfig~leds-of_register_platform_driver-doesnt-exist-on-sparc64 drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-of_register_platform_driver-doesnt-exist-on-sparc64
+++ a/drivers/leds/Kconfig
@@ -139,6 +139,7 @@ config LEDS_GPIO_PLATFORM
 config LEDS_GPIO_OF
 	bool "OpenFirmware platform device bindings for GPIO LEDs"
 	depends on LEDS_GPIO && OF_DEVICE
+	depends on !SPARC64
 	default y
 	help
 	  Let the leds-gpio driver drive LEDs which have been defined as
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

alpha-unbreak-percpu-again.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-keyboard-introduce-lm8323-driver.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
revert-fbdev-uninline-lock_fb_info.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
fs-sysfs-filec-use-create_singlethread_workqueue.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

