From: akpm@linux-foundation.org
Subject: + adbhid-produce-all-capslock-key-events.patch added to -mm tree
Date: Wed, 18 Jul 2007 22:38:29 -0700
Message-ID: <200707190538.l6J5cTGr015978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101AbXGSFis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:38:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amcnabb@mcnabbs.org, benh@kernel.crashing.org, dtor@mail.ru, jkosina@suse.cz


The patch titled
     adbhid: produce all capslock key events
has been added to the -mm tree.  Its filename is
     adbhid-produce-all-capslock-key-events.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: adbhid: produce all capslock key events
From: Andrew McNabb <amcnabb@mcnabbs.org>

The ADB keyboard, which is used for Apple PowerBooks, has strange behavior
with regard to the capslock key.  It keeps track of capslock state
internally, and it sends a keycode when capslock is engaged and a keycode
when capslock is disengaged.

When the current adbhid driver sees that the capslock key is pressed or
released, it creates both a keypress event and a keyrelease event
simultaneously.  This results in normal capslock behavior.

While this works, it makes it impossible to remap the capslock key to be a
control key.  However, by translating the 0xff keycode into capslock
keycodes, we can restore the missing capslock events and make it possible
to remap the capslock key.

With this patch, the adbhid driver will translate these 0xff keycodes into
capslock keypresses and keyreleases if
/sys/module/adbhid/parameters/restore_capslock_events is set to 1. 
Otherwise it will retain the current behavior.  This option is off by
default because occasionally the 0xff keycode is not a capslock event, and
a mistake may require the user to tap the capslock key.

Signed-off-by: Andrew McNabb <amcnabb@mcnabbs.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/adbhid.c |   46 +++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff -puN drivers/macintosh/adbhid.c~adbhid-produce-all-capslock-key-events drivers/macintosh/adbhid.c
--- a/drivers/macintosh/adbhid.c~adbhid-produce-all-capslock-key-events
+++ a/drivers/macintosh/adbhid.c
@@ -52,6 +52,11 @@
 
 MODULE_AUTHOR("Franz Sirl <Franz.Sirl-kernel@lauterbach.com>");
 
+static int restore_capslock_events = 0;
+module_param(restore_capslock_events, int, 0644);
+MODULE_PARM_DESC(restore_capslock_events,
+	"Produce keypress events for capslock on both keyup and keydown.");
+
 #define KEYB_KEYREG	0	/* register # for key up/down data */
 #define KEYB_LEDREG	2	/* register # for leds on ADB keyboard */
 #define MOUSE_DATAREG	0	/* reg# for movement/button codes from mouse */
@@ -217,6 +222,8 @@ struct adbhid {
 #define FLAG_FN_KEY_PRESSED	0x00000001
 #define FLAG_POWER_FROM_FN	0x00000002
 #define FLAG_EMU_FWDEL_DOWN	0x00000004
+#define FLAG_CAPSLOCK_TRANSLATE	0x00000008
+#define FLAG_CAPSLOCK_DOWN	0x00000010
 
 static struct adbhid *adbhid[16];
 
@@ -272,16 +279,45 @@ adbhid_keyboard_input(unsigned char *dat
 }
 
 static void
-adbhid_input_keycode(int id, int keycode, int repeat)
+adbhid_input_keycode(int id, int scancode, int repeat)
 {
 	struct adbhid *ahid = adbhid[id];
-	int up_flag;
+	int keycode, up_flag;
+
+	keycode = (scancode & 0x7f);
+	up_flag = (scancode & 0x80);
 
-	up_flag = (keycode & 0x80);
-	keycode &= 0x7f;
+	if (restore_capslock_events) {
+		if ((keycode == ADB_KEY_CAPSLOCK) && !up_flag) {
+			/* Key pressed, turning on the CapsLock LED.
+			 * The next 0xff will be interpreted as a release. */
+			ahid->flags |= FLAG_CAPSLOCK_TRANSLATE
+					| FLAG_CAPSLOCK_DOWN;
+		} else if (scancode == 0xff) {
+			/* Scancode 0xff usually signifies that the capslock
+			 * key was either pressed or released. */
+			if (ahid->flags & FLAG_CAPSLOCK_TRANSLATE) {
+				keycode = ADB_KEY_CAPSLOCK;
+				if (ahid->flags & FLAG_CAPSLOCK_DOWN) {
+					/* Key released */
+					up_flag = 1;
+					ahid->flags &= ~FLAG_CAPSLOCK_DOWN;
+				} else {
+					/* Key pressed */
+					up_flag = 0;
+					ahid->flags &= ~FLAG_CAPSLOCK_TRANSLATE;
+				}
+			} else {
+				printk(KERN_INFO "Spurious caps lock event "
+						"(scancode 0xff).");
+			}
+		}
+	}
 
 	switch (keycode) {
-	case ADB_KEY_CAPSLOCK: /* Generate down/up events for CapsLock everytime. */
+	case ADB_KEY_CAPSLOCK:
+		if (restore_capslock_events) break;
+		/* Generate down/up events for CapsLock everytime. */
 		input_report_key(ahid->input, KEY_CAPSLOCK, 1);
 		input_report_key(ahid->input, KEY_CAPSLOCK, 0);
 		input_sync(ahid->input);
_

Patches currently in -mm which might be from amcnabb@mcnabbs.org are

adbhid-produce-all-capslock-key-events.patch
adbhid-produce-all-capslock-key-events-fix.patch
