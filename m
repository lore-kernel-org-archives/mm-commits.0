From: akpm@linux-foundation.org
Subject: + drm-i915-fix-pointer-strip.patch added to -mm tree
Date: Tue, 13 Nov 2007 11:47:19 -0800
Message-ID: <200711131947.lADJlJ48032095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758972AbXKMTrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Nov 2007 14:47:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, airlied@linux.ie, thomas@tungstengraphics.com


The patch titled
     drm: i915, fix pointer strip
has been added to the -mm tree.  Its filename is
     drm-i915-fix-pointer-strip.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fs-sysfs-remove-spin_lock_unlocked.patch
cscope-build-warning.patch
net-sunrpc-remove-spin_lock_unlocked.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix.patch
git-watchdog.patch
git-wireless.patch
drm-i915-fix-pointer-strip.patch
crisv10-serial-driver-rewrite-take-three.patch
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
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
