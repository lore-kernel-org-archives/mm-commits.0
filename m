From: akpm@linux-foundation.org
Subject: - drm-i915-fix-pointer-strip.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:23:02 -0800
Message-ID: <200712010023.lB10N2bU031969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756969AbXLAA1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, airlied@linux.ie, thomas@tungstengraphics.com, mm-commits@vger.kernel.org


The patch titled
     drm: i915, fix pointer strip
has been removed from the -mm tree.  Its filename was
     drm-i915-fix-pointer-strip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drm: i915, fix pointer strip
From: Jiri Slaby <jirislaby@gmail.com>

Beside the emitted warning, the added cast (u64 -> unsigned) strips out
part of address on 64 bit. Cast to unsigned long instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/i915_dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/drm/i915_dma.c~drm-i915-fix-pointer-strip drivers/char/drm/i915_dma.c
--- a/drivers/char/drm/i915_dma.c~drm-i915-fix-pointer-strip
+++ a/drivers/char/drm/i915_dma.c
@@ -900,7 +900,7 @@ int i915_validate_buffer_list(struct drm
 
 		buffers[buf_count] = NULL;
 
-		if (copy_from_user(&arg, (void __user *)(unsigned)data, sizeof(arg))) {
+		if (copy_from_user(&arg, (void __user *)(unsigned long)data, sizeof(arg))) {
 			ret = -EFAULT;
 			goto out_err;
 		}
@@ -951,7 +951,7 @@ int i915_validate_buffer_list(struct drm
 		arg.handled = 1;
 		arg.d.rep = rep;
 
-		if (copy_to_user((void __user *)(unsigned)data, &arg, sizeof(arg)))
+		if (copy_to_user((void __user *)(unsigned long)data, &arg, sizeof(arg)))
 			return -EFAULT;
 
 		data = next;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
git-watchdog.patch
git-wireless.patch
hwmon-coretemp-suspend-fix.patch
hwmon-coretemp-suspend-fix-fix.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
maintainers-order-auerswald-alphabetically.patch
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
