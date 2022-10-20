Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC133C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 00:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJTAEB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 20:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiJTAEB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 20:04:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6CA1960A0
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 17:03:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B95E1614EF
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 00:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177CDC433C1;
        Thu, 20 Oct 2022 00:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666224236;
        bh=BwzUOsMA5yzmnhDzcXKOanlkPFXzDZZhVeKtNcMUSI8=;
        h=Date:To:From:Subject:From;
        b=cQgACLoG6Od3a8r0NS6qa2kdwAwP6pAIsEymoTaopCSUmtWl83697Z9AlQal4yW0A
         DLVycjKBS4tgaICQUkU9LRXMPoHdPBPr1QaKOlFoFSn0WhhVKk8bl81kbbkYw1mOW0
         DSk5XpUw3+Op7YuWM6QLu68dfTRD5L4hSTrWZLcw=
Date:   Wed, 19 Oct 2022 17:03:55 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        masahiroy@kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com,
        Jason@zx2c4.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-treat-char-as-always-unsigned.patch added to mm-nonmm-unstable branch
Message-Id: <20221020000356.177CDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: treat char as always unsigned
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-treat-char-as-always-unsigned.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-treat-char-as-always-unsigned.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: kbuild: treat char as always unsigned
Date: Wed, 19 Oct 2022 14:30:34 -0600

Recently, some compile-time checking I added to the clamp_t family of
functions triggered a build error when a poorly written driver was
compiled on ARM, because the driver assumed that the naked `char` type is
signed, but ARM treats it as unsigned, and the C standard says it's
architecture-dependent.

I doubt this particular driver is the only instance in which unsuspecting
authors make assumptions about `char` with no `signed` or `unsigned`
specifier.  We were lucky enough this time that that driver used
`clamp_t(char, negative_value, positive_value)`, so the new checking code
found it, and I've sent a patch to fix it, but there are likely other
places lurking that won't be so easily unearthed.

So let's just eliminate this particular variety of heisensign bugs
entirely.  Set `-funsigned-char` globally, so that gcc makes the type
unsigned on all architectures.

This will break things in some places and fix things in others, so this
will likely cause a bit of churn while reconciling the type misuse.

Link: https://lkml.kernel.org/r/20221019203034.3795710-1-Jason@zx2c4.com
Link: https://lore.kernel.org/lkml/202210190108.ESC3pc3D-lkp@intel.com/
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile~kbuild-treat-char-as-always-unsigned
+++ a/Makefile
@@ -562,7 +562,7 @@ KBUILD_AFLAGS   := -D__ASSEMBLY__ -fno-P
 KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
 		   -Werror=implicit-function-declaration -Werror=implicit-int \
-		   -Werror=return-type -Wno-format-security \
+		   -Werror=return-type -Wno-format-security -funsigned-char \
 		   -std=gnu11
 KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_RUSTFLAGS := $(rust_common_flags) \
_

Patches currently in -mm which might be from Jason@zx2c4.com are

wifi-rt2x00-use-explicitly-signed-type-for-clamping.patch
minmax-sanity-check-constant-bounds-when-clamping.patch
minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch
kbuild-treat-char-as-always-unsigned.patch

