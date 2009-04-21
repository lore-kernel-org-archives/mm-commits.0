From: akpm@linux-foundation.org
Subject: + drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch added to -mm tree
Date: Mon, 20 Apr 2009 17:14:05 -0700
Message-ID: <200904210014.n3L0E5J4023817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754822AbZDUART (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 20:17:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie, eric@anholt.net, hannes@hanneseder.net, linux@youmustbejoking.demon.co.uk


The patch titled
     drivers/gpu/drm/i915/intel_fb.c: remove sysrq-g handler
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch

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
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
clocksource-pass-clocksource-to-read-callback.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch

