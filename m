From: akpm@linux-foundation.org
Subject: + input-put-ledstate-in-the-keyboard-notifier.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:29:26 -0800
Message-ID: <200802230730.m1N7UFZx017939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753813AbYBWHak (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:30:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eklhad@comcast.net, dtor@mail.ru, jikos@jikos.cz


The patch titled
     input: put ledstate in the keyboard notifier
has been added to the -mm tree.  Its filename is
     input-put-ledstate-in-the-keyboard-notifier.patch

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
Subject: input: put ledstate in the keyboard notifier
From: Karl Dahlke <eklhad@comcast.net>

I think there is general agreement, including myself, that led state should
be part of the key event, like shiftstate, and not grabbed asynchronously
after the fact.

Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c  |    1 +
 include/linux/keyboard.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/char/keyboard.c~input-put-ledstate-in-the-keyboard-notifier drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~input-put-ledstate-in-the-keyboard-notifier
+++ a/drivers/char/keyboard.c
@@ -1238,6 +1238,7 @@ static void kbd_keycode(unsigned int key
 	}
 
 	param.shift = shift_final = (shift_state | kbd->slockstate) ^ kbd->lockstate;
+	param.ledstate = getledstate();
 	key_map = key_maps[shift_final];
 
 	if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_KEYCODE, &param) == NOTIFY_STOP || !key_map) {
diff -puN include/linux/keyboard.h~input-put-ledstate-in-the-keyboard-notifier include/linux/keyboard.h
--- a/include/linux/keyboard.h~input-put-ledstate-in-the-keyboard-notifier
+++ a/include/linux/keyboard.h
@@ -33,6 +33,7 @@ struct keyboard_notifier_param {
 	struct vc_data *vc;	/* VC on which the keyboard press was done */
 	int down;		/* Pressure of the key? */
 	int shift;		/* Current shift mask */
+	int ledstate;		/* Current led state */
 	unsigned int value;	/* keycode, unicode value or keysym */
 };
 
_

Patches currently in -mm which might be from eklhad@comcast.net are

input-put-ledstate-in-the-keyboard-notifier.patch
vt-notifier-extension-for-accessibility.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
