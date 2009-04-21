From: akpm@linux-foundation.org
Subject: [folded] pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch removed from -mm tree
Date: Tue, 21 Apr 2009 12:22:21 -0700
Message-ID: <200904211922.n3LJMLfr015192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbZDUTYc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 15:24:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, den@openvz.org, eric.miao@marvell.com, mm-commits@vger.kernel.org


The patch titled
     pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix
has been removed from the -mm tree.  Its filename was
     pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch

This patch was dropped because it was folded into pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix
From: Andrew Morton <akpm@linux-foundation.org>

save an ifdef

Cc: Denis V. Lunev <den@openvz.org>
Cc: Eric Miao <eric.miao@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix
+++ a/drivers/video/pxafb.c
@@ -1440,9 +1440,6 @@ static irqreturn_t pxafb_handle_irq(int 
 {
 	struct pxafb_info *fbi = dev_id;
 	unsigned int lccr0, lcsr;
-#ifdef CONFIG_FB_PXA_OVERLAY
-	unsigned int lcsr1;
-#endif
 
 	lcsr = lcd_readl(fbi, LCSR);
 	if (lcsr & LCSR_LDD) {
@@ -1458,14 +1455,16 @@ static irqreturn_t pxafb_handle_irq(int 
 	lcd_writel(fbi, LCSR, lcsr);
 
 #ifdef CONFIG_FB_PXA_OVERLAY
-	lcsr1 = lcd_readl(fbi, LCSR1);
-	if (lcsr1 & LCSR1_BS(1))
-		complete(&fbi->overlay[0].branch_done);
+	{
+		unsigned int lcsr1 = lcd_readl(fbi, LCSR1);
+		if (lcsr1 & LCSR1_BS(1))
+			complete(&fbi->overlay[0].branch_done);
 
-	if (lcsr1 & LCSR1_BS(2))
-		complete(&fbi->overlay[1].branch_done);
+		if (lcsr1 & LCSR1_BS(2))
+			complete(&fbi->overlay[1].branch_done);
 
-	lcd_writel(fbi, LCSR1, lcsr1);
+		lcd_writel(fbi, LCSR1, lcsr1);
+	}
 #endif
 	return IRQ_HANDLED;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
clocksource-pass-clocksource-to-read-callback.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
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

