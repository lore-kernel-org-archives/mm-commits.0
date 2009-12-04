From: akpm@linux-foundation.org
Subject: + string-on-strstrip-first-remove-leading-spaces-before-running-over-str.patch added to -mm tree
Date: Fri, 04 Dec 2009 14:32:13 -0800
Message-ID: <200912042232.nB4MWD2L011681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757435AbZLDWmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 17:42:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com


The patch titled
     string: on strstrip(), first remove leading spaces before running =
over str
has been added to the -mm tree.  Its filename is
     string-on-strstrip-first-remove-leading-spaces-before-running-over=
-str.patch

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
Subject: string: on strstrip(), first remove leading spaces before runn=
ing over str
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

=2E.. so that strlen() iterates over a smaller string comprising of the
remaining characters only.

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/string.c~string-on-strstrip-first-remove-leading-spaces-b=
efore-running-over-str lib/string.c
--- a/lib/string.c~string-on-strstrip-first-remove-leading-spaces-befor=
e-running-over-str
+++ a/lib/string.c
@@ -364,8 +364,8 @@ char *strstrip(char *s)
 	size_t size;
 	char *end;
=20
+	s =3D skip_spaces(s);
 	size =3D strlen(s);
-
 	if (!size)
 		return s;
=20
@@ -374,7 +374,7 @@ char *strstrip(char *s)
 		end--;
 	*(end + 1) =3D '\0';
=20
-	return skip_spaces(s);
+	return s;
 }
 EXPORT_SYMBOL(strstrip);
=20
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
