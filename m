From: akpm@linux-foundation.org
Subject: + uvesafb-dont-treat-valid-modes-returned-by-fb_find_mode-as-errors.patch added to -mm tree
Date: Wed, 05 Mar 2008 22:52:56 -0800
Message-ID: <200803060652.m266qulw013522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758831AbYCFGx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 01:53:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@pol.net


The patch titled
     uvesafb: don't treat valid modes returned byfb_find_mode() as errors
has been added to the -mm tree.  Its filename is
     uvesafb-dont-treat-valid-modes-returned-by-fb_find_mode-as-errors.patch

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
Subject: uvesafb: don't treat valid modes returned byfb_find_mode() as errors
From: Michal Januszewski <spock@gentoo.org>

Don't treat valid modes returned by fb_find_mode() (best-fit modes,
default modes or the first valid mode) as errors.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/uvesafb.c~uvesafb-dont-treat-valid-modes-returned-by-fb_find_mode-as-errors drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-dont-treat-valid-modes-returned-by-fb_find_mode-as-errors
+++ a/drivers/video/uvesafb.c
@@ -885,7 +885,7 @@ static int __devinit uvesafb_vbe_init_mo
 	}
 
 	/* fb_find_mode() failed */
-	if (i == 0 || i >= 3) {
+	if (i == 0) {
 		info->var.xres = 640;
 		info->var.yres = 480;
 		mode = (struct fb_videomode *)
_

Patches currently in -mm which might be from spock@gentoo.org are

fbdev-make-the-best-fit-section-of-fb_find_mode-return-the-closest-matching-mode.patch
uvesafb-dont-treat-valid-modes-returned-by-fb_find_mode-as-errors.patch

