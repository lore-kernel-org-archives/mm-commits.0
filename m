Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0802C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A08AE613C2
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbhEGBDx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhEGBDx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E93B61289;
        Fri,  7 May 2021 01:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349374;
        bh=Vp2vXw7vPPzgJiIMmR712Ii1qWPT0DR6K7zy8l6pPG8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M6gWXOeWyvg6c7460/1ljmvfHC1Cxp80xe+dbf8JZsZye1kqaHyFvSymyE6szbphE
         OTc3yeoNYfcCK9nepugl69/LTM5y8Q/AktslYlF6dSVOwuXNPULUsQaeoBE5yJOVFS
         vY6uQL/WWdfWSow31+3AQHh2gpmIdQX3aEY5Cf18=
Date:   Thu, 06 May 2021 18:02:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, dalias@libc.org,
        dennis@kernel.org, dsterba@suse.com, geert@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, jianpeng.ma@intel.com,
        joe@perches.com, jpoimboe@redhat.com, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, linux@roeck-us.net,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        sbrivio@redhat.com, torvalds@linux-foundation.org,
        wsa+renesas@sang-engineering.com, ysato@users.osdn.me,
        yury.norov@gmail.com
Subject:  [patch 17/91] arch: rearrange headers inclusion order in
 asm/bitops for m68k, sh and h8300
Message-ID: <20210507010253.7KzR98_px%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: arch: rearrange headers inclusion order in asm/bitops for m68k, sh and h8300

m68k and sh include bitmap/{find,le}.h prior to ffs/fls headers.  New
fast-path implementation in find.h requires ffs/fls.  Reordering the
headers inclusion sequence helps to prevent compile-time implicit function
declaration error.

[yury.norov@gmail.com: h8300: rearrange headers inclusion order in asm/bitops]
  Link: https://lkml.kernel.org/r/20210406183625.794227-1-yury.norov@gmail.com
Link: https://lkml.kernel.org/r/20210401003153.97325-5-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Sterba <dsterba@suse.com>
Cc: Dennis Zhou <dennis@kernel.org>
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

 arch/h8300/include/asm/bitops.h |    8 ++++----
 arch/m68k/include/asm/bitops.h  |    6 +++---
 arch/sh/include/asm/bitops.h    |    5 +++--
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/arch/h8300/include/asm/bitops.h~arch-rearrange-headers-inclusion-order-in-asm-bitops-for-m68k-and-sh
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
--- a/arch/m68k/include/asm/bitops.h~arch-rearrange-headers-inclusion-order-in-asm-bitops-for-m68k-and-sh
+++ a/arch/m68k/include/asm/bitops.h
@@ -440,8 +440,6 @@ static inline unsigned long ffz(unsigned
 
 #endif
 
-#include <asm-generic/bitops/find.h>
-
 #ifdef __KERNEL__
 
 #if defined(CONFIG_CPU_HAS_NO_BITFIELDS)
@@ -525,10 +523,12 @@ static inline int __fls(int x)
 #define __clear_bit_unlock	clear_bit_unlock
 
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/le.h>
 #endif /* __KERNEL__ */
 
+#include <asm-generic/bitops/find.h>
+
 #endif /* _M68K_BITOPS_H */
--- a/arch/sh/include/asm/bitops.h~arch-rearrange-headers-inclusion-order-in-asm-bitops-for-m68k-and-sh
+++ a/arch/sh/include/asm/bitops.h
@@ -58,15 +58,16 @@ static inline unsigned long __ffs(unsign
 	return result;
 }
 
-#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
-#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
+#include <asm-generic/bitops/le.h>
+#include <asm-generic/bitops/find.h>
+
 #endif /* __ASM_SH_BITOPS_H */
_
