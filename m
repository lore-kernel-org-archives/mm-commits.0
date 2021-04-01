Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CED6C433B4
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46EFF610CB
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhDAAxn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 20:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232492AbhDAAxj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 20:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D9F361055;
        Thu,  1 Apr 2021 00:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617238418;
        bh=3T2A+OcfQ9sr3t4z0eI8AgvFN7oZ+KWGL848PjeUIvw=;
        h=Date:From:To:Subject:From;
        b=dV60B0f8nuYLsFZhV+nQZAVQcvyjJ0PkkWPQ7BcdwZ/g0yhXumnecyDPiplIj1S2O
         EPZnVUQdC+miTSuEWhO7ZMkyjA+1VXHi2kvkafgGZnVtv9StYrYl1DnuDeGpPalXYT
         xMJq+ZYp5E8PXJ9YENO6VF6LqgvCeZfLbFGJdQH4=
Date:   Wed, 31 Mar 2021 17:53:37 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, dalias@libc.org, dennis@kernel.org,
        dsterba@suse.com, geert@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, jianpeng.ma@intel.com,
        joe@perches.com, jpoimboe@redhat.com, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        sbrivio@redhat.com, wsa+renesas@sang-engineering.com,
        ysato@users.osdn.me, yury.norov@gmail.com
Subject:  + tools-disable-wno-type-limits.patch added to -mm tree
Message-ID: <20210401005337.8vq6ugNtK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools: disable -Wno-type-limits
has been added to the -mm tree.  Its filename is
     tools-disable-wno-type-limits.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-disable-wno-type-limits.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-disable-wno-type-limits.patch

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
Subject: tools: disable -Wno-type-limits

Patch series "lib/find_bit: fast path for small bitmaps", v6.

Bitmap operations are much simpler and faster in case of small bitmaps
which fit into a single word.  In linux/bitmap.c we have a machinery that
allows compiler to replace actual function call with a few instructions if
bitmaps passed into the function are small and their size is known at
compile time.

find_*_bit() API lacks this functionality; but users will benefit from it
a lot.  One important example is cpumask subsystem when NR_CPUS <=
BITS_PER_LONG.


This patch (of 12):

GENMASK(h, l) may be passed with unsigned types.  In such case,
type-limits warning is generated for example in case of GENMASK(h, 0).

Link: https://lkml.kernel.org/r/20210401003153.97325-1-yury.norov@gmail.com
Link: https://lkml.kernel.org/r/20210401003153.97325-2-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Sterba <dsterba@suse.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Stefano Brivio <sbrivio@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/scripts/Makefile.include |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/scripts/Makefile.include~tools-disable-wno-type-limits
+++ a/tools/scripts/Makefile.include
@@ -38,6 +38,7 @@ EXTRA_WARNINGS += -Wswitch-enum
 EXTRA_WARNINGS += -Wundef
 EXTRA_WARNINGS += -Wwrite-strings
 EXTRA_WARNINGS += -Wformat
+EXTRA_WARNINGS += -Wno-type-limits
 
 CC_NO_CLANG := $(shell $(CC) -dM -E -x c /dev/null | grep -Fq "__clang__"; echo $$?)
 
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
tools-sync-lib-find_bit-implementation.patch
maintainers-add-entry-for-the-bitmap-api.patch

