From: akpm@linux-foundation.org
Subject: [nacked] parse_integer-convert-scanf.patch removed from -mm tree
Date: Thu, 10 Sep 2015 13:40:40 -0700
Message-ID: <55f1eac8.q/zNUPJ54FB1BMJV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbIJUkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 16:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert scanf()
has been removed from the -mm tree.  Its filename was
     parse_integer-convert-scanf.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: convert scanf()

Remove base second guessing -- done by parse_integer() just fine.

Uniformly fix too liberal acceptance in %lu/%ld cases in the next patch.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff -puN lib/vsprintf.c~parse_integer-convert-scanf lib/vsprintf.c
--- a/lib/vsprintf.c~parse_integer-convert-scanf
+++ a/lib/vsprintf.c
@@ -2471,8 +2471,6 @@ EXPORT_SYMBOL_GPL(bprintf);
 int vsscanf(const char *buf, const char *fmt, va_list args)
 {
 	const char *str = buf;
-	char *next;
-	char digit;
 	int num = 0;
 	u8 qualifier;
 	unsigned int base;
@@ -2484,6 +2482,8 @@ int vsscanf(const char *buf, const char
 	bool is_sign;
 
 	while (*fmt) {
+		int len;
+
 		/* skip any white space in format */
 		/* white space in format matchs any amount of
 		 * white space, including none, in the input.
@@ -2612,35 +2612,22 @@ int vsscanf(const char *buf, const char
 		 */
 		str = skip_spaces(str);
 
-		digit = *str;
-		if (is_sign && digit == '-')
-			digit = *(str + 1);
-
-		if (!digit
-		    || (base == 16 && !isxdigit(digit))
-		    || (base == 10 && !isdigit(digit))
-		    || (base == 8 && (!isdigit(digit) || digit > '7'))
-		    || (base == 0 && !isdigit(digit)))
-			break;
-
 		if (is_sign)
-			val.s = qualifier != 'L' ?
-				simple_strtol(str, &next, base) :
-				simple_strtoll(str, &next, base);
+			len = parse_integer(str, base, &val.s);
 		else
-			val.u = qualifier != 'L' ?
-				simple_strtoul(str, &next, base) :
-				simple_strtoull(str, &next, base);
+			len = parse_integer(str, base, &val.u);
+		if (len < 0)
+			break;
 
-		if (field_width > 0 && next - str > field_width) {
+		if (field_width > 0) {
 			if (base == 0)
 				_parse_integer_fixup_radix(str, &base);
-			while (next - str > field_width) {
+			while (len > field_width) {
 				if (is_sign)
 					val.s = div_s64(val.s, base);
 				else
 					val.u = div_u64(val.u, base);
-				--next;
+				len--;
 			}
 		}
 
@@ -2681,10 +2668,7 @@ int vsscanf(const char *buf, const char
 			break;
 		}
 		num++;
