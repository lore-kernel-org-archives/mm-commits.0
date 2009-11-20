From: akpm@linux-foundation.org
Subject: + drivers-char-keyboardc-fix-braille-keyboard-keysym-generation.patch added to -mm tree
Date: Fri, 20 Nov 2009 13:20:04 -0800
Message-ID: <200911202120.nAKLK4bI015752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762AbZKTVUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 16:20:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, alan@lxorguk.ukuu.org.uk, dtor@mail.ru


The patch titled
     drivers/char/keyboard.c: fix braille keyboard keysym generation
has been added to the -mm tree.  Its filename is
     drivers-char-keyboardc-fix-braille-keyboard-keysym-generation.patch

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
Subject: drivers/char/keyboard.c: fix braille keyboard keysym generation
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Keysyms stored in key_map[] are not simply K() values, but U(K()) values,
as can be seen in the KDSKBENT ioctl handler.  The kernel-generated
braille keysyms thus need a U() call too.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/keyboard.c~drivers-char-keyboardc-fix-braille-keyboard-keysym-generation drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~drivers-char-keyboardc-fix-braille-keyboard-keysym-generation
+++ a/drivers/char/keyboard.c
@@ -1249,7 +1249,7 @@ static void kbd_keycode(unsigned int key
 
 	if (keycode >= NR_KEYS)
 		if (keycode >= KEY_BRL_DOT1 && keycode <= KEY_BRL_DOT8)
-			keysym = K(KT_BRL, keycode - KEY_BRL_DOT1 + 1);
+			keysym = U(K(KT_BRL, keycode - KEY_BRL_DOT1 + 1));
 		else
 			return;
 	else
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

drivers-char-keyboardc-fix-braille-keyboard-keysym-generation.patch

