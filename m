From: akpm@linux-foundation.org
Subject: - input-put-ledstate-in-the-keyboard-notifier.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:42 -0700
Message-ID: <200804150910.m3F9Ag6k020650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756822AbYDOJMs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:12:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eklhad@comcast.net, dtor@mail.ru, jikos@jikos.cz, samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     input: put ledstate in the keyboard notifier
has been removed from the -mm tree.  Its filename was
     input-put-ledstate-in-the-keyboard-notifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: put ledstate in the keyboard notifier
From: Karl Dahlke <eklhad@comcast.net>

I think there is general agreement, including myself, that led state should
be part of the key event, like shiftstate, and not grabbed asynchronously
after the fact.

[samuel.thibault@ens-lyon.org: various fixes]
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c  |    2 ++
 include/linux/keyboard.h |    1 +
 2 files changed, 3 insertions(+)

diff -puN drivers/char/keyboard.c~input-put-ledstate-in-the-keyboard-notifier drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~input-put-ledstate-in-the-keyboard-notifier
+++ a/drivers/char/keyboard.c
@@ -1238,6 +1238,7 @@ static void kbd_keycode(unsigned int key
 	}
 
 	param.shift = shift_final = (shift_state | kbd->slockstate) ^ kbd->lockstate;
+	param.ledstate = kbd->ledflagstate;
 	key_map = key_maps[shift_final];
 
 	if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_KEYCODE, &param) == NOTIFY_STOP || !key_map) {
@@ -1286,6 +1287,7 @@ static void kbd_keycode(unsigned int key
 
 	(*k_handler[type])(vc, keysym & 0xff, !down);
 
+	param.ledstate = kbd->ledflagstate;
 	atomic_notifier_call_chain(&keyboard_notifier_list, KBD_POST_KEYSYM, &param);
 
 	if (type != KT_SLOCK)
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

git-input.patch
vt-notifier-extension-for-accessibility.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch

