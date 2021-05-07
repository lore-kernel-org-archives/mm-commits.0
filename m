Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3542DC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 00:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D08B613B9
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 00:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhEGAJA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 20:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232375AbhEGAI7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 20:08:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4234E61104;
        Fri,  7 May 2021 00:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620346068;
        bh=4B8TqRFn/monnJcPuriKBAsjakeJb9WeK6zLNnRYU9A=;
        h=Date:From:To:Subject:From;
        b=a5+VvHp9Tbxxcr31Y0q9prFtUtqy+xIPBVnQZM6inurbFqkXfjE58kEfPq5msLBKd
         u/fcTXGnqbE3vramx09WTQFNUrFhNAU3ImNiss0VNPCFyitP3nEFMs+0Cdesbi/SZj
         amJRVCOkT564Fg7BPySkB6nJis3FqoXlRveiF+K4=
Date:   Thu, 06 May 2021 17:07:47 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, linux@roeck-us.net,
        lkp@intel.com, mm-commits@vger.kernel.org, yury.norov@gmail.com
Subject:  [folded-merged]
 =?US-ASCII?Q?arch-rearrange-headers-inclusion-order-in-asm-bitops-for-m?=
 =?US-ASCII?Q?68k-and-sh-fix.patch?= removed from -mm tree
Message-ID: <20210507000747.2DgTkat2I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: rearrange headers inclusion order in asm/bitops
has been removed from the -mm tree.  Its filename was
     arch-rearrange-headers-inclusion-order-in-asm-bitops-for-m68k-and-sh-fix.patch

This patch was dropped because it was folded into arch-rearrange-headers-inclusion-order-in-asm-bitops-for-m68k-and-sh.patch

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: h8300: rearrange headers inclusion order in asm/bitops

fix h8300 as well

Link: https://lkml.kernel.org/r/20210406183625.794227-1-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/bitops.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/h8300/include/asm/bitops.h~arch-rearrange-headers-inclusion-order-in-asm-bitops-for-m68k-and-sh-fix
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
tools-sync-lib-find_bit-implementation.patch
maintainers-add-entry-for-the-bitmap-api.patch

