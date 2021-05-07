Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41DACC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24ACE613B5
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhEGBDn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhEGBDm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7C6C61041;
        Fri,  7 May 2021 01:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349363;
        bh=dtN6/mDIhSYvL2dOinpwL3CnqAnD9YfcdeoYWOpIo2M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ufKzsR7/HpyTKMZ/F6J38cMdKa1Wr1Aohkxhcol7ufX9K033CMgfGGfITz56RQFXv
         aisfFTTip9ZuKFSi2lB+tJnu/Gu8u/cw81ch6oh3SRfJ4f5Qr9Y1Qkvasy1gsnlb6j
         s6xNQZf3BxOflyIrYf7Gt6e62jbkZDd2hHyP2x+0=
Date:   Thu, 06 May 2021 18:02:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, dalias@libc.org,
        dennis@kernel.org, dsterba@suse.com, geert@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, jianpeng.ma@intel.com,
        joe@perches.com, jpoimboe@redhat.com, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, sbrivio@redhat.com,
        torvalds@linux-foundation.org, wsa+renesas@sang-engineering.com,
        ysato@users.osdn.me, yury.norov@gmail.com
Subject:  [patch 14/91] tools: disable -Wno-type-limits
Message-ID: <20210507010242.ydCofRv4z%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
 
 # Makefiles suck: This macro sets a default value of $(2) for the
 # variable named by $(1), unless the variable has been set by
_
