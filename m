From: akpm@linux-foundation.org
Subject: - viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:53:39 -0700
Message-ID: <200810152353.m9FNreXr024007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855AbYJOXyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, JosephChan@via.com.tw, geert@linux-m68k.org, jirislaby@gmail.com, josephchan@via.com.tw, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb-viafbdevc-viafbdevh-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch

This patch was dropped because it was folded into viafb-viafbdevc-viafbdevh.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb-viafbdevc-viafbdevh-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: suspect code indent for conditional statements
#306: FILE: drivers/video/via/viafbdev.c:285:
+	if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name) {

WARNING: suspect code indent for conditional statements
#408: FILE: drivers/video/via/viafbdev.c:387:
+	if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name) {

WARNING: suspect code indent for conditional statements
#585: FILE: drivers/video/via/viafbdev.c:564:
+		if (copy_to_user(argp, viaparinfo->chip_info,

WARNING: suspect code indent for conditional statements
#782: FILE: drivers/video/via/viafbdev.c:761:
+		if (copy_from_user

WARNING: suspect code indent for conditional statements
#1377: FILE: drivers/video/via/viafbdev.c:1356:
+	if ((active_dev.samm == STATE_OFF)

total: 0 errors, 5 warnings, 2675 lines checked

./patches/viafb-viafbdevc-viafbdevh.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-viafbdevc-viafbdevh-checkpatch-fixes drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-viafbdevc-viafbdevh-checkpatch-fixes
+++ a/drivers/video/via/viafbdev.c
@@ -283,7 +283,9 @@ unsigned blue, unsigned transp, struct f
 	if (regno >= cmap_entries)
 		return 1;
 	if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name) {
-	/* Read PCI bus 0,dev 0,function 0,index 0xF6 to get chip rev. */
+		/*
+		 * Read PCI bus 0,dev 0,function 0,index 0xF6 to get chip rev.
+		 */
 		outl(0x80000000 | (0xf6 & ~3), (unsigned long)0xCF8);
 		rev = (inl((unsigned long)0xCFC) >> ((0xf6 & 3) * 8)) & 0xff;
 	}
@@ -385,7 +387,10 @@ static int viafb_setcmap(struct fb_cmap 
 	if (len > 256)
 		return 1;
 	if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name) {
-	/* Read PCI bus 0, dev 0, function 0, index 0xF6 to get chip rev. */
+		/*
+		 * Read PCI bus 0, dev 0, function 0, index 0xF6 to get chip
+		 * rev.
+		 */
 		outl(0x80000000 | (0xf6 & ~3), (unsigned long)0xCF8);
 		rev = (inl((unsigned long)0xCFC) >> ((0xf6 & 3) * 8)) & 0xff;
 	}
@@ -562,8 +567,8 @@ static int viafb_ioctl(struct fb_info *i
 	switch (cmd) {
 	case VIAFB_GET_CHIP_INFO:
 		if (copy_to_user(argp, viaparinfo->chip_info,
-		sizeof(struct chip_information)))
-		return -EFAULT;
+				sizeof(struct chip_information)))
+			return -EFAULT;
 		break;
 	case VIAFB_GET_INFO_SIZE:
 		return put_user(viainfo_size, argp);
@@ -758,10 +763,10 @@ static int viafb_ioctl(struct fb_info *i
 		viafb_gamma_table = kmalloc(256 * sizeof(u32), GFP_KERNEL);
 		if (!viafb_gamma_table)
 			return -ENOMEM;
-		if (copy_from_user
-		    (viafb_gamma_table, argp, sizeof(viafb_gamma_table))) {
-		    kfree(viafb_gamma_table);
-		    return -EFAULT;
+		if (copy_from_user(viafb_gamma_table, argp,
+				sizeof(viafb_gamma_table))) {
+			kfree(viafb_gamma_table);
+			return -EFAULT;
 		}
 		viafb_set_gamma_table(viafb_bpp, viafb_gamma_table);
 		kfree(viafb_gamma_table);
@@ -1353,9 +1358,8 @@ static void viafb_set_device(struct devi
 		viafb_refresh = active_dev.refresh;
 	if (active_dev.refresh1 != 0)
 		viafb_refresh1 = active_dev.refresh1;
-	if ((active_dev.samm == STATE_OFF)
-	    || (active_dev.samm == STATE_ON))
-	    viafb_SAMM_ON = active_dev.samm;
+	if ((active_dev.samm == STATE_OFF) || (active_dev.samm == STATE_ON))
+		viafb_SAMM_ON = active_dev.samm;
 	viafb_primary_dev = active_dev.primary_dev;
 
 	viafb_set_start_addr();
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
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch

