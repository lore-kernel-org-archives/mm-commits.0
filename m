From: akpm@linux-foundation.org
Subject: [merged] vsprintf-use-tolower-whenever-possible.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:21 -0800
Message-ID: <200912152157.nBFLvLm0015716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755481AbZLOWHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:07:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vsprintf: use TOLOWER whenever possible
has been removed from the -mm tree.  Its filename was
     vsprintf-use-tolower-whenever-possible.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

origin.patch
pid-tighten-pidmap-spinlock-critical-section-by-removing-kfree.patch
pid-reduce-code-size-by-using-a-pointer-to-iterate-over-array.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
