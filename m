From: akpm@linux-foundation.org
Subject: - uvesafb-dont-treat-valid-modes-returned-by-fb_find_mode-as-errors.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:24 -0700
Message-ID: <200804282158.m3SLwOAG018489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965305AbYD1V62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     uvesafb: don't treat valid modes returned byfb_find_mode() as errors
has been removed from the -mm tree.  Its filename was
     uvesafb-dont-treat-valid-modes-returned-by-fb_find_mode-as-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uvesafb: don't treat valid modes returned byfb_find_mode() as errors
From: Michal Januszewski <spock@gentoo.org>

Don't treat valid modes returned by fb_find_mode() (best-fit modes, default
modes or the first valid mode) as errors.

Currently, when fb_find_mode() finds a valid mode belonging to one of the
above-mentioned classes, uvesafb will ignore it and will try to set a 640x480
video mode.  The expected behaviour (introduced by this patch) would be to use
the valid mode returned by fb_find_mode() instead.

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

origin.patch

