From: akpm@linux-foundation.org
Subject: [withdrawn] drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch removed from -mm tree
Date: Sat, 16 May 2009 15:52:03 -0700
Message-ID: <200905162252.n4GMq3nh012020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755628AbZEPWwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 May 2009 18:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, airlied@linux.ie, eric@anholt.net, hannes@hanneseder.net, linux@youmustbejoking.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/i915/intel_fb.c: remove sysrq-g handler
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/i915/intel_fb.c: remove sysrq-g handler
From: Andrew Morton <akpm@linux-foundation.org>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13130

Just remove this sysrq handler - it's doing various bad things from
hardirq context and clearly isn't used much at all.

Reported-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_fb.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_fb.c~drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler drivers/gpu/drm/i915/intel_fb.c
--- a/drivers/gpu/drm/i915/intel_fb.c~drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler
+++ a/drivers/gpu/drm/i915/intel_fb.c
@@ -31,7 +31,6 @@
 #include <linux/mm.h>
 #include <linux/tty.h>
 #include <linux/slab.h>
-#include <linux/sysrq.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/init.h>
@@ -857,17 +856,6 @@ void intelfb_restore(void)
 	drm_crtc_helper_set_config(&kernelfb_mode);
 }
 
-static void intelfb_sysrq(int dummy1, struct tty_struct *dummy3)
-{
-        intelfb_restore();
-}
-
-static struct sysrq_key_op sysrq_intelfb_restore_op = {
-        .handler = intelfb_sysrq,
-        .help_msg = "force-fb(G)",
-        .action_msg = "Restore framebuffer console",
-};
-
 int intelfb_probe(struct drm_device *dev)
 {
 	int ret;
@@ -898,8 +886,6 @@ int intelfb_probe(struct drm_device *dev
 		ret = intelfb_single_fb_probe(dev);
 	}
 
-	register_sysrq_key('g', &sysrq_intelfb_restore_op);
-
 	return ret;
 }
 EXPORT_SYMBOL(intelfb_probe);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
splice-fix-error-return-code.patch
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
drivers-usb-serial-sierrac-fix-printk-warning.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
revert-fbdev-uninline-lock_fb_info.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
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

