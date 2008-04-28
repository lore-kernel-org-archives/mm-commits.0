From: akpm@linux-foundation.org
Subject: - free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:54 -0700
Message-ID: <200804282157.m3SLvsB7018437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965189AbYD1V55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     video/aty/atyfb_base.c: free when fb can't be registered
has been removed from the -mm tree.  Its filename was
     free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video/aty/atyfb_base.c: free when fb can't be registered
From: Roel Kluin <12o3l@tiscali.nl>

Free buffer when the framebuffer can't be registered

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~free-when-fb-cant-be-registered-in-video-aty-atyfb_basec drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~free-when-fb-cant-be-registered-in-video-aty-atyfb_basec
+++ a/drivers/video/aty/atyfb_base.c
@@ -2621,10 +2621,13 @@ static int __devinit aty_init(struct fb_
 #endif /* CONFIG_FB_ATY_CT */
 	info->var = var;
 
-	fb_alloc_cmap(&info->cmap, 256, 0);
+	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0)
+		goto aty_init_exit;
 
-	if (register_framebuffer(info) < 0)
+	if (register_framebuffer(info) < 0) {
+		fb_dealloc_cmap(&info->cmap);
 		goto aty_init_exit;
+	}
 
 	fb_list = info;
 
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-kbuild.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

