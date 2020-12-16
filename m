Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF8AC2BB48
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 02:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8AC230FF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 02:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgLPCLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 21:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgLPCLE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 21:11:04 -0500
Date:   Tue, 15 Dec 2020 18:10:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608084624;
        bh=jYghAA6AE5iwHWRXBciLvzWeEYpzfQeGcXUh5YOD5SA=;
        h=From:To:Subject:From;
        b=Z5hJVC9u/NLOKTQfRtU3RUZGpAB8tFAqFyGP6A7FWjAwvYnbEGmQPOZ7wsksaQiOz
         jcyYwoGLV6wVI4fiL/kVSRf6+IWd23ZBHCbxcQUDWCorBTYLWlSS1kIl3MAybBKl3a
         TjJ3gIets8FFrgMuvaT2KQ//9TCa4zQCP6K66B8s=
From:   akpm@linux-foundation.org
To:     aryabinin@virtuozzo.com, linus.walleij@linaro.org,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        natechancellor@gmail.com, sfr@canb.auug.org.au,
        valdis.kletnieks@vt.edu
Subject:  [folded-merged]
 treewide-remove-stringification-from-__alias-macro-definition-fix.patch
 removed from -mm tree
Message-ID: <20201216021023.YSnAlZrPf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: boot: quote aliased symbol names in string.c
has been removed from the -mm tree.  Its filename was
     treewide-remove-stringification-from-__alias-macro-definition-fix.patch

This patch was dropped because it was folded into treewide-remove-stringifi=
cation-from-__alias-macro-definition.patch

------------------------------------------------------
=46rom: Nathan Chancellor <natechancellor@gmail.com>
Subject: ARM: boot: quote aliased symbol names in string.c

Patch "treewide: Remove stringification from __alias macro definition"
causes arguments to __alias to no longer be quoted automatically, which
breaks CONFIG_KASAN on ARM after commit d6d51a96c7d6 ("ARM: 9014/2:
Replace string mem* functions for KASan"):

arch/arm/boot/compressed/string.c:24:1: error: attribute 'alias' argument n=
ot a string
   24 | void *__memcpy(void *__dest, __const void *__src, size_t __n) __ali=
as(memcpy);
      | ^~~~
arch/arm/boot/compressed/string.c:25:1: error: attribute 'alias' argument n=
ot a string
   25 | void *__memmove(void *__dest, __const void *__src, size_t count) __=
alias(memmove);
      | ^~~~
arch/arm/boot/compressed/string.c:26:1: error: attribute 'alias' argument n=
ot a string
   26 | void *__memset(void *s, int c, size_t count) __alias(memset);
      | ^~~~
make[3]: *** [scripts/Makefile.build:283: arch/arm/boot/compressed/string.o=
] Error 1

Quote the names like the treewide patch does so there is no more error.

Link: https://lkml.kernel.org/r/20201109001712.3384097-1-natechancellor@gma=
il.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Valdis Kl=C4=93tnieks <valdis.kletnieks@vt.edu>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/compressed/string.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/boot/compressed/string.c~treewide-remove-stringification-fro=
m-__alias-macro-definition-fix
+++ a/arch/arm/boot/compressed/string.c
@@ -21,9 +21,9 @@
 #undef memcpy
 #undef memmove
 #undef memset
-void *__memcpy(void *__dest, __const void *__src, size_t __n) __alias(memc=
py);
-void *__memmove(void *__dest, __const void *__src, size_t count) __alias(m=
emmove);
-void *__memset(void *s, int c, size_t count) __alias(memset);
+void *__memcpy(void *__dest, __const void *__src, size_t __n) __alias("mem=
cpy");
+void *__memmove(void *__dest, __const void *__src, size_t count) __alias("=
memmove");
+void *__memset(void *s, int c, size_t count) __alias("memset");
 #endif
=20
 void *memcpy(void *__dest, __const void *__src, size_t __n)
_

Patches currently in -mm which might be from natechancellor@gmail.com are

reboot-fix-variable-assignments-in-type_store.patch

