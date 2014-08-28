From: akpm@linux-foundation.org
Subject: + lib-string_helpers-introduce-string_escape_mem.patch added to
 -mm tree
Date: Thu, 28 Aug 2014 14:09:07 -0700
Message-ID: <53ff9a73.fyHhO33lcEf948SZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:47945 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaH1WGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 18:06:05 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1125795pab.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 15:06:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib / string_helpers: introduce string_escape_mem()
has been added to the -mm tree.  Its filename is
     lib-string_helpers-introduce-string_escape_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpers-introduce-string_escape_mem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpers-introduce-string_escape_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib / string_helpers: introduce string_escape_mem()

This is almost the opposite function to string_unescape().  Nevertheless
it handles \0 and could be used for any byte buffer.

The documentation is supplied together with the function prototype.

The test cases covers most of the scenarios and would be expanded later
on.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |   31 +++
 lib/string_helpers.c           |  274 +++++++++++++++++++++++++++++++
 lib/test-string_helpers.c      |  213 ++++++++++++++++++++++++
 3 files changed, 518 insertions(+)

diff -puN include/linux/string_helpers.h~lib-string_helpers-introduce-string_escape_mem include/linux/string_helpers.h
--- a/include/linux/string_helpers.h~lib-string_helpers-introduce-string_escape_mem
+++ a/include/linux/string_helpers.h
@@ -37,4 +37,35 @@ static inline int string_unescape_any_in
 	return string_unescape_any(buf, buf, 0);
 }
 
+#define ESCAPE_SPACE		0x01
+#define ESCAPE_SPECIAL		0x02
+#define ESCAPE_NULL		0x04
+#define ESCAPE_OCTAL		0x08
+#define ESCAPE_ANY		\
+	(ESCAPE_SPACE | ESCAPE_OCTAL | ESCAPE_SPECIAL | ESCAPE_NULL)
+#define ESCAPE_NP		0x10
+#define ESCAPE_ANY_NP		(ESCAPE_ANY | ESCAPE_NP)
+#define ESCAPE_HEX		0x20
+
+int string_escape_mem(const char *src, size_t isz, char **dst, size_t osz,
+		unsigned int flags, const char *esc);
+
+static inline int string_escape_mem_any_np(const char *src, size_t isz,
+		char **dst, size_t osz, const char *esc)
+{
+	return string_escape_mem(src, isz, dst, osz, ESCAPE_ANY_NP, esc);
+}
+
+static inline int string_escape_str(const char *src, char **dst, size_t sz,
+		unsigned int flags, const char *esc)
+{
+	return string_escape_mem(src, strlen(src), dst, sz, flags, esc);
+}
+
+static inline int string_escape_str_any_np(const char *src, char **dst,
+		size_t sz, const char *esc)
+{
+	return string_escape_str(src, dst, sz, ESCAPE_ANY_NP, esc);
+}
+
 #endif
diff -puN lib/string_helpers.c~lib-string_helpers-introduce-string_escape_mem lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpers-introduce-string_escape_mem
+++ a/lib/string_helpers.c
@@ -8,6 +8,8 @@
 #include <linux/math64.h>
 #include <linux/export.h>
 #include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/string.h>
 #include <linux/string_helpers.h>
 
 /**
@@ -240,3 +242,275 @@ int string_unescape(char *src, char *dst
 	return out - dst;
 }
 EXPORT_SYMBOL(string_unescape);
+
+static int escape_passthrough(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+
+	if (*osz < 1)
+		return -ENOMEM;
+
+	*out++ = c;
+
+	*dst = out;
+	*osz -= 1;
+
+	return 1;
+}
+
+static int escape_space(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+	unsigned char to;
+
+	if (*osz < 2)
+		return -ENOMEM;
+
+	switch (c) {
+	case '\n':
+		to = 'n';
+		break;
+	case '\r':
+		to = 'r';
+		break;
+	case '\t':
+		to = 't';
+		break;
+	case '\v':
+		to = 'v';
+		break;
+	case '\f':
+		to = 'f';
+		break;
+	default:
+		return 0;
+	}
+
+	*out++ = '\\';
+	*out++ = to;
+
+	*dst = out;
+	*osz -= 2;
+
+	return 1;
+}
+
+static int escape_special(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+	unsigned char to;
+
+	if (*osz < 2)
+		return -ENOMEM;
+
+	switch (c) {
+	case '\\':
+		to = '\\';
+		break;
+	case '\a':
+		to = 'a';
+		break;
+	case '\e':
+		to = 'e';
+		break;
+	default:
+		return 0;
+	}
+
+	*out++ = '\\';
+	*out++ = to;
+
+	*dst = out;
+	*osz -= 2;
+
+	return 1;
+}
+
+static int escape_null(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+
+	if (*osz < 2)
+		return -ENOMEM;
+
+	if (c)
+		return 0;
+
+	*out++ = '\\';
+	*out++ = '0';
+
+	*dst = out;
+	*osz -= 2;
+
+	return 1;
+}
+
+static int escape_octal(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+
+	if (*osz < 4)
+		return -ENOMEM;
+
+	*out++ = '\\';
+	*out++ = ((c >> 6) & 0x07) + '0';
+	*out++ = ((c >> 3) & 0x07) + '0';
+	*out++ = ((c >> 0) & 0x07) + '0';
+
+	*dst = out;
+	*osz -= 4;
+
+	return 1;
+}
+
+static int escape_hex(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+
+	if (*osz < 4)
+		return -ENOMEM;
+
+	*out++ = '\\';
+	*out++ = 'x';
+	*out++ = hex_asc_hi(c);
+	*out++ = hex_asc_lo(c);
+
+	*dst = out;
+	*osz -= 4;
+
+	return 1;
+}
+
+/**
+ * string_escape_mem - quote characters in the given memory buffer
+ * @src:	source buffer (unescaped)
+ * @isz:	source buffer size
+ * @dst:	destination buffer (escaped)
+ * @osz:	destination buffer size
+ * @flags:	combination of the flags (bitwise OR):
+ *	%ESCAPE_SPACE:
+ *		'\f' - form feed
+ *		'\n' - new line
+ *		'\r' - carriage return
+ *		'\t' - horizontal tab
+ *		'\v' - vertical tab
+ *	%ESCAPE_SPECIAL:
+ *		'\\' - backslash
+ *		'\a' - alert (BEL)
+ *		'\e' - escape
+ *	%ESCAPE_NULL:
+ *		'\0' - null
+ *	%ESCAPE_OCTAL:
+ *		'\NNN' - byte with octal value NNN (3 digits)
+ *	%ESCAPE_ANY:
+ *		all previous together
+ *	%ESCAPE_NP:
+ *		escape only non-printable characters (checked by isprint)
+ *	%ESCAPE_ANY_NP:
+ *		all previous together
+ *	%ESCAPE_HEX:
+ *		'\xHH' - byte with hexadecimal value HH (2 digits)
+ * @esc:	NULL-terminated string of characters any of which, if found in
+ *		the source, has to be escaped
+ *
+ * Description:
+ * The process of escaping byte buffer includes several parts. They are applied
+ * in the following sequence.
+ *	1. The character is matched to the printable class, if asked, and in
+ *	   case of match it passes through to the output.
+ *	2. The character is not matched to the one from @esc string and thus
+ *	   must go as is to the output.
+ *	3. The character is checked if it falls into the class given by @flags.
+ *	   %ESCAPE_OCTAL and %ESCAPE_HEX are going last since they cover any
+ *	   character. Note that they actually can't go together, otherwise
+ *	   %ESCAPE_HEX will be ignored.
+ *
+ * Caller must provide valid source and destination pointers. Be aware that
+ * destination buffer will not be NULL-terminated, thus caller have to append
+ * it if needs.
+ *
+ * Return:
+ * The amount of the characters processed to the destination buffer, or
+ * %-ENOMEM if the size of buffer is not enough to put an escaped character is
+ * returned.
+ *
+ * Even in the case of error @dst pointer will be updated to point to the byte
+ * after the last processed character.
+ */
+int string_escape_mem(const char *src, size_t isz, char **dst, size_t osz,
+		      unsigned int flags, const char *esc)
+{
+	char *out = *dst, *p = out;
+	bool is_dict = esc && *esc;
+	int ret = 0;
+
+	while (isz--) {
+		unsigned char c = *src++;
+
+		/*
+		 * Apply rules in the following sequence:
+		 *	- the character is printable, when @flags has
+		 *	  %ESCAPE_NP bit set
+		 *	- the @esc string is supplied and does not contain a
+		 *	  character under question
+		 *	- the character doesn't fall into a class of symbols
+		 *	  defined by given @flags
+		 * In these cases we just pass through a character to the
+		 * output buffer.
+		 */
+		if ((flags & ESCAPE_NP && isprint(c)) ||
+		    (is_dict && !strchr(esc, c))) {
+			/* do nothing */
+		} else {
+			if (flags & ESCAPE_SPACE) {
+				ret = escape_space(c, &p, &osz);
+				if (ret < 0)
+					break;
+				if (ret > 0)
+					continue;
+			}
+
+			if (flags & ESCAPE_SPECIAL) {
+				ret = escape_special(c, &p, &osz);
+				if (ret < 0)
+					break;
+				if (ret > 0)
+					continue;
+			}
+
+			if (flags & ESCAPE_NULL) {
+				ret = escape_null(c, &p, &osz);
+				if (ret < 0)
+					break;
+				if (ret > 0)
+					continue;
+			}
+
+			/* ESCAPE_OCTAL and ESCAPE_HEX always go last */
+			if (flags & ESCAPE_OCTAL) {
+				ret = escape_octal(c, &p, &osz);
+				if (ret < 0)
+					break;
+				continue;
+			}
+			if (flags & ESCAPE_HEX) {
+				ret = escape_hex(c, &p, &osz);
+				if (ret < 0)
+					break;
+				continue;
+			}
+		}
+
+		ret = escape_passthrough(c, &p, &osz);
+		if (ret < 0)
+			break;
+	}
+
+	*dst = p;
+
+	if (ret < 0)
+		return ret;
+
+	return p - out;
+}
+EXPORT_SYMBOL(string_escape_mem);
diff -puN lib/test-string_helpers.c~lib-string_helpers-introduce-string_escape_mem lib/test-string_helpers.c
--- a/lib/test-string_helpers.c~lib-string_helpers-introduce-string_escape_mem
+++ a/lib/test-string_helpers.c
@@ -102,6 +102,209 @@ static void __init test_string_unescape(
 			      out_test, q_test);
 }
 
+struct test_string_1 {
+	const char *out;
+	unsigned int flags;
+};
+
+#define	TEST_STRING_2_MAX_S1		32
+struct test_string_2 {
+	const char *in;
+	struct test_string_1 s1[TEST_STRING_2_MAX_S1];
+};
+
+#define	TEST_STRING_2_DICT_0		NULL
+static const struct test_string_2 escape0[] __initconst = {{
+	.in = "\f\\ \n\r\t\v",
+	.s1 = {{
+		.out = "\\f\\ \\n\\r\\t\\v",
+		.flags = ESCAPE_SPACE,
+	},{
+		.out = "\\f\\134\\040\\n\\r\\t\\v",
+		.flags = ESCAPE_SPACE | ESCAPE_OCTAL,
+	},{
+		.out = "\\f\\x5c\\x20\\n\\r\\t\\v",
+		.flags = ESCAPE_SPACE | ESCAPE_HEX,
+	},{
+		/* terminator */
+	}},
+},{
+	.in = "\\h\\\"\a\e\\",
+	.s1 = {{
+		.out = "\\\\h\\\\\"\\a\\e\\\\",
+		.flags = ESCAPE_SPECIAL,
+	},{
+		.out = "\\\\\\150\\\\\\042\\a\\e\\\\",
+		.flags = ESCAPE_SPECIAL | ESCAPE_OCTAL,
+	},{
+		.out = "\\\\\\x68\\\\\\x22\\a\\e\\\\",
+		.flags = ESCAPE_SPECIAL | ESCAPE_HEX,
+	},{
+		/* terminator */
+	}},
+},{
+	.in = "\eb \\C\007\"\x90\r]",
+	.s1 = {{
+		.out = "\eb \\C\007\"\x90\\r]",
+		.flags = ESCAPE_SPACE,
+	},{
+		.out = "\\eb \\\\C\\a\"\x90\r]",
+		.flags = ESCAPE_SPECIAL,
+	},{
+		.out = "\\eb \\\\C\\a\"\x90\\r]",
+		.flags = ESCAPE_SPACE | ESCAPE_SPECIAL,
+	},{
+		.out = "\\033\\142\\040\\134\\103\\007\\042\\220\\015\\135",
+		.flags = ESCAPE_OCTAL,
+	},{
+		.out = "\\033\\142\\040\\134\\103\\007\\042\\220\\r\\135",
+		.flags = ESCAPE_SPACE | ESCAPE_OCTAL,
+	},{
+		.out = "\\e\\142\\040\\\\\\103\\a\\042\\220\\015\\135",
+		.flags = ESCAPE_SPECIAL | ESCAPE_OCTAL,
+	},{
+		.out = "\\e\\142\\040\\\\\\103\\a\\042\\220\\r\\135",
+		.flags = ESCAPE_SPACE | ESCAPE_SPECIAL | ESCAPE_OCTAL,
+	},{
+		.out = "\eb \\C\007\"\x90\r]",
+		.flags = ESCAPE_NP,
+	},{
+		.out = "\eb \\C\007\"\x90\\r]",
+		.flags = ESCAPE_SPACE | ESCAPE_NP,
+	},{
+		.out = "\\eb \\C\\a\"\x90\r]",
+		.flags = ESCAPE_SPECIAL | ESCAPE_NP,
+	},{
+		.out = "\\eb \\C\\a\"\x90\\r]",
+		.flags = ESCAPE_SPACE | ESCAPE_SPECIAL | ESCAPE_NP,
+	},{
+		.out = "\\033b \\C\\007\"\\220\\015]",
+		.flags = ESCAPE_OCTAL | ESCAPE_NP,
+	},{
+		.out = "\\033b \\C\\007\"\\220\\r]",
+		.flags = ESCAPE_SPACE | ESCAPE_OCTAL | ESCAPE_NP,
+	},{
+		.out = "\\eb \\C\\a\"\\220\\r]",
+		.flags = ESCAPE_SPECIAL | ESCAPE_SPACE | ESCAPE_OCTAL |
+			 ESCAPE_NP,
+	},{
+		.out = "\\x1bb \\C\\x07\"\\x90\\x0d]",
+		.flags = ESCAPE_NP | ESCAPE_HEX,
+	},{
+		/* terminator */
+	}},
+},{
+	/* terminator */
+}};
+
+#define	TEST_STRING_2_DICT_1		"b\\ \t\r"
+static const struct test_string_2 escape1[] __initconst = {{
+	.in = "\f\\ \n\r\t\v",
+	.s1 = {{
+		.out = "\f\\134\\040\n\\015\\011\v",
+		.flags = ESCAPE_OCTAL,
+	},{
+		.out = "\f\\x5c\\x20\n\\x0d\\x09\v",
+		.flags = ESCAPE_HEX,
+	},{
+		/* terminator */
+	}},
+},{
+	.in = "\\h\\\"\a\e\\",
+	.s1 = {{
+		.out = "\\134h\\134\"\a\e\\134",
+		.flags = ESCAPE_OCTAL,
+	},{
+		/* terminator */
+	}},
+},{
+	.in = "\eb \\C\007\"\x90\r]",
+	.s1 = {{
+		.out = "\e\\142\\040\\134C\007\"\x90\\015]",
+		.flags = ESCAPE_OCTAL,
+	},{
+		/* terminator */
+	}},
+},{
+	/* terminator */
+}};
+
+static __init const char *test_string_find_match(const struct test_string_2 *s2,
+						 unsigned int flags)
+{
+	const struct test_string_1 *s1 = s2->s1;
+	unsigned int i;
+
+	if (!flags)
+		return s2->in;
+
+	/* Test cases are NULL-aware */
+	flags &= ~ESCAPE_NULL;
+
+	/* ESCAPE_OCTAL has a higher priority */
+	if (flags & ESCAPE_OCTAL)
+		flags &= ~ESCAPE_HEX;
+
+	for (i = 0; i < TEST_STRING_2_MAX_S1 && s1->out; i++, s1++)
+		if (s1->flags == flags)
+			return s1->out;
+	return NULL;
+}
+
+static __init void test_string_escape(const char *name,
+				      const struct test_string_2 *s2,
+				      unsigned int flags, const char *esc)
+{
+	char in[256];
+	char out_test[512];
+	char out_real[512], *buf = out_real;
+	int p = 0, q_test = 0, q_real = sizeof(out_real);
+
+	for (; s2->in; s2++) {
+		const char *out;
+		int len;
+
+		/* NULL injection */
+		if (flags & ESCAPE_NULL) {
+			in[p++] = '\0';
+			out_test[q_test++] = '\\';
+			out_test[q_test++] = '0';
+		}
+
+		/* Don't try strings that have no output */
+		out = test_string_find_match(s2, flags);
+		if (!out)
+			continue;
+
+		/* Copy string to in buffer */
+		len = strlen(s2->in);
+		memcpy(&in[p], s2->in, len);
+		p += len;
+
+		/* Copy expected result for given flags */
+		len = strlen(out);
+		memcpy(&out_test[q_test], out, len);
+		q_test += len;
+	}
+
+	q_real = string_escape_mem(in, p, &buf, q_real, flags, esc);
+
+	test_string_check_buf(name, flags, in, p, out_real, q_real, out_test, q_test);
+}
+
+static __init void test_string_escape_nomem(void)
+{
+	char *in = "\eb \\C\007\"\x90\r]";
+	char out[64], *buf = out;
+	int rc = -ENOMEM, ret;
+
+	ret = string_escape_str_any_np(in, &buf, strlen(in), NULL);
+	if (ret == rc)
+		return;
+
+	pr_err("Test 'escape nomem' failed: got %d instead of %d\n", ret, rc);
+}
+
 static int __init test_string_helpers_init(void)
 {
 	unsigned int i;
@@ -112,6 +315,16 @@ static int __init test_string_helpers_in
 	test_string_unescape("unescape inplace",
 			     get_random_int() % (UNESCAPE_ANY + 1), true);
 
+	/* Without dictionary */
+	for (i = 0; i < (ESCAPE_ANY_NP | ESCAPE_HEX) + 1; i++)
+		test_string_escape("escape 0", escape0, i, TEST_STRING_2_DICT_0);
+
+	/* With dictionary */
+	for (i = 0; i < (ESCAPE_ANY_NP | ESCAPE_HEX) + 1; i++)
+		test_string_escape("escape 1", escape1, i, TEST_STRING_2_DICT_1);
+
+	test_string_escape_nomem();
+
 	return -EINVAL;
 }
 module_init(test_string_helpers_init);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch
linux-next.patch

