From: akpm@linux-foundation.org
Subject: + vt-fix-background-color-on-line-feed-dec-invert.patch added to -mm tree
Date: Wed, 28 May 2008 12:27:42 -0700
Message-ID: <200805281927.m4SJRgW8028712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635AbYE1T2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 15:28:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@medozas.de, thunder7@xs4all.nl


The patch titled
     vt: fix background color on line feed, DEC invert
has been added to the -mm tree.  Its filename is
     vt-fix-background-color-on-line-feed-dec-invert.patch

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
Subject: vt: fix background color on line feed, DEC invert
From: Jan Engelhardt <jengelh@medozas.de>

Original report: """I used to force my console to black-on-white by the
command `setterm -inversescreen on`.  In 2.6.26-rc4, I get lots of black
background characters."""

Another addendum to commit c9e587ab.  This was previously missed out since
I was not aware of what vc_decscnm was for.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Reported-by: <thunder7@xs4all.nl>
Tested-by: <thunder7@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/vt.c~vt-fix-background-color-on-line-feed-dec-invert drivers/char/vt.c
--- a/drivers/char/vt.c~vt-fix-background-color-on-line-feed-dec-invert
+++ a/drivers/char/vt.c
@@ -434,7 +434,7 @@ static void update_attr(struct vc_data *
 	              vc->vc_blink, vc->vc_underline,
 	              vc->vc_reverse ^ vc->vc_decscnm, vc->vc_italic);
 	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1, vc->vc_blink, 0, vc->vc_decscnm, 0) << 8) | ' ';
-	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, false, false) << 8) | ' ';
+	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, vc->vc_decscnm, false) << 8) | ' ';
 }
 
 /* Note: inverting the screen twice should revert to the original state */
_

Patches currently in -mm which might be from jengelh@medozas.de are

fs-make-struct-file-arg-to-d_path-const.patch
vt-fix-background-color-on-line-feed-dec-invert.patch

