Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67924C56202
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 01:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23BA42075A
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 01:19:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2QDwhl9G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgKXBTT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:19:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727520AbgKXBTT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 20:19:19 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44F0F20728;
        Tue, 24 Nov 2020 01:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606180757;
        bh=9RBxdoQbxPIZpR84dLVjgleWgDQPwjpV3eZvq2J8f1E=;
        h=Date:From:To:Subject:From;
        b=2QDwhl9GXB88oE4XGLJrBL28M3rd4M+YxgH6u/YJMuFkbS9khiJRPlyzpwrFOzApq
         bH7IvFVJIs7y9B50W2opWtaBYOwuWclXYmLKfTRsNywLrZ7TY1yPmunDV3R4MXZemM
         894Xz/n1DrYsCX+lDLx7djCq8Z+2aptUXGY0BS14=
Date:   Mon, 23 Nov 2020 17:19:15 -0800
From:   akpm@linux-foundation.org
To:     danielmicay@gmail.com, dja@axtens.net, keescook@chromium.org,
        laniel_francis@privacyrequired.com, mm-commits@vger.kernel.org
Subject:  +
 stringh-detect-intra-object-overflow-in-fortified-string-functions.patch
 added to -mm tree
Message-ID: <20201124011915.-c4pdeXdY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: string.h: detect intra-object overflow in fortified string functions
has been added to the -mm tree.  Its filename is
     stringh-detect-intra-object-overflow-in-fortified-string-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/stringh-detect-intra-object-overflow-in-fortified-string-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/stringh-detect-intra-object-overflow-in-fortified-string-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: lib: string.h: detect intra-object overflow in fortified string functions

Patch series "Fortify strscpy()", v7.


This patch implements a fortified version of strscpy() enabled by setting
CONFIG_FORTIFY_SOURCE=y.  The new version ensures the following before
calling vanilla strscpy():

1. There is no read overflow because either size is smaller than src
   length or we shrink size to src length by calling fortified strnlen().

2. There is no write overflow because we either failed during
   compilation or at runtime by checking that size is smaller than dest
   size.  Note that, if src and dst size cannot be got, the patch defaults
   to call vanilla strscpy().

The patches adds the following:

1. Implement the fortified version of strscpy().

2. Add a new LKDTM test to ensures the fortified version still returns
   the same value as the vanilla one while panic'ing when there is a write
   overflow.

3. Correct some typos in LKDTM related file.

I based my modifications on top of two patches from Daniel Axtens which
modify calls to __builtin_object_size, in fortified string functions, to
ensure the true size of char * are returned and not the surrounding
structure size.

About performance, I measured the slow down of fortified strscpy(), using
the vanilla one as baseline.  The hardware I used is an Intel i3 2130 CPU
clocked at 3.4 GHz.  I ran "Linux 5.10.0-rc4+ SMP PREEMPT" inside qemu
3.10 with 4 CPU cores.  The following code, called through LKDTM, was used
as a benchmark:

#define TIMES 10000
	char *src;
	char dst[7];
	int i;
	ktime_t begin;

	src = kstrdup("foobar", GFP_KERNEL);

	if (src == NULL)
		return;

	begin = ktime_get();
	for (i = 0; i < TIMES; i++)
		strscpy(dst, src, strlen(src));
	pr_info("%d fortified strscpy() tooks %lld", TIMES, ktime_get() - begin);

	begin = ktime_get();
	for (i = 0; i < TIMES; i++)
		__real_strscpy(dst, src, strlen(src));
	pr_info("%d vanilla strscpy() tooks %lld", TIMES, ktime_get() - begin);

	kfree(src);

I called the above code 30 times to compute stats for each version (in ns,
round to int):

| version   | mean    | std    | median  | 95th    |
| --------- | ------- | ------ | ------- | ------- |
| fortified | 245_069 | 54_657 | 216_230 | 331_122 |
| vanilla   | 172_501 | 70_281 | 143_539 | 219_553 |

On average, fortified strscpy() is approximately 1.42 times slower than
vanilla strscpy().  For the 95th percentile, the fortified version is
about 1.50 times slower.

So, clearly the stats are not in favor of fortified strscpy().  But, the
fortified version loops the string twice (one in strnlen() and another in
vanilla strscpy()) while the vanilla one only loops once.  This can
explain why fortified strscpy() is slower than the vanilla one.


This patch (of 5):

When the fortify feature was first introduced in commit 6974f0c4555e
("include/linux/string.h: add the option of fortified string.h
functions"), Daniel Micay observed:

  * It should be possible to optionally use __builtin_object_size(x, 1) for
    some functions (C strings) to detect intra-object overflows (like
    glibc's _FORTIFY_SOURCE=2), but for now this takes the conservative
    approach to avoid likely compatibility issues.

This is a case that often cannot be caught by KASAN. Consider:

struct foo {
    char a[10];
    char b[10];
}

void test() {
    char *msg;
    struct foo foo;

    msg = kmalloc(16, GFP_KERNEL);
    strcpy(msg, "Hello world!!");
    // this copy overwrites foo.b
    strcpy(foo.a, msg);
}

The questionable copy overflows foo.a and writes to foo.b as well.  It
cannot be detected by KASAN.  Currently it is also not detected by
fortify, because strcpy considers __builtin_object_size(x, 0), which
considers the size of the surrounding object (here, struct foo).  However,
if we switch the string functions over to use __builtin_object_size(x, 1),
the compiler will measure the size of the closest surrounding subobject
(here, foo.a), rather than the size of the surrounding object as a whole. 
See https://gcc.gnu.org/onlinedocs/gcc/Object-Size-Checking.html for more
info.

Only do this for string functions: we cannot use it on things like memcpy,
memmove, memcmp and memchr_inv due to code like this which purposefully
operates on multiple structure members: (arch/x86/kernel/traps.c)

	/*
	 * regs->sp points to the failing IRET frame on the
	 * ESPFIX64 stack.  Copy it to the entry stack.  This fills
	 * in gpregs->ss through gpregs->ip.
	 *
	 */
	memmove(&gpregs->ip, (void *)regs->sp, 5*8);

This change passes an allyesconfig on powerpc and x86, and an x86 kernel
built with it survives running with syz-stress from syzkaller, so it seems
safe so far.

Link: https://lkml.kernel.org/r/20201122162451.27551-1-laniel_francis@privacyrequired.com
Link: https://lkml.kernel.org/r/20201122162451.27551-2-laniel_francis@privacyrequired.com
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/include/linux/string.h~stringh-detect-intra-object-overflow-in-fortified-string-functions
+++ a/include/linux/string.h
@@ -292,7 +292,7 @@ extern char *__underlying_strncpy(char *
 
 __FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
 {
-	size_t p_size = __builtin_object_size(p, 0);
+	size_t p_size = __builtin_object_size(p, 1);
 	if (__builtin_constant_p(size) && p_size < size)
 		__write_overflow();
 	if (p_size < size)
@@ -302,7 +302,7 @@ __FORTIFY_INLINE char *strncpy(char *p,
 
 __FORTIFY_INLINE char *strcat(char *p, const char *q)
 {
-	size_t p_size = __builtin_object_size(p, 0);
+	size_t p_size = __builtin_object_size(p, 1);
 	if (p_size == (size_t)-1)
 		return __underlying_strcat(p, q);
 	if (strlcat(p, q, p_size) >= p_size)
@@ -313,7 +313,7 @@ __FORTIFY_INLINE char *strcat(char *p, c
 __FORTIFY_INLINE __kernel_size_t strlen(const char *p)
 {
 	__kernel_size_t ret;
-	size_t p_size = __builtin_object_size(p, 0);
+	size_t p_size = __builtin_object_size(p, 1);
 
 	/* Work around gcc excess stack consumption issue */
 	if (p_size == (size_t)-1 ||
@@ -328,7 +328,7 @@ __FORTIFY_INLINE __kernel_size_t strlen(
 extern __kernel_size_t __real_strnlen(const char *, __kernel_size_t) __RENAME(strnlen);
 __FORTIFY_INLINE __kernel_size_t strnlen(const char *p, __kernel_size_t maxlen)
 {
-	size_t p_size = __builtin_object_size(p, 0);
+	size_t p_size = __builtin_object_size(p, 1);
 	__kernel_size_t ret = __real_strnlen(p, maxlen < p_size ? maxlen : p_size);
 	if (p_size <= ret && maxlen != ret)
 		fortify_panic(__func__);
@@ -340,8 +340,8 @@ extern size_t __real_strlcpy(char *, con
 __FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
 {
 	size_t ret;
-	size_t p_size = __builtin_object_size(p, 0);
-	size_t q_size = __builtin_object_size(q, 0);
+	size_t p_size = __builtin_object_size(p, 1);
+	size_t q_size = __builtin_object_size(q, 1);
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
 		return __real_strlcpy(p, q, size);
 	ret = strlen(q);
@@ -361,8 +361,8 @@ __FORTIFY_INLINE size_t strlcpy(char *p,
 __FORTIFY_INLINE char *strncat(char *p, const char *q, __kernel_size_t count)
 {
 	size_t p_len, copy_len;
-	size_t p_size = __builtin_object_size(p, 0);
-	size_t q_size = __builtin_object_size(q, 0);
+	size_t p_size = __builtin_object_size(p, 1);
+	size_t q_size = __builtin_object_size(q, 1);
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
 		return __underlying_strncat(p, q, count);
 	p_len = strlen(p);
@@ -475,11 +475,16 @@ __FORTIFY_INLINE void *kmemdup(const voi
 /* defined after fortified strlen and memcpy to reuse them */
 __FORTIFY_INLINE char *strcpy(char *p, const char *q)
 {
-	size_t p_size = __builtin_object_size(p, 0);
-	size_t q_size = __builtin_object_size(q, 0);
+	size_t p_size = __builtin_object_size(p, 1);
+	size_t q_size = __builtin_object_size(q, 1);
+	size_t size;
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
 		return __underlying_strcpy(p, q);
-	memcpy(p, q, strlen(q) + 1);
+	size = strlen(q) + 1;
+	/* test here to use the more stringent object size */
+	if (p_size < size)
+		fortify_panic(__func__);
+	memcpy(p, q, size);
 	return p;
 }
 
_

Patches currently in -mm which might be from dja@axtens.net are

stringh-detect-intra-object-overflow-in-fortified-string-functions.patch
lkdtm-tests-for-fortify_source.patch

