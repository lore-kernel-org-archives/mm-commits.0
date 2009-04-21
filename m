From: akpm@linux-foundation.org
Subject: + vgacon-return-the-upper-half-of-512-character-fonts.patch added to -mm tree
Date: Tue, 21 Apr 2009 13:55:16 -0700
Message-ID: <200904212055.n3LKtGEG029954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbZDUU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 16:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefan.bader@canonical.com, ubuntuLp-ugeuder@sneakemail.com


The patch titled
     vgacon: return the upper half of 512 character fonts
has been added to the -mm tree.  Its filename is
     vgacon-return-the-upper-half-of-512-character-fonts.patch

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
Subject: vgacon: return the upper half of 512 character fonts
From: Stefan Bader <stefan.bader@canonical.com>

Uwe Geuder noted that he gets random bitmaps on a text console if he tried
to type extended characters (like the e acute).  For him everything above
unicode 0xa0 was corrupted.

After some digging there seems to be a little culprit in vgacon since the
beginning of ages (well git).  The function vgacon_font_get will store the
number of characters correctly in font->charcount but then calls to
vgacon_do_font_op(..., 0, 0).  Which means only the lower 256 characters
are actually stored to the fontdata.  The rest is left untouched.  So the
next time that saved data is used, the garbled font appears.  This happens
on every switch between text consoles.

Addresses https://bugs.launchpad.net/ubuntu/+source/linux/+bug/355057

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Tested-by: Uwe Geuder <ubuntuLp-ugeuder@sneakemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/vgacon.c~vgacon-return-the-upper-half-of-512-character-fonts drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~vgacon-return-the-upper-half-of-512-character-fonts
+++ a/drivers/video/console/vgacon.c
@@ -1282,7 +1282,7 @@ static int vgacon_font_get(struct vc_dat
 	font->charcount = vga_512_chars ? 512 : 256;
 	if (!font->data)
 		return 0;
-	return vgacon_do_font_op(&state, font->data, 0, 0);
+	return vgacon_do_font_op(&state, font->data, 0, vga_512_chars);
 }
 
 #else
_

Patches currently in -mm which might be from stefan.bader@canonical.com are

vgacon-return-the-upper-half-of-512-character-fonts.patch

