Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8525C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 23:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68FEC23715
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 23:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbhAGXJe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbhAGXJe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Jan 2021 18:09:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6C88235FC;
        Thu,  7 Jan 2021 23:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610060932;
        bh=Qsnh5mlUSAbRxkAo+MtSrIyXcfIqlm7xBIiemvo+xlY=;
        h=Date:From:To:Subject:From;
        b=qp9YL/0wbVQst00LfzO3PJM0lukgxqgDcSm1NyU+czQfSeH9ZTP4l+k68MM/xKfdu
         R4oK7v61OTl4BFBgvWQuiURyKfQbdeeozA18mwQPIRMxbxXQ/KIDlJ55VuvSOijexf
         jclVu6LxN+SlvLczHBFnMrEBV37jxnba0C//8Mow=
Date:   Thu, 07 Jan 2021 15:08:51 -0800
From:   akpm@linux-foundation.org
To:     danielmicay@gmail.com, dja@axtens.net, keescook@chromium.org,
        laniel_francis@privacyrequired.com, mm-commits@vger.kernel.org
Subject:  +
 stringh-create-header-for-fortified-string-functions.patch added to -mm
 tree
Message-ID: <20210107230851.fGVFuJNLR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: string.h: create header for fortified string functions
has been added to the -mm tree.  Its filename is
     stringh-create-header-for-fortified-string-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/stringh-create-header-for-fortified-string-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/stringh-create-header-for-fortified-string-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Francis Laniel <laniel_francis@privacyrequired.com>
Subject: string.h: create header for fortified string functions

Add fortify-string.h to contain fortified functions definitions.  Thus,
the code is more separated and compile time is slightly faster for people
who do not set CONFIG_FORTIFY_SOURCE.

Link: https://lkml.kernel.org/r/20210107145143.7438-2-laniel_francis@privacyrequired.com
Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fortify-string.h |  302 +++++++++++++++++++++++++++++++
 include/linux/string.h         |  282 ----------------------------
 2 files changed, 303 insertions(+), 281 deletions(-)

--- /dev/null
+++ a/include/linux/fortify-string.h
@@ -0,0 +1,302 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_FORTIFY_STRING_H_
+#define _LINUX_FORTIFY_STRING_H_
+
+
+#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
+extern void *__underlying_memchr(const void *p, int c, __kernel_size_t size) __RENAME(memchr);
+extern int __underlying_memcmp(const void *p, const void *q, __kernel_size_t size) __RENAME(memcmp);
+extern void *__underlying_memcpy(void *p, const void *q, __kernel_size_t size) __RENAME(memcpy);
+extern void *__underlying_memmove(void *p, const void *q, __kernel_size_t size) __RENAME(memmove);
+extern void *__underlying_memset(void *p, int c, __kernel_size_t size) __RENAME(memset);
+extern char *__underlying_strcat(char *p, const char *q) __RENAME(strcat);
+extern char *__underlying_strcpy(char *p, const char *q) __RENAME(strcpy);
+extern __kernel_size_t __underlying_strlen(const char *p) __RENAME(strlen);
+extern char *__underlying_strncat(char *p, const char *q, __kernel_size_t count) __RENAME(strncat);
+extern char *__underlying_strncpy(char *p, const char *q, __kernel_size_t size) __RENAME(strncpy);
+#else
+#define __underlying_memchr	__builtin_memchr
+#define __underlying_memcmp	__builtin_memcmp
+#define __underlying_memcpy	__builtin_memcpy
+#define __underlying_memmove	__builtin_memmove
+#define __underlying_memset	__builtin_memset
+#define __underlying_strcat	__builtin_strcat
+#define __underlying_strcpy	__builtin_strcpy
+#define __underlying_strlen	__builtin_strlen
+#define __underlying_strncat	__builtin_strncat
+#define __underlying_strncpy	__builtin_strncpy
+#endif
+
+__FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 1);
+
+	if (__builtin_constant_p(size) && p_size < size)
+		__write_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __underlying_strncpy(p, q, size);
+}
+
+__FORTIFY_INLINE char *strcat(char *p, const char *q)
+{
+	size_t p_size = __builtin_object_size(p, 1);
+
+	if (p_size == (size_t)-1)
+		return __underlying_strcat(p, q);
+	if (strlcat(p, q, p_size) >= p_size)
+		fortify_panic(__func__);
+	return p;
+}
+
+__FORTIFY_INLINE __kernel_size_t strlen(const char *p)
+{
+	__kernel_size_t ret;
+	size_t p_size = __builtin_object_size(p, 1);
+
+	/* Work around gcc excess stack consumption issue */
+	if (p_size == (size_t)-1 ||
+		(__builtin_constant_p(p[p_size - 1]) && p[p_size - 1] == '\0'))
+		return __underlying_strlen(p);
+	ret = strnlen(p, p_size);
+	if (p_size <= ret)
+		fortify_panic(__func__);
+	return ret;
+}
+
+extern __kernel_size_t __real_strnlen(const char *, __kernel_size_t) __RENAME(strnlen);
+__FORTIFY_INLINE __kernel_size_t strnlen(const char *p, __kernel_size_t maxlen)
+{
+	size_t p_size = __builtin_object_size(p, 1);
+	__kernel_size_t ret = __real_strnlen(p, maxlen < p_size ? maxlen : p_size);
+
+	if (p_size <= ret && maxlen != ret)
+		fortify_panic(__func__);
+	return ret;
+}
+
+/* defined after fortified strlen to reuse it */
+extern size_t __real_strlcpy(char *, const char *, size_t) __RENAME(strlcpy);
+__FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
+{
+	size_t ret;
+	size_t p_size = __builtin_object_size(p, 1);
+	size_t q_size = __builtin_object_size(q, 1);
+
+	if (p_size == (size_t)-1 && q_size == (size_t)-1)
+		return __real_strlcpy(p, q, size);
+	ret = strlen(q);
+	if (size) {
+		size_t len = (ret >= size) ? size - 1 : ret;
+
+		if (__builtin_constant_p(len) && len >= p_size)
+			__write_overflow();
+		if (len >= p_size)
+			fortify_panic(__func__);
+			__underlying_memcpy(p, q, len);
+		p[len] = '\0';
+	}
+	return ret;
+}
+
+/* defined after fortified strnlen to reuse it */
+extern ssize_t __real_strscpy(char *, const char *, size_t) __RENAME(strscpy);
+__FORTIFY_INLINE ssize_t strscpy(char *p, const char *q, size_t size)
+{
+	size_t len;
+	/* Use string size rather than possible enclosing struct size. */
+	size_t p_size = __builtin_object_size(p, 1);
+	size_t q_size = __builtin_object_size(q, 1);
+
+	/* If we cannot get size of p and q default to call strscpy. */
+	if (p_size == (size_t) -1 && q_size == (size_t) -1)
+		return __real_strscpy(p, q, size);
+
+	/*
+	 * If size can be known at compile time and is greater than
+	 * p_size, generate a compile time write overflow error.
+	 */
+	if (__builtin_constant_p(size) && size > p_size)
+		__write_overflow();
+
+	/*
+	 * This call protects from read overflow, because len will default to q
+	 * length if it smaller than size.
+	 */
+	len = strnlen(q, size);
+	/*
+	 * If len equals size, we will copy only size bytes which leads to
+	 * -E2BIG being returned.
+	 * Otherwise we will copy len + 1 because of the final '\O'.
+	 */
+	len = len == size ? size : len + 1;
+
+	/*
+	 * Generate a runtime write overflow error if len is greater than
+	 * p_size.
+	 */
+	if (len > p_size)
+		fortify_panic(__func__);
+
+	/*
+	 * We can now safely call vanilla strscpy because we are protected from:
+	 * 1. Read overflow thanks to call to strnlen().
+	 * 2. Write overflow thanks to above ifs.
+	 */
+	return __real_strscpy(p, q, len);
+}
+
+/* defined after fortified strlen and strnlen to reuse them */
+__FORTIFY_INLINE char *strncat(char *p, const char *q, __kernel_size_t count)
+{
+	size_t p_len, copy_len;
+	size_t p_size = __builtin_object_size(p, 1);
+	size_t q_size = __builtin_object_size(q, 1);
+
+	if (p_size == (size_t)-1 && q_size == (size_t)-1)
+		return __underlying_strncat(p, q, count);
+	p_len = strlen(p);
+	copy_len = strnlen(q, count);
+	if (p_size < p_len + copy_len + 1)
+		fortify_panic(__func__);
+		__underlying_memcpy(p + p_len, q, copy_len);
+	p[p_len + copy_len] = '\0';
+	return p;
+}
+
+__FORTIFY_INLINE void *memset(void *p, int c, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+
+	if (__builtin_constant_p(size) && p_size < size)
+		__write_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __underlying_memset(p, c, size);
+}
+
+__FORTIFY_INLINE void *memcpy(void *p, const void *q, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	size_t q_size = __builtin_object_size(q, 0);
+
+	if (__builtin_constant_p(size)) {
+		if (p_size < size)
+			__write_overflow();
+		if (q_size < size)
+			__read_overflow2();
+	}
+	if (p_size < size || q_size < size)
+		fortify_panic(__func__);
+	return __underlying_memcpy(p, q, size);
+}
+
+__FORTIFY_INLINE void *memmove(void *p, const void *q, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	size_t q_size = __builtin_object_size(q, 0);
+
+	if (__builtin_constant_p(size)) {
+		if (p_size < size)
+			__write_overflow();
+		if (q_size < size)
+			__read_overflow2();
+	}
+	if (p_size < size || q_size < size)
+		fortify_panic(__func__);
+	return __underlying_memmove(p, q, size);
+}
+
+extern void *__real_memscan(void *, int, __kernel_size_t) __RENAME(memscan);
+__FORTIFY_INLINE void *memscan(void *p, int c, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+
+	if (__builtin_constant_p(size) && p_size < size)
+		__read_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __real_memscan(p, c, size);
+}
+
+__FORTIFY_INLINE int memcmp(const void *p, const void *q, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+	size_t q_size = __builtin_object_size(q, 0);
+
+	if (__builtin_constant_p(size)) {
+		if (p_size < size)
+			__read_overflow();
+		if (q_size < size)
+			__read_overflow2();
+	}
+	if (p_size < size || q_size < size)
+		fortify_panic(__func__);
+	return __underlying_memcmp(p, q, size);
+}
+
+__FORTIFY_INLINE void *memchr(const void *p, int c, __kernel_size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+
+	if (__builtin_constant_p(size) && p_size < size)
+		__read_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __underlying_memchr(p, c, size);
+}
+
+void *__real_memchr_inv(const void *s, int c, size_t n) __RENAME(memchr_inv);
+__FORTIFY_INLINE void *memchr_inv(const void *p, int c, size_t size)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+
+	if (__builtin_constant_p(size) && p_size < size)
+		__read_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __real_memchr_inv(p, c, size);
+}
+
+extern void *__real_kmemdup(const void *src, size_t len, gfp_t gfp) __RENAME(kmemdup);
+__FORTIFY_INLINE void *kmemdup(const void *p, size_t size, gfp_t gfp)
+{
+	size_t p_size = __builtin_object_size(p, 0);
+
+	if (__builtin_constant_p(size) && p_size < size)
+		__read_overflow();
+	if (p_size < size)
+		fortify_panic(__func__);
+	return __real_kmemdup(p, size, gfp);
+}
+
+/* defined after fortified strlen and memcpy to reuse them */
+__FORTIFY_INLINE char *strcpy(char *p, const char *q)
+{
+	size_t p_size = __builtin_object_size(p, 1);
+	size_t q_size = __builtin_object_size(q, 1);
+	size_t size;
+
+	if (p_size == (size_t)-1 && q_size == (size_t)-1)
+		return __underlying_strcpy(p, q);
+	size = strlen(q) + 1;
+	/* test here to use the more stringent object size */
+	if (p_size < size)
+		fortify_panic(__func__);
+	memcpy(p, q, size);
+	return p;
+}
+
+/* Don't use these outside the FORITFY_SOURCE implementation */
+#undef __underlying_memchr
+#undef __underlying_memcmp
+#undef __underlying_memcpy
+#undef __underlying_memmove
+#undef __underlying_memset
+#undef __underlying_strcat
+#undef __underlying_strcpy
+#undef __underlying_strlen
+#undef __underlying_strncat
+#undef __underlying_strncpy
+
+#endif /* _LINUX_FORTIFY_STRING_H_ */
--- a/include/linux/string.h~stringh-create-header-for-fortified-string-functions
+++ a/include/linux/string.h
@@ -266,287 +266,7 @@ void __read_overflow3(void) __compiletim
 void __write_overflow(void) __compiletime_error("detected write beyond size of object passed as 1st parameter");
 
 #if !defined(__NO_FORTIFY) && defined(__OPTIMIZE__) && defined(CONFIG_FORTIFY_SOURCE)
-
-#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
-extern void *__underlying_memchr(const void *p, int c, __kernel_size_t size) __RENAME(memchr);
-extern int __underlying_memcmp(const void *p, const void *q, __kernel_size_t size) __RENAME(memcmp);
-extern void *__underlying_memcpy(void *p, const void *q, __kernel_size_t size) __RENAME(memcpy);
-extern void *__underlying_memmove(void *p, const void *q, __kernel_size_t size) __RENAME(memmove);
-extern void *__underlying_memset(void *p, int c, __kernel_size_t size) __RENAME(memset);
-extern char *__underlying_strcat(char *p, const char *q) __RENAME(strcat);
-extern char *__underlying_strcpy(char *p, const char *q) __RENAME(strcpy);
-extern __kernel_size_t __underlying_strlen(const char *p) __RENAME(strlen);
-extern char *__underlying_strncat(char *p, const char *q, __kernel_size_t count) __RENAME(strncat);
-extern char *__underlying_strncpy(char *p, const char *q, __kernel_size_t size) __RENAME(strncpy);
-#else
-#define __underlying_memchr	__builtin_memchr
-#define __underlying_memcmp	__builtin_memcmp
-#define __underlying_memcpy	__builtin_memcpy
-#define __underlying_memmove	__builtin_memmove
-#define __underlying_memset	__builtin_memset
-#define __underlying_strcat	__builtin_strcat
-#define __underlying_strcpy	__builtin_strcpy
-#define __underlying_strlen	__builtin_strlen
-#define __underlying_strncat	__builtin_strncat
-#define __underlying_strncpy	__builtin_strncpy
-#endif
-
-__FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
-{
-	size_t p_size = __builtin_object_size(p, 1);
-	if (__builtin_constant_p(size) && p_size < size)
-		__write_overflow();
-	if (p_size < size)
-		fortify_panic(__func__);
-	return __underlying_strncpy(p, q, size);
-}
-
-__FORTIFY_INLINE char *strcat(char *p, const char *q)
-{
-	size_t p_size = __builtin_object_size(p, 1);
-	if (p_size == (size_t)-1)
-		return __underlying_strcat(p, q);
-	if (strlcat(p, q, p_size) >= p_size)
-		fortify_panic(__func__);
-	return p;
-}
-
-__FORTIFY_INLINE __kernel_size_t strlen(const char *p)
-{
-	__kernel_size_t ret;
-	size_t p_size = __builtin_object_size(p, 1);
-
-	/* Work around gcc excess stack consumption issue */
-	if (p_size == (size_t)-1 ||
-	    (__builtin_constant_p(p[p_size - 1]) && p[p_size - 1] == '\0'))
-		return __underlying_strlen(p);
-	ret = strnlen(p, p_size);
-	if (p_size <= ret)
-		fortify_panic(__func__);
-	return ret;
-}
-
-extern __kernel_size_t __real_strnlen(const char *, __kernel_size_t) __RENAME(strnlen);
-__FORTIFY_INLINE __kernel_size_t strnlen(const char *p, __kernel_size_t maxlen)
-{
-	size_t p_size = __builtin_object_size(p, 1);
-	__kernel_size_t ret = __real_strnlen(p, maxlen < p_size ? maxlen : p_size);
-	if (p_size <= ret && maxlen != ret)
-		fortify_panic(__func__);
-	return ret;
-}
-
-/* defined after fortified strlen to reuse it */
-extern size_t __real_strlcpy(char *, const char *, size_t) __RENAME(strlcpy);
-__FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
-{
-	size_t ret;
-	size_t p_size = __builtin_object_size(p, 1);
-	size_t q_size = __builtin_object_size(q, 1);
-	if (p_size == (size_t)-1 && q_size == (size_t)-1)
-		return __real_strlcpy(p, q, size);
-	ret = strlen(q);
-	if (size) {
-		size_t len = (ret >= size) ? size - 1 : ret;
-		if (__builtin_constant_p(len) && len >= p_size)
-			__write_overflow();
-		if (len >= p_size)
-			fortify_panic(__func__);
-		__underlying_memcpy(p, q, len);
-		p[len] = '\0';
-	}
-	return ret;
-}
-
-/* defined after fortified strnlen to reuse it */
-extern ssize_t __real_strscpy(char *, const char *, size_t) __RENAME(strscpy);
-__FORTIFY_INLINE ssize_t strscpy(char *p, const char *q, size_t size)
-{
-	size_t len;
-	/* Use string size rather than possible enclosing struct size. */
-	size_t p_size = __builtin_object_size(p, 1);
-	size_t q_size = __builtin_object_size(q, 1);
-
-	/* If we cannot get size of p and q default to call strscpy. */
-	if (p_size == (size_t) -1 && q_size == (size_t) -1)
-		return __real_strscpy(p, q, size);
-
-	/*
-	 * If size can be known at compile time and is greater than
-	 * p_size, generate a compile time write overflow error.
-	 */
-	if (__builtin_constant_p(size) && size > p_size)
-		__write_overflow();
-
-	/*
-	 * This call protects from read overflow, because len will default to q
-	 * length if it smaller than size.
-	 */
-	len = strnlen(q, size);
-	/*
-	 * If len equals size, we will copy only size bytes which leads to
-	 * -E2BIG being returned.
-	 * Otherwise we will copy len + 1 because of the final '\O'.
-	 */
-	len = len == size ? size : len + 1;
-
-	/*
-	 * Generate a runtime write overflow error if len is greater than
-	 * p_size.
-	 */
-	if (len > p_size)
-		fortify_panic(__func__);
-
-	/*
-	 * We can now safely call vanilla strscpy because we are protected from:
-	 * 1. Read overflow thanks to call to strnlen().
-	 * 2. Write overflow thanks to above ifs.
-	 */
-	return __real_strscpy(p, q, len);
-}
-
-/* defined after fortified strlen and strnlen to reuse them */
-__FORTIFY_INLINE char *strncat(char *p, const char *q, __kernel_size_t count)
-{
-	size_t p_len, copy_len;
-	size_t p_size = __builtin_object_size(p, 1);
-	size_t q_size = __builtin_object_size(q, 1);
-	if (p_size == (size_t)-1 && q_size == (size_t)-1)
-		return __underlying_strncat(p, q, count);
-	p_len = strlen(p);
-	copy_len = strnlen(q, count);
-	if (p_size < p_len + copy_len + 1)
-		fortify_panic(__func__);
-	__underlying_memcpy(p + p_len, q, copy_len);
-	p[p_len + copy_len] = '\0';
-	return p;
-}
-
-__FORTIFY_INLINE void *memset(void *p, int c, __kernel_size_t size)
-{
-	size_t p_size = __builtin_object_size(p, 0);
-	if (__builtin_constant_p(size) && p_size < size)
-		__write_overflow();
-	if (p_size < size)
-		fortify_panic(__func__);
-	return __underlying_memset(p, c, size);
-}
-
-__FORTIFY_INLINE void *memcpy(void *p, const void *q, __kernel_size_t size)
-{
-	size_t p_size = __builtin_object_size(p, 0);
-	size_t q_size = __builtin_object_size(q, 0);
-	if (__builtin_constant_p(size)) {
-		if (p_size < size)
-			__write_overflow();
-		if (q_size < size)
-			__read_overflow2();
-	}
-	if (p_size < size || q_size < size)
-		fortify_panic(__func__);
-	return __underlying_memcpy(p, q, size);
-}
-
-__FORTIFY_INLINE void *memmove(void *p, const void *q, __kernel_size_t size)
-{
-	size_t p_size = __builtin_object_size(p, 0);
-	size_t q_size = __builtin_object_size(q, 0);
-	if (__builtin_constant_p(size)) {
-		if (p_size < size)
-			__write_overflow();
-		if (q_size < size)
-			__read_overflow2();
-	}
-	if (p_size < size || q_size < size)
-		fortify_panic(__func__);
-	return __underlying_memmove(p, q, size);
-}
-
-extern void *__real_memscan(void *, int, __kernel_size_t) __RENAME(memscan);
-__FORTIFY_INLINE void *memscan(void *p, int c, __kernel_size_t size)
-{
-	size_t p_size = __builtin_object_size(p, 0);
-	if (__builtin_constant_p(size) && p_size < size)
-		__read_overflow();
-	if (p_size < size)
-		fortify_panic(__func__);
-	return __real_memscan(p, c, size);
-}
-
-__FORTIFY_INLINE int memcmp(const void *p, const void *q, __kernel_size_t size)
-{
-	size_t p_size = __builtin_object_size(p, 0);
-	size_t q_size = __builtin_object_size(q, 0);
-	if (__builtin_constant_p(size)) {
-		if (p_size < size)
-			__read_overflow();
-		if (q_size < size)
-			__read_overflow2();
-	}
-	if (p_size < size || q_size < size)
-		fortify_panic(__func__);
-	return __underlying_memcmp(p, q, size);
-}
-
-__FORTIFY_INLINE void *memchr(const void *p, int c, __kernel_size_t size)
-{
-	size_t p_size = __builtin_object_size(p, 0);
-	if (__builtin_constant_p(size) && p_size < size)
-		__read_overflow();
-	if (p_size < size)
-		fortify_panic(__func__);
-	return __underlying_memchr(p, c, size);
-}
-
-void *__real_memchr_inv(const void *s, int c, size_t n) __RENAME(memchr_inv);
-__FORTIFY_INLINE void *memchr_inv(const void *p, int c, size_t size)
-{
-	size_t p_size = __builtin_object_size(p, 0);
-	if (__builtin_constant_p(size) && p_size < size)
-		__read_overflow();
-	if (p_size < size)
-		fortify_panic(__func__);
-	return __real_memchr_inv(p, c, size);
-}
-
-extern void *__real_kmemdup(const void *src, size_t len, gfp_t gfp) __RENAME(kmemdup);
-__FORTIFY_INLINE void *kmemdup(const void *p, size_t size, gfp_t gfp)
-{
-	size_t p_size = __builtin_object_size(p, 0);
-	if (__builtin_constant_p(size) && p_size < size)
-		__read_overflow();
-	if (p_size < size)
-		fortify_panic(__func__);
-	return __real_kmemdup(p, size, gfp);
-}
-
-/* defined after fortified strlen and memcpy to reuse them */
-__FORTIFY_INLINE char *strcpy(char *p, const char *q)
-{
-	size_t p_size = __builtin_object_size(p, 1);
-	size_t q_size = __builtin_object_size(q, 1);
-	size_t size;
-	if (p_size == (size_t)-1 && q_size == (size_t)-1)
-		return __underlying_strcpy(p, q);
-	size = strlen(q) + 1;
-	/* test here to use the more stringent object size */
-	if (p_size < size)
-		fortify_panic(__func__);
-	memcpy(p, q, size);
-	return p;
-}
-
-/* Don't use these outside the FORITFY_SOURCE implementation */
-#undef __underlying_memchr
-#undef __underlying_memcmp
-#undef __underlying_memcpy
-#undef __underlying_memmove
-#undef __underlying_memset
-#undef __underlying_strcat
-#undef __underlying_strcpy
-#undef __underlying_strlen
-#undef __underlying_strncat
-#undef __underlying_strncpy
+#include <linux/fortify-string.h>
 #endif
 
 /**
_

Patches currently in -mm which might be from laniel_francis@privacyrequired.com are

stringh-create-header-for-fortified-string-functions.patch

