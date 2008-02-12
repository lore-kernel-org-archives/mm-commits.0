From: akpm@linux-foundation.org
Subject: + keyboard-notifier-documentation.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:18:59 -0800
Message-ID: <200802122318.m1CNIxrf028032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYBLXTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:19:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, dtor@mail.ru, rdunlap@xenotime.net, rob@landley.net


The patch titled
     keyboard notifier documentation
has been added to the -mm tree.  Its filename is
     keyboard-notifier-documentation.patch

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

keyboard-notifier-documentation.patch
