Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCBCC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4F4361381
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbhKKCzZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C0E761361;
        Thu, 11 Nov 2021 02:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599155;
        bh=XczaUwFMYpjQwFbMdBpXYUpdYu1qB79/10gjuSTaMoY=;
        h=Date:From:To:Subject:From;
        b=f7i9NPTktDofyWQzdXUZ8cvCvDDxl5mEiRtytZVt01V+xY1AIDcT5VobcUdxM16ww
         e3Gt3JM/Cd60tTNG2jhIdm0qLUWMnC063OIDzkBqoIfyK8xcbO5u8unzGGieEx6u02
         ib/LzOEFEtrP5lJj08UjvLtqd3kD1Ja84ovAsyRw=
Date:   Wed, 10 Nov 2021 18:52:34 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, arnd@arndb.de, ast@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de,
        christophe.leroy@csgroup.eu, davem@davemloft.net,
        dvyukov@google.com, glider@google.com, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        monstr@monstr.eu, mpe@ellerman.id.au, paulus@samba.org,
        pmladek@suse.com, rostedt@goodmis.org, rth@twiddle.net,
        ryabinin.a.a@gmail.com, senozhatsky@chromium.org,
        tglx@linutronix.de, wangkefeng.wang@huawei.com
Subject:  [merged]
 kallsyms-remove-arch-specific-text-and-data-check.patch removed from -mm
 tree
Message-ID: <20211111025234.aGWom6FPp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kallsyms: remove arch specific text and data check
has been removed from the -mm tree.  Its filename was
     kallsyms-remove-arch-specific-text-and-data-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: kallsyms: remove arch specific text and data check

Patch series "sections: Unify kernel sections range check and use", v4.

There are three head files(kallsyms.h, kernel.h and sections.h) which
include the kernel sections range check, let's make some cleanup and unify
them.

1. cleanup arch specific text/data check and fix address boundary check
   in kallsyms.h

2. make all the basic/core kernel range check function into sections.h

3. update all the callers, and use the helper in sections.h to simplify
   the code

After this series, we have 5 APIs about kernel sections range check in
sections.h

 * is_kernel_rodata()		--- already in sections.h
 * is_kernel_core_data()	--- come from core_kernel_data() in kernel.h
 * is_kernel_inittext()		--- come from kernel.h and kallsyms.h
 * __is_kernel_text()		--- add new internal helper
 * __is_kernel()		--- add new internal helper

Note: For the last two helpers, people should not use directly, consider to
      use corresponding function in kallsyms.h.


This patch (of 11):

Remove arch specific text and data check after commit 4ba66a976072 ("arch:
remove blackfin port"), no need arch-specific text/data check.

Link: https://lkml.kernel.org/r/20210930071143.63410-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20210930071143.63410-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/sections.h |   16 ----------------
 include/linux/kallsyms.h       |    3 +--
 kernel/locking/lockdep.c       |    3 ---
 3 files changed, 1 insertion(+), 21 deletions(-)

--- a/include/asm-generic/sections.h~kallsyms-remove-arch-specific-text-and-data-check
+++ a/include/asm-generic/sections.h
@@ -64,22 +64,6 @@ extern __visible const void __nosave_beg
 #define dereference_kernel_function_descriptor(p) ((void *)(p))
 #endif
 
-/* random extra sections (if any).  Override
- * in asm/sections.h */
-#ifndef arch_is_kernel_text
-static inline int arch_is_kernel_text(unsigned long addr)
-{
-	return 0;
-}
-#endif
-
-#ifndef arch_is_kernel_data
-static inline int arch_is_kernel_data(unsigned long addr)
-{
-	return 0;
-}
-#endif
-
 /**
  * memory_contains - checks if an object is contained within a memory region
  * @begin: virtual address of the beginning of the memory region
--- a/include/linux/kallsyms.h~kallsyms-remove-arch-specific-text-and-data-check
+++ a/include/linux/kallsyms.h
@@ -34,8 +34,7 @@ static inline int is_kernel_inittext(uns
 
 static inline int is_kernel_text(unsigned long addr)
 {
-	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext) ||
-	    arch_is_kernel_text(addr))
+	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext))
 		return 1;
 	return in_gate_area_no_mm(addr);
 }
--- a/kernel/locking/lockdep.c~kallsyms-remove-arch-specific-text-and-data-check
+++ a/kernel/locking/lockdep.c
@@ -818,9 +818,6 @@ static int static_obj(const void *obj)
 	if ((addr >= start) && (addr < end))
 		return 1;
 
-	if (arch_is_kernel_data(addr))
-		return 1;
-
 	/*
 	 * in-kernel percpu var?
 	 */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


