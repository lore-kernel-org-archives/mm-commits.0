From: akpm@linux-foundation.org
Subject: + input-put-ledstate-in-the-keyboard-notifier-fix.patch added to -mm tree
Date: Sat, 23 Feb 2008 10:59:00 -0800
Message-ID: <200802231859.m1NIx0vP010329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762203AbYBWS7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 13:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, dtor@mail.ru, eklhad@comcast.net, jikos@jikos.cz


The patch titled
     Keyboard notification ledstate fixes.
has been added to the -mm tree.  Its filename is
     input-put-ledstate-in-the-keyboard-notifier-fix.patch

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
Subject: Keyboard notification ledstate fixes.
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

In keyboard notifications, use kbd->ledflagstate instead of
getledstate() since that's what the keyboard layer is supposed to use.

Update param.ledstate again between key handler call and notifying
KBD_POST_KEYSYM, since key handlers may update the led state.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Karl Dahlke <eklhad@comcast.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/keyboard.c~input-put-ledstate-in-the-keyboard-notifier-fix drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~input-put-ledstate-in-the-keyboard-notifier-fix
+++ a/drivers/char/keyboard.c
@@ -1238,7 +1238,7 @@ static void kbd_keycode(unsigned int key
 	}
 
 	param.shift = shift_final = (shift_state | kbd->slockstate) ^ kbd->lockstate;
-	param.ledstate = getledstate();
+	param.ledstate = kbd->ledflagstate;
 	key_map = key_maps[shift_final];
 
 	if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_KEYCODE, &param) == NOTIFY_STOP || !key_map) {
@@ -1287,6 +1287,7 @@ static void kbd_keycode(unsigned int key
 
 	(*k_handler[type])(vc, keysym & 0xff, !down);
 
+	param.ledstate = kbd->ledflagstate;
 	atomic_notifier_call_chain(&keyboard_notifier_list, KBD_POST_KEYSYM, &param);
 
 	if (type != KT_SLOCK)
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

keyboard-notifier-documentation.patch
input-put-ledstate-in-the-keyboard-notifier-fix.patch
vt-notifier-fix-for-vt-switch.patch
vt-notifier-extension-for-accessibility.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
basic-braille-screen-reader-support.patch
