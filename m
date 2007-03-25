From: akpm@linux-foundation.org
Subject: + keyboardc-stop-flooding-dmesg-with-useless-warnings.patch added to -mm tree
Date: Sun, 25 Mar 2007 01:39:03 -0800
Message-ID: <200703250939.l2P9d3gR024857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37719 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbXCYJjP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 05:39:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: parag.warudkar@gmail.com, dtor@mail.ru


The patch titled
     keyboard.c: stop flooding dmesg with useless warnings
has been added to the -mm tree.  Its filename is
     keyboardc-stop-flooding-dmesg-with-useless-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: keyboard.c: stop flooding dmesg with useless warnings
From: Parag Warudkar <parag.warudkar@gmail.com>

I use Apple keyboard and mouse which seem to generate events with
keycode==0.

keyboard.c floods dmesg endlessly with below messages.  This happens at a
very fast rate and never stops, leaving the dmesg unusable.

[46591.960000] keyboard.c: can't emulate rawmode for keycode 0
[46591.996000] keyboard.c: can't emulate rawmode for keycode 0
[46592.032000] keyboard.c: can't emulate rawmode for keycode 0
[46592.068000] keyboard.c: can't emulate rawmode for keycode 0
[46592.104000] keyboard.c: can't emulate rawmode for keycode 0
[46592.140000] keyboard.c: can't emulate rawmode for keycode 0
[46592.176000] keyboard.c: can't emulate rawmode for keycode 0
[46592.212000] keyboard.c: can't emulate rawmode for keycode 0
[46592.248000] keyboard.c: can't emulate rawmode for keycode 0

The patch below avoids printing the warning if keycode == KEY_RESERVED.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/keyboard.c~keyboardc-stop-flooding-dmesg-with-useless-warnings drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~keyboardc-stop-flooding-dmesg-with-useless-warnings
+++ a/drivers/char/keyboard.c
@@ -1135,7 +1135,7 @@ static void kbd_keycode(unsigned int key
 
 	if ((raw_mode = (kbd->kbdmode == VC_RAW)) && !hw_raw)
 		if (emulate_raw(vc, keycode, !down << 7))
-			if (keycode < BTN_MISC)
+			if (keycode < BTN_MISC && keycode != KEY_RESERVED)
 				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode %d\n", keycode);
 
 #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
_

Patches currently in -mm which might be from parag.warudkar@gmail.com are

make-aout-executables-work-again.patch
make-aout-executables-work-again-fix.patch
keyboardc-stop-flooding-dmesg-with-useless-warnings.patch
