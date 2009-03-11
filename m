From: akpm@linux-foundation.org
Subject: + uvesafb-fix-selecting-mode-with-the-vbemode-option.patch added to -mm tree
Date: Tue, 10 Mar 2009 23:52:14 -0700
Message-ID: <200903110652.n2B6qE5k023848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbZCKGxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 02:53:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, krzysztof.h1@poczta.fm


The patch titled
     uvesafb: fix selecting mode with the vbemode option
has been added to the -mm tree.  Its filename is
     uvesafb-fix-selecting-mode-with-the-vbemode-option.patch

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
Subject: uvesafb: fix selecting mode with the vbemode option
From: Michal Januszewski <spock@gentoo.org>

If the vbemode option is used, uvesafb calls fb_get_mode() without first
setting the resolution in info->var.  This results in a division by zero
in fb_get_mode(), as evidenced e.g.  in [1].  Fix this by ensuring the
info->var structure is populated before fb_get_mode() is called.

[1] http://bugzilla.kernel.org/show_bug.cgi?id=11661#c37

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-fix-selecting-mode-with-the-vbemode-option drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-fix-selecting-mode-with-the-vbemode-option
+++ a/drivers/video/uvesafb.c
@@ -850,14 +850,16 @@ static int __devinit uvesafb_vbe_init_mo
 	if (vbemode) {
 		for (i = 0; i < par->vbe_modes_cnt; i++) {
 			if (par->vbe_modes[i].mode_id == vbemode) {
+				modeid = i;
+				uvesafb_setup_var(&info->var, info,
+						&par->vbe_modes[modeid]);
 				fb_get_mode(FB_VSYNCTIMINGS | FB_IGNOREMON, 60,
-							&info->var, info);
+						&info->var, info);
 				/*
 				 * With pixclock set to 0, the default BIOS
 				 * timings will be used in set_par().
 				 */
 				info->var.pixclock = 0;
-				modeid = i;
 				goto gotmode;
 			}
 		}
@@ -904,8 +906,11 @@ static int __devinit uvesafb_vbe_init_mo
 			fb_videomode_to_var(&info->var, mode);
 		} else {
 			modeid = par->vbe_modes[0].mode_id;
+			uvesafb_setup_var(&info->var, info,
+					&par->vbe_modes[modeid]);
 			fb_get_mode(FB_VSYNCTIMINGS | FB_IGNOREMON, 60,
-				    &info->var, info);
+					&info->var, info);
+
 			goto gotmode;
 		}
 	}
@@ -917,9 +922,9 @@ static int __devinit uvesafb_vbe_init_mo
 	if (modeid == -1)
 		return -EINVAL;
 
-gotmode:
 	uvesafb_setup_var(&info->var, info, &par->vbe_modes[modeid]);
 
+gotmode:
 	/*
 	 * If we are not VBE3.0+ compliant, we're done -- the BIOS will
 	 * ignore our timings anyway.
_

Patches currently in -mm which might be from spock@gentoo.org are

linux-next.patch
uvesafb-fix-selecting-mode-with-the-vbemode-option.patch

