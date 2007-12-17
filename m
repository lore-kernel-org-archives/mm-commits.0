From: akpm@linux-foundation.org
Subject: - drm-i915-suspend-oops-fix.patch removed from -mm tree
Date: Sun, 16 Dec 2007 18:45:01 -0800
Message-ID: <200712170245.lBH2j1K3026557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755656AbXLQCpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Dec 2007 21:45:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: i915, suspend oops fix
has been removed from the -mm tree.  Its filename was
     drm-i915-suspend-oops-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: drm: i915, suspend oops fix
From: Jiri Slaby <jirislaby@gmail.com>

Register mmio_map space when suspending, it might be lost due to DRM device
closing with older X userspace drivers (it closes drm device and frees
resources after X starts) and then it accesses bad address and oopses while
suspending.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/i915_dma.c |   24 +++++++++++++++---------
 drivers/char/drm/i915_drv.c |   10 +++++++++-
 drivers/char/drm/i915_drv.h |    1 +
 3 files changed, 25 insertions(+), 10 deletions(-)

diff -puN drivers/char/drm/i915_dma.c~drm-i915-suspend-oops-fix drivers/char/drm/i915_dma.c
--- a/drivers/char/drm/i915_dma.c~drm-i915-suspend-oops-fix
+++ a/drivers/char/drm/i915_dma.c
@@ -1276,11 +1276,23 @@ static int i915_set_status_page(struct d
 	return 0;
 }
 
-int i915_driver_load(struct drm_device *dev, unsigned long flags)
+int i915_register_mmio_map(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	unsigned long base, size;
-	int ret = 0, mmio_bar = IS_I9XX(dev) ? 0 : 1;
+	int mmio_bar = IS_I9XX(dev) ? 0 : 1;
+
+	/* Add register map (needed for suspend/resume) */
+	base = drm_get_resource_start(dev, mmio_bar);
+	size = drm_get_resource_len(dev, mmio_bar);
+
+	return drm_addmap(dev, base, size, _DRM_REGISTERS, _DRM_KERNEL,
+			 &dev_priv->mmio_map);
+}
+
+int i915_driver_load(struct drm_device *dev, unsigned long flags)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
 
 	/* i915 has 4 more counters */
 	dev->counters += 4;
@@ -1297,13 +1309,7 @@ int i915_driver_load(struct drm_device *
 
 	dev->dev_private = (void *)dev_priv;
 
-	/* Add register map (needed for suspend/resume) */
-	base = drm_get_resource_start(dev, mmio_bar);
-	size = drm_get_resource_len(dev, mmio_bar);
-
-	ret = drm_addmap(dev, base, size, _DRM_REGISTERS, _DRM_KERNEL,
-			 &dev_priv->mmio_map);
-	return ret;
+	return i915_register_mmio_map(dev);
 }
 
 int i915_driver_unload(struct drm_device *dev)
diff -puN drivers/char/drm/i915_drv.c~drm-i915-suspend-oops-fix drivers/char/drm/i915_drv.c
--- a/drivers/char/drm/i915_drv.c~drm-i915-suspend-oops-fix
+++ a/drivers/char/drm/i915_drv.c
@@ -266,7 +266,7 @@ static void i915_restore_vga(struct drm_
 static int i915_suspend(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	int i;
+	int i, ret;
 
 	if (!dev || !dev_priv) {
 		printk(KERN_ERR "dev: %p, dev_priv: %p\n", dev, dev_priv);
@@ -274,6 +274,14 @@ static int i915_suspend(struct drm_devic
 		return -ENODEV;
 	}
 
+	/* Every lastclose will destroy this mapping, we need it for suspend.
+	 * It doesn't matter if it exists already, it will return the existing
+	 * one. Also it will be surely destroyed; either on next lastclose or
+	 * on lastclose called from drm unload path. -js */
+	ret = i915_register_mmio_map(dev);
+	if (ret)
+		return ret;
+
 	pci_save_state(dev->pdev);
 	pci_read_config_byte(dev->pdev, LBB, &dev_priv->saveLBB);
 
diff -puN drivers/char/drm/i915_drv.h~drm-i915-suspend-oops-fix drivers/char/drm/i915_drv.h
--- a/drivers/char/drm/i915_drv.h~drm-i915-suspend-oops-fix
+++ a/drivers/char/drm/i915_drv.h
@@ -216,6 +216,7 @@ extern int i915_max_ioctl;
 
 				/* i915_dma.c */
 extern void i915_kernel_lost_context(struct drm_device * dev);
+extern int i915_register_mmio_map(struct drm_device *dev);
 extern int i915_driver_load(struct drm_device *, unsigned long flags);
 extern int i915_driver_unload(struct drm_device *);
 extern void i915_driver_lastclose(struct drm_device * dev);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
git-watchdog.patch
git-wireless.patch
drm-i915-suspend-oops-fix.patch
drm-i915-fix-oops-after-killing-x.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
maintainers-order-auerswald-alphabetically.patch
pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
char-esp-remove-hangup-and-wakeup-bottomhalves.patch
char-istallion-remove-hangup-bottomhalf.patch
char-specialix-remove-bottomhalves.patch
char-stallion-remove-bottomhalf.patch
char-serial167-remove-bottomhalf.patch
char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
moxa-first-pass-at-termios-reporting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
