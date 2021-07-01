Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F32C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D40B661468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbhGAB6l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238467AbhGAB6k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6933C6141A;
        Thu,  1 Jul 2021 01:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104570;
        bh=EEPC75fzbW9XZ3F52rrT7rZHx3IVd/Tlj00WafeDCVw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Tgi0wucdDtNjhYnyyiri3aYYqqVV6YVNbjloZiMNnWlvu5PR47iWcL0Wu5g5nqTxZ
         1nIjKQCAgkJUpmmmbnbBif1sddyaV58kTx+ZPIhTofPslOW5a3EgKj8KMiVnF+VUTZ
         fNGOIViZ/88xvnhQ0a0fQpinL9oLvFZ9uKzLA+Ps=
Date:   Wed, 30 Jun 2021 18:56:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        anna.schumaker@netapp.com, bfields@fieldses.org,
        chuck.lever@oracle.com, Jonathan.Cameron@huawei.com,
        kerneldev@karsmulder.nl, laniel_francis@privacyrequired.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org,
        trond.myklebust@hammerspace.com
Subject:  [patch 170/192] kernel.h: split out kstrtox() and
 simple_strtox() to a separate header
Message-ID: <20210701015610.LwOPRe5qf%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: split out kstrtox() and simple_strtox() to a separate header

kernel.h is being used as a dump for all kinds of stuff for a long time. 
Here is the attempt to start cleaning it up by splitting out kstrtox() and
simple_strtox() helpers.

At the same time convert users in header and lib folders to use new
header.  Though for time being include new header back to kernel.h to
avoid twisted indirected includes for existing users.

[andy.shevchenko@gmail.com: fix documentation references]
  Link: https://lkml.kernel.org/r/20210615220003.377901-1-andy.shevchenko@gmail.com
Link: https://lkml.kernel.org/r/20210611185815.44103-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Francis Laniel <laniel_francis@privacyrequired.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Kars Mulder <kerneldev@karsmulder.nl>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/kernel-api.rst |    7 -
 include/linux/kernel.h                |  143 ----------------------
 include/linux/kstrtox.h               |  155 ++++++++++++++++++++++++
 include/linux/string.h                |    7 -
 include/linux/sunrpc/cache.h          |    1 
 lib/kstrtox.c                         |    5 
 lib/parser.c                          |    1 
 7 files changed, 163 insertions(+), 156 deletions(-)

--- a/Documentation/core-api/kernel-api.rst~kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header
+++ a/Documentation/core-api/kernel-api.rst
@@ -24,11 +24,8 @@ String Conversions
 .. kernel-doc:: lib/vsprintf.c
    :export:
 
-.. kernel-doc:: include/linux/kernel.h
-   :functions: kstrtol
-
-.. kernel-doc:: include/linux/kernel.h
-   :functions: kstrtoul
+.. kernel-doc:: include/linux/kstrtox.h
+   :functions: kstrtol kstrtoul
 
 .. kernel-doc:: lib/kstrtox.c
    :export:
--- a/include/linux/kernel.h~kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header
+++ a/include/linux/kernel.h
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/bitops.h>
+#include <linux/kstrtox.h>
 #include <linux/log2.h>
 #include <linux/math.h>
 #include <linux/minmax.h>
@@ -180,148 +181,6 @@ static inline void might_fault(void) { }
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
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
- * Preferred over simple_strtoul(). Return code must be checked.
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
- * Preferred over simple_strtol(). Return code must be checked.
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
-int __must_check kstrtobool(const char *s, bool *res);
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
-int __must_check kstrtobool_from_user(const char __user *s, size_t count, bool *res);
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
-/*
- * Use kstrto<foo> instead.
- *
- * NOTE: simple_strto<foo> does not check for the range overflow and,
- *	 depending on the input, may give interesting results.
- *
- * Use these functions if and only if you cannot use kstrto<foo>, because
- * the conversion ends on the first non-digit character, which may be far
- * beyond the supported range. It might be useful to parse the strings like
- * 10x50 or 12:21 without altering original string or temporary buffer in use.
- * Keep in mind above caveat.
- */
-
-extern unsigned long simple_strtoul(const char *,char **,unsigned int);
-extern long simple_strtol(const char *,char **,unsigned int);
-extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
-extern long long simple_strtoll(const char *,char **,unsigned int);
-
 extern int num_to_str(char *buf, int size,
 		      unsigned long long num, unsigned int width);
 
--- /dev/null
+++ a/include/linux/kstrtox.h
@@ -0,0 +1,155 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KSTRTOX_H
+#define _LINUX_KSTRTOX_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/* Internal, do not use. */
+int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
+int __must_check _kstrtol(const char *s, unsigned int base, long *res);
+
+int __must_check kstrtoull(const char *s, unsigned int base, unsigned long long *res);
+int __must_check kstrtoll(const char *s, unsigned int base, long long *res);
+
+/**
+ * kstrtoul - convert a string to an unsigned long
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign, but not a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Preferred over simple_strtoul(). Return code must be checked.
+*/
+static inline int __must_check kstrtoul(const char *s, unsigned int base, unsigned long *res)
+{
+	/*
+	 * We want to shortcut function call, but
+	 * __builtin_types_compatible_p(unsigned long, unsigned long long) = 0.
+	 */
+	if (sizeof(unsigned long) == sizeof(unsigned long long) &&
+	    __alignof__(unsigned long) == __alignof__(unsigned long long))
+		return kstrtoull(s, base, (unsigned long long *)res);
+	else
+		return _kstrtoul(s, base, res);
+}
+
+/**
+ * kstrtol - convert a string to a long
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign or a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Preferred over simple_strtol(). Return code must be checked.
+ */
+static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
+{
+	/*
+	 * We want to shortcut function call, but
+	 * __builtin_types_compatible_p(long, long long) = 0.
+	 */
+	if (sizeof(long) == sizeof(long long) &&
+	    __alignof__(long) == __alignof__(long long))
+		return kstrtoll(s, base, (long long *)res);
+	else
+		return _kstrtol(s, base, res);
+}
+
+int __must_check kstrtouint(const char *s, unsigned int base, unsigned int *res);
+int __must_check kstrtoint(const char *s, unsigned int base, int *res);
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
+int __must_check kstrtou16(const char *s, unsigned int base, u16 *res);
+int __must_check kstrtos16(const char *s, unsigned int base, s16 *res);
+int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
+int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
+int __must_check kstrtobool(const char *s, bool *res);
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
+int __must_check kstrtobool_from_user(const char __user *s, size_t count, bool *res);
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
+
+/*
+ * Use kstrto<foo> instead.
+ *
+ * NOTE: simple_strto<foo> does not check for the range overflow and,
+ *	 depending on the input, may give interesting results.
+ *
+ * Use these functions if and only if you cannot use kstrto<foo>, because
+ * the conversion ends on the first non-digit character, which may be far
+ * beyond the supported range. It might be useful to parse the strings like
+ * 10x50 or 12:21 without altering original string or temporary buffer in use.
+ * Keep in mind above caveat.
+ */
+
+extern unsigned long simple_strtoul(const char *,char **,unsigned int);
+extern long simple_strtol(const char *,char **,unsigned int);
+extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
+extern long long simple_strtoll(const char *,char **,unsigned int);
+
+static inline int strtobool(const char *s, bool *res)
+{
+	return kstrtobool(s, res);
+}
+
+#endif	/* _LINUX_KSTRTOX_H */
--- a/include/linux/string.h~kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header
+++ a/include/linux/string.h
@@ -2,7 +2,6 @@
 #ifndef _LINUX_STRING_H_
 #define _LINUX_STRING_H_
 
-
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
@@ -184,12 +183,6 @@ extern char **argv_split(gfp_t gfp, cons
 extern void argv_free(char **argv);
 
 extern bool sysfs_streq(const char *s1, const char *s2);
-extern int kstrtobool(const char *s, bool *res);
-static inline int strtobool(const char *s, bool *res)
-{
-	return kstrtobool(s, res);
-}
-
 int match_string(const char * const *array, size_t n, const char *string);
 int __sysfs_match_string(const char * const *array, size_t n, const char *s);
 
--- a/include/linux/sunrpc/cache.h~kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header
+++ a/include/linux/sunrpc/cache.h
@@ -14,6 +14,7 @@
 #include <linux/kref.h>
 #include <linux/slab.h>
 #include <linux/atomic.h>
+#include <linux/kstrtox.h>
 #include <linux/proc_fs.h>
 
 /*
--- a/lib/kstrtox.c~kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header
+++ a/lib/kstrtox.c
@@ -14,11 +14,12 @@
  */
 #include <linux/ctype.h>
 #include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/math64.h>
 #include <linux/export.h>
+#include <linux/kstrtox.h>
+#include <linux/math64.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
+
 #include "kstrtox.h"
 
 const char *_parse_integer_fixup_radix(const char *s, unsigned int *base)
--- a/lib/parser.c~kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header
+++ a/lib/parser.c
@@ -6,6 +6,7 @@
 #include <linux/ctype.h>
 #include <linux/types.h>
 #include <linux/export.h>
+#include <linux/kstrtox.h>
 #include <linux/parser.h>
 #include <linux/slab.h>
 #include <linux/string.h>
_
