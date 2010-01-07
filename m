From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch removed from -mm tree
Date: Thu, 07 Jan 2010 13:10:31 -0800
Message-ID: <201001072110.o07LAVvp017678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022Ab0AGVME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 16:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, airlied@linux.ie, eric@anholt.net, jbarnes@virtuousgeek.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/i915/i915_dma.c: fix unused var
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/i915/i915_dma.c: fix unused var
From: Andrew Morton <akpm@linux-foundation.org>

drivers/gpu/drm/i915/i915_dma.c: In function 'i915_driver_load':
drivers/gpu/drm/i915/i915_dma.c:1114: warning: 'll_base' may be used uninitialized in this function

Partly this is because gcc isn't smart enough.  But `ll_base' does get used
uninitialised in the DRM_DEBUG() call.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_dma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/i915_dma.c~drivers-gpu-drm-i915-i915_dmac-fix-unused-var drivers/gpu/drm/i915/i915_dma.c
--- a/drivers/gpu/drm/i915/i915_dma.c~drivers-gpu-drm-i915-i915_dmac-fix-unused-var
+++ a/drivers/gpu/drm/i915/i915_dma.c
@@ -1117,7 +1117,8 @@ static void i915_setup_compression(struc
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_mm_node *compressed_fb, *compressed_llb;
-	unsigned long cfb_base, ll_base;
+	unsigned long cfb_base;
+	unsigned long ll_base = 0;
 
 	/* Leave 1M for line length buffer & misc. */
 	compressed_fb = drm_mm_search_free(&dev_priv->vram, size, 4096, 0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
kernelh-add-build_bug_on_not_power_of_2-fix.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
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

