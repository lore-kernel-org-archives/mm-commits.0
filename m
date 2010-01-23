From: akpm@linux-foundation.org
Subject: + lib-stringc-simplify-stricmp.patch added to -mm tree
Date: Fri, 22 Jan 2010 16:27:48 -0800
Message-ID: <201001230027.o0N0Rmh1005756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755418Ab0AWA2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 19:28:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, fweisbec@gmail.com, joe@perches.com


The patch titled
     lib/string.c: simplify stricmp()
has been added to the -mm tree.  Its filename is
     lib-stringc-simplify-stricmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lib/string.c: simplify stricmp()
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

Removes 32 bytes on core2 with gcc 4.4.1:
   text    data     bss     dec     hex filename
   3196       0       0    3196     c7c lib/string-BEFORE.o
   3164       0       0    3164     c5c lib/string-AFTER.o

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff -puN lib/string.c~lib-stringc-simplify-stricmp lib/string.c
--- a/lib/string.c~lib-stringc-simplify-stricmp
+++ a/lib/string.c
@@ -36,25 +36,21 @@ int strnicmp(const char *s1, const char=20
 	/* Yes, Virginia, it had better be unsigned */
 	unsigned char c1, c2;
=20
-	c1 =3D c2 =3D 0;
-	if (len) {
-		do {
-			c1 =3D *s1;
-			c2 =3D *s2;
-			s1++;
-			s2++;
-			if (!c1)
-				break;
-			if (!c2)
-				break;
-			if (c1 =3D=3D c2)
-				continue;
-			c1 =3D tolower(c1);
-			c2 =3D tolower(c2);
-			if (c1 !=3D c2)
-				break;
-		} while (--len);
-	}
+	if (!len)
+		return 0;
+
+	do {
+		c1 =3D *s1++;
+		c2 =3D *s2++;
+		if (!c1 || !c2)
+			break;
+		if (c1 =3D=3D c2)
+			continue;
+		c1 =3D tolower(c1);
+		c2 =3D tolower(c2);
+		if (c1 !=3D c2)
+			break;
+	} while (--len);
 	return (int)c1 - (int)c2;
 }
 EXPORT_SYMBOL(strnicmp);
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

lib-stringc-simplify-stricmp.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
