From: akpm@linux-foundation.org
Subject: [merged] atyfb-speed-up-mach64-cursor.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:44:17 -0700
Message-ID: <200904011844.n31IiH55010426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933595AbZDAS7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:59:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     atyfb: speed up Mach64 cursor
has been removed from the -mm tree.  Its filename was
     atyfb-speed-up-mach64-cursor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

