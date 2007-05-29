From: akpm@linux-foundation.org
Subject: - drm-spinlock-initializer-cleanup.patch removed from -mm tree
Date: Tue, 29 May 2007 11:53:48 -0700
Message-ID: <200705291853.l4TIrlRO008480@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760374AbXE2Syq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:54:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     DRM: Spinlock initializer cleanup
has been removed from the -mm tree.  Its filename was
     drm-spinlock-initializer-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: DRM: Spinlock initializer cleanup
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/i915_irq.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/drm/i915_irq.c~drm-spinlock-initializer-cleanup drivers/char/drm/i915_irq.c
--- a/drivers/char/drm/i915_irq.c~drm-spinlock-initializer-cleanup
+++ a/drivers/char/drm/i915_irq.c
@@ -582,7 +582,7 @@ void i915_driver_irq_postinstall(drm_dev
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
 
-	dev_priv->swaps_lock = SPIN_LOCK_UNLOCKED;
+	spin_lock_init(&dev_priv->swaps_lock);
 	INIT_LIST_HEAD(&dev_priv->vbl_swaps.head);
 	dev_priv->swaps_pending = 0;
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-drm.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
