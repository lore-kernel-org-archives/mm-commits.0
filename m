From: akpm@linux-foundation.org
Subject: + parser-remove-unnecessary-strlen.patch added to -mm tree
Date: Fri, 04 Dec 2009 14:33:47 -0800
Message-ID: <200912042233.nB4MXlxF015432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757233AbZLDWeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 17:34:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, randy.dunlap@oracle.com


The patch titled
     parser: remove unnecessary strlen()
has been added to the -mm tree.  Its filename is
     parser-remove-unnecessary-strlen.patch

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

linux-next.patch
vsprintf-factorize-null-string.patch
vsprintf-pre-calculate-final-string-length-for-later-use.patch
vsprintf-give-it-some-care-to-please-checkpatchpl.patch
vsprintf-use-tolower-whenever-possible.patch
vsprintf-reduce-code-size-by-avoiding-extra-check.patch
vsprintf-move-local-vars-to-block-local-vars-and-remove-unneeded-ones.p=
atch
vsprintf-factor-out-skip_space-code-in-a-separate-function.patch
vsprintf-reuse-almost-identical-simple_strtoulx-functions.patch
ctype-constify-read-only-_ctype-string.patch
string-factorize-skip_spaces-and-export-it-to-be-generally-available.pa=
tch
string-on-strstrip-first-remove-leading-spaces-before-running-over-str.=
patch
tree-wide-convert-open-calls-to-remove-spaces-to-skip_spaces-lib-functi=
on.patch
parser-remove-unnecessary-strlen.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
