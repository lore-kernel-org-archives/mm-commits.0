From: akpm@linux-foundation.org
Subject: - fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:50:16 -0700
Message-ID: <200810182350.m9INoG3X001590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbYJRXvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adaplas@pol.net, alan@lxorguk.ukuu.org.uk, alan@redhat.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch

This patch was dropped because it was folded into fb-push-down-the-bkl-in-the-ioctl-handler.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: suspect code indent for conditional statements
#134: FILE: drivers/video/fbmem.c:1088:
+		else if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)

ERROR: space prohibited after that '-' (ctx:WxW)
#154: FILE: drivers/video/fbmem.c:1102:
+			ret = - EFAULT;
 			      ^

total: 1 errors, 1 warnings, 217 lines checked

./patches/fb-push-down-the-bkl-in-the-ioctl-handler.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@redhat.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/fbmem.c~fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes
+++ a/drivers/video/fbmem.c
@@ -1077,7 +1077,7 @@ fb_ioctl(struct file *file, unsigned int
 		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
 			ret = -EFAULT;
 		else if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
-		    ret = -EINVAL;
+			ret = -EINVAL;
 		else {
 			con2fb.framebuffer = -1;
 			event.info = info;
@@ -1090,7 +1090,7 @@ fb_ioctl(struct file *file, unsigned int
 		break;
 	case FBIOPUT_CON2FBMAP:
 		if (copy_from_user(&con2fb, argp, sizeof(con2fb))) {
-			ret = - EFAULT;
+			ret = -EFAULT;
 			break;
 		}
 		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-implement-freezer-cgroup-subsystem.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

