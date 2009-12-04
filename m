From: akpm@linux-foundation.org
Subject: + vsprintf-factorize-null-string.patch added to -mm tree
Date: Fri, 04 Dec 2009 14:31:51 -0800
Message-ID: <200912042231.nB4MVpRP010771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932483AbZLDWcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 17:32:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, fweisbec@gmail.com


The patch titled
     vsprintf: factorize "(null)" string
has been added to the -mm tree.  Its filename is
     vsprintf-factorize-null-string.patch

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
Subject: vsprintf: factorize "(null)" string
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

Change "<NULL>" to "(null)", unifying 3 equal strings.
glibc also uses "(null)" for the same purpose.

It decreases code size by 7 bytes:
 text    data     bss     dec     hex filename
15765       0       8   15773    3d9d vsprintf.o (ex lib/lib.a-BEFORE)
15758       0       8   15766    3d96 vsprintf.o (ex lib/lib.a-AFTER)

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-factorize-null-string lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-factorize-null-string
+++ a/lib/vsprintf.c
@@ -546,12 +546,12 @@ static char *number(char *buf, char *end
 	return buf;
 }
=20
-static char *string(char *buf, char *end, char *s, struct printf_spec =
spec)
+static char *string(char *buf, char *end, const char *s, struct printf=
_spec spec)
 {
 	int len, i;
=20
 	if ((unsigned long)s < PAGE_SIZE)
-		s =3D "<NULL>";
+		s =3D "(null)";
=20
 	len =3D strnlen(s, spec.precision);
=20
@@ -1498,7 +1498,7 @@ do {									\
 			size_t len;
 			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
 					|| (unsigned long)save_str < PAGE_SIZE)
-				save_str =3D "<NULL>";
+				save_str =3D "(null)";
 			len =3D strlen(save_str);
 			if (str + len + 1 < end)
 				memcpy(str, save_str, len + 1);
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

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
