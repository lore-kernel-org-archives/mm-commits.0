Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679FBC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E0A461242
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbhKICfd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35E2F61208;
        Tue,  9 Nov 2021 02:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425167;
        bh=xK3j/0Cxm/bDpBGGPzNPLFzabu+Hb5VnyLZWXBr7z2w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Q7Usljbdna7mM0bTvAStW9glXqd7zstdqZf/aqSiXZtmr6kPlSv4Npr7aBe6cl6Ld
         PhjiN112sURSfJ5TxfC7AI8vkHUOdLbT9AfosamNDXEK5Ohs9JkVOGLR++CGhuRO4e
         GjUWr/8+ugdS6ItN1g2ECx8PVEsaGYXRxWKlPLOs=
Date:   Mon, 08 Nov 2021 18:32:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        ojeda@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 26/87] linux/container_of.h: switch to
 static_assert
Message-ID: <20211109023246.wjhHbi8dH%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
