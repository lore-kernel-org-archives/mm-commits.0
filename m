Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E08C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  7 Apr 2021 04:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 039D5613BD
	for <mm-commits@archiver.kernel.org>; Wed,  7 Apr 2021 04:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhDGELD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Apr 2021 00:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhDGELC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Apr 2021 00:11:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEAF66124C;
        Wed,  7 Apr 2021 04:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617768654;
        bh=5KO8mdDeq9F6I8mPyjt4P020SRrbBQ5/s9JctiOg1xA=;
        h=Date:From:To:Subject:From;
        b=ZeGmSB6nH4MSuSH/g47WC1nHadSxVOIMZvyA3Pgo+b/QSOLTScJ33ScnmgrHdXgkc
         YalX3xCJnKJijT2xcuDkXYWvvHL0cmpdrWDtbCrfcv4kwZ8nqCYmhnT8kCcbwOVIgL
         2PqCpEHNlF7uIgMdiDdTVeEDyf9DlJeJqmdK30kc=
Date:   Tue, 06 Apr 2021 21:10:53 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, linux@roeck-us.net,
        lkp@intel.com, mm-commits@vger.kernel.org, yury.norov@gmail.com
Subject:  +
 lib-add-fast-path-for-find_first__bit-and-find_last_bit-fix.patch added to
 -mm tree
Message-ID: <20210407041053.A-vUlWLaZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: rearrange headers inclusion order in asm/bitops
has been added to the -mm tree.  Its filename is
     lib-add-fast-path-for-find_first__bit-and-find_last_bit-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-add-fast-path-for-find_first__bit-and-find_last_bit-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-add-fast-path-for-find_first__bit-and-find_last_bit-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: h8300: rearrange headers inclusion order in asm/bitops

The commit a5145bdad3ff ("arch: rearrange headers inclusion order in
asm/bitops for m68k and sh") on next-20210401 fixed header ordering issue.
h8300 has similar problem, which was overlooked by me.

h8300 includes bitmap/{find,le}.h prior to ffs/fls headers. New fast-path
implementation in find.h requires ffs/fls. Reordering the headers inclusion
sequence helps to prevent compile-time implicit function declaration error.

v2: change wording in the comment.

Link: https://lkml.kernel.org/r/20210406183625.794227-1-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/bitops.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/h8300/include/asm/bitops.h~lib-add-fast-path-for-find_first__bit-and-find_last_bit-fix
+++ a/arch/h8300/include/asm/bitops.h
@@ -9,6 +9,10 @@
 
 #include <linux/compiler.h>
 
+#include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
+#include <asm-generic/bitops/fls64.h>
+
 #ifdef __KERNEL__
 
 #ifndef _LINUX_BITOPS_H
@@ -173,8 +177,4 @@ static inline unsigned long __ffs(unsign
 
 #endif /* __KERNEL__ */
 
-#include <asm-generic/bitops/fls.h>
-#include <asm-generic/bitops/__fls.h>
-#include <asm-generic/bitops/fls64.h>
-
 #endif /* _H8300_BITOPS_H */
_

Patches currently in -mm which might be from yury.norov@gmail.com are

tools-disable-wno-type-limits.patch
tools-bitmap-sync-function-declarations-with-the-kernel.patch
tools-sync-bitmap_last_word_mask-macro-with-the-kernel.patch
arch-rearrange-headers-inclusion-order-in-asm-bitops-for-m68k-and-sh.patch
lib-extend-the-scope-of-small_const_nbits-macro.patch
tools-sync-small_const_nbits-macro-with-the-kernel.patch
lib-inline-_find_next_bit-wrappers.patch
tools-sync-find_next_bit-implementation.patch
lib-add-fast-path-for-find_next__bit.patch
lib-add-fast-path-for-find_first__bit-and-find_last_bit.patch
lib-add-fast-path-for-find_first__bit-and-find_last_bit-fix.patch
tools-sync-lib-find_bit-implementation.patch
maintainers-add-entry-for-the-bitmap-api.patch

