From: akpm@linux-foundation.org
Subject: - keyboard-notifier-documentation.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:14 -0700
Message-ID: <200803172100.m2HL0EHf030841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361AbYCQVER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:04:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, dtor@mail.ru, rdunlap@xenotime.net, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     keyboard notifier documentation
has been removed from the -mm tree.  Its filename was
     keyboard-notifier-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keyboard notifier documentation
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Document the keyboard notifier.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/input/notifier.txt |   52 +++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff -puN /dev/null Documentation/input/notifier.txt
--- /dev/null
+++ a/Documentation/input/notifier.txt
@@ -0,0 +1,52 @@
+Keyboard notifier
+
+One can use register_keyboard_notifier to get called back on keyboard
+events (see kbd_keycode() function for details).  The passed structure is
+keyboard_notifier_param:
+
+- 'vc' always provide the VC for which the keyboard event applies;
+- 'down' is 1 for a key press event, 0 for a key release;
+- 'shift' is the current modifier state, mask bit indexes are KG_*;
+- 'value' depends on the type of event.
+
+- KBD_KEYCODE events are always sent before other events, value is the keycode.
+- KBD_UNBOUND_KEYCODE events are sent if the keycode is not bound to a keysym.
+  value is the keycode.
+- KBD_UNICODE events are sent if the keycode -> keysym translation produced a
+  unicode character. value is the unicode value.
+- KBD_KEYSYM events are sent if the keycode -> keysym translation produced a
+  non-unicode character. value is the keysym.
+- KBD_POST_KEYSYM events are sent after the treatment of non-unicode keysyms.
+  That permits one to inspect the resulting LEDs for instance.
+
+For each kind of event but the last, the callback may return NOTIFY_STOP in
+order to "eat" the event: the notify loop is stopped and the keyboard event is
+dropped.
+
+In a rough C snippet, we have:
+
+kbd_keycode(keycode) {
+	...
+	params.value = keycode;
+	if (notifier_call_chain(KBD_KEYCODE,&params) == NOTIFY_STOP)
+	    || !bound) {
+		notifier_call_chain(KBD_UNBOUND_KEYCODE,&params);
+		return;
+	}
+
+	if (unicode) {
+		param.value = unicode;
+		if (notifier_call_chain(KBD_UNICODE,&params) == NOTIFY_STOP)
+			return;
+		emit unicode;
+		return;
+	}
+
+	params.value = keysym;
+	if (notifier_call_chain(KBD_KEYSYM,&params) == NOTIFY_STOP)
+		return;
+	apply keysym;
+	notifier_call_chain(KBD_POST_KEYSYM,&params);
+}
+
+NOTE: This notifier is usually called from interrupt context.
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

git-input.patch
input-put-ledstate-in-the-keyboard-notifier.patch
vt-notifier-extension-for-accessibility.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
basic-braille-screen-reader-support.patch
basic-braille-screen-reader-support-fixes.patch
basic-braille-screen-reader-support-ppc-fix.patch
basic-braille-screen-reader-support-doc.patch

