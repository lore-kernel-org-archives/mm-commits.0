Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F77C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A206561151
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242709AbhJOThW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 15:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238544AbhJOThW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 15:37:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0E1161164;
        Fri, 15 Oct 2021 19:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634326507;
        bh=PjvkYxUp4GnXY1kQtsFWAcXguqc6dh6Gmy99pzrEEoo=;
        h=Date:From:To:Subject:From;
        b=wGYlJ7DYQw1rvk70lsxfnNK9+GAWor/pz8Uf0kKU9nzKXvgwfzKG7KCxs5xinhlun
         JwiEj0AEJD4IZ3uC8+OtqXfUv6vSoTl3elr+1kNNO9ejmTtOrItiNvauZL8P8XMz/g
         sWHGLtYLiEaoaYQR0H4cQii8z88Fecm2pTDHlJhQ=
Date:   Fri, 15 Oct 2021 12:35:07 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        ojeda@kernel.org
Subject:  + linux-container_ofh-switch-to-static_assert.patch added
 to -mm tree
Message-ID: <20211015193507.XCWTkd9OB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/container_of.h: switch to static_assert
has been added to the -mm tree.  Its filename is
     linux-container_ofh-switch-to-static_assert.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-container_ofh-switch-to-static_assert.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-container_ofh-switch-to-static_assert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: linux/container_of.h: switch to static_assert

_Static_assert() is evaluated already in the compiler's frontend, and
gives a somehat more to-the-point error, compared to the BUILD_BUG_ON
macro, which only fires after the optimizer has had a chance to eliminate
calls to functions marked with __attribute__((error)).  In theory, this
might make builds a tiny bit faster.

There's also a little less gunk in the error message emitted:

lib/sort.c: In function `foo':
./include/linux/build_bug.h:78:41: error: static assertion failed: "pointer type mismatch in container_of()"
   78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)

compared to

lib/sort.c: In function `foo':
././include/linux/compiler_types.h:322:38: error: call to `__compiletime_assert_2' declared with attribute error: pointer type mismatch in container_of()
  322 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)

While at it, fix the copy-pasto in container_of_safe().

Link: https://lkml.kernel.org/r/20211015090530.2774079-1-linux@rasmusvillemoes.dk
Link: https://lore.kernel.org/lkml/20211014132331.GA4811@kernel.org/T/
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/container_of.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/container_of.h~linux-container_ofh-switch-to-static_assert
+++ a/include/linux/container_of.h
@@ -16,9 +16,9 @@
  */
 #define container_of(ptr, type, member) ({				\
 	void *__mptr = (void *)(ptr);					\
-	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
-			 !__same_type(*(ptr), void),			\
-			 "pointer type mismatch in container_of()");	\
+	static_assert(__same_type(*(ptr), ((type *)0)->member) ||	\
+		      __same_type(*(ptr), void),			\
+		      "pointer type mismatch in container_of()");	\
 	((type *)(__mptr - offsetof(type, member))); })
 
 /**
@@ -31,9 +31,9 @@
  */
 #define container_of_safe(ptr, type, member) ({				\
 	void *__mptr = (void *)(ptr);					\
-	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
-			 !__same_type(*(ptr), void),			\
-			 "pointer type mismatch in container_of()");	\
+	static_assert(__same_type(*(ptr), ((type *)0)->member) ||	\
+		      __same_type(*(ptr), void),			\
+		      "pointer type mismatch in container_of_safe()");	\
 	IS_ERR_OR_NULL(__mptr) ? ERR_CAST(__mptr) :			\
 		((type *)(__mptr - offsetof(type, member))); })
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-container_ofh-switch-to-static_assert.patch

