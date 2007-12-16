From: akpm@linux-foundation.org
Subject: + drm-i915-fix-oops-after-killing-x.patch added to -mm tree
Date: Sun, 16 Dec 2007 14:18:28 -0800
Message-ID: <200712162218.lBGMISIP015284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029AbXLPWTD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Dec 2007 17:19:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, airlied@linux.ie


The patch titled
     drm: i915, fix oops after killing X
has been added to the -mm tree.  Its filename is
     drm-i915-fix-oops-after-killing-x.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drm: i915, fix oops after killing X
From: Jiri Slaby <jirislaby@gmail.com>

Null sarea_priv, because next lastclose would have bad address in it if
initialization is not called in the meantime.

This is a problem in setups, where drm are closed after X starts.  Next
lastclose is invoked on X kill.  Newer intel drivers (2.2) with EXA support
hold the device whole time while X runs.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/i915_dma.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/char/drm/i915_dma.c~drm-i915-fix-oops-after-killing-x drivers/char/drm/i915_dma.c
--- a/drivers/char/drm/i915_dma.c~drm-i915-fix-oops-after-killing-x
+++ a/drivers/char/drm/i915_dma.c
@@ -1335,6 +1335,12 @@ void i915_driver_lastclose(struct drm_de
 		i915_mem_takedown(&(dev_priv->agp_heap));
 
 	i915_dma_cleanup(dev);
+
+	/* Mapping won't survive to the next firstopen anyways. It will
+	 * probably oops without it on next lastclose if we not null it
+	 * here, if it will be mapped anywhere else, but without dma being
+	 * initialized -js */
+	dev_priv->sarea_priv = NULL;
 }
 
 void i915_driver_preclose(struct drm_device * dev, struct drm_file *file_priv)
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
