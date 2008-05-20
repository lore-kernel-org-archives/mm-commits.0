From: akpm@linux-foundation.org
Subject: + input-i8042-move-dritek-quirk-so-it-also-gets-applied-on-resume.patch added to -mm tree
Date: Mon, 19 May 2008 17:12:32 -0700
Message-ID: <200805200012.m4K0CWpn028417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757919AbYETAMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 20:12:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bonbons@linux-vserver.org, dtor@mail.ru


The patch titled
     input: i8042: move Dritek quirk so it also gets applied on resume
has been added to the -mm tree.  Its filename is
     input-i8042-move-dritek-quirk-so-it-also-gets-applied-on-resume.pa=
tch

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
Subject: input: i8042: move Dritek quirk so it also gets applied on res=
ume
=46rom: Bruno Pr=E9mont <bonbons@linux-vserver.org>

Move the quirk from from i8042_probe() to i8042_enable_kbd_port() which=
 is
also called during resume.

I think it is safe to ignore failure to enable dritek.  I would also
prefer not to fail complete keyboard initialisation if the extension
fails.

The Dritek quirk is also required on resume from S2RAM, doing it only a=
t
probe time is not sufficient.

Signed-off-by: Bruno Pr=E9mont <bonbons@linux-vserver.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/input/serio/i8042.c~input-i8042-move-dritek-quirk-so-=
it-also-gets-applied-on-resume drivers/input/serio/i8042.c
--- a/drivers/input/serio/i8042.c~input-i8042-move-dritek-quirk-so-it-a=
lso-gets-applied-on-resume
+++ a/drivers/input/serio/i8042.c
@@ -404,6 +404,15 @@ static int i8042_enable_kbd_port(void)
 		printk(KERN_ERR "i8042.c: Failed to enable KBD port.\n");
 		return -EIO;
 	}
+#ifdef CONFIG_X86
+	if (i8042_dritek) {
+		char param =3D 0x90;
+		int error =3D i8042_command(&param, 0x1059);
+		if (error)
+			printk(KERN_WARNING "Failed to enable DRITEK "
+			       "extension: %d\n", error);
+	}
+#endif
=20
 	return 0;
 }
@@ -1171,14 +1180,6 @@ static int __devinit i8042_probe(struct=20
 		if (error)
 			goto out_fail;
 	}
-#ifdef CONFIG_X86
-	if (i8042_dritek) {
-		char param =3D 0x90;
-		error =3D i8042_command(&param, 0x1059);
-		if (error)
-			goto out_fail;
-	}
-#endif
 /*
  * Ok, everything is ready, let's register all serio ports
  */
_

Patches currently in -mm which might be from bonbons@linux-vserver.org =
are

input-i8042-move-dritek-quirk-so-it-also-gets-applied-on-resume.patch
input-i8042-add-dritek-quirk-for-acer-travelmate-660.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
