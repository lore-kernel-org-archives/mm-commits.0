From: akpm@linux-foundation.org
Subject: + vsprintf-move-local-vars-to-block-local-vars-and-remove-unneeded-ones.patch added to -mm tree
Date: Fri, 04 Dec 2009 14:32:01 -0800
Message-ID: <200912042232.nB4MW1OZ011194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757364AbZLDWcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 17:32:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, fweisbec@gmail.com


The patch titled
     vsprintf: move local vars to block local vars and remove unneeded =
ones
has been added to the -mm tree.  Its filename is
     vsprintf-move-local-vars-to-block-local-vars-and-remove-unneeded-o=
nes.patch

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
Subject: vsprintf: move local vars to block local vars and remove unnee=
ded ones
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

Cleanup by moving variables closer to the scope where they're used in f=
act.
Also, remove unneeded ones.

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   64 ++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 36 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-move-local-vars-to-block-local-vars-a=
nd-remove-unneeded-ones lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-move-local-vars-to-block-local-vars-and-r=
emove-unneeded-ones
+++ a/lib/vsprintf.c
@@ -892,8 +892,8 @@ static char *pointer(const char *fmt, ch
 	case 'F':
 	case 'f':
 		ptr =3D dereference_function_descriptor(ptr);
-	case 's':
 		/* Fallthrough */
+	case 's':
 	case 'S':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
@@ -1156,8 +1156,7 @@ qualifier:
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
 	unsigned long long num;
-	char *str, *end, c;
-	int read;
+	char *str, *end;
 	struct printf_spec spec =3D {0};
=20
 	/* Reject out-of-range values early.  Large positive sizes are
@@ -1176,8 +1175,7 @@ int vsnprintf(char *buf, size_t size, co
=20
 	while (*fmt) {
 		const char *old_fmt =3D fmt;
-
-		read =3D format_decode(fmt, &spec);
+		int read =3D format_decode(fmt, &spec);
=20
 		fmt +=3D read;
=20
@@ -1201,7 +1199,9 @@ int vsnprintf(char *buf, size_t size, co
 			spec.precision =3D va_arg(args, int);
 			break;
=20
-		case FORMAT_TYPE_CHAR:
+		case FORMAT_TYPE_CHAR: {
+			char c;
+
 			if (!(spec.flags & LEFT)) {
 				while (--spec.field_width > 0) {
 					if (str < end)
@@ -1220,6 +1220,7 @@ int vsnprintf(char *buf, size_t size, co
 				++str;
 			}
 			break;
+		}
=20
 		case FORMAT_TYPE_STR:
 			str =3D string(str, end, va_arg(args, char *), spec);
@@ -1464,7 +1465,6 @@ int vbin_printf(u32 *bin_buf, size_t siz
 {
 	struct printf_spec spec =3D {0};
 	char *str, *end;
-	int read;
=20
 	str =3D (char *)bin_buf;
 	end =3D (char *)(bin_buf + size);
@@ -1490,12 +1490,14 @@ do {									\
 } while (0)
=20
 	while (*fmt) {
-		read =3D format_decode(fmt, &spec);
+		int read =3D format_decode(fmt, &spec);
=20
 		fmt +=3D read;
=20
 		switch (spec.type) {
 		case FORMAT_TYPE_NONE:
+		case FORMAT_TYPE_INVALID:
+		case FORMAT_TYPE_PERCENT_CHAR:
 			break;
=20
 		case FORMAT_TYPE_WIDTH:
@@ -1528,12 +1530,6 @@ do {									\
 				fmt++;
 			break;
=20
-		case FORMAT_TYPE_PERCENT_CHAR:
-			break;
-
-		case FORMAT_TYPE_INVALID:
-			break;
-
 		case FORMAT_TYPE_NRCHARS: {
 			/* skip %n 's argument */
 			int qualifier =3D spec.qualifier;
@@ -1606,10 +1602,9 @@ EXPORT_SYMBOL_GPL(vbin_printf);
  */
 int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bi=
n_buf)
 {
-	unsigned long long num;
-	char *str, *end, c;
-	const char *args =3D (const char *)bin_buf;
 	struct printf_spec spec =3D {0};
+	char *str, *end;
+	const char *args =3D (const char *)bin_buf;
=20
 	if (WARN_ON_ONCE((int) size < 0))
 		return 0;
@@ -1639,10 +1634,8 @@ int bstr_printf(char *buf, size_t size,=20
 	}
=20
 	while (*fmt) {
-		int read;
 		const char *old_fmt =3D fmt;
-
-		read =3D format_decode(fmt, &spec);
+		int read =3D format_decode(fmt, &spec);
=20
 		fmt +=3D read;
=20
@@ -1666,7 +1659,9 @@ int bstr_printf(char *buf, size_t size,=20
 			spec.precision =3D get_arg(int);
 			break;
=20
-		case FORMAT_TYPE_CHAR:
+		case FORMAT_TYPE_CHAR: {
+			char c;
+
 			if (!(spec.flags & LEFT)) {
 				while (--spec.field_width > 0) {
 					if (str < end)
@@ -1684,11 +1679,11 @@ int bstr_printf(char *buf, size_t size,=20
 				++str;
 			}
 			break;
+		}
=20
 		case FORMAT_TYPE_STR: {
 			const char *str_arg =3D args;
-			size_t len =3D strlen(str_arg);
-			args +=3D len + 1;
+			args +=3D strlen(str_arg) + 1;
 			str =3D string(str, end, (char *)str_arg, spec);
 			break;
 		}
@@ -1700,11 +1695,6 @@ int bstr_printf(char *buf, size_t size,=20
 			break;
=20
 		case FORMAT_TYPE_PERCENT_CHAR:
-			if (str < end)
-				*str =3D '%';
-			++str;
-			break;
-
 		case FORMAT_TYPE_INVALID:
 			if (str < end)
 				*str =3D '%';
@@ -1715,15 +1705,15 @@ int bstr_printf(char *buf, size_t size,=20
 			/* skip */
 			break;
=20
-		default:
+		default: {
+			unsigned long long num;
+
 			switch (spec.type) {
=20
 			case FORMAT_TYPE_LONG_LONG:
 				num =3D get_arg(long long);
 				break;
 			case FORMAT_TYPE_ULONG:
-				num =3D get_arg(unsigned long);
-				break;
 			case FORMAT_TYPE_LONG:
 				num =3D get_arg(unsigned long);
 				break;
@@ -1753,8 +1743,9 @@ int bstr_printf(char *buf, size_t size,=20
 			}
=20
 			str =3D number(str, end, num, spec);
-		}
-	}
+		} /* default: */
+		} /* switch(spec.type) */
+	} /* while(*fmt) */
=20
 	if (size > 0) {
 		if (str < end)
@@ -1808,7 +1799,7 @@ int vsscanf(const char *buf, const char=20
 	char digit;
 	int num =3D 0;
 	int qualifier, base, field_width;
-	int is_sign =3D 0;
+	bool is_sign;
=20
 	while (*fmt && *str) {
 		/* skip any white space in format */
@@ -1864,12 +1855,13 @@ int vsscanf(const char *buf, const char=20
 				}
 			}
 		}
-		base =3D 10;
-		is_sign =3D 0;
=20
 		if (!*fmt || !*str)
 			break;
=20
+		base =3D 10;
+		is_sign =3D 0;
+
 		switch (*fmt++) {
 		case 'c':
 		{
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
