From: akpm@linux-foundation.org
Subject: + fbcon-dont-inline-updatescrollmode.patch added to -mm tree
Date: Sat, 25 Oct 2008 13:46:57 -0700
Message-ID: <200810252046.m9PKkv3d017352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbYJYUra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Oct 2008 16:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, adaplas@gmail.com, krzysztof.h1@wp.pl


The patch titled
     fbcon: don't inline updatescrollmode
has been added to the -mm tree.  Its filename is
     fbcon-dont-inline-updatescrollmode.patch

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
Subject: fbcon: don't inline updatescrollmode
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Updatescrollmode is marked inline, but it's big and is called only from
non-critical codepaths (fbcon_resize, fbcon_switch, fbcon_modechanged).
Dropping it saves almost 800 bytes of text size.

   text    data     bss     dec     hex filename
  23859     287    8448   32594    7f52 drivers/video/console/fbcon.o.before
  23065     287    8448   31800    7c38 drivers/video/console/fbcon.o.after

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbcon-dont-inline-updatescrollmode drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-dont-inline-updatescrollmode
+++ a/drivers/video/console/fbcon.c
@@ -2118,7 +2118,7 @@ static void fbcon_bmove_rec(struct vc_da
 		   height, width);
 }
 
-static __inline__ void updatescrollmode(struct display *p,
+static void updatescrollmode(struct display *p,
 					struct fb_info *info,
 					struct vc_data *vc)
 {
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

fbcon-dont-inline-updatescrollmode.patch

