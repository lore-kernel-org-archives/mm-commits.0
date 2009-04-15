From: akpm@linux-foundation.org
Subject: + pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch added to -mm tree
Date: Tue, 14 Apr 2009 17:08:29 -0700
Message-ID: <200904150008.n3F08TRr011752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbZDOAKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 20:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, den@openvz.org, eric.miao@marvell.com


The patch titled
     pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix
has been added to the -mm tree.  Its filename is
     pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch

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
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
readahead-introduce-context-readahead-algorithm-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
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

