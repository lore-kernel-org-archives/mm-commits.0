From: akpm@linux-foundation.org
Subject: - viafb-accelc-accelh-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:52:40 -0700
Message-ID: <200810152352.m9FNqfeo023893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753714AbYJOXxO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:53:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, JosephChan@via.com.tw, geert@linux-m68k.org, josephchan@via.com.tw, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb-accelc-accelh-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     viafb-accelc-accelh-checkpatch-fixes.patch

This patch was dropped because it was folded into viafb-accelc-accelh.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb-accelc-accelh-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: open brace '{' following function declarations go on the next line
#222: FILE: drivers/video/via/accel.c:204:
+void viafb_show_hw_cursor(struct fb_info *info, int Status) {

WARNING: suspect code indent for conditional statements
#249: FILE: drivers/video/via/accel.c:231:
+	while (!(MMIO_IN32(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY)

WARNING: suspect code indent for conditional statements
#253: FILE: drivers/video/via/accel.c:235:
+	while ((MMIO_IN32(VIA_REG_STATUS) &

total: 1 errors, 2 warnings, 421 lines checked

./patches/viafb-accelc-accelh.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/video/via/accel.c~viafb-accelc-accelh-checkpatch-fixes drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-accelc-accelh-checkpatch-fixes
+++ a/drivers/video/via/accel.c
@@ -201,7 +201,8 @@ void viafb_hw_cursor_init(void)
 	MMIO_OUT32(VIA_REG_CURSOR_FG, 0x0);
 }
 
-void viafb_show_hw_cursor(struct fb_info *info, int Status) {
+void viafb_show_hw_cursor(struct fb_info *info, int Status)
+{
 	u32 temp;
 	u32 iga_path = ((struct viafb_par *)(info->par))->iga_path;
 
@@ -222,20 +223,21 @@ void viafb_show_hw_cursor(struct fb_info
 	default:
 		temp &= 0x7FFFFFFF;
 	}
-	MMIO_OUT32(VIA_REG_CURSOR_MODE, temp); }
+	MMIO_OUT32(VIA_REG_CURSOR_MODE, temp);
+}
 
 int viafb_wait_engine_idle(void)
 {
 	int loop = 0;
 
-	while (!(MMIO_IN32(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY)
-	       && (loop++ < MAXLOOP))
-	       cpu_relax();
+	while (!(MMIO_IN32(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) &&
+			(loop++ < MAXLOOP))
+		cpu_relax();
 
 	while ((MMIO_IN32(VIA_REG_STATUS) &
-		(VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)) &&
-	       (loop++ < MAXLOOP))
-	       cpu_relax();
+		    (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)) &&
+		    (loop++ < MAXLOOP))
+		cpu_relax();
 
 	return loop >= MAXLOOP;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
viafb-accelc-accelh.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch

