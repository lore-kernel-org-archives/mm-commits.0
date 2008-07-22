From: akpm@linux-foundation.org
Subject: + hid-apple_fn_keys-f5-and-f6.patch added to -mm tree
Date: Tue, 22 Jul 2008 02:08:14 -0700
Message-ID: <200807220908.m6M98EIL020178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbYGVJIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 05:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, dtor@mail.ru, jikos@jikos.cz


The patch titled
     hid: apple_fn_keys F5 and F6
has been added to the -mm tree.  Its filename is
     hid-apple_fn_keys-f5-and-f6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: hid: apple_fn_keys F5 and F6
=46rom: Henrik Rydberg <rydberg@euromail.se>

In drivers/hid/hid-input.c, the apple_fn_keys translation table contain=
s
no entries for the F5 and F6 keys.  This patch maps the F5 and F6 keys =
to
KBDILLUMDOWN and KBDILLUMUP, respektively, which make them work as
keyboard backlight control keys.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-input.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/hid/hid-input.c~hid-apple_fn_keys-f5-and-f6 drivers/h=
id/hid-input.c
--- a/drivers/hid/hid-input.c~hid-apple_fn_keys-f5-and-f6
+++ a/drivers/hid/hid-input.c
@@ -100,6 +100,8 @@ static struct hidinput_key_translation a
 	{ KEY_F2,       KEY_BRIGHTNESSUP,   APPLE_FLAG_FKEY },
 	{ KEY_F3,       KEY_FN_F5,          APPLE_FLAG_FKEY }, /* Expos=E9 */
 	{ KEY_F4,       KEY_FN_F4,          APPLE_FLAG_FKEY }, /* Dashboard *=
/
+	{ KEY_F5,	KEY_KBDILLUMDOWN,   APPLE_FLAG_FKEY },
+	{ KEY_F6,	KEY_KBDILLUMUP,     APPLE_FLAG_FKEY },
 	{ KEY_F7,       KEY_PREVIOUSSONG,   APPLE_FLAG_FKEY },
 	{ KEY_F8,       KEY_PLAYPAUSE,      APPLE_FLAG_FKEY },
 	{ KEY_F9,       KEY_NEXTSONG,       APPLE_FLAG_FKEY },
_

Patches currently in -mm which might be from rydberg@euromail.se are

hid-apple_fn_keys-f5-and-f6.patch
input-bcm5974-055-smoother-motion-irq-simplification.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
