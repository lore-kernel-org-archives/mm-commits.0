From: akpm@linux-foundation.org
Subject: + vsprintf-use-tolower-whenever-possible.patch added to -mm tree
Date: Fri, 04 Dec 2009 14:31:57 -0800
Message-ID: <200912042231.nB4MVvI6010957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932507AbZLDWcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 17:32:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, fweisbec@gmail.com


The patch titled
     vsprintf: use TOLOWER whenever possible
has been added to the -mm tree.  Its filename is
     vsprintf-use-tolower-whenever-possible.patch

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
Subject: vsprintf: use TOLOWER whenever possible
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

It decreases code size as well:
 text    data     bss     dec     hex filename
15758       0       8   15766    3d96 vsprintf.o (ex lib/lib.a-BEFORE)
15726       0       8   15734    3d76 vsprintf.o (ex lib/lib.a-TOLOWER)

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-use-tolower-whenever-possible lib/vsp=
rintf.c
--- a/lib/vsprintf.c~vsprintf-use-tolower-whenever-possible
+++ a/lib/vsprintf.c
@@ -1034,8 +1034,8 @@ precision:
 qualifier:
 	/* get the conversion qualifier */
 	spec->qualifier =3D -1;
-	if (*fmt =3D=3D 'h' || *fmt =3D=3D 'l' || *fmt =3D=3D 'L' ||
-	    *fmt =3D=3D 'Z' || *fmt =3D=3D 'z' || *fmt =3D=3D 't') {
+	if (*fmt =3D=3D 'h' || TOLOWER(*fmt) =3D=3D 'l' ||
+	    TOLOWER(*fmt) =3D=3D 'z' || *fmt =3D=3D 't') {
 		spec->qualifier =3D *fmt++;
 		if (unlikely(spec->qualifier =3D=3D *fmt)) {
 			if (spec->qualifier =3D=3D 'l') {
@@ -1102,7 +1102,7 @@ qualifier:
 			spec->type =3D FORMAT_TYPE_LONG;
 		else
 			spec->type =3D FORMAT_TYPE_ULONG;
-	} else if (spec->qualifier =3D=3D 'Z' || spec->qualifier =3D=3D 'z') =
{
+	} else if (TOLOWER(spec->qualifier) =3D=3D 'z') {
 		spec->type =3D FORMAT_TYPE_SIZE_T;
 	} else if (spec->qualifier =3D=3D 't') {
 		spec->type =3D FORMAT_TYPE_PTRDIFF;
@@ -1249,8 +1249,7 @@ int vsnprintf(char *buf, size_t size, co
 			if (qualifier =3D=3D 'l') {
 				long *ip =3D va_arg(args, long *);
 				*ip =3D (str - buf);
-			} else if (qualifier =3D=3D 'Z' ||
-					qualifier =3D=3D 'z') {
+			} else if (TOLOWER(qualifier) =3D=3D 'z') {
 				size_t *ip =3D va_arg(args, size_t *);
 				*ip =3D (str - buf);
 			} else {
@@ -1540,7 +1539,7 @@ do {									\
 			void *skip_arg;
 			if (qualifier =3D=3D 'l')
 				skip_arg =3D va_arg(args, long *);
-			else if (qualifier =3D=3D 'Z' || qualifier =3D=3D 'z')
+			else if (TOLOWER(qualifier) =3D=3D 'z')
 				skip_arg =3D va_arg(args, size_t *);
 			else
 				skip_arg =3D va_arg(args, int *);
@@ -1851,8 +1850,8 @@ int vsscanf(const char *buf, const char=20
=20
 		/* get conversion qualifier */
 		qualifier =3D -1;
-		if (*fmt =3D=3D 'h' || *fmt =3D=3D 'l' || *fmt =3D=3D 'L' ||
-		    *fmt =3D=3D 'Z' || *fmt =3D=3D 'z') {
+		if (*fmt =3D=3D 'h' || TOLOWER(*fmt) =3D=3D 'l' ||
+		    TOLOWER(*fmt) =3D=3D 'z') {
 			qualifier =3D *fmt++;
 			if (unlikely(qualifier =3D=3D *fmt)) {
 				if (qualifier =3D=3D 'h') {
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
