From: akpm@linux-foundation.org
Subject: [merged] drivers-char-keyboardc-fix-braille-keyboard-keysym-generation.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:34:36 -0800
Message-ID: <200911302034.nAUKYalc023947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187AbZK3Ufy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:35:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, alan@lxorguk.ukuu.org.uk, dtor@mail.ru, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/char/keyboard.c: fix braille keyboard keysym generation
has been removed from the -mm tree.  Its filename was
     drivers-char-keyboardc-fix-braille-keyboard-keysym-generation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/keyboard.c: fix braille keyboard keysym generation
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Keysyms stored in key_map[] are not simply K() values, but U(K()) values,
as can be seen in the KDSKBENT ioctl handler.  The kernel-generated
braille keysyms thus need a U() call too.

Without this patch, braille keyboards announced as KEY_BRL_DOT* (whcih are
still pretty rare) won't actually work.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: <stable@kernel.org>
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

linux-next.patch

