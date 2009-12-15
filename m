From: akpm@linux-foundation.org
Subject: [merged] vsprintf-give-it-some-care-to-please-checkpatchpl.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:18 -0800
Message-ID: <200912152157.nBFLvIv8015712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933920AbZLOWIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:08:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vsprintf: give it some care to please checkpatch.pl
has been removed from the -mm tree.  Its filename was
     vsprintf-give-it-some-care-to-please-checkpatchpl.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: vsprintf: give it some care to please checkpatch.pl
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

Most relevant complaints were addressed.

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |  184 +++++++++++++++++++++++++----------------------
 1 file changed, 98 insertions(+), 86 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-give-it-some-care-to-please-checkpatc=
hpl lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-give-it-some-care-to-please-checkpatchpl
+++ a/lib/vsprintf.c
@@ -9,7 +9,7 @@
  * Wirzenius wrote this portably, Torvalds fucked it up :-)
  */
=20
-/*=20
+/*
  * Fri Jul 13 2001 Crutcher Dunnavant <crutcher+kernel@datastacks.com>
  * - changed to provide snprintf and vsnprintf functions
  * So Feb  1 16:51:32 CET 2004 Juergen Quade <quade@hsnr.de>
@@ -71,9 +71,9 @@ unsigned long simple_strtoul(const char=20
 		result =3D result * base + value;
 		cp++;
 	}
-
 	if (endp)
 		*endp =3D (char *)cp;
+
 	return result;
 }
 EXPORT_SYMBOL(simple_strtoul);
@@ -86,8 +86,9 @@ EXPORT_SYMBOL(simple_strtoul);
  */
 long simple_strtol(const char *cp, char **endp, unsigned int base)
 {
-	if(*cp =3D=3D '-')
+	if (*cp =3D=3D '-')
 		return -simple_strtoul(cp + 1, endp, base);
+
 	return simple_strtoul(cp, endp, base);
 }
 EXPORT_SYMBOL(simple_strtol);
@@ -117,9 +118,9 @@ unsigned long long simple_strtoull(const
 		result =3D result * base + value;
 		cp++;
 	}
-
 	if (endp)
 		*endp =3D (char *)cp;
+
 	return result;
 }
 EXPORT_SYMBOL(simple_strtoull);
@@ -132,8 +133,9 @@ EXPORT_SYMBOL(simple_strtoull);
  */
 long long simple_strtoll(const char *cp, char **endp, unsigned int bas=
e)
 {
-	if(*cp=3D=3D'-')
+	if (*cp =3D=3D '-')
 		return -simple_strtoull(cp + 1, endp, base);
+
 	return simple_strtoull(cp, endp, base);
 }
=20
@@ -173,6 +175,7 @@ int strict_strtoul(const char *cp, unsig
 	val =3D simple_strtoul(cp, &tail, base);
 	if (tail =3D=3D cp)
 		return -EINVAL;
+
 	if ((*tail =3D=3D '\0') ||
 		((len =3D=3D (size_t)(tail - cp) + 1) && (*tail =3D=3D '\n'))) {
 		*res =3D val;
@@ -285,10 +288,11 @@ EXPORT_SYMBOL(strict_strtoll);
=20
 static int skip_atoi(const char **s)
 {
-	int i=3D0;
+	int i =3D 0;
=20
 	while (isdigit(**s))
 		i =3D i*10 + *((*s)++) - '0';
+
 	return i;
 }
=20
@@ -302,7 +306,7 @@ static int skip_atoi(const char **s)
 /* Formats correctly any integer in [0,99999].
  * Outputs from one to five digits depending on input.
  * On i386 gcc 4.1.2 -O2: ~250 bytes of code. */
-static char* put_dec_trunc(char *buf, unsigned q)
+static char *put_dec_trunc(char *buf, unsigned q)
 {
 	unsigned d3, d2, d1, d0;
 	d1 =3D (q>>4) & 0xf;
@@ -331,14 +335,15 @@ static char* put_dec_trunc(char *buf, un
 				d3 =3D d3 - 10*q;
 				*buf++ =3D d3 + '0';  /* next digit */
 				if (q !=3D 0)
-					*buf++ =3D q + '0';  /* most sign. digit */
+					*buf++ =3D q + '0'; /* most sign. digit */
 			}
 		}
 	}
+
 	return buf;
 }
 /* Same with if's removed. Always emits five digits */
-static char* put_dec_full(char *buf, unsigned q)
+static char *put_dec_full(char *buf, unsigned q)
 {
 	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
 	/* but anyway, gcc produces better code with full-sized ints */
@@ -347,14 +352,15 @@ static char* put_dec_full(char *buf, uns
 	d2 =3D (q>>8) & 0xf;
 	d3 =3D (q>>12);
=20
-	/* Possible ways to approx. divide by 10 */
-	/* gcc -O2 replaces multiply with shifts and adds */
-	// (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
-	// (x * 0x67) >> 10:  1100111
-	// (x * 0x34) >> 9:    110100 - same
-	// (x * 0x1a) >> 8:     11010 - same
-	// (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
-
+	/*
+	 * Possible ways to approx. divide by 10
+	 * gcc -O2 replaces multiply with shifts and adds
+	 * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
+	 * (x * 0x67) >> 10:  1100111
+	 * (x * 0x34) >> 9:    110100 - same
+	 * (x * 0x1a) >> 8:     11010 - same
+	 * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+	 */
 	d0 =3D 6*(d3 + d2 + d1) + (q & 0xf);
 	q =3D (d0 * 0xcd) >> 11;
 	d0 =3D d0 - 10*q;
@@ -375,10 +381,11 @@ static char* put_dec_full(char *buf, uns
 				d3 =3D d3 - 10*q;
 				*buf++ =3D d3 + '0';
 					*buf++ =3D q + '0';
+
 	return buf;
 }
 /* No inlining helps gcc to use registers better */
-static noinline char* put_dec(char *buf, unsigned long long num)
+static noinline char *put_dec(char *buf, unsigned long long num)
 {
 	while (1) {
 		unsigned rem;
@@ -448,9 +455,9 @@ static char *number(char *buf, char *end
 		spec.flags &=3D ~ZEROPAD;
 	sign =3D 0;
 	if (spec.flags & SIGN) {
-		if ((signed long long) num < 0) {
+		if ((signed long long)num < 0) {
 			sign =3D '-';
-			num =3D - (signed long long) num;
+			num =3D -(signed long long)num;
 			spec.field_width--;
 		} else if (spec.flags & PLUS) {
 			sign =3D '+';
@@ -478,7 +485,9 @@ static char *number(char *buf, char *end
 	else if (spec.base !=3D 10) { /* 8 or 16 */
 		int mask =3D spec.base - 1;
 		int shift =3D 3;
-		if (spec.base =3D=3D 16) shift =3D 4;
+
+		if (spec.base =3D=3D 16)
+			shift =3D 4;
 		do {
 			tmp[i++] =3D (digits[((unsigned char)num) & mask] | locase);
 			num >>=3D shift;
@@ -493,7 +502,7 @@ static char *number(char *buf, char *end
 	/* leading space padding */
 	spec.field_width -=3D spec.precision;
 	if (!(spec.flags & (ZEROPAD+LEFT))) {
-		while(--spec.field_width >=3D 0) {
+		while (--spec.field_width >=3D 0) {
 			if (buf < end)
 				*buf =3D ' ';
 			++buf;
@@ -543,6 +552,7 @@ static char *number(char *buf, char *end
 			*buf =3D ' ';
 		++buf;
 	}
+
 	return buf;
 }
=20
@@ -572,6 +582,7 @@ static char *string(char *buf, char *end
 			*buf =3D ' ';
 		++buf;
 	}
+
 	return buf;
 }
=20
@@ -585,11 +596,13 @@ static char *symbol_string(char *buf, ch
 		sprint_symbol(sym, value);
 	else
 		kallsyms_lookup(value, NULL, NULL, NULL, sym);
+
 	return string(buf, end, sym, spec);
 #else
-	spec.field_width =3D 2*sizeof(void *);
+	spec.field_width =3D 2 * sizeof(void *);
 	spec.flags |=3D SPECIAL | SMALL | ZEROPAD;
 	spec.base =3D 16;
+
 	return number(buf, end, value, spec);
 #endif
 }
@@ -718,22 +731,19 @@ static char *ip4_string(char *p, const u
 		if (i < 3)
 			*p++ =3D '.';
 	}
-
 	*p =3D '\0';
+
 	return p;
 }
=20
 static char *ip6_compressed_string(char *p, const char *addr)
 {
-	int i;
-	int j;
-	int range;
+	int i, j, range;
 	unsigned char zerolength[8];
 	int longest =3D 1;
 	int colonpos =3D -1;
 	u16 word;
-	u8 hi;
-	u8 lo;
+	u8 hi, lo;
 	bool needcolon =3D false;
 	bool useIPv4;
 	struct in6_addr in6;
@@ -800,22 +810,23 @@ static char *ip6_compressed_string(char=20
 			*p++ =3D ':';
 		p =3D ip4_string(p, &in6.s6_addr[12], false);
 	}
-
 	*p =3D '\0';
+
 	return p;
 }
=20
 static char *ip6_string(char *p, const char *addr, const char *fmt)
 {
 	int i;
+
 	for (i =3D 0; i < 8; i++) {
 		p =3D pack_hex_byte(p, *addr++);
 		p =3D pack_hex_byte(p, *addr++);
 		if (fmt[0] =3D=3D 'I' && i !=3D 7)
 			*p++ =3D ':';
 	}
-
 	*p =3D '\0';
+
 	return p;
 }
=20
@@ -1322,7 +1333,8 @@ int vscnprintf(char *buf, size_t size, c
 {
 	int i;
=20
-	i=3Dvsnprintf(buf,size,fmt,args);
+	i =3D vsnprintf(buf, size, fmt, args);
+
 	return (i >=3D size) ? (size - 1) : i;
 }
 EXPORT_SYMBOL(vscnprintf);
@@ -1341,14 +1353,15 @@ EXPORT_SYMBOL(vscnprintf);
  *
  * See the vsnprintf() documentation for format string extensions over=
 C99.
  */
-int snprintf(char * buf, size_t size, const char *fmt, ...)
+int snprintf(char *buf, size_t size, const char *fmt, ...)
 {
 	va_list args;
 	int i;
=20
 	va_start(args, fmt);
-	i=3Dvsnprintf(buf,size,fmt,args);
+	i =3D vsnprintf(buf, size, fmt, args);
 	va_end(args);
+
 	return i;
 }
 EXPORT_SYMBOL(snprintf);
@@ -1364,7 +1377,7 @@ EXPORT_SYMBOL(snprintf);
  * the trailing '\0'. If @size is <=3D 0 the function returns 0.
  */
=20
-int scnprintf(char * buf, size_t size, const char *fmt, ...)
+int scnprintf(char *buf, size_t size, const char *fmt, ...)
 {
 	va_list args;
 	int i;
@@ -1372,6 +1385,7 @@ int scnprintf(char * buf, size_t size, c
 	va_start(args, fmt);
 	i =3D vsnprintf(buf, size, fmt, args);
 	va_end(args);
+
 	return (i >=3D size) ? (size - 1) : i;
 }
 EXPORT_SYMBOL(scnprintf);
@@ -1409,14 +1423,15 @@ EXPORT_SYMBOL(vsprintf);
  *
  * See the vsnprintf() documentation for format string extensions over=
 C99.
  */
-int sprintf(char * buf, const char *fmt, ...)
+int sprintf(char *buf, const char *fmt, ...)
 {
 	va_list args;
 	int i;
=20
 	va_start(args, fmt);
-	i=3Dvsnprintf(buf, INT_MAX, fmt, args);
+	i =3D vsnprintf(buf, INT_MAX, fmt, args);
 	va_end(args);
+
 	return i;
 }
 EXPORT_SYMBOL(sprintf);
@@ -1474,7 +1489,6 @@ do {									\
 	str +=3D sizeof(type);						\
 } while (0)
=20
-
 	while (*fmt) {
 		read =3D format_decode(fmt, &spec);
=20
@@ -1562,8 +1576,8 @@ do {									\
 			}
 		}
 	}
-	return (u32 *)(PTR_ALIGN(str, sizeof(u32))) - bin_buf;
=20
+	return (u32 *)(PTR_ALIGN(str, sizeof(u32))) - bin_buf;
 #undef save_arg
 }
 EXPORT_SYMBOL_GPL(vbin_printf);
@@ -1595,7 +1609,6 @@ int bstr_printf(char *buf, size_t size,=20
 	unsigned long long num;
 	char *str, *end, c;
 	const char *args =3D (const char *)bin_buf;
-
 	struct printf_spec spec =3D {0};
=20
 	if (WARN_ON_ONCE((int) size < 0))
@@ -1775,6 +1788,7 @@ int bprintf(u32 *bin_buf, size_t size, c
 	va_start(args, fmt);
 	ret =3D vbin_printf(bin_buf, size, fmt, args);
 	va_end(args);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(bprintf);
@@ -1787,18 +1801,16 @@ EXPORT_SYMBOL_GPL(bprintf);
  * @fmt:	format of buffer
  * @args:	arguments
  */
-int vsscanf(const char * buf, const char * fmt, va_list args)
+int vsscanf(const char *buf, const char *fmt, va_list args)
 {
 	const char *str =3D buf;
 	char *next;
 	char digit;
 	int num =3D 0;
-	int qualifier;
-	int base;
-	int field_width;
+	int qualifier, base, field_width;
 	int is_sign =3D 0;
=20
-	while(*fmt && *str) {
+	while (*fmt && *str) {
 		/* skip any white space in format */
 		/* white space in format matchs any amount of
 		 * white space, including none, in the input.
@@ -1820,7 +1832,7 @@ int vsscanf(const char * buf, const char
 		if (!*fmt)
 			break;
 		++fmt;
-	=09
+
 		/* skip this conversion.
 		 * advance both strings to next white space
 		 */
@@ -1858,10 +1870,10 @@ int vsscanf(const char * buf, const char
 		if (!*fmt || !*str)
 			break;
=20
-		switch(*fmt++) {
+		switch (*fmt++) {
 		case 'c':
 		{
-			char *s =3D (char *) va_arg(args,char*);
+			char *s =3D (char *)va_arg(args, char*);
 			if (field_width =3D=3D -1)
 				field_width =3D 1;
 			do {
@@ -1872,17 +1884,16 @@ int vsscanf(const char * buf, const char
 		continue;
 		case 's':
 		{
-			char *s =3D (char *) va_arg(args, char *);
-			if(field_width =3D=3D -1)
+			char *s =3D (char *)va_arg(args, char *);
+			if (field_width =3D=3D -1)
 				field_width =3D INT_MAX;
 			/* first, skip leading white space in buffer */
 			while (isspace(*str))
 				str++;
=20
 			/* now copy until next white space */
-			while (*str && !isspace(*str) && field_width--) {
+			while (*str && !isspace(*str) && field_width--)
 				*s++ =3D *str++;
-			}
 			*s =3D '\0';
 			num++;
 		}
@@ -1890,7 +1901,7 @@ int vsscanf(const char * buf, const char
 		case 'n':
 			/* return number of characters read so far */
 		{
-			int *i =3D (int *)va_arg(args,int*);
+			int *i =3D (int *)va_arg(args, int*);
 			*i =3D str - buf;
 		}
 		continue;
@@ -1902,14 +1913,14 @@ int vsscanf(const char * buf, const char
 			base =3D 16;
 			break;
 		case 'i':
-                        base =3D 0;
+			base =3D 0;
 		case 'd':
 			is_sign =3D 1;
 		case 'u':
 			break;
 		case '%':
 			/* looking for '%' in str */
-			if (*str++ !=3D '%')=20
+			if (*str++ !=3D '%')
 				return num;
 			continue;
 		default:
@@ -1928,63 +1939,63 @@ int vsscanf(const char * buf, const char
 			digit =3D *(str + 1);
=20
 		if (!digit
-                    || (base =3D=3D 16 && !isxdigit(digit))
-                    || (base =3D=3D 10 && !isdigit(digit))
-                    || (base =3D=3D 8 && (!isdigit(digit) || digit > '=
7'))
-                    || (base =3D=3D 0 && !isdigit(digit)))
-				break;
+		    || (base =3D=3D 16 && !isxdigit(digit))
+		    || (base =3D=3D 10 && !isdigit(digit))
+		    || (base =3D=3D 8 && (!isdigit(digit) || digit > '7'))
+		    || (base =3D=3D 0 && !isdigit(digit)))
+			break;
=20
-		switch(qualifier) {
+		switch (qualifier) {
 		case 'H':	/* that's 'hh' in format */
 			if (is_sign) {
-				signed char *s =3D (signed char *) va_arg(args,signed char *);
-				*s =3D (signed char) simple_strtol(str,&next,base);
+				signed char *s =3D (signed char *)va_arg(args, signed char *);
+				*s =3D (signed char)simple_strtol(str, &next, base);
 			} else {
-				unsigned char *s =3D (unsigned char *) va_arg(args, unsigned char =
*);
-				*s =3D (unsigned char) simple_strtoul(str, &next, base);
+				unsigned char *s =3D (unsigned char *)va_arg(args, unsigned char *=
);
+				*s =3D (unsigned char)simple_strtoul(str, &next, base);
 			}
 			break;
 		case 'h':
 			if (is_sign) {
-				short *s =3D (short *) va_arg(args,short *);
-				*s =3D (short) simple_strtol(str,&next,base);
+				short *s =3D (short *)va_arg(args, short *);
+				*s =3D (short)simple_strtol(str, &next, base);
 			} else {
-				unsigned short *s =3D (unsigned short *) va_arg(args, unsigned sho=
rt *);
-				*s =3D (unsigned short) simple_strtoul(str, &next, base);
+				unsigned short *s =3D (unsigned short *)va_arg(args, unsigned shor=
t *);
+				*s =3D (unsigned short)simple_strtoul(str, &next, base);
 			}
 			break;
 		case 'l':
 			if (is_sign) {
-				long *l =3D (long *) va_arg(args,long *);
-				*l =3D simple_strtol(str,&next,base);
+				long *l =3D (long *)va_arg(args, long *);
+				*l =3D simple_strtol(str, &next, base);
 			} else {
-				unsigned long *l =3D (unsigned long*) va_arg(args,unsigned long*);
-				*l =3D simple_strtoul(str,&next,base);
+				unsigned long *l =3D (unsigned long *)va_arg(args, unsigned long *=
);
+				*l =3D simple_strtoul(str, &next, base);
 			}
 			break;
 		case 'L':
 			if (is_sign) {
-				long long *l =3D (long long*) va_arg(args,long long *);
-				*l =3D simple_strtoll(str,&next,base);
+				long long *l =3D (long long *)va_arg(args, long long *);
+				*l =3D simple_strtoll(str, &next, base);
 			} else {
-				unsigned long long *l =3D (unsigned long long*) va_arg(args,unsign=
ed long long*);
-				*l =3D simple_strtoull(str,&next,base);
+				unsigned long long *l =3D (unsigned long long *)va_arg(args, unsig=
ned long long *);
+				*l =3D simple_strtoull(str, &next, base);
 			}
 			break;
 		case 'Z':
 		case 'z':
 		{
-			size_t *s =3D (size_t*) va_arg(args,size_t*);
-			*s =3D (size_t) simple_strtoul(str,&next,base);
+			size_t *s =3D (size_t *)va_arg(args, size_t *);
+			*s =3D (size_t)simple_strtoul(str, &next, base);
 		}
 		break;
 		default:
 			if (is_sign) {
-				int *i =3D (int *) va_arg(args, int*);
-				*i =3D (int) simple_strtol(str,&next,base);
+				int *i =3D (int *)va_arg(args, int *);
+				*i =3D (int)simple_strtol(str, &next, base);
 			} else {
-				unsigned int *i =3D (unsigned int*) va_arg(args, unsigned int*);
-				*i =3D (unsigned int) simple_strtoul(str,&next,base);
+				unsigned int *i =3D (unsigned int *)va_arg(args, unsigned int*);
+				*i =3D (unsigned int)simple_strtoul(str, &next, base);
 			}
 			break;
 		}
@@ -2015,14 +2026,15 @@ EXPORT_SYMBOL(vsscanf);
  * @fmt:	formatting of buffer
  * @...:	resulting arguments
  */
-int sscanf(const char * buf, const char * fmt, ...)
+int sscanf(const char *buf, const char *fmt, ...)
 {
 	va_list args;
 	int i;
=20
-	va_start(args,fmt);
-	i =3D vsscanf(buf,fmt,args);
+	va_start(args, fmt);
+	i =3D vsscanf(buf, fmt, args);
 	va_end(args);
+
 	return i;
 }
 EXPORT_SYMBOL(sscanf);
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
