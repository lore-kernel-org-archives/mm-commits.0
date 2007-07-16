From: akpm@linux-foundation.org
Subject: - vsprintfc-optimizing-part-1-easy-and-obvious-stuff.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:30 -0700
Message-ID: <200707162059.l6GKxUtT002433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762656AbXGPVPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, jones@cs.uiowa.edu, mm-commits@vger.kernel.org


The patch titled
     vsprintf.c: optimizing, part 1 (easy and obvious stuff)
has been removed from the -mm tree.  Its filename was
     vsprintfc-optimizing-part-1-easy-and-obvious-stuff.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: vsprintf.c: optimizing, part 1 (easy and obvious stuff)
=46rom: Denis Vlasenko <vda.linux@googlemail.com>

* There is no point in having full "0...9a...z" constant vector,
  if we use only "0...9a...f" (and "x" for "0x").

* Post-decrement usually needs a few more instructions, so use
  pre decrement instead where makes sense:
- =A0 =A0 =A0 while (i < precision--) {
+ =A0 =A0 =A0 while (i <=3D --precision) {

* if base !=3D 10 (=3D> base 8 or 16), we can avoid using division
  in a loop and use mask/shift, obtaining much faster conversion.
  (More complex optimization for base 10 case is in the second patch).

Overall, size vsprintf.o shows ~80 bytes smaller text section
with this patch applied.

Signed-off-by: Douglas W Jones <jones@cs.uiowa.edu>
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   73 ++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 28 deletions(-)

diff -puN lib/vsprintf.c~vsprintfc-optimizing-part-1-easy-and-obvious-s=
tuff lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintfc-optimizing-part-1-easy-and-obvious-stuff
+++ a/lib/vsprintf.c
@@ -143,12 +143,14 @@ static int skip_atoi(const char **s)
 #define SPECIAL	32		/* 0x */
 #define LARGE	64		/* use 'ABCDEF' instead of 'abcdef' */
=20
-static char * number(char * buf, char * end, unsigned long long num, i=
nt base, int size, int precision, int type)
+static char *number(char *buf, char *end, unsigned long long num, int =
base, int size, int precision, int type)
 {
-	char c,sign,tmp[66];
+	char sign,tmp[66];
 	const char *digits;
-	static const char small_digits[] =3D "0123456789abcdefghijklmnopqrstu=
vwxyz";
-	static const char large_digits[] =3D "0123456789ABCDEFGHIJKLMNOPQRSTU=
VWXYZ";
+	/* we are called with base 8, 10 or 16, only, thus don't need "g..." =
 */
+	static const char small_digits[] =3D "0123456789abcdefx"; /* "ghijklm=
nopqrstuvwxyz"; */
+	static const char large_digits[] =3D "0123456789ABCDEFX"; /* "GHIJKLM=
NOPQRSTUVWXYZ"; */
+	int need_pfx =3D ((type & SPECIAL) && base !=3D 10);
 	int i;
=20
 	digits =3D (type & LARGE) ? large_digits : small_digits;
@@ -156,7 +158,6 @@ static char * number(char * buf, char *=20
 		type &=3D ~ZEROPAD;
 	if (base < 2 || base > 36)
 		return NULL;
-	c =3D (type & ZEROPAD) ? '0' : ' ';
 	sign =3D 0;
 	if (type & SIGN) {
 		if ((signed long long) num < 0) {
@@ -171,64 +172,80 @@ static char * number(char * buf, char *=20
 			size--;
 		}
 	}
-	if (type & SPECIAL) {
+	if (need_pfx) {
+		size--;
 		if (base =3D=3D 16)
-			size -=3D 2;
-		else if (base =3D=3D 8)
 			size--;
 	}
+
+	/* generate full string in tmp[], in reverse order */
 	i =3D 0;
 	if (num =3D=3D 0)
-		tmp[i++]=3D'0';
-	else while (num !=3D 0)
-		tmp[i++] =3D digits[do_div(num,base)];
+		tmp[i++] =3D '0';
+	else if (base !=3D 10) { /* 8 or 16 */
+		int mask =3D base - 1;
+		int shift =3D 3;
+		if (base =3D=3D 16) shift =3D 4;
+		do {
+			tmp[i++] =3D digits[((unsigned char)num) & mask];
+			num >>=3D shift;
+		} while (num);
+	} else do { /* generic code, works for any base */
+		tmp[i++] =3D digits[do_div(num,10 /*base*/)];
+	} while (num);
+
+	/* printing 100 using %2d gives "100", not "00" */
 	if (i > precision)
 		precision =3D i;
+	/* leading space padding */
 	size -=3D precision;
-	if (!(type&(ZEROPAD+LEFT))) {
-		while(size-->0) {
+	if (!(type & (ZEROPAD+LEFT))) {
+		while(--size >=3D 0) {
 			if (buf < end)
 				*buf =3D ' ';
 			++buf;
 		}
 	}
+	/* sign */
 	if (sign) {
 		if (buf < end)
 			*buf =3D sign;
 		++buf;
 	}
-	if (type & SPECIAL) {
-		if (base=3D=3D8) {
-			if (buf < end)
-				*buf =3D '0';
-			++buf;
-		} else if (base=3D=3D16) {
-			if (buf < end)
-				*buf =3D '0';
-			++buf;
+	/* "0x" / "0" prefix */
+	if (need_pfx) {
+		if (buf < end)
+			*buf =3D '0';
+		++buf;
+		if (base =3D=3D 16) {
 			if (buf < end)
-				*buf =3D digits[33];
+				*buf =3D digits[16]; /* for arbitrary base: digits[33]; */
 			++buf;
 		}
 	}
+	/* zero or space padding */
 	if (!(type & LEFT)) {
-		while (size-- > 0) {
+		char c =3D (type & ZEROPAD) ? '0' : ' ';
+		while (--size >=3D 0) {
 			if (buf < end)
 				*buf =3D c;
 			++buf;
 		}
 	}
-	while (i < precision--) {
+	/* hmm even more zero padding? */
+	while (i <=3D --precision) {
 		if (buf < end)
 			*buf =3D '0';
 		++buf;
 	}
-	while (i-- > 0) {
+	/* actual digits of result */
+	while (--i >=3D 0) {
 		if (buf < end)
 			*buf =3D tmp[i];
 		++buf;
 	}
-	while (size-- > 0) {
+	/* trailing space padding */
+	while (--size >=3D 0) {
 		if (buf < end)
 			*buf =3D ' ';
 		++buf;
@@ -276,7 +293,7 @@ int vsnprintf(char *buf, size_t size, co
 	   used for unknown buffer sizes. */
 	if (unlikely((int) size < 0)) {
 		/* There can be only one.. */
-		static int warn =3D 1;
+		static char warn =3D 1;
 		WARN_ON(warn);
 		warn =3D 0;
 		return 0;
_

Patches currently in -mm which might be from vda.linux@googlemail.com a=
re

origin.patch
