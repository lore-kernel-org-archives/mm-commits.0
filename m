From: akpm@linux-foundation.org
Subject: + add-parse_integer-replacement-for-simple_strto.patch added to
 -mm tree
Date: Thu, 09 Jul 2015 12:26:05 -0700
Message-ID: <559ecacd.tKmQ3DRvnOF4Y/I/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbbGIT0G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:26:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, dhowells@redhat.com, jack@suse.cz, jlbec@evilplan.org, linux@rasmusvillemoes.dk, mfasheh@suse.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/: add parse_integer() (replacement for simple_strto*())
has been added to the -mm tree.  Its filename is
     add-parse_integer-replacement-for-simple_strto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-parse_integer-replacement-for-simple_strto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-parse_integer-replacement-for-simple_strto.patch

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
Subject: lib/: add parse_integer() (replacement for simple_strto*())

kstrto*() and kstrto*_from_user() family of functions were added to help
with parsing one integer written as string to proc/sysfs/debugfs files. 
But they have a limitation: string passed must end with \0 or \n\0.  There
are enough places where kstrto*() functions can't be used because of this
limitation.  Trivial example: major:minor "%u:%u".

Currently the only way to parse everything is simple_strto*() functions.
But they are suboptimal:

* they do not detect overflow (can be fixed, but no one bothered since
  ~0.99.11),

* there are only 4 of them -- long and "long long" versions, This leads
  to silent truncation in the most simple case:

	val = strtoul(s, NULL, 0);

* half of the people think that "char **endp" argument is necessary and
  add unnecessary variable.

OpenBSD people, fed up with how complex correct integer parsing is, added
strtonum(3) to fixup for deficiencies of libc-style integer parsing:
http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man3/strtonum.3?query=strtonum&arch=i386

It'd be OK to copy that but it relies on "errno" and fixed strings as
error reporting channel which I think is not OK for kernel.  strtonum()
also doesn't report number of characted consumed.

What to do?

Enter parse_integer().

	int parse_integer(const char *s, unsigned int base, T *val);

Rationale:
* parse_integer() is exactly 1 (one) interface not 4 or many, one for each type.

* parse_integer() reports -E errors reliably in a canonical kernel way:

	rv = parse_integer(str, 10, &val);
	if (rv < 0)
		return rv;

* parse_integer() writes result only if there were no errors,
  at least one digit has to be consumed,

* parse_integer doesn't mix error reporting channel and value channel,
  it does mix error and number-of-character-consumed channel, though.

* parse_integer() reports number of characters consumed, makes parsing
  multiple values easy:

	rv = parse_integer(str, 0, &val1);
	if (rv < 0)
		return rv;
	str += rv;
	if (*str++ != ':')
		return -EINVAL;
	rv = parse_integer(str, 0, &val2);
	if (rv < 0)
		return rv;
	if (str[rv] != '\0')
		return -EINVAL;

There are several deficiencies in parse_integer() compared to strto*():

* can't be used in initializers:

	const T x = strtoul();

* can't be used with bitfields,
* can't be used in expressions:

	x = strtol() * 1024;
	x = y = strtol();
	x += strtol();

* currently there is no support for _Bool and at least one place
  where simple_strtoul() is directly assigned to _Bool variable.
  It is trivial to add, but not clear if it should only accept "0" and "1",
  because, say, module param code accepts 0, 1, y, n, Y and N.

In defense of parse_integer() all I can say, is that using strtol() in
expression or initializer promotes no error checking and thus probably
should not be encouraged in C, language with no built-in error checking
anyway.

The amount of "x = y = strtol()" expressions in kernel is very small.
The amount of direct usage in expression is not small, but can be
counted as an acceptable loss.

Misc suggestions and ideas from Rasmus Villemoes.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h        |    7 -
 include/linux/parse-integer.h |   79 ++++++++++++
 lib/Makefile                  |    1 
 lib/kstrtox.c                 |   76 +++---------
 lib/kstrtox.h                 |    1 
 lib/parse-integer.c           |  198 ++++++++++++++++++++++++++++++++
 6 files changed, 305 insertions(+), 57 deletions(-)

diff -puN include/linux/kernel.h~add-parse_integer-replacement-for-simple_strto include/linux/kernel.h
--- a/include/linux/kernel.h~add-parse_integer-replacement-for-simple_strto
+++ a/include/linux/kernel.h
@@ -10,6 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/log2.h>
 #include <linux/typecheck.h>
+#include <linux/parse-integer.h>
 #include <linux/printk.h>
 #include <linux/dynamic_debug.h>
 #include <asm/byteorder.h>
@@ -388,8 +389,10 @@ static inline int __must_check kstrtos32
 	return kstrtoint_from_user(s, count, base, res);
 }
 
-/* Obsolete, do not use.  Use kstrto<foo> instead */
-
+/*
+ * Obsolete, do not use.
+ * Use parse_integer(), kstrto*(), kstrto*_from_user(), sscanf().
+ */
 extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
diff -puN /dev/null include/linux/parse-integer.h
--- /dev/null
+++ a/include/linux/parse-integer.h
@@ -0,0 +1,79 @@
+#ifndef _PARSE_INTEGER_H
+#define _PARSE_INTEGER_H
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/*
+ * int parse_integer(const char *s, unsigned int base, T *val);
+ *
+ * Convert integer string representation to an integer.
+ * Range of accepted values equals to that of type T.
+ *
+ * Conversion to unsigned integer accepts sign "+".
+ * Conversion to signed integer accepts sign "+" and sign "-".
+ *
+ * Radix 0 means autodetection: leading "0x" implies radix 16,
+ * leading "0" implies radix 8, otherwise radix is 10.
+ * Autodetection hint works after optional sign, but not before.
+ *
+ * Return number of characters parsed or -E.
+ *
+ * "T=char" case is not supported because -f{un,}signed-char can silently
+ * change range of accepted values.
+ */
+#define parse_integer(s, base, val)	\
+({					\
+	const char *_s = (s);		\
+	unsigned int _base = (base);	\
+	typeof(&(val)[0]) _val = (val);	\
+					\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), signed char *),	\
+	_parse_integer_sc(_s, _base, (void *)_val),			\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), unsigned char *),	\
+	_parse_integer_uc(_s, _base, (void *)_val),			\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), short *),		\
+	_parse_integer_s(_s, _base, (void *)_val),			\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), unsigned short *),	\
+	_parse_integer_us(_s, _base, (void *)_val),			\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), int *),		\
+	_parse_integer_i(_s, _base, (void *)_val),			\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), unsigned int *),	\
+	_parse_integer_u(_s, _base, (void *)_val),			\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), long *) && sizeof(long) == 4,\
+	_parse_integer_i(_s, _base, (void *)_val),			\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), long *) && sizeof(long) == 8,\
+	_parse_integer_ll(_s, _base, (void *)_val),			\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), unsigned long *) && sizeof(unsigned long) == 4,\
+	_parse_integer_u(_s, _base, (void *)_val),			\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), unsigned long *) && sizeof(unsigned long) == 8,\
+	_parse_integer_ull(_s, _base, (void *)_val),			\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), long long *),	\
+	_parse_integer_ll(_s, _base, (void *)_val),			\
+	__builtin_choose_expr(						\
+	__builtin_types_compatible_p(typeof(_val), unsigned long long *),\
+	_parse_integer_ull(_s, _base, (void *)_val),			\
+	_parse_integer_link_time_error()))))))))))));	\
+})
+/* internal, do not use */
+int _parse_integer_sc(const char *s, unsigned int base, signed char *val);
+int _parse_integer_uc(const char *s, unsigned int base, unsigned char *val);
+int _parse_integer_s(const char *s, unsigned int base, short *val);
+int _parse_integer_us(const char *s, unsigned int base, unsigned short *val);
+int _parse_integer_i(const char *s, unsigned int base, int *val);
+int _parse_integer_u(const char *s, unsigned int base, unsigned int *val);
+int _parse_integer_ll(const char *s, unsigned int base, long long *val);
+int _parse_integer_ull(const char *s, unsigned int base, unsigned long long *val);
+void _parse_integer_link_time_error(void);
+const char *_parse_integer_fixup_radix(const char *s, unsigned int *base);
+#endif
diff -puN lib/Makefile~add-parse_integer-replacement-for-simple_strto lib/Makefile
--- a/lib/Makefile~add-parse_integer-replacement-for-simple_strto
+++ a/lib/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_TEST_STRING_HELPERS) += tes
 obj-y += hexdump.o
 obj-$(CONFIG_TEST_HEXDUMP) += test-hexdump.o
 obj-y += kstrtox.o
+obj-y += parse-integer.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
 obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
 obj-$(CONFIG_TEST_KASAN) += test_kasan.o
diff -puN lib/kstrtox.c~add-parse_integer-replacement-for-simple_strto lib/kstrtox.c
--- a/lib/kstrtox.c~add-parse_integer-replacement-for-simple_strto
+++ a/lib/kstrtox.c
@@ -20,22 +20,6 @@
 #include <asm/uaccess.h>
 #include "kstrtox.h"
 
-const char *_parse_integer_fixup_radix(const char *s, unsigned int *base)
-{
-	if (*base == 0) {
-		if (s[0] == '0') {
-			if (_tolower(s[1]) == 'x' && isxdigit(s[2]))
-				*base = 16;
-			else
-				*base = 8;
-		} else
-			*base = 10;
-	}
-	if (*base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
-		s += 2;
-	return s;
-}
-
 /*
  * Convert non-negative integer string representation in explicitly given radix
  * to an integer.
@@ -83,26 +67,6 @@ unsigned int _parse_integer(const char *
 	return rv;
 }
 
-static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
-{
-	unsigned long long _res;
-	unsigned int rv;
-
-	s = _parse_integer_fixup_radix(s, &base);
-	rv = _parse_integer(s, base, &_res);
-	if (rv & KSTRTOX_OVERFLOW)
-		return -ERANGE;
-	if (rv == 0)
-		return -EINVAL;
-	s += rv;
-	if (*s == '\n')
-		s++;
-	if (*s)
-		return -EINVAL;
-	*res = _res;
-	return 0;
-}
-
 /**
  * kstrtoull - convert a string to an unsigned long long
  * @s: The start of the string. The string must be null-terminated, and may also
@@ -121,9 +85,19 @@ static int _kstrtoull(const char *s, uns
  */
 int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 {
-	if (s[0] == '+')
+	unsigned long long _res;
+	int rv;
+
+	rv = parse_integer(s, base, &_res);
+	if (rv < 0)
+		return rv;
+	s += rv;
+	if (*s == '\n')
 		s++;
-	return _kstrtoull(s, base, res);
+	if (*s)
+		return -EINVAL;
+	*res = _res;
+	return 0;
 }
 EXPORT_SYMBOL(kstrtoull);
 
@@ -145,24 +119,18 @@ EXPORT_SYMBOL(kstrtoull);
  */
 int kstrtoll(const char *s, unsigned int base, long long *res)
 {
-	unsigned long long tmp;
+	long long _res;
 	int rv;
 
-	if (s[0] == '-') {
-		rv = _kstrtoull(s + 1, base, &tmp);
-		if (rv < 0)
-			return rv;
-		if ((long long)-tmp > 0)
-			return -ERANGE;
-		*res = -tmp;
-	} else {
-		rv = kstrtoull(s, base, &tmp);
-		if (rv < 0)
-			return rv;
-		if ((long long)tmp < 0)
-			return -ERANGE;
-		*res = tmp;
-	}
+	rv = parse_integer(s, base, &_res);
+	if (rv < 0)
+		return rv;
+	s += rv;
+	if (*s == '\n')
+		s++;
+	if (*s)
+		return -EINVAL;
+	*res = _res;
 	return 0;
 }
 EXPORT_SYMBOL(kstrtoll);
diff -puN lib/kstrtox.h~add-parse_integer-replacement-for-simple_strto lib/kstrtox.h
--- a/lib/kstrtox.h~add-parse_integer-replacement-for-simple_strto
+++ a/lib/kstrtox.h
@@ -2,7 +2,6 @@
 #define _LIB_KSTRTOX_H
 
 #define KSTRTOX_OVERFLOW	(1U << 31)
-const char *_parse_integer_fixup_radix(const char *s, unsigned int *base);
 unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long *res);
 
 #endif
diff -puN /dev/null lib/parse-integer.c
--- /dev/null
+++ a/lib/parse-integer.c
@@ -0,0 +1,198 @@
+/*
+ * See parse_integer().
+ *
+ * Individual dispatch functions in this file aren't supposed to be used
+ * directly and thus aren't advertised and documented despited being exported.
+ *
+ * Do not use any function in this file for any reason.
+ */
+#include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/math64.h>
+#include <linux/parse-integer.h>
+#include <asm/bug.h>
+
+const char *_parse_integer_fixup_radix(const char *s, unsigned int *base)
+{
+	if (*base == 0) {
+		if (s[0] == '0') {
+			if (_tolower(s[1]) == 'x' && isxdigit(s[2]))
+				*base = 16;
+			else
+				*base = 8;
+		} else
+			*base = 10;
+	}
+	if (*base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
+		s += 2;
+	BUG_ON(*base < 2 || *base > 16);
+	return s;
+}
+
+static int __parse_integer(const char *s, unsigned int base, unsigned long long *val)
+{
+	const char *s0 = s, *sd;
+	unsigned long long acc;
+
+	s = sd = _parse_integer_fixup_radix(s0, &base);
+	acc = 0;
+	while (*s) {
+		unsigned int d;
+
+		if ('0' <= *s && *s <= '9')
+			d = *s - '0';
+		else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
+			d = _tolower(*s) - 'a' + 10;
+		else
+			break;
+		if (d >= base)
+			break;
+		/* Overflow can't happen early enough. */
+		if ((acc >> 60) && acc > div_u64(ULLONG_MAX - d, base))
+			return -ERANGE;
+		acc = acc * base + d;
+		s++;
+	}
+	/* At least one digit has to be converted. */
+	if (s == sd)
+		return -EINVAL;
+	*val = acc;
+	/* Radix 1 is not supported otherwise returned length can overflow. */
+	return s - s0;
+}
+
+int _parse_integer_ull(const char *s, unsigned int base, unsigned long long *val)
+{
+	char sign;
+	int rv;
+
+	sign = 0;
+	if (*s == '-')
+		return -EINVAL;
+	else if (*s == '+')
+		sign = *s++;
+
+	rv = __parse_integer(s, base, val);
+	if (rv < 0)
+		return rv;
+	return rv + !!sign;
+}
+EXPORT_SYMBOL(_parse_integer_ull);
+
+int _parse_integer_ll(const char *s, unsigned int base, long long *val)
+{
+	unsigned long long tmp;
+	char sign;
+	int rv;
+
+	sign = 0;
+	if (*s == '-' || *s == '+')
+		sign = *s++;
+
+	rv = __parse_integer(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (sign == '-') {
+		if ((long long)-tmp > 0)
+			return -ERANGE;
+		*val = -tmp;
+	} else {
+		if ((long long)tmp < 0)
+			return -ERANGE;
+		*val = tmp;
+	}
+	return rv + !!sign;
+}
+EXPORT_SYMBOL(_parse_integer_ll);
+
+int _parse_integer_u(const char *s, unsigned int base, unsigned int *val)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = _parse_integer_ull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned int)tmp)
+		return -ERANGE;
+	*val = tmp;
+	return rv;
+}
+EXPORT_SYMBOL(_parse_integer_u);
+
+int _parse_integer_i(const char *s, unsigned int base, int *val)
+{
+	long long tmp;
+	int rv;
+
+	rv = _parse_integer_ll(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (int)tmp)
+		return -ERANGE;
+	*val = tmp;
+	return rv;
+}
+EXPORT_SYMBOL(_parse_integer_i);
+
+int _parse_integer_us(const char *s, unsigned int base, unsigned short *val)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = _parse_integer_ull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned short)tmp)
+		return -ERANGE;
+	*val = tmp;
+	return rv;
+}
+EXPORT_SYMBOL(_parse_integer_us);
+
+int _parse_integer_s(const char *s, unsigned int base, short *val)
+{
+	long long tmp;
+	int rv;
+
+	rv = _parse_integer_ll(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (short)tmp)
+		return -ERANGE;
+	*val = tmp;
+	return rv;
+}
+EXPORT_SYMBOL(_parse_integer_s);
+
+int _parse_integer_uc(const char *s, unsigned int base, unsigned char *val)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = _parse_integer_ull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned char)tmp)
+		return -ERANGE;
+	*val = tmp;
+	return rv;
+}
+EXPORT_SYMBOL(_parse_integer_uc);
+
+int _parse_integer_sc(const char *s, unsigned int base, signed char *val)
+{
+	long long tmp;
+	int rv;
+
+	rv = _parse_integer_ll(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (signed char)tmp)
+		return -ERANGE;
+	*val = tmp;
+	return rv;
+}
+EXPORT_SYMBOL(_parse_integer_sc);
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

