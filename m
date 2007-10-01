From: akpm@linux-foundation.org
Subject: - i915-make-vbl-interrupts-work-properly-on-i965g-gm.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:13:43 -0700
Message-ID: <200710010713.l917Dhu1004466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbXJAHNw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:13:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, jesse.barnes@intel.com, mm-commits@vger.kernel.org


The patch titled
     i915: make vbl interrupts work properly on i965g/gm
has been removed from the -mm tree.  Its filename was
     i915-make-vbl-interrupts-work-properly-on-i965g-gm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i915: make vbl interrupts work properly on i965g/gm
From: Dave Airlie <airlied@linux.ie>

This code is ported from the DRM git tree and allows the vblank interrupts to
function on the i965 hw.  It also requires a change in Mesa's 965 driver to
actually use them.

Signed-off-by: Dave Airlie <airlied@linux.ie>
Acked-by:  Jesse Barnes <jesse.barnes@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/drm/i915_drv.h~i915-make-vbl-interrupts-work-properly-on-i965g-gm drivers/char/drm/i915_drv.h
--- a/drivers/char/drm/i915_drv.h~i915-make-vbl-interrupts-work-properly-on-i965g-gm
+++ a/drivers/char/drm/i915_drv.h
@@ -210,6 +210,12 @@ extern int i915_wait_ring(struct drm_dev
 #define I915REG_INT_MASK_R 	0x020a8
 #define I915REG_INT_ENABLE_R	0x020a0
 
+#define I915REG_PIPEASTAT	0x70024
+#define I915REG_PIPEBSTAT	0x71024
+
+#define I915_VBLANK_INTERRUPT_ENABLE	(1UL<<17)
+#define I915_VBLANK_CLEAR		(1UL<<1)
+
 #define SRX_INDEX		0x3c4
 #define SRX_DATA		0x3c5
 #define SR01			1
diff -puN drivers/char/drm/i915_irq.c~i915-make-vbl-interrupts-work-properly-on-i965g-gm drivers/char/drm/i915_irq.c
--- a/drivers/char/drm/i915_irq.c~i915-make-vbl-interrupts-work-properly-on-i965g-gm
+++ a/drivers/char/drm/i915_irq.c
@@ -214,6 +214,10 @@ irqreturn_t i915_driver_irq_handler(DRM_
 	struct drm_device *dev = (struct drm_device *) arg;
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
 	u16 temp;
+	u32 pipea_stats, pipeb_stats;
+
+	pipea_stats = I915_READ(I915REG_PIPEASTAT);
+	pipeb_stats = I915_READ(I915REG_PIPEBSTAT);
 
 	temp = I915_READ16(I915REG_INT_IDENTITY_R);
 
@@ -225,6 +229,8 @@ irqreturn_t i915_driver_irq_handler(DRM_
 		return IRQ_NONE;
 
 	I915_WRITE16(I915REG_INT_IDENTITY_R, temp);
+	(void) I915_READ16(I915REG_INT_IDENTITY_R);
+	DRM_READMEMORYBARRIER();
 
 	dev_priv->sarea_priv->last_dispatch = READ_BREADCRUMB(dev_priv);
 
@@ -252,6 +258,12 @@ irqreturn_t i915_driver_irq_handler(DRM_
 
 		if (dev_priv->swaps_pending > 0)
 			drm_locked_tasklet(dev, i915_vblank_tasklet);
+		I915_WRITE(I915REG_PIPEASTAT,
+			pipea_stats|I915_VBLANK_INTERRUPT_ENABLE|
+			I915_VBLANK_CLEAR);
+		I915_WRITE(I915REG_PIPEBSTAT,
+			pipeb_stats|I915_VBLANK_INTERRUPT_ENABLE|
+			I915_VBLANK_CLEAR);
 	}
 
 	return IRQ_HANDLED;
_

Patches currently in -mm which might be from airlied@linux.ie are

origin.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-drm.patch
drm-via-invalid-device-ids-removal.patch
agp-fix-race-condition-between-unmapping-and-freeing-pages.patch
convert-ill-defined-log2-to-ilog2.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
