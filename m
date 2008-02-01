From: akpm@linux-foundation.org
Subject: - printk-trivial-optimizations.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:17 -0800
Message-ID: <200802012230.m11MUHTP001894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756366AbYBAWsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:48:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     printk: trivial optimizations
has been removed from the -mm tree.  Its filename was
     printk-trivial-optimizations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: trivial optimizations
From: Denys Vlasenko <vda.linux@googlemail.com>

In arch/x86/boot/printf.c gets rid of unused tail of digits: const char
*digits = "0123456789abcdefghijklmnopqrstuvwxyz"; (we are using 0-9a-f
only)

Uses smaller/faster lowercasing (by ORing with 0x20)
if we know that we work on numbers/digits. Makes
strtoul smaller, and also we are getting rid of

  static const char small_digits[] = "0123456789abcdefx";
  static const char large_digits[] = "0123456789ABCDEFX";

since this works equally well:

  static const char digits[16] = "0123456789ABCDEF";

Size savings:

$ size vmlinux.org vmlinux
   text    data     bss     dec     hex filename
 877320  112252   90112 1079684  107984 vmlinux.org
 877048  112252   90112 1079412  107874 vmlinux

It may be also a tiny bit faster because code has less
branches now, but I doubt it is measurable.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/printf.c |   24 +++++++++++--------
 lib/vsprintf.c         |   48 +++++++++++++++++++++------------------
 2 files changed, 40 insertions(+), 32 deletions(-)

diff -puN arch/x86/boot/printf.c~printk-trivial-optimizations arch/x86/boot/printf.c
--- a/arch/x86/boot/printf.c~printk-trivial-optimizations
+++ a/arch/x86/boot/printf.c
@@ -33,8 +33,8 @@ static int skip_atoi(const char **s)
 #define PLUS	4		/* show plus */
 #define SPACE	8		/* space if plus */
 #define LEFT	16		/* left justified */
-#define SPECIAL	32		/* 0x */
-#define LARGE	64		/* use 'ABCDEF' instead of 'abcdef' */
+#define SMALL	32		/* Must be 32 == 0x20 */
+#define SPECIAL	64		/* 0x */
 
 #define do_div(n,base) ({ \
 int __res; \
@@ -45,12 +45,16 @@ __res; })
 static char *number(char *str, long num, int base, int size, int precision,
 		    int type)
 {
-	char c, sign, tmp[66];
-	const char *digits = "0123456789abcdefghijklmnopqrstuvwxyz";
+	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
+	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+
+	char tmp[66];
+	char c, sign, locase;
 	int i;
 
-	if (type & LARGE)
-		digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
+	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
+	 * produces same digits or (maybe lowercased) letters */
+	locase = (type & SMALL);
 	if (type & LEFT)
 		type &= ~ZEROPAD;
 	if (base < 2 || base > 36)
@@ -81,7 +85,7 @@ static char *number(char *str, long num,
 		tmp[i++] = '0';
 	else
 		while (num != 0)
-			tmp[i++] = digits[do_div(num, base)];
+			tmp[i++] = (digits[do_div(num, base)] | locase);
 	if (i > precision)
 		precision = i;
 	size -= precision;
@@ -95,7 +99,7 @@ static char *number(char *str, long num,
 			*str++ = '0';
 		else if (base == 16) {
 			*str++ = '0';
-			*str++ = digits[33];
+			*str++ = ('X' | locase);
 		}
 	}
 	if (!(type & LEFT))
@@ -244,9 +248,9 @@ int vsprintf(char *buf, const char *fmt,
 			base = 8;
 			break;
 
-		case 'X':
-			flags |= LARGE;
 		case 'x':
+			flags |= SMALL;
+		case 'X':
 			base = 16;
 			break;
 
diff -puN lib/vsprintf.c~printk-trivial-optimizations lib/vsprintf.c
--- a/lib/vsprintf.c~printk-trivial-optimizations
+++ a/lib/vsprintf.c
@@ -26,6 +26,9 @@
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/div64.h>
 
+/* Works only for digits and letters, but small and fast */
+#define TOLOWER(x) ((x) | 0x20)
+
 /**
  * simple_strtoul - convert a string to an unsigned long
  * @cp: The start of the string
@@ -41,17 +44,17 @@ unsigned long simple_strtoul(const char 
 		if (*cp == '0') {
 			base = 8;
 			cp++;
-			if ((toupper(*cp) == 'X') && isxdigit(cp[1])) {
+			if ((TOLOWER(*cp) == 'x') && isxdigit(cp[1])) {
 				cp++;
 				base = 16;
 			}
 		}
 	} else if (base == 16) {
-		if (cp[0] == '0' && toupper(cp[1]) == 'X')
+		if (cp[0] == '0' && TOLOWER(cp[1]) == 'x')
 			cp += 2;
 	}
 	while (isxdigit(*cp) &&
-	       (value = isdigit(*cp) ? *cp-'0' : toupper(*cp)-'A'+10) < base) {
+	       (value = isdigit(*cp) ? *cp-'0' : TOLOWER(*cp)-'a'+10) < base) {
 		result = result*base + value;
 		cp++;
 	}
@@ -92,17 +95,17 @@ unsigned long long simple_strtoull(const
 		if (*cp == '0') {
 			base = 8;
 			cp++;
-			if ((toupper(*cp) == 'X') && isxdigit(cp[1])) {
+			if ((TOLOWER(*cp) == 'x') && isxdigit(cp[1])) {
 				cp++;
 				base = 16;
 			}
 		}
 	} else if (base == 16) {
-		if (cp[0] == '0' && toupper(cp[1]) == 'X')
+		if (cp[0] == '0' && TOLOWER(cp[1]) == 'x')
 			cp += 2;
 	}
-	while (isxdigit(*cp) && (value = isdigit(*cp) ? *cp-'0' : (islower(*cp)
-	    ? toupper(*cp) : *cp)-'A'+10) < base) {
+	while (isxdigit(*cp)
+	 && (value = isdigit(*cp) ? *cp-'0' : TOLOWER(*cp)-'a'+10) < base) {
 		result = result*base + value;
 		cp++;
 	}
@@ -237,24 +240,25 @@ static noinline char* put_dec(char *buf,
 #define PLUS	4		/* show plus */
 #define SPACE	8		/* space if plus */
 #define LEFT	16		/* left justified */
-#define SPECIAL	32		/* 0x */
-#define LARGE	64		/* use 'ABCDEF' instead of 'abcdef' */
+#define SMALL	32		/* Must be 32 == 0x20 */
+#define SPECIAL	64		/* 0x */
 
 static char *number(char *buf, char *end, unsigned long long num, int base, int size, int precision, int type)
 {
-	char sign,tmp[66];
-	const char *digits;
-	/* we are called with base 8, 10 or 16, only, thus don't need "g..."  */
-	static const char small_digits[] = "0123456789abcdefx"; /* "ghijklmnopqrstuvwxyz"; */
-	static const char large_digits[] = "0123456789ABCDEFX"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
+	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+
+	char tmp[66];
+	char sign;
+	char locase;
 	int need_pfx = ((type & SPECIAL) && base != 10);
 	int i;
 
-	digits = (type & LARGE) ? large_digits : small_digits;
+	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
+	 * produces same digits or (maybe lowercased) letters */
+	locase = (type & SMALL);
 	if (type & LEFT)
 		type &= ~ZEROPAD;
-	if (base < 2 || base > 36)
-		return NULL;
 	sign = 0;
 	if (type & SIGN) {
 		if ((signed long long) num < 0) {
@@ -281,7 +285,7 @@ static char *number(char *buf, char *end
 		tmp[i++] = '0';
 	/* Generic code, for any base:
 	else do {
-		tmp[i++] = digits[do_div(num,base)];
+		tmp[i++] = (digits[do_div(num,base)] | locase);
 	} while (num != 0);
 	*/
 	else if (base != 10) { /* 8 or 16 */
@@ -289,7 +293,7 @@ static char *number(char *buf, char *end
 		int shift = 3;
 		if (base == 16) shift = 4;
 		do {
-			tmp[i++] = digits[((unsigned char)num) & mask];
+			tmp[i++] = (digits[((unsigned char)num) & mask] | locase);
 			num >>= shift;
 		} while (num);
 	} else { /* base 10 */
@@ -321,7 +325,7 @@ static char *number(char *buf, char *end
 		++buf;
 		if (base == 16) {
 			if (buf < end)
-				*buf = digits[16]; /* for arbitrary base: digits[33]; */
+				*buf = ('X' | locase);
 			++buf;
 		}
 	}
@@ -557,9 +561,9 @@ int vsnprintf(char *buf, size_t size, co
 				base = 8;
 				break;
 
-			case 'X':
-				flags |= LARGE;
 			case 'x':
+				flags |= SMALL;
+			case 'X':
 				base = 16;
 				break;
 
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
git-x86.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
printkc-use-unsigned-ints-instead-of-longs-for-logbuf-index.patch
