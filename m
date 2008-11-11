From: akpm@linux-foundation.org
Subject: - drm-fix-radeon-suspend-resume-oops.patch removed from -mm tree
Date: Tue, 11 Nov 2008 00:49:06 -0800
Message-ID: <200811110849.mAB8n6eU031118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbYKKItj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 03:49:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, airlied@linux.ie, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     drm: fix radeon suspend/resume oops
has been removed from the -mm tree.  Its filename was
     drm-fix-radeon-suspend-resume-oops.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: fix radeon suspend/resume oops
From: Jiri Slaby <jirislaby@gmail.com>

When the driver is bound to a device and nobody opens the device node, it
will oops on suspend and resume, since it's not mapped and dev_priv->mmio
is NULL.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/radeon_drv.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/gpu/drm/radeon/radeon_drv.c~drm-fix-radeon-suspend-resume-oops drivers/gpu/drm/radeon/radeon_drv.c
--- a/drivers/gpu/drm/radeon/radeon_drv.c~drm-fix-radeon-suspend-resume-oops
+++ a/drivers/gpu/drm/radeon/radeon_drv.c
@@ -56,6 +56,9 @@ static int radeon_suspend(struct drm_dev
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
 
+	if (!dev_priv->mmio)
+		return 0;
+
 	/* Disable *all* interrupts */
 	if ((dev_priv->flags & RADEON_FAMILY_MASK) >= CHIP_RS690)
 		RADEON_WRITE(R500_DxMODE_INT_MASK, 0);
@@ -67,6 +70,9 @@ static int radeon_resume(struct drm_devi
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
 
+	if (!dev_priv->mmio)
+		return 0;
+
 	/* Restore interrupt registers */
 	if ((dev_priv->flags & RADEON_FAMILY_MASK) >= CHIP_RS690)
 		RADEON_WRITE(R500_DxMODE_INT_MASK, dev_priv->r500_disp_irq_reg);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
drm-fix-radeon-suspend-resume-oops.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

