From: akpm@linux-foundation.org
Subject: + neofb-remove-open_lock-mutex.patch added to -mm tree
Date: Wed, 27 Aug 2008 13:32:58 -0700
Message-ID: <200808272032.m7RKWwEY020884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbYH0UdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 16:33:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     neofb: remove open_lock mutex
has been added to the -mm tree.  Its filename is
     neofb-remove-open_lock-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: neofb: remove open_lock mutex
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove mutex from the fb_open/fb_release functions as these operations are
mutexed at fb layer.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c    |   10 ++--------
 include/video/neomagic.h |    1 -
 2 files changed, 2 insertions(+), 9 deletions(-)

diff -puN drivers/video/neofb.c~neofb-remove-open_lock-mutex drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-remove-open_lock-mutex
+++ a/drivers/video/neofb.c
@@ -557,14 +557,12 @@ neofb_open(struct fb_info *info, int use
 {
 	struct neofb_par *par = info->par;
 
-	mutex_lock(&par->open_lock);
 	if (!par->ref_count) {
 		memset(&par->state, 0, sizeof(struct vgastate));
 		par->state.flags = VGA_SAVE_MODE | VGA_SAVE_FONTS;
 		save_vga(&par->state);
 	}
 	par->ref_count++;
-	mutex_unlock(&par->open_lock);
 
 	return 0;
 }
@@ -574,16 +572,13 @@ neofb_release(struct fb_info *info, int 
 {
 	struct neofb_par *par = info->par;
 
-	mutex_lock(&par->open_lock);
-	if (!par->ref_count) {
-		mutex_unlock(&par->open_lock);
+	if (!par->ref_count)
 		return -EINVAL;
-	}
+
 	if (par->ref_count == 1) {
 		restore_vga(&par->state);
 	}
 	par->ref_count--;
-	mutex_unlock(&par->open_lock);
 
 	return 0;
 }
@@ -1958,7 +1953,6 @@ static struct fb_info *__devinit neo_all
 
 	info->fix.accel = id->driver_data;
 
-	mutex_init(&par->open_lock);
 	par->pci_burst = !nopciburst;
 	par->lcd_stretch = !nostretch;
 	par->libretto = libretto;
diff -puN include/video/neomagic.h~neofb-remove-open_lock-mutex include/video/neomagic.h
--- a/include/video/neomagic.h~neofb-remove-open_lock-mutex
+++ a/include/video/neomagic.h
@@ -123,7 +123,6 @@ typedef volatile struct {
 
 struct neofb_par {
 	struct vgastate state;
-	struct mutex open_lock;
 	unsigned int ref_count;
 
 	unsigned char MiscOutReg;	/* Misc */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
fb-metronome-printk-format-warning.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch

