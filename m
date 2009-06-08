From: akpm@linux-foundation.org
Subject: + fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch added to -mm tree
Date: Mon, 08 Jun 2009 16:54:44 -0700
Message-ID: <200906082354.n58NsjcI001383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbZFHXyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 19:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kristoffer.ericson@gmail.com, krzysztof.h1@poczta.fm, rmk@arm.linux.org.uk


The patch titled
     fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch

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
Subject: fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#87: FILE: drivers/video/s1d13xxxfb.c:55:
+#define dbg_blit(fmt, args...) do {printk(KERN_INFO BLIT fmt, ## args); } while(0)

ERROR: space required before the open parenthesis '('
#87: FILE: drivers/video/s1d13xxxfb.c:55:
+#define dbg_blit(fmt, args...) do {printk(KERN_INFO BLIT fmt, ## args); } while(0)

WARNING: line over 80 characters
#283: FILE: drivers/video/s1d13xxxfb.c:522:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_SRC_START1, (src >> 8) & 0x00ff);

WARNING: line over 80 characters
#284: FILE: drivers/video/s1d13xxxfb.c:523:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_SRC_START2, (src >> 16) & 0x00ff);

WARNING: line over 80 characters
#288: FILE: drivers/video/s1d13xxxfb.c:527:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_DST_START1, (dst >> 8) & 0x00ff);

WARNING: line over 80 characters
#289: FILE: drivers/video/s1d13xxxfb.c:528:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_DST_START2, (dst >> 16) & 0x00ff);

WARNING: line over 80 characters
#295: FILE: drivers/video/s1d13xxxfb.c:534:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_HEIGHT0, (height & 0xff) - 1);

WARNING: line over 80 characters
#314: FILE: drivers/video/s1d13xxxfb.c:553:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_MEM_OFF0, (stride >> 1) & 0xff);

WARNING: line over 80 characters
#321: FILE: drivers/video/s1d13xxxfb.c:560:
+	dbg_blit("(copyarea) bpp=%d=0x0%d, mem_offset1=%d, mem_offset2=%d\n", bpp, (bpp >> 1),

WARNING: line over 80 characters
#345: FILE: drivers/video/s1d13xxxfb.c:584:
+s1d13xxxfb_bitblt_solidfill(struct fb_info *info, const struct fb_fillrect *rect)

WARNING: line over 80 characters
#372: FILE: drivers/video/s1d13xxxfb.c:611:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_DST_START1, ((dest >> 8) & 0x00ff));

WARNING: line over 80 characters
#373: FILE: drivers/video/s1d13xxxfb.c:612:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_DST_START2, ((dest >> 16) & 0x00ff));

WARNING: line over 80 characters
#376: FILE: drivers/video/s1d13xxxfb.c:615:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_WIDTH0, ((rect->width) & 0x00ff) - 1);

WARNING: line over 80 characters
#380: FILE: drivers/video/s1d13xxxfb.c:619:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_HEIGHT0, ((rect->height) & 0x00ff) - 1);

WARNING: line over 80 characters
#381: FILE: drivers/video/s1d13xxxfb.c:620:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_HEIGHT1, (rect->height >> 8));

WARNING: line over 80 characters
#387: FILE: drivers/video/s1d13xxxfb.c:626:
+		dbg_blit("(solidfill) pseudo_palette[%d] = %d\n", rect->color, fg);

WARNING: line over 80 characters
#404: FILE: drivers/video/s1d13xxxfb.c:643:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_CTL1, (info->var.bits_per_pixel >> 4));

WARNING: line over 80 characters
#407: FILE: drivers/video/s1d13xxxfb.c:646:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_MEM_OFF0, (screen_stride >> 1) & 0x00ff);

WARNING: line over 80 characters
#408: FILE: drivers/video/s1d13xxxfb.c:647:
+	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_MEM_OFF1, (screen_stride >> 9));

WARNING: line over 80 characters
#458: FILE: drivers/video/s1d13xxxfb.c:922:
+	info->fix.mmio_len = pdev->resource[1].end - pdev->resource[1].start + 1;

WARNING: line over 80 characters
#461: FILE: drivers/video/s1d13xxxfb.c:924:
+	info->fix.smem_len = pdev->resource[0].end - pdev->resource[0].start + 1;

ERROR: switch and case should be at the same indent
#471: FILE: drivers/video/s1d13xxxfb.c:933:
+	switch(prod_id) {
+	    case S1D13506_PROD_ID : /* activate acceleration */

ERROR: space required before the open parenthesis '('
#471: FILE: drivers/video/s1d13xxxfb.c:933:
+	switch(prod_id) {

ERROR: space prohibited before that ':' (ctx:WxW)
#472: FILE: drivers/video/s1d13xxxfb.c:934:
+	    case S1D13506_PROD_ID : /* activate acceleration */
 	                          ^

ERROR: space prohibited before that ':' (ctx:WxE)
#478: FILE: drivers/video/s1d13xxxfb.c:940:
+	    default :
 	            ^

total: 5 errors, 20 warnings, 448 lines checked

./patches/fbdev-s1d13xxxfb-add-accelerated-bitblt-functions.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s1d13xxxfb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/s1d13xxxfb.c~fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes drivers/video/s1d13xxxfb.c
--- a/drivers/video/s1d13xxxfb.c~fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes
+++ a/drivers/video/s1d13xxxfb.c
@@ -52,7 +52,7 @@
  * set this to enable debugging on 2D acceleration
  */
 #if 0
-#define dbg_blit(fmt, args...) do {printk(KERN_INFO BLIT fmt, ## args); } while(0)
+#define dbg_blit(fmt, args...) do { printk(KERN_INFO BLIT fmt, ## args); } while (0)
 #else
 #define dbg_blit(fmt, args...) do { } while (0)
 #endif
@@ -931,13 +931,13 @@ s1d13xxxfb_probe(struct platform_device 
 	info->fbops = &s1d13xxxfb_fbops;
 
 	switch(prod_id) {
-	    case S1D13506_PROD_ID : /* activate acceleration */
+	case S1D13506_PROD_ID:	/* activate acceleration */
 		s1d13xxxfb_fbops.fb_fillrect = s1d13xxxfb_bitblt_solidfill;
 		s1d13xxxfb_fbops.fb_copyarea = s1d13xxxfb_bitblt_copyarea;
 		info->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN |
 			FBINFO_HWACCEL_FILLRECT | FBINFO_HWACCEL_COPYAREA;
 		break;
-	    default :
+	default:
 		break;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
ds_selftest-is-borked.patch
eeepc-laptop-enable-camera-by-default-fix.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data-cleanup.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device-cleanup.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
mtd-flex-onenand-support.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
firmware_map-fix-hang-with-x86-32bit-fix.patch
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
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
gpio-driver-for-primecell-pl061-gpio-controller-fix.patch
gpio-driver-for-primecell-pl061-gpio-controller-fix-fix.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
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

