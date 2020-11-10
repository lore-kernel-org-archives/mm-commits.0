Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 729D1C388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D2F207D3
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pSVCzBxG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgKJVYl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 16:24:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgKJVYh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 16:24:37 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D56BF206F1;
        Tue, 10 Nov 2020 21:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605043477;
        bh=sXIWpsP+39rCkv/KktTYlzz1LzaYBE/uzX0KoRc5gU8=;
        h=Date:From:To:Subject:From;
        b=pSVCzBxGdGaPuE2chjJpr2CgY34GOQZLjaxHmIccxjnEmHzrqUbd4rhyU5VMzzTZq
         fQGxpspBxbqHfHAkO2LOGZ+hmUhJcJ9yabbfnrtuX82mwCcxKtD3vm1Q5Rrn/5iuTA
         VX6EAil/pXGJvkH6CLYuB7SvFKZ5a/e8BbF4yEN0=
Date:   Tue, 10 Nov 2020 13:24:36 -0800
From:   akpm@linux-foundation.org
To:     aryabinin@virtuozzo.com, linus.walleij@linaro.org,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        natechancellor@gmail.com, sfr@canb.auug.org.au,
        valdis.kletnieks@vt.edu
Subject:  +
 treewide-remove-stringification-from-__alias-macro-definition-fix.patch
 added to -mm tree
Message-ID: <20201110212436.yGYhesom8%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     treewide-remove-stringification-from-__alias-macro-definition-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/treewide-remove-stringificati=
on-from-__alias-macro-definition-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/treewide-remove-stringificati=
on-from-__alias-macro-definition-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

treewide-remove-stringification-from-__alias-macro-definition-fix.patch

