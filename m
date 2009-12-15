From: akpm@linux-foundation.org
Subject: [merged] parser-remove-unnecessary-strlen.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:51 -0800
Message-ID: <200912152157.nBFLvpde015752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761324AbZLOV6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:58:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     parser: remove unnecessary strlen()
has been removed from the -mm tree.  Its filename was
     parser-remove-unnecessary-strlen.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: parser: remove unnecessary strlen()
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

No functional change.  Cache strlen() result to avoid recalculating it =
up
to 3 times on the worst case.

Reduces code size a little by 32 bytes:
   text    data     bss     dec     hex filename
   1385       0       0    1385     569 lib/parser.o-BEFORE
   1353       0       0    1353     549 lib/parser.o-AFTER

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/parser.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN lib/parser.c~parser-remove-unnecessary-strlen lib/parser.c
--- a/lib/parser.c~parser-remove-unnecessary-strlen
+++ a/lib/parser.c
@@ -56,13 +56,16 @@ static int match_one(char *s, const char
=20
 		args[argc].from =3D s;
 		switch (*p++) {
-		case 's':
-			if (strlen(s) =3D=3D 0)
+		case 's': {
+			size_t str_len =3D strlen(s);
+
+			if (str_len =3D=3D 0)
 				return 0;
-			else if (len =3D=3D -1 || len > strlen(s))
-				len =3D strlen(s);
+			if (len =3D=3D -1 || len > str_len)
+				len =3D str_len;
 			args[argc].to =3D s + len;
 			break;
+		}
 		case 'd':
 			simple_strtol(s, &args[argc].to, 0);
 			goto num;
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

origin.patch
pid-tighten-pidmap-spinlock-critical-section-by-removing-kfree.patch
pid-reduce-code-size-by-using-a-pointer-to-iterate-over-array.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
