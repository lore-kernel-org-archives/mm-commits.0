Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5EBC15507
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB5D064EC0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhCDA7P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1451449AbhCDAhF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:37:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB69B64E28;
        Wed,  3 Mar 2021 23:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614813482;
        bh=5o4hC6x5kAQlohycvXomLELW7DKQtq5FxwIRbSC29VE=;
        h=Date:From:To:Subject:From;
        b=Y75pRo2oJ5CxKpxkd6/qomFK7ao8KqHy3IA15DnjpglljCoriCmHaRPavJL182AlH
         091pVadjOLcanaWp0JLfnCYV8sMu8IQa8Q0FFA+/ok+QsjU9KPk1ui6z82ZO/ddMXM
         f7m+YBfNU2YMjAVCX8tSUgillP3ERvaLDWYOtV1g=
Date:   Wed, 03 Mar 2021 15:18:02 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, luc.vanoostenryck@gmail.com,
        mm-commits@vger.kernel.org, ojeda@kernel.org
Subject:  + sparse-can-do-constant-folding-of-__builtin_bswap.patch
 added to -mm tree
Message-ID: <20210303231802.-9GdDypMY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compiler-gcc.h: sparse can do constant folding of __builtin_bswap*()
has been added to the -mm tree.  Its filename is
     sparse-can-do-constant-folding-of-__builtin_bswap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sparse-can-do-constant-folding-of-__builtin_bswap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sparse-can-do-constant-folding-of-__builtin_bswap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sparse-can-do-constant-folding-of-__builtin_bswap.patch

