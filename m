From: akpm@linux-foundation.org
Subject: + lib-string_helpersc-refactor-string_escape_mem.patch added to
 -mm tree
Date: Wed, 04 Mar 2015 13:25:54 -0800
Message-ID: <54f77862.V9IEKpEc/b/X76HA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbCDVZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 16:25:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers.c: refactor string_escape_mem
has been added to the -mm tree.  Its filename is
     lib-string_helpersc-refactor-string_escape_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpersc-refactor-string_escape_mem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpersc-refactor-string_escape_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/string_helpers.c: refactor string_escape_mem

When printf is given the format specifier %pE, it needs a way of obtaining
the total output size that would be generated if the buffer was large
enough, and string_escape_mem doesn't easily provide that.  This is a
refactorization of string_escape_mem in preparation of changing its
external API to provide that information.

The somewhat ugly early returns and subsequent seemingly redundant
conditionals are to make the following patch touch as little as possible
in string_helpers.c while still preserving the current behaviour of never
outputting partial escape sequences.  That behaviour must also change for
%pE to work as one expects from every other printf specifier.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |  208 ++++++++++++++++++++---------------------
 1 file changed, 105 insertions(+), 103 deletions(-)

diff -puN lib/string_helpers.c~lib-string_helpersc-refactor-string_escape_mem lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpersc-refactor-string_escape_mem
+++ a/lib/string_helpers.c
@@ -239,29 +239,21 @@ int string_unescape(char *src, char *dst
 }
 EXPORT_SYMBOL(string_unescape);
 
-static int escape_passthrough(unsigned char c, char **dst, size_t *osz)
+static bool escape_passthrough(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 
-	if (*osz < 1)
-		return -ENOMEM;
-
-	*out++ = c;
-
-	*dst = out;
-	*osz -= 1;
-
-	return 1;
+	if (out < end)
+		*out = c;
+	*dst = out + 1;
+	return true;
 }
 
-static int escape_space(unsigned char c, char **dst, size_t *osz)
+static bool escape_space(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 	unsigned char to;
 
-	if (*osz < 2)
-		return -ENOMEM;
-
 	switch (c) {
 	case '\n':
 		to = 'n';
@@ -279,26 +271,30 @@ static int escape_space(unsigned char c,
 		to = 'f';
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	*out++ = '\\';
-	*out++ = to;
+	if (out + 2 > end) {
+		*dst = out + 2;
+		return true;
+	}
 
-	*dst = out;
-	*osz -= 2;
+	if (out < end)
+		*out = '\\';
+	++out;
+	if (out < end)
+		*out = to;
+	++out;
 
-	return 1;
+	*dst = out;
+	return true;
 }
 
-static int escape_special(unsigned char c, char **dst, size_t *osz)
+static bool escape_special(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 	unsigned char to;
 
-	if (*osz < 2)
-		return -ENOMEM;
-
 	switch (c) {
 	case '\\':
 		to = '\\';
@@ -310,71 +306,98 @@ static int escape_special(unsigned char
 		to = 'e';
 		break;
 	default:
-		return 0;
+		return false;
 	}
 
-	*out++ = '\\';
-	*out++ = to;
+	if (out + 2 > end) {
+		*dst = out + 2;
+		return true;
+	}
 
-	*dst = out;
-	*osz -= 2;
+	if (out < end)
+		*out = '\\';
+	++out;
+	if (out < end)
+		*out = to;
+	++out;
 
-	return 1;
+	*dst = out;
+	return true;
 }
 
-static int escape_null(unsigned char c, char **dst, size_t *osz)
+static bool escape_null(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 
-	if (*osz < 2)
-		return -ENOMEM;
-
 	if (c)
-		return 0;
+		return false;
 
-	*out++ = '\\';
-	*out++ = '0';
+	if (out + 2 > end) {
+		*dst = out + 2;
+		return true;
+	}
 
-	*dst = out;
-	*osz -= 2;
+	if (out < end)
+		*out = '\\';
+	++out;
+	if (out < end)
+		*out = '0';
+	++out;
 
-	return 1;
+	*dst = out;
+	return true;
 }
 
-static int escape_octal(unsigned char c, char **dst, size_t *osz)
+static bool escape_octal(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 
-	if (*osz < 4)
-		return -ENOMEM;
+	if (out + 4 > end) {
+		*dst = out + 4;
+		return true;
+	}
 
-	*out++ = '\\';
-	*out++ = ((c >> 6) & 0x07) + '0';
-	*out++ = ((c >> 3) & 0x07) + '0';
-	*out++ = ((c >> 0) & 0x07) + '0';
+	if (out < end)
+		*out = '\\';
+	++out;
+	if (out < end)
+		*out = ((c >> 6) & 0x07) + '0';
+	++out;
+	if (out < end)
+		*out = ((c >> 3) & 0x07) + '0';
+	++out;
+	if (out < end)
+		*out = ((c >> 0) & 0x07) + '0';
+	++out;
 
 	*dst = out;
-	*osz -= 4;
-
-	return 1;
+	return true;
 }
 
-static int escape_hex(unsigned char c, char **dst, size_t *osz)
+static bool escape_hex(unsigned char c, char **dst, char *end)
 {
 	char *out = *dst;
 
-	if (*osz < 4)
-		return -ENOMEM;
+	if (out + 4 > end) {
+		*dst = out + 4;
+		return true;
+	}
 
-	*out++ = '\\';
-	*out++ = 'x';
-	*out++ = hex_asc_hi(c);
-	*out++ = hex_asc_lo(c);
+	if (out < end)
+		*out = '\\';
+	++out;
+	if (out < end)
+		*out = 'x';
+	++out;
+	if (out < end)
+		*out = hex_asc_hi(c);
+	++out;
+	if (out < end)
+		*out = hex_asc_lo(c);
+	++out;
 
 	*dst = out;
-	*osz -= 4;
-
-	return 1;
+	return true;
 }
 
 /**
@@ -436,9 +459,10 @@ static int escape_hex(unsigned char c, c
 int string_escape_mem(const char *src, size_t isz, char **dst, size_t osz,
 		      unsigned int flags, const char *esc)
 {
-	char *out = *dst, *p = out;
+	char *p = *dst;
+	char *end = p + osz;
 	bool is_dict = esc && *esc;
-	int ret = 0;
+	int ret;
 
 	while (isz--) {
 		unsigned char c = *src++;
@@ -458,55 +482,33 @@ int string_escape_mem(const char *src, s
 		    (is_dict && !strchr(esc, c))) {
 			/* do nothing */
 		} else {
-			if (flags & ESCAPE_SPACE) {
-				ret = escape_space(c, &p, &osz);
-				if (ret < 0)
-					break;
-				if (ret > 0)
-					continue;
-			}
-
-			if (flags & ESCAPE_SPECIAL) {
-				ret = escape_special(c, &p, &osz);
-				if (ret < 0)
-					break;
-				if (ret > 0)
-					continue;
-			}
-
-			if (flags & ESCAPE_NULL) {
-				ret = escape_null(c, &p, &osz);
-				if (ret < 0)
-					break;
-				if (ret > 0)
-					continue;
-			}
+			if (flags & ESCAPE_SPACE && escape_space(c, &p, end))
+				continue;
+
+			if (flags & ESCAPE_SPECIAL && escape_special(c, &p, end))
+				continue;
+
+			if (flags & ESCAPE_NULL && escape_null(c, &p, end))
+				continue;
 
 			/* ESCAPE_OCTAL and ESCAPE_HEX always go last */
-			if (flags & ESCAPE_OCTAL) {
-				ret = escape_octal(c, &p, &osz);
-				if (ret < 0)
-					break;
+			if (flags & ESCAPE_OCTAL && escape_octal(c, &p, end))
 				continue;
-			}
-			if (flags & ESCAPE_HEX) {
-				ret = escape_hex(c, &p, &osz);
-				if (ret < 0)
-					break;
+
+			if (flags & ESCAPE_HEX && escape_hex(c, &p, end))
 				continue;
-			}
 		}
 
-		ret = escape_passthrough(c, &p, &osz);
-		if (ret < 0)
-			break;
+		escape_passthrough(c, &p, end);
 	}
 
-	*dst = p;
-
-	if (ret < 0)
-		return ret;
+	if (p > end) {
+		*dst = end;
+		return -ENOMEM;
+	}
 
-	return p - out;
+	ret = p - *dst;
+	*dst = p;
+	return ret;
 }
 EXPORT_SYMBOL(string_escape_mem);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
include-linux-remove-empty-conditionals.patch
lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch
lib-string_helpersc-refactor-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
lib-lz4-pull-out-constant-tables.patch
linux-next.patch

