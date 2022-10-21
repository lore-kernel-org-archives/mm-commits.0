Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E44FC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 01:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJUB1i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 21:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJUB1h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 21:27:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A08C229E7D
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 18:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD66D61D85
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 01:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208CCC433C1;
        Fri, 21 Oct 2022 01:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666315655;
        bh=tZRTm4j7ie3BwOmcOQyAKJvWr8ZrKTUI496kj/fFXO8=;
        h=Date:To:From:Subject:From;
        b=HNZ4e6zAyUqT56GI4LUzOHGXy2U/URYIlEWzT7C0GtJzMCjhFbd3l+P/WinpuAuu5
         JuWmVJJzBBBvNIanOCEjwhoKGL/8M/k+n9oM3GTnEKzBGW0jPyP4ikryLtqsJqxxWY
         eN3XasC+jMwKOEQ2C4GF0XMZs8IBGZv3GeNoJx/8=
Date:   Thu, 20 Oct 2022 18:27:34 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        masahiroy@kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com,
        Jason@zx2c4.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kbuild-treat-char-as-always-unsigned.patch removed from -mm tree
Message-Id: <20221021012735.208CCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kbuild: treat char as always unsigned
has been removed from the -mm tree.  Its filename was
     kbuild-treat-char-as-always-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

