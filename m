From: akpm@linux-foundation.org
Subject: - input-map-missing-keys-to-appropriate-functions.patch removed from -mm tree
Date: Wed, 12 Nov 2008 12:47:03 -0800
Message-ID: <200811122047.mACKl3M9006826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572AbYKLUrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 15:47:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, dmitry.torokhov@gmail.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     input: map missing keys to appropriate functions
has been removed from the -mm tree.  Its filename was
     input-map-missing-keys-to-appropriate-functions.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: input: map missing keys to appropriate functions
=46rom: Henrik Rydberg <rydberg@euromail.se>

On macbooks there are specific keys for the user-space functions Expose
and Dashboard, which currently has no counterpart in input.h.  This pat=
ch
adds KEY_SCALE and KEY_DASHBOARD, and maps the keyboard accordingly.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-apple.c |    5 +++--
 include/linux/input.h   |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/hid/hid-apple.c~input-map-missing-keys-to-appropriate=
-functions drivers/hid/hid-apple.c
--- a/drivers/hid/hid-apple.c~input-map-missing-keys-to-appropriate-fun=
ctions
+++ a/drivers/hid/hid-apple.c
@@ -55,10 +55,11 @@ struct apple_key_translation {
=20
 static struct apple_key_translation apple_fn_keys[] =3D {
 	{ KEY_BACKSPACE, KEY_DELETE },
+	{ KEY_ENTER,	KEY_INSERT },
 	{ KEY_F1,	KEY_BRIGHTNESSDOWN, APPLE_FLAG_FKEY },
 	{ KEY_F2,	KEY_BRIGHTNESSUP,   APPLE_FLAG_FKEY },
-	{ KEY_F3,	KEY_FN_F5,          APPLE_FLAG_FKEY }, /* Expos=C3=A9 */
-	{ KEY_F4,	KEY_FN_F4,          APPLE_FLAG_FKEY }, /* Dashboard */
+	{ KEY_F3,	KEY_SCALE,          APPLE_FLAG_FKEY },
+	{ KEY_F4,	KEY_DASHBOARD,      APPLE_FLAG_FKEY },
 	{ KEY_F5,	KEY_KBDILLUMDOWN,   APPLE_FLAG_FKEY },
 	{ KEY_F6,	KEY_KBDILLUMUP,     APPLE_FLAG_FKEY },
 	{ KEY_F7,	KEY_PREVIOUSSONG,   APPLE_FLAG_FKEY },
diff -puN include/linux/input.h~input-map-missing-keys-to-appropriate-f=
unctions include/linux/input.h
--- a/include/linux/input.h~input-map-missing-keys-to-appropriate-funct=
ions
+++ a/include/linux/input.h
@@ -238,6 +238,7 @@ struct input_absinfo {
 #define KEY_KPEQUAL		117
 #define KEY_KPPLUSMINUS		118
 #define KEY_PAUSE		119
+#define KEY_SCALE		120	/* AL Compiz Scale (Expose) */
=20
 #define KEY_KPCOMMA		121
 #define KEY_HANGEUL		122
@@ -322,6 +323,7 @@ struct input_absinfo {
 #define KEY_PAUSECD		201
 #define KEY_PROG3		202
 #define KEY_PROG4		203
+#define KEY_DASHBOARD		204	/* AL Dashboard */
 #define KEY_SUSPEND		205
 #define KEY_CLOSE		206	/* AC Close */
 #define KEY_PLAY		207
_

Patches currently in -mm which might be from rydberg@euromail.se are

hwmon-applesmc-add-support-for-macbook-4.patch
linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
