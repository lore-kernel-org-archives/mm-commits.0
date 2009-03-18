From: akpm@linux-foundation.org
Subject: + atyfb-speed-up-mach64-cursor.patch added to -mm tree
Date: Wed, 18 Mar 2009 16:49:42 -0700
Message-ID: <200903182353.n2INr4KM031697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbZCRXyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 19:54:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     atyfb: speed up Mach64 cursor
has been added to the -mm tree.  Its filename is
     atyfb-speed-up-mach64-cursor.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atyfb: speed up Mach64 cursor
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Save one fifo entry on cursor enabling and disabling.

Save another fifo entry for FB_CUR_SETPOS operation by removing redundant one.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/mach64_cursor.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/video/aty/mach64_cursor.c~atyfb-speed-up-mach64-cursor drivers/video/aty/mach64_cursor.c
--- a/drivers/video/aty/mach64_cursor.c~atyfb-speed-up-mach64-cursor
+++ a/drivers/video/aty/mach64_cursor.c
@@ -77,9 +77,13 @@ static int atyfb_cursor(struct fb_info *
 	if (par->asleep)
 		return -EPERM;
 
-	/* Hide cursor */
 	wait_for_fifo(1, par);
-	aty_st_le32(GEN_TEST_CNTL, aty_ld_le32(GEN_TEST_CNTL, par) & ~HWCURSOR_ENABLE, par);
+	if (cursor->enable)
+		aty_st_le32(GEN_TEST_CNTL, aty_ld_le32(GEN_TEST_CNTL, par)
+			    | HWCURSOR_ENABLE, par);
+	else
+		aty_st_le32(GEN_TEST_CNTL, aty_ld_le32(GEN_TEST_CNTL, par)
+				& ~HWCURSOR_ENABLE, par);
 
 	/* set position */
 	if (cursor->set & FB_CUR_SETPOS) {
@@ -109,7 +113,7 @@ static int atyfb_cursor(struct fb_info *
 			y<<=1;
 			h<<=1;
 		}
-		wait_for_fifo(4, par);
+		wait_for_fifo(3, par);
 		aty_st_le32(CUR_OFFSET, (info->fix.smem_len >> 3) + (yoff << 1), par);
 		aty_st_le32(CUR_HORZ_VERT_OFF,
 			    ((u32) (64 - h + yoff) << 16) | xoff, par);
@@ -177,11 +181,6 @@ static int atyfb_cursor(struct fb_info *
 	    }
 	}
 
-	if (cursor->enable) {
-		wait_for_fifo(1, par);
-		aty_st_le32(GEN_TEST_CNTL, aty_ld_le32(GEN_TEST_CNTL, par)
-			    | HWCURSOR_ENABLE, par);
-	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix3.patch
cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch
cirrusfb-add-laguna-additional-overflow-register.patch
cirrusfb-add-mmio-registers-for-laguna-chipsets.patch
cirrusfb-do-not-calculate-line-length-twice.patch
cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch
cirrusfb-various-improvements.patch
cirrusfb-laguna-chipset-8bpp-fix.patch
cirrusfb-check_var-improvements.patch
cirrusfb-various-laguna-fixes.patch
cirrusfb-acceleration-improvements.patch
cirrusfb-add-imageblit-function.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch
cirrusfb-gd5446-fixes.patch
cirrusfb-use-24bpp-instead-of-32bpp.patch
cirrusfb-fix-clock-doubling.patch
cirrusfb-fix-clock-doubling-fix.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
asiliantfb-fix-cmap-memory-leaks.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
remove-cyblafb-driver.patch
cirrusfb-add-accelerator-constant.patch
cirrusfb-set-mclk-in-one-place.patch
nvidiafb-remove-open_lock-mutex.patch
fb-hide-hardware-cursor-in-graphics-mode-mach64.patch
atyfb-speed-up-mach64-cursor.patch

