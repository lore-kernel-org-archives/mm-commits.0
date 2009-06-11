From: akpm@linux-foundation.org
Subject: [folded] input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors-fix-fix.patch removed from -mm tree
Date: Thu, 11 Jun 2009 16:16:38 -0700
Message-ID: <200906112316.n5BNGdoq015665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbZFKXQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 19:16:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com, dtor@mail.ru, hcegtvedt@atmel.com, jirislaby@gmail.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors-fix-fix
has been removed from the -mm tree.  Its filename was
     input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors-fix-fix.patch

This patch was dropped because it was folded into input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

handle wm97xx_register_mach_ops() failure, spotted by jirislaby@gmail.com.

Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/at32-wm97xx.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/input/touchscreen/at32-wm97xx.c~input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors-fix-fix drivers/input/touchscreen/at32-wm97xx.c
--- a/drivers/input/touchscreen/at32-wm97xx.c~input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors-fix-fix
+++ a/drivers/input/touchscreen/at32-wm97xx.c
@@ -339,13 +339,19 @@ static int __init at32_wm97xx_probe(stru
 			IRQF_SHARED, "at32-wm97xx-ch-b", at32_wm97xx);
 	if (ret) {
 		dev_dbg(&pdev->dev, "could not request ac97c irq\n");
-		kfree(at32_wm97xx);
-		return ret;
+		goto err;
 	}
 
 	platform_set_drvdata(pdev, at32_wm97xx);
 
-	return wm97xx_register_mach_ops(wm, &at32_mach_ops);
+	ret = wm97xx_register_mach_ops(wm, &at32_mach_ops);
+	if (!ret)
+		return 0;
+
+	free_irq(at32_wm97xx->ac97c_irq, at32_wm97xx);
+err:
+	kfree(at32_wm97xx);
+	return ret;
 }
 
 static int __exit at32_wm97xx_remove(struct platform_device *pdev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
ds_selftest-is-borked.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data-cleanup.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch
input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors-fix-fix.patch
e100-add-non-mii-phy-support.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
firmware_map-fix-hang-with-x86-32bit.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool-fix.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
proc-merge-arrayc-into-basec-checkpatch-fixes.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
char-moxa-prevent-opening-unavailable-ports.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
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

