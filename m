From: akpm@linux-foundation.org
Subject: - drm-i915-fix-oops-after-killing-x.patch removed from -mm tree
Date: Wed, 05 Mar 2008 01:30:17 -0800
Message-ID: <200803050930.m259UHI0025339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757699AbYCEJbH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 04:31:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: i915, fix oops after killing X
has been removed from the -mm tree.  Its filename was
     drm-i915-fix-oops-after-killing-x.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1375,6 +1375,12 @@ void i915_driver_lastclose(struct drm_de
 		i915_mem_takedown(&(dev_priv->agp_heap));
 
 	i915_dma_cleanup(dev);
+
+	/* Mapping won't survive to the next firstopen anyways. It will
+	 * probably oops without it on next lastclose if we not null it
+	 * here, if it will be mapped anywhere else, but without dma being
+	 * initialized -js */
+	dev_priv->sarea_priv = NULL;
 }
 
 void i915_driver_preclose(struct drm_device *dev, struct drm_file *file_priv)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
wdev-ath5k-typecheck-on-nondebug.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
misc-phantom-consistent-whitespace.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
char-espc-fix-possible-double-unlock.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

