From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 01 Apr 2010 11:05:50 -0400
Message-ID: <201004011807.o31I728P000611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab0DASHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 14:07:33 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o31I73p5030310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 1 Apr 2010 11:07:04 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/radeon.h      |    6 ------
 drivers/gpu/drm/radeon/radeon_asic.c |    4 ----
 drivers/gpu/drm/radeon/radeon_drv.c  |    6 ------
 drivers/gpu/drm/radeon/rv770.c       |    7 -------
 4 files changed, 23 deletions(-)

diff -puN drivers/gpu/drm/radeon/radeon.h~linux-next-git-rejects drivers/gpu/drm/radeon/radeon.h
--- a/drivers/gpu/drm/radeon/radeon.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/radeon/radeon.h
@@ -91,10 +91,7 @@ extern int radeon_tv;
 extern int radeon_new_pll;
 extern int radeon_dynpm;
 extern int radeon_audio;
-<<<<<<< HEAD
 extern int radeon_disp_priority;
-=======
->>>>>>> FETCH_HEAD
 extern int radeon_hw_i2c;
 
 /*
@@ -1201,10 +1198,7 @@ extern int radeon_modeset_init(struct ra
 extern void radeon_modeset_fini(struct radeon_device *rdev);
 extern bool radeon_card_posted(struct radeon_device *rdev);
 extern void radeon_update_bandwidth_info(struct radeon_device *rdev);
-<<<<<<< HEAD
 extern void radeon_update_display_priority(struct radeon_device *rdev);
-=======
->>>>>>> FETCH_HEAD
 extern bool radeon_boot_test_post_card(struct radeon_device *rdev);
 extern int radeon_clocks_init(struct radeon_device *rdev);
 extern void radeon_clocks_fini(struct radeon_device *rdev);
diff -puN drivers/gpu/drm/radeon/radeon_asic.c~linux-next-git-rejects drivers/gpu/drm/radeon/radeon_asic.c
--- a/drivers/gpu/drm/radeon/radeon_asic.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/radeon/radeon_asic.c
@@ -561,12 +561,8 @@ static struct radeon_asic rs780_asic = {
 	.resume = &r600_resume,
 	.cp_commit = &r600_cp_commit,
 	.vga_set_state = &r600_vga_set_state,
-<<<<<<< HEAD
-	.gpu_reset = &r600_gpu_reset,
-=======
 	.gpu_is_lockup = &r600_gpu_is_lockup,
 	.asic_reset = &r600_asic_reset,
->>>>>>> FETCH_HEAD
 	.gart_tlb_flush = &r600_pcie_gart_tlb_flush,
 	.gart_set_page = &rs600_gart_set_page,
 	.ring_test = &r600_ring_test,
diff -puN drivers/gpu/drm/radeon/radeon_drv.c~linux-next-git-rejects drivers/gpu/drm/radeon/radeon_drv.c
--- a/drivers/gpu/drm/radeon/radeon_drv.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/radeon/radeon_drv.c
@@ -92,10 +92,7 @@ int radeon_tv = 1;
 int radeon_new_pll = -1;
 int radeon_dynpm = -1;
 int radeon_audio = 1;
-<<<<<<< HEAD
 int radeon_disp_priority = 0;
-=======
->>>>>>> FETCH_HEAD
 int radeon_hw_i2c = 0;
 
 MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers");
@@ -140,12 +137,9 @@ module_param_named(dynpm, radeon_dynpm, 
 MODULE_PARM_DESC(audio, "Audio enable (0 = disable)");
 module_param_named(audio, radeon_audio, int, 0444);
 
-<<<<<<< HEAD
 MODULE_PARM_DESC(disp_priority, "Display Priority (0 = auto, 1 = normal, 2 = high)");
 module_param_named(disp_priority, radeon_disp_priority, int, 0444);
 
-=======
->>>>>>> FETCH_HEAD
 MODULE_PARM_DESC(hw_i2c, "hw i2c engine enable (0 = disable)");
 module_param_named(hw_i2c, radeon_hw_i2c, int, 0444);
 
diff -puN drivers/gpu/drm/radeon/rv770.c~linux-next-git-rejects drivers/gpu/drm/radeon/rv770.c
--- a/drivers/gpu/drm/radeon/rv770.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/radeon/rv770.c
@@ -913,13 +913,6 @@ int rv770_mc_init(struct radeon_device *
 	}
 	r600_vram_gtt_location(rdev, &rdev->mc);
 	radeon_update_bandwidth_info(rdev);
-<<<<<<< HEAD
-
-	return 0;
-}
-=======
->>>>>>> FETCH_HEAD
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
exit-fix-oops-in-sync_mm_rss-fix.patch
ratelimit-annotate-___ratelimit-fix.patch
rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915-checkpatch-fixes.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

