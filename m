From: akpm@linux-foundation.org
Subject: - vga16fb-remove-open_lock-mutex.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:16:59 -0700
Message-ID: <200810182316.m9INGxZC028920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbYJRXRB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     vga16fb: remove open_lock mutex
has been removed from the -mm tree.  Its filename was
     vga16fb-remove-open_lock-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vga16fb: remove open_lock mutex
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove mutex from the fb_open/fb_release functions as these operations are
mutexed at fb layer.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vga16fb.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN drivers/video/vga16fb.c~vga16fb-remove-open_lock-mutex drivers/video/vga16fb.c
--- a/drivers/video/vga16fb.c~vga16fb-remove-open_lock-mutex
+++ a/drivers/video/vga16fb.c
@@ -58,7 +58,6 @@ struct vga16fb_par {
 		unsigned char	ClockingMode;	  /* Seq-Controller:01h */
 	} vga_state;
 	struct vgastate state;
-	struct mutex open_lock;
 	unsigned int ref_count;
 	int palette_blanked, vesa_blanked, mode, isVGA;
 	u8 misc, pel_msk, vss, clkdiv;
@@ -286,7 +285,6 @@ static int vga16fb_open(struct fb_info *
 {
 	struct vga16fb_par *par = info->par;
 
-	mutex_lock(&par->open_lock);
 	if (!par->ref_count) {
 		memset(&par->state, 0, sizeof(struct vgastate));
 		par->state.flags = VGA_SAVE_FONTS | VGA_SAVE_MODE |
@@ -294,7 +292,6 @@ static int vga16fb_open(struct fb_info *
 		save_vga(&par->state);
 	}
 	par->ref_count++;
-	mutex_unlock(&par->open_lock);
 
 	return 0;
 }
@@ -303,15 +300,12 @@ static int vga16fb_release(struct fb_inf
 {
 	struct vga16fb_par *par = info->par;
 
-	mutex_lock(&par->open_lock);
-	if (!par->ref_count) {
-		mutex_unlock(&par->open_lock);
+	if (!par->ref_count)
 		return -EINVAL;
-	}
+
 	if (par->ref_count == 1)
 		restore_vga(&par->state);
 	par->ref_count--;
-	mutex_unlock(&par->open_lock);
 
 	return 0;
 }
@@ -1326,7 +1320,6 @@ static int __init vga16fb_probe(struct p
 	printk(KERN_INFO "vga16fb: mapped to 0x%p\n", info->screen_base);
 	par = info->par;
 
-	mutex_init(&par->open_lock);
 	par->isVGA = screen_info.orig_video_isVGA;
 	par->palette_blanked = 0;
 	par->vesa_blanked = 0;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

