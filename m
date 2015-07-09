From: akpm@linux-foundation.org
Subject: + parse-integer-rewrite-kstrto.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:26:09 -0700
Message-ID: <559ecad1.umgp2YXsAZTsNLqX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbbGIT0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: parse-integer: rewrite kstrto*()
has been added to the -mm tree.  Its filename is
     parse-integer-rewrite-kstrto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parse-integer-rewrite-kstrto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parse-integer-rewrite-kstrto.patch

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
Subject: parse-integer: rewrite kstrto*()

Rewrite kstrto*() functions through parse_integer().

_kstrtoul() and _kstrtol() are removed because parse_integer()
can dispatch based on sizeof(long) saving function call.

Also move function definitions and comment one instance.
Remove redundant boilerplate comments from elsewhere.

High bit base hack suggested by Andrew Morton.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h        |  124 -----------------
 include/linux/parse-integer.h |  109 +++++++++++++++
 lib/kstrtox.c                 |  222 --------------------------------
 lib/parse-integer.c           |   26 +++
 4 files changed, 134 insertions(+), 347 deletions(-)

diff -puN include/linux/kernel.h~parse-integer-rewrite-kstrto include/linux/kernel.h
--- a/include/linux/kernel.h~parse-integer-rewrite-kstrto
+++ a/include/linux/kernel.h
@@ -265,130 +265,6 @@ void do_exit(long error_code)
 void complete_and_exit(struct completion *, long)
 	__noreturn;
 
-/* Internal, do not use. */
-int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
-int __must_check _kstrtol(const char *s, unsigned int base, long *res);
-
-int __must_check kstrtoull(const char *s, unsigned int base, unsigned long long *res);
-int __must_check kstrtoll(const char *s, unsigned int base, long long *res);
-
-/**
- * kstrtoul - convert a string to an unsigned long
- * @s: The start of the string. The string must be null-terminated, and may also
- *  include a single newline before its terminating null. The first character
- *  may also be a plus sign, but not a minus sign.
- * @base: The number base to use. The maximum supported base is 16. If base is
- *  given as 0, then the base of the string is automatically detected with the
- *  conventional semantics - If it begins with 0x the number will be parsed as a
- *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
- *  parsed as an octal number. Otherwise it will be parsed as a decimal.
- * @res: Where to write the result of the conversion on success.
- *
- * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoull. Return code must
- * be checked.
-*/
-static inline int __must_check kstrtoul(const char *s, unsigned int base, unsigned long *res)
-{
-	/*
-	 * We want to shortcut function call, but
-	 * __builtin_types_compatible_p(unsigned long, unsigned long long) = 0.
-	 */
-	if (sizeof(unsigned long) == sizeof(unsigned long long) &&
-	    __alignof__(unsigned long) == __alignof__(unsigned long long))
-		return kstrtoull(s, base, (unsigned long long *)res);
-	else
-		return _kstrtoul(s, base, res);
-}
-
-/**
- * kstrtol - convert a string to a long
- * @s: The start of the string. The string must be null-terminated, and may also
- *  include a single newline before its terminating null. The first character
- *  may also be a plus sign or a minus sign.
- * @base: The number base to use. The maximum supported base is 16. If base is
- *  given as 0, then the base of the string is automatically detected with the
- *  conventional semantics - If it begins with 0x the number will be parsed as a
- *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
- *  parsed as an octal number. Otherwise it will be parsed as a decimal.
- * @res: Where to write the result of the conversion on success.
- *
- * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoull. Return code must
- * be checked.
- */
-static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
-{
-	/*
-	 * We want to shortcut function call, but
-	 * __builtin_types_compatible_p(long, long long) = 0.
-	 */
-	if (sizeof(long) == sizeof(long long) &&
-	    __alignof__(long) == __alignof__(long long))
-		return kstrtoll(s, base, (long long *)res);
-	else
-		return _kstrtol(s, base, res);
-}
-
-int __must_check kstrtouint(const char *s, unsigned int base, unsigned int *res);
-int __must_check kstrtoint(const char *s, unsigned int base, int *res);
-
-static inline int __must_check kstrtou64(const char *s, unsigned int base, u64 *res)
-{
-	return kstrtoull(s, base, res);
-}
-
-static inline int __must_check kstrtos64(const char *s, unsigned int base, s64 *res)
-{
-	return kstrtoll(s, base, res);
-}
-
-static inline int __must_check kstrtou32(const char *s, unsigned int base, u32 *res)
-{
-	return kstrtouint(s, base, res);
-}
-
-static inline int __must_check kstrtos32(const char *s, unsigned int base, s32 *res)
-{
-	return kstrtoint(s, base, res);
-}
-
-int __must_check kstrtou16(const char *s, unsigned int base, u16 *res);
-int __must_check kstrtos16(const char *s, unsigned int base, s16 *res);
-int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
-int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
-
-int __must_check kstrtoull_from_user(const char __user *s, size_t count, unsigned int base, unsigned long long *res);
-int __must_check kstrtoll_from_user(const char __user *s, size_t count, unsigned int base, long long *res);
-int __must_check kstrtoul_from_user(const char __user *s, size_t count, unsigned int base, unsigned long *res);
-int __must_check kstrtol_from_user(const char __user *s, size_t count, unsigned int base, long *res);
-int __must_check kstrtouint_from_user(const char __user *s, size_t count, unsigned int base, unsigned int *res);
-int __must_check kstrtoint_from_user(const char __user *s, size_t count, unsigned int base, int *res);
-int __must_check kstrtou16_from_user(const char __user *s, size_t count, unsigned int base, u16 *res);
-int __must_check kstrtos16_from_user(const char __user *s, size_t count, unsigned int base, s16 *res);
-int __must_check kstrtou8_from_user(const char __user *s, size_t count, unsigned int base, u8 *res);
-int __must_check kstrtos8_from_user(const char __user *s, size_t count, unsigned int base, s8 *res);
-
-static inline int __must_check kstrtou64_from_user(const char __user *s, size_t count, unsigned int base, u64 *res)
-{
-	return kstrtoull_from_user(s, count, base, res);
-}
-
-static inline int __must_check kstrtos64_from_user(const char __user *s, size_t count, unsigned int base, s64 *res)
-{
-	return kstrtoll_from_user(s, count, base, res);
-}
-
-static inline int __must_check kstrtou32_from_user(const char __user *s, size_t count, unsigned int base, u32 *res)
-{
-	return kstrtouint_from_user(s, count, base, res);
-}
-
-static inline int __must_check kstrtos32_from_user(const char __user *s, size_t count, unsigned int base, s32 *res)
-{
-	return kstrtoint_from_user(s, count, base, res);
-}
-
 /*
  * Obsolete, do not use.
  * Use parse_integer(), kstrto*(), kstrto*_from_user(), sscanf().
diff -puN include/linux/parse-integer.h~parse-integer-rewrite-kstrto include/linux/parse-integer.h
--- a/include/linux/parse-integer.h~parse-integer-rewrite-kstrto
+++ a/include/linux/parse-integer.h
@@ -76,4 +76,113 @@ int _parse_integer_ll(const char *s, uns
 int _parse_integer_ull(const char *s, unsigned int base, unsigned long long *val);
 void _parse_integer_link_time_error(void);
 const char *_parse_integer_fixup_radix(const char *s, unsigned int *base);
+#define PARSE_INTEGER_NEWLINE 0x80000000u
+
+/*
+ * Convert integer string representation terminated by \n\0 or \0 to an integer.
+ *
+ * Return 0 on success or -E.
+ *
+ * See parse_integer().
+ */
+static inline int __must_check kstrtoull(const char *s, unsigned int base, unsigned long long *res)
+{
+	return parse_integer(s, base | PARSE_INTEGER_NEWLINE, res);
+}
+
+static inline int __must_check kstrtoll(const char *s, unsigned int base, long long *res)
+{
+	return parse_integer(s, base | PARSE_INTEGER_NEWLINE, res);
+}
+
+static inline int __must_check kstrtoul(const char *s, unsigned int base, unsigned long *res)
+{
+	return parse_integer(s, base | PARSE_INTEGER_NEWLINE, res);
+}
+
+static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
+{
+	return parse_integer(s, base | PARSE_INTEGER_NEWLINE, res);
+}
+
+static inline int __must_check kstrtouint(const char *s, unsigned int base, unsigned int *res)
+{
+	return parse_integer(s, base | PARSE_INTEGER_NEWLINE, res);
+}
+
+static inline int __must_check kstrtoint(const char *s, unsigned int base, int *res)
+{
+	return parse_integer(s, base | PARSE_INTEGER_NEWLINE, res);
+}
+
+static inline int __must_check kstrtou64(const char *s, unsigned int base, u64 *res)
+{
+	return kstrtoull(s, base, res);
+}
+
+static inline int __must_check kstrtos64(const char *s, unsigned int base, s64 *res)
+{
+	return kstrtoll(s, base, res);
+}
+
+static inline int __must_check kstrtou32(const char *s, unsigned int base, u32 *res)
+{
+	return kstrtouint(s, base, res);
+}
+
+static inline int __must_check kstrtos32(const char *s, unsigned int base, s32 *res)
+{
+	return kstrtoint(s, base, res);
+}
+
+static inline int __must_check kstrtou16(const char *s, unsigned int base, u16 *res)
+{
+	return parse_integer(s, base | PARSE_INTEGER_NEWLINE, res);
+}
+
+static inline int __must_check kstrtos16(const char *s, unsigned int base, s16 *res)
+{
+	return parse_integer(s, base | PARSE_INTEGER_NEWLINE, res);
+}
+
+static inline int __must_check kstrtou8(const char *s, unsigned int base, u8 *res)
+{
+	return parse_integer(s, base | PARSE_INTEGER_NEWLINE, res);
+}
+
+static inline int __must_check kstrtos8(const char *s, unsigned int base, s8 *res)
+{
+	return parse_integer(s, base | PARSE_INTEGER_NEWLINE, res);
+}
+
+int __must_check kstrtoull_from_user(const char __user *s, size_t count, unsigned int base, unsigned long long *res);
+int __must_check kstrtoll_from_user(const char __user *s, size_t count, unsigned int base, long long *res);
+int __must_check kstrtoul_from_user(const char __user *s, size_t count, unsigned int base, unsigned long *res);
+int __must_check kstrtol_from_user(const char __user *s, size_t count, unsigned int base, long *res);
+int __must_check kstrtouint_from_user(const char __user *s, size_t count, unsigned int base, unsigned int *res);
+int __must_check kstrtoint_from_user(const char __user *s, size_t count, unsigned int base, int *res);
+int __must_check kstrtou16_from_user(const char __user *s, size_t count, unsigned int base, u16 *res);
+int __must_check kstrtos16_from_user(const char __user *s, size_t count, unsigned int base, s16 *res);
+int __must_check kstrtou8_from_user(const char __user *s, size_t count, unsigned int base, u8 *res);
+int __must_check kstrtos8_from_user(const char __user *s, size_t count, unsigned int base, s8 *res);
+
+static inline int __must_check kstrtou64_from_user(const char __user *s, size_t count, unsigned int base, u64 *res)
+{
+	return kstrtoull_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtos64_from_user(const char __user *s, size_t count, unsigned int base, s64 *res)
+{
+	return kstrtoll_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtou32_from_user(const char __user *s, size_t count, unsigned int base, u32 *res)
+{
+	return kstrtouint_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtos32_from_user(const char __user *s, size_t count, unsigned int base, s32 *res)
+{
+	return kstrtoint_from_user(s, count, base, res);
+}
 #endif
diff -puN lib/kstrtox.c~parse-integer-rewrite-kstrto lib/kstrtox.c
--- a/lib/kstrtox.c~parse-integer-rewrite-kstrto
+++ a/lib/kstrtox.c
@@ -67,228 +67,6 @@ unsigned int _parse_integer(const char *
 	return rv;
 }
 
-/**
- * kstrtoull - convert a string to an unsigned long long
- * @s: The start of the string. The string must be null-terminated, and may also
- *  include a single newline before its terminating null. The first character
- *  may also be a plus sign, but not a minus sign.
- * @base: The number base to use. The maximum supported base is 16. If base is
- *  given as 0, then the base of the string is automatically detected with the
- *  conventional semantics - If it begins with 0x the number will be parsed as a
- *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
- *  parsed as an octal number. Otherwise it will be parsed as a decimal.
- * @res: Where to write the result of the conversion on success.
- *
- * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoull. Return code must
- * be checked.
- */
-int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
-{
-	unsigned long long _res;
-	int rv;
-
-	rv = parse_integer(s, base, &_res);
-	if (rv < 0)
-		return rv;
-	s += rv;
-	if (*s == '\n')
-		s++;
-	if (*s)
-		return -EINVAL;
-	*res = _res;
-	return 0;
-}
-EXPORT_SYMBOL(kstrtoull);
-
-/**
- * kstrtoll - convert a string to a long long
- * @s: The start of the string. The string must be null-terminated, and may also
- *  include a single newline before its terminating null. The first character
- *  may also be a plus sign or a minus sign.
- * @base: The number base to use. The maximum supported base is 16. If base is
- *  given as 0, then the base of the string is automatically detected with the
- *  conventional semantics - If it begins with 0x the number will be parsed as a
- *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
- *  parsed as an octal number. Otherwise it will be parsed as a decimal.
- * @res: Where to write the result of the conversion on success.
- *
- * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoull. Return code must
- * be checked.
- */
-int kstrtoll(const char *s, unsigned int base, long long *res)
-{
-	long long _res;
-	int rv;
-
-	rv = parse_integer(s, base, &_res);
-	if (rv < 0)
-		return rv;
-	s += rv;
-	if (*s == '\n')
-		s++;
-	if (*s)
-		return -EINVAL;
-	*res = _res;
-	return 0;
-}
-EXPORT_SYMBOL(kstrtoll);
-
-/* Internal, do not use. */
-int _kstrtoul(const char *s, unsigned int base, unsigned long *res)
-{
-	unsigned long long tmp;
-	int rv;
-
-	rv = kstrtoull(s, base, &tmp);
-	if (rv < 0)
-		return rv;
-	if (tmp != (unsigned long long)(unsigned long)tmp)
-		return -ERANGE;
-	*res = tmp;
-	return 0;
-}
-EXPORT_SYMBOL(_kstrtoul);
-
-/* Internal, do not use. */
-int _kstrtol(const char *s, unsigned int base, long *res)
-{
-	long long tmp;
-	int rv;
-
-	rv = kstrtoll(s, base, &tmp);
-	if (rv < 0)
-		return rv;
-	if (tmp != (long long)(long)tmp)
-		return -ERANGE;
-	*res = tmp;
-	return 0;
-}
-EXPORT_SYMBOL(_kstrtol);
-
-/**
- * kstrtouint - convert a string to an unsigned int
- * @s: The start of the string. The string must be null-terminated, and may also
- *  include a single newline before its terminating null. The first character
- *  may also be a plus sign, but not a minus sign.
- * @base: The number base to use. The maximum supported base is 16. If base is
- *  given as 0, then the base of the string is automatically detected with the
- *  conventional semantics - If it begins with 0x the number will be parsed as a
- *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
- *  parsed as an octal number. Otherwise it will be parsed as a decimal.
- * @res: Where to write the result of the conversion on success.
- *
- * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoull. Return code must
- * be checked.
- */
-int kstrtouint(const char *s, unsigned int base, unsigned int *res)
-{
-	unsigned long long tmp;
-	int rv;
-
-	rv = kstrtoull(s, base, &tmp);
-	if (rv < 0)
-		return rv;
-	if (tmp != (unsigned long long)(unsigned int)tmp)
-		return -ERANGE;
-	*res = tmp;
-	return 0;
-}
-EXPORT_SYMBOL(kstrtouint);
-
-/**
- * kstrtoint - convert a string to an int
- * @s: The start of the string. The string must be null-terminated, and may also
- *  include a single newline before its terminating null. The first character
- *  may also be a plus sign or a minus sign.
- * @base: The number base to use. The maximum supported base is 16. If base is
- *  given as 0, then the base of the string is automatically detected with the
- *  conventional semantics - If it begins with 0x the number will be parsed as a
- *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
- *  parsed as an octal number. Otherwise it will be parsed as a decimal.
- * @res: Where to write the result of the conversion on success.
- *
- * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoull. Return code must
- * be checked.
- */
-int kstrtoint(const char *s, unsigned int base, int *res)
-{
-	long long tmp;
-	int rv;
-
-	rv = kstrtoll(s, base, &tmp);
-	if (rv < 0)
-		return rv;
-	if (tmp != (long long)(int)tmp)
-		return -ERANGE;
-	*res = tmp;
-	return 0;
-}
-EXPORT_SYMBOL(kstrtoint);
-
-int kstrtou16(const char *s, unsigned int base, u16 *res)
-{
-	unsigned long long tmp;
-	int rv;
-
-	rv = kstrtoull(s, base, &tmp);
-	if (rv < 0)
-		return rv;
-	if (tmp != (unsigned long long)(u16)tmp)
-		return -ERANGE;
-	*res = tmp;
-	return 0;
-}
-EXPORT_SYMBOL(kstrtou16);
-
-int kstrtos16(const char *s, unsigned int base, s16 *res)
-{
-	long long tmp;
-	int rv;
-
-	rv = kstrtoll(s, base, &tmp);
-	if (rv < 0)
-		return rv;
-	if (tmp != (long long)(s16)tmp)
-		return -ERANGE;
-	*res = tmp;
-	return 0;
-}
-EXPORT_SYMBOL(kstrtos16);
-
-int kstrtou8(const char *s, unsigned int base, u8 *res)
-{
-	unsigned long long tmp;
-	int rv;
-
-	rv = kstrtoull(s, base, &tmp);
-	if (rv < 0)
-		return rv;
-	if (tmp != (unsigned long long)(u8)tmp)
-		return -ERANGE;
-	*res = tmp;
-	return 0;
-}
-EXPORT_SYMBOL(kstrtou8);
-
-int kstrtos8(const char *s, unsigned int base, s8 *res)
-{
-	long long tmp;
-	int rv;
-
-	rv = kstrtoll(s, base, &tmp);
-	if (rv < 0)
-		return rv;
-	if (tmp != (long long)(s8)tmp)
-		return -ERANGE;
-	*res = tmp;
-	return 0;
-}
-EXPORT_SYMBOL(kstrtos8);
-
 #define kstrto_from_user(f, g, type)					\
 int f(const char __user *s, size_t count, unsigned int base, type *res)	\
 {									\
diff -puN lib/parse-integer.c~parse-integer-rewrite-kstrto lib/parse-integer.c
--- a/lib/parse-integer.c~parse-integer-rewrite-kstrto
+++ a/lib/parse-integer.c
@@ -31,7 +31,7 @@ const char *_parse_integer_fixup_radix(c
 	return s;
 }
 
-static int __parse_integer(const char *s, unsigned int base, unsigned long long *val)
+static int ___parse_integer(const char *s, unsigned int base, unsigned long long *val)
 {
 	const char *s0 = s, *sd;
 	unsigned long long acc;
@@ -63,6 +63,26 @@ static int __parse_integer(const char *s
 	return s - s0;
 }
 
+static int __parse_integer(const char *s, unsigned int base, unsigned long long *val)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = ___parse_integer(s, base & ~PARSE_INTEGER_NEWLINE, &tmp);
+	if (rv < 0)
+		return rv;
+	if (base & PARSE_INTEGER_NEWLINE) {
+		/* Accept "integer\0" or "integer\n\0" */
+		s += rv;
+		if (*s == '\n')
+			s++;
+		if (*s)
+			return -EINVAL;
+	}
+	*val = tmp;
+	return rv;
+}
+
 int _parse_integer_ull(const char *s, unsigned int base, unsigned long long *val)
 {
 	char sign;
@@ -77,6 +97,8 @@ int _parse_integer_ull(const char *s, un
 	rv = __parse_integer(s, base, val);
 	if (rv < 0)
 		return rv;
+	if (base & PARSE_INTEGER_NEWLINE)
+		return 0;
 	return rv + !!sign;
 }
 EXPORT_SYMBOL(_parse_integer_ull);
@@ -103,6 +125,8 @@ int _parse_integer_ll(const char *s, uns
 			return -ERANGE;
 		*val = tmp;
 	}
+	if (base & PARSE_INTEGER_NEWLINE)
+		return 0;
 	return rv + !!sign;
 }
 EXPORT_SYMBOL(_parse_integer_ll);
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

