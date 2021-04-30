Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6CAC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A9FB61458
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhD3Fyj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhD3Fyj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 422D861424;
        Fri, 30 Apr 2021 05:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762031;
        bh=eCX4eLein6ZKwumBcX9wQrbg9jdge0pTwDPxjMvvgnA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UTyNdoVIIl9QHs8yD8Jwl4mFRq1HJLCIhuuW2yu1fhIYooG7xenLEUTGu4Ay5nvyh
         mOqHsdoFvjMSQ85rYTRC+Zv5W2ZZXP3NemVpGi1DJ24rEnS3fj6dDqio5V+QrN22s/
         uDf961WzowqACdsB+v68gACYjUh6lIcodJGjfUPk=
Date:   Thu, 29 Apr 2021 22:53:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, linux-mm@kvack.org,
        luc.vanoostenryck@gmail.com, mm-commits@vger.kernel.org,
        ojeda@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 012/178] include/linux/compiler-gcc.h: sparse can
 do constant folding of __builtin_bswap*()
Message-ID: <20210430055350.RQ7VgyFZj%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
