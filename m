From: akpm@linux-foundation.org
Subject: - drm-i915-only-use-tiled-blits-on-965.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:26:46 -0700
Message-ID: <200807040726.m647Qka7019301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbYGDH06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbarnes@virtuousgeek.org, airlied@linux.ie, keithp@keithp.com, rjw@sisk.pl, tomi@nomi.cz, mm-commits@vger.kernel.org


The patch titled
     DRM/i915: only use tiled blits on 965+
has been removed from the -mm tree.  Its filename was
     drm-i915-only-use-tiled-blits-on-965.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: DRM/i915: only use tiled blits on 965+
From: Jesse Barnes <jbarnes@virtuousgeek.org>

When scheduled swaps occur, we need to blit between front & back buffers. 
If the buffers are tiled, we need to set the appropriate XY_SRC_COPY tile
bit, but only on 965 chips, since it will cause corruption on pre-965
(e.g.  945).

Bug reported by and fix tested by Tomas Janousek.

Reported-by: Tomas Janousek <tomi@nomi.cz>
Tested-by: Tomas Janousek <tomi@nomi.cz>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Keith Packard <keithp@keithp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/i915_irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/drm/i915_irq.c~drm-i915-only-use-tiled-blits-on-965 drivers/char/drm/i915_irq.c
--- a/drivers/char/drm/i915_irq.c~drm-i915-only-use-tiled-blits-on-965
+++ a/drivers/char/drm/i915_irq.c
@@ -62,11 +62,11 @@ static void i915_vblank_tasklet(struct d
 	u32 ropcpp = (0xcc << 16) | ((cpp - 1) << 24);
 	RING_LOCALS;
 
-	if (sarea_priv->front_tiled) {
+	if (IS_I965G(dev) && sarea_priv->front_tiled) {
 		cmd |= XY_SRC_COPY_BLT_DST_TILED;
 		dst_pitch >>= 2;
 	}
-	if (sarea_priv->back_tiled) {
+	if (IS_I965G(dev) && sarea_priv->back_tiled) {
 		cmd |= XY_SRC_COPY_BLT_SRC_TILED;
 		src_pitch >>= 2;
 	}
_

Patches currently in -mm which might be from jbarnes@virtuousgeek.org are

origin.patch
pci-vt3336-cant-do-msi-either.patch
linux-next.patch
x86-pci-use-dev_printk-when-possible.patch

