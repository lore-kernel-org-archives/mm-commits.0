Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4BAC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 648196187A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhKKCzf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DB26610A2;
        Thu, 11 Nov 2021 02:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599167;
        bh=DSOBI1tYO4oSEK8Dm1Y7SrIL2JHLavGxTKDtbXPm2aU=;
        h=Date:From:To:Subject:From;
        b=pMUnyAvGNHaV8AHcCUJdWlMvCD4no2jUsgHADKKjl9G0hqoQ+UZ/HVNm+uboCJaq+
         MOB0V8+RxXzNEaWH29LUWFYi9RVRpva/fVqoP2FRhpVqWW1sTE04Z2VcusMkOsj2Oa
         2BCduOZU1hoNNoIQZXdcCVPObLmQCqPp2FSj7XWE=
Date:   Wed, 10 Nov 2021 18:52:46 -0800
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
 x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch removed from
 -mm tree
Message-ID: <20211111025246.WAz9hoh8i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: mm: rename __is_kernel_text() to is_x86_32_kernel_text()
has been removed from the -mm tree.  Its filename was
     x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: x86: mm: rename __is_kernel_text() to is_x86_32_kernel_text()

Commit b56cd05c55a1 ("x86/mm: Rename is_kernel_text to __is_kernel_text"),
add '__' prefix not to get in conflict with existing is_kernel_text() in
<linux/kallsyms.h>.

We will add __is_kernel_text() for the basic kernel text range check in
the next patch, so use private is_x86_32_kernel_text() naming for x86
special check.

Link: https://lkml.kernel.org/r/20210930071143.63410-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_32.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/arch/x86/mm/init_32.c~x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text
+++ a/arch/x86/mm/init_32.c
@@ -238,11 +238,7 @@ page_table_range_init(unsigned long star
 	}
 }
 
-/*
- * The <linux/kallsyms.h> already defines is_kernel_text,
- * using '__' prefix not to get in conflict.
- */
-static inline int __is_kernel_text(unsigned long addr)
+static inline int is_x86_32_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_text && addr <= (unsigned long)__init_end)
 		return 1;
@@ -333,8 +329,8 @@ repeat:
 				addr2 = (pfn + PTRS_PER_PTE-1) * PAGE_SIZE +
 					PAGE_OFFSET + PAGE_SIZE-1;
 
-				if (__is_kernel_text(addr) ||
-				    __is_kernel_text(addr2))
+				if (is_x86_32_kernel_text(addr) ||
+				    is_x86_32_kernel_text(addr2))
 					prot = PAGE_KERNEL_LARGE_EXEC;
 
 				pages_2m++;
@@ -359,7 +355,7 @@ repeat:
 				 */
 				pgprot_t init_prot = __pgprot(PTE_IDENT_ATTR);
 
-				if (__is_kernel_text(addr))
+				if (is_x86_32_kernel_text(addr))
 					prot = PAGE_KERNEL_EXEC;
 
 				pages_4k++;
@@ -789,7 +785,7 @@ static void mark_nxdata_nx(void)
 	 */
 	unsigned long start = PFN_ALIGN(_etext);
 	/*
-	 * This comes from __is_kernel_text upper limit. Also HPAGE where used:
+	 * This comes from is_x86_32_kernel_text upper limit. Also HPAGE where used:
 	 */
 	unsigned long size = (((unsigned long)__init_end + HPAGE_SIZE) & HPAGE_MASK) - start;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


