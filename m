From: akpm@linux-foundation.org
Subject: [folded] revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer-fix.patch removed from -mm tree
Date: Fri, 15 Jan 2010 16:53:53 -0800
Message-ID: <201001160053.o0G0rrTp008496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758113Ab0APAzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Jan 2010 19:55:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ben-linux@fluff.org, broonie@opensource.wolfsonmicro.com, inki.dae@samsung.com, kmpark@infradead.org, krzysztof.h1@poczta.fm, m.szyprowski@samsung.com, stab


The patch titled
     revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer-fix
has been removed from the -mm tree.  Its filename was
     revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer-fix.patch

This patch was dropped because it was folded into revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer-fix
From: Andrew Morton <akpm@linux-foundation.org>

don't revert the correct bit

Cc: <stable@kernel.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/s3c-fb.c~revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer-fix drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer-fix
+++ a/drivers/video/s3c-fb.c
@@ -267,6 +267,7 @@ static int s3c_fb_set_par(struct fb_info
 	struct s3c_fb *sfb = win->parent;
 	void __iomem *regs = sfb->regs;
 	int win_no = win->index;
+	u32 osdc_data = 0;
 	u32 data;
 	u32 pagewidth;
 	int clkdiv;
@@ -359,8 +360,6 @@ static int s3c_fb_set_par(struct fb_info
 
 	data = var->xres * var->yres;
 
-	u32 osdc_data = 0;
-
 	osdc_data = VIDISD14C_ALPHA1_R(0xf) |
 		VIDISD14C_ALPHA1_G(0xf) |
 		VIDISD14C_ALPHA1_B(0xf);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ttyh-make-function-static.patch
revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer.patch
revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
drivers-usb-core-sysfsc-set_reset_quirk-remove-unused-local.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

