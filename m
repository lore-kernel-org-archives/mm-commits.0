From: akpm@linux-foundation.org
Subject: + parse_integer-convert-lib.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:26:15 -0700
Message-ID: <559ecad7.QcIrzQtm3UVV4+ud%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbbGIT0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:26:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert lib/
has been added to the -mm tree.  Its filename is
     parse_integer-convert-lib.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parse_integer-convert-lib.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parse_integer-convert-lib.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: convert lib/

Convert away lib/ from deprecated simple_strto*() interfaces.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |   42 +++++++++++++++++++++++-------------------
 lib/parser.c  |   33 ++++++++++++++++-----------------
 lib/swiotlb.c |    2 +-
 3 files changed, 40 insertions(+), 37 deletions(-)

diff -puN lib/cmdline.c~parse_integer-convert-lib lib/cmdline.c
--- a/lib/cmdline.c~parse_integer-convert-lib
+++ a/lib/cmdline.c
@@ -27,7 +27,7 @@ static int get_range(char **str, int *pi
 	int x, inc_counter, upper_range;
 
 	(*str)++;
-	upper_range = simple_strtol((*str), NULL, 0);
+	parse_integer(*str, 0, &upper_range);
 	inc_counter = upper_range - *pint;
 	for (x = *pint; x < upper_range; x++)
 		*pint++ = x;
@@ -51,13 +51,14 @@ static int get_range(char **str, int *pi
 
 int get_option(char **str, int *pint)
 {
-	char *cur = *str;
+	int len;
 
-	if (!cur || !(*cur))
+	if (!str || !*str)
 		return 0;
-	*pint = simple_strtol(cur, str, 0);
-	if (cur == *str)
+	len = parse_integer(*str, 0, pint);
+	if (len < 0)
 		return 0;
+	*str += len;
 	if (**str == ',') {
 		(*str)++;
 		return 2;
@@ -126,38 +127,41 @@ EXPORT_SYMBOL(get_options);
 
 unsigned long long memparse(const char *ptr, char **retptr)
 {
-	char *endptr;	/* local pointer to end of parsed string */
+	unsigned long long val = 0;
+	int len;
 
-	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
-
-	switch (*endptr) {
+	len = parse_integer(ptr, 0, &val);
+	if (len < 0)
+		goto out;
+	ptr += len;
+	switch (*ptr) {
 	case 'E':
 	case 'e':
-		ret <<= 10;
+		val <<= 10;
 	case 'P':
 	case 'p':
-		ret <<= 10;
+		val <<= 10;
 	case 'T':
 	case 't':
-		ret <<= 10;
+		val <<= 10;
 	case 'G':
 	case 'g':
-		ret <<= 10;
+		val <<= 10;
 	case 'M':
 	case 'm':
-		ret <<= 10;
+		val <<= 10;
 	case 'K':
 	case 'k':
-		ret <<= 10;
-		endptr++;
+		val <<= 10;
+		ptr++;
 	default:
 		break;
 	}
-
+out:
 	if (retptr)
-		*retptr = endptr;
+		*retptr = (char *)ptr;
 
-	return ret;
+	return val;
 }
 EXPORT_SYMBOL(memparse);
 
diff -puN lib/parser.c~parse_integer-convert-lib lib/parser.c
--- a/lib/parser.c~parse_integer-convert-lib
+++ a/lib/parser.c
@@ -44,7 +44,7 @@ static int match_one(char *s, const char
 		p = meta + 1;
 
 		if (isdigit(*p))
-			len = simple_strtoul(p, (char **) &p, 10);
+			p += parse_integer(p, 10, (unsigned int *)&len);
 		else if (*p == '%') {
 			if (*s++ != '%')
 				return 0;
@@ -57,6 +57,11 @@ static int match_one(char *s, const char
 
 		args[argc].from = s;
 		switch (*p++) {
+			union {
+				int i;
+				unsigned int u;
+			} u;
+
 		case 's': {
 			size_t str_len = strlen(s);
 
@@ -68,19 +73,20 @@ static int match_one(char *s, const char
 			break;
 		}
 		case 'd':
-			simple_strtol(s, &args[argc].to, 0);
+			len = parse_integer(s, 0, &u.i);
 			goto num;
 		case 'u':
-			simple_strtoul(s, &args[argc].to, 0);
+			len = parse_integer(s, 0, &u.u);
 			goto num;
 		case 'o':
-			simple_strtoul(s, &args[argc].to, 8);
+			len = parse_integer(s, 8, &u.u);
 			goto num;
 		case 'x':
-			simple_strtoul(s, &args[argc].to, 16);
+			len = parse_integer(s, 16, &u.u);
 		num:
-			if (args[argc].to == args[argc].from)
+			if (len < 0)
 				return 0;
+			args[argc].to = args[argc].from + len;
 			break;
 		default:
 			return 0;
@@ -127,10 +133,8 @@ EXPORT_SYMBOL(match_token);
  */
 static int match_number(substring_t *s, int *result, int base)
 {
-	char *endp;
 	char *buf;
 	int ret;
-	long val;
 	size_t len = s->to - s->from;
 
 	buf = kmalloc(len + 1, GFP_KERNEL);
@@ -139,16 +143,11 @@ static int match_number(substring_t *s,
 	memcpy(buf, s->from, len);
 	buf[len] = '\0';
 
-	ret = 0;
-	val = simple_strtol(buf, &endp, base);
-	if (endp == buf)
-		ret = -EINVAL;
-	else if (val < (long)INT_MIN || val > (long)INT_MAX)
-		ret = -ERANGE;
-	else
-		*result = (int) val;
+	ret = parse_integer(buf, base, result);
 	kfree(buf);
-	return ret;
+	if (ret < 0)
+		return ret;
+	return 0;
 }
 
 /**
diff -puN lib/swiotlb.c~parse_integer-convert-lib lib/swiotlb.c
--- a/lib/swiotlb.c~parse_integer-convert-lib
+++ a/lib/swiotlb.c
@@ -100,7 +100,7 @@ static int __init
 setup_io_tlb_npages(char *str)
 {
 	if (isdigit(*str)) {
-		io_tlb_nslabs = simple_strtoul(str, &str, 0);
+		str += parse_integer(str, 0, &io_tlb_nslabs);
 		/* avoid tail segment of size < IO_TLB_SEGSIZE */
 		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
 	}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrto-accept-0-for-signed-conversion.patch
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse-integer-rewrite-kstrto.patch
parse_integer-convert-scanf.patch
scanf-fix-type-range-overflow.patch
parse_integer-convert-lib.patch
parse_integer-convert-mm.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch

