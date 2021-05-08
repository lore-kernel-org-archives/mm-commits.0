Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E1EC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D01261415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEHWkU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhEHWkT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 709166140E;
        Sat,  8 May 2021 22:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513557;
        bh=wDwL/wwxTj2nP+ETsgPhLI1r/bKJvZ+wu9Sysu5EM1o=;
        h=Date:From:To:Subject:From;
        b=nZSVrddu/JMPRvTEXu6ieAd8aL7hBRPBOCsOzwKHb8kMcZ3g1kPqfkPC4fo0R9o+U
         tXYB0DXKeuYbr8FYlEi1Ti90Syuov5ZLemNl0eKMrY+3WJ8QSb4UDgA1dZ52qnCXAi
         ivNO1W3xcpjo8ULh6iEdPanUwn27++wXaaw2lcq0=
Date:   Sat, 08 May 2021 15:39:17 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, luc.vanoostenryck@gmail.com,
        mm-commits@vger.kernel.org, ojeda@kernel.org
Subject:  [merged]
 sparse-can-do-constant-folding-of-__builtin_bswap.patch removed from -mm
 tree
Message-ID: <20210508223917.20nsK5MrE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compiler-gcc.h: sparse can do constant folding of __builtin_bswap*()
has been removed from the -mm tree.  Its filename was
     sparse-can-do-constant-folding-of-__builtin_bswap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: include/linux/compiler-gcc.h: sparse can do constant folding of __builtin_bswap*()

Sparse can do constant folding of __builtin_bswap*() since 2017.  Also, a
much recent version of Sparse is needed anyway, see commit 6ec4476ac825
("Raise gcc version requirement to 4.9").

So, remove the comment about sparse not being yet able to constant fold
__builtin_bswap*() and remove the corresponding test of __CHECKER__.

Link: https://lkml.kernel.org/r/20210226092236.99369-1-luc.vanoostenryck@gmail.com
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/include/linux/compiler-gcc.h~sparse-can-do-constant-folding-of-__builtin_bswap
+++ a/include/linux/compiler-gcc.h
@@ -90,15 +90,11 @@
  */
 #define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
 
-/*
- * sparse (__CHECKER__) pretends to be gcc, but can't do constant
- * folding in __builtin_bswap*() (yet), so don't set these for it.
- */
-#if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP) && !defined(__CHECKER__)
+#if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP)
 #define __HAVE_BUILTIN_BSWAP32__
 #define __HAVE_BUILTIN_BSWAP64__
 #define __HAVE_BUILTIN_BSWAP16__
-#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP && !__CHECKER__ */
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
 
 #if GCC_VERSION >= 70000
 #define KASAN_ABI_VERSION 5
_

Patches currently in -mm which might be from luc.vanoostenryck@gmail.com are


