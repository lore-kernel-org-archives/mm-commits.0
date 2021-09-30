Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C48C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 685D761A6E
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349659AbhI3VYC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 17:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349601AbhI3VXs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 17:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2273461A61;
        Thu, 30 Sep 2021 21:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633036925;
        bh=+Kqem3vQ+D/MnOz/ZTWcX9sMLW0xFU0uyrKyGnP/r78=;
        h=Date:From:To:Subject:From;
        b=iO4HaTEewg6bPKjkrCXfbde2Ozl3aFSpKjA9+s80zw2lqGy33Btem+c0txpWQyY5F
         DIry4vTeYkZU83YYaolDQV5M2buCv9wfBu6ajOksYr9ii1jYZtFPlmZznHdna5/ql0
         zrNKZIaPKe2l3UF1JUdli9MklojULkIxowGxjLcw=
Date:   Thu, 30 Sep 2021 14:22:04 -0700
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
Subject:  +
 x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch added to -mm
 tree
Message-ID: <20210930212204.PUGHACY8T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: mm: rename __is_kernel_text() to is_x86_32_kernel_text()
has been added to the -mm tree.  Its filename is
     x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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
@@ -820,7 +816,7 @@ static void mark_nxdata_nx(void)
 	 */
 	unsigned long start = PFN_ALIGN(_etext);
 	/*
-	 * This comes from __is_kernel_text upper limit. Also HPAGE where used:
+	 * This comes from is_x86_32_kernel_text upper limit. Also HPAGE where used:
 	 */
 	unsigned long size = (((unsigned long)__init_end + HPAGE_SIZE) & HPAGE_MASK) - start;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

slub-add-back-check-for-free-nonslab-objects.patch
mm-nommu-kill-arch_get_unmapped_area.patch
kallsyms-remove-arch-specific-text-and-data-check.patch
kallsyms-fix-address-checks-for-kernel-related-range.patch
sections-move-and-rename-core_kernel_data-to-is_kernel_core_data.patch
sections-move-is_kernel_inittext-into-sectionsh.patch
x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch
sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch
mm-kasan-use-is_kernel-helper.patch
extable-use-is_kernel_text-helper.patch
powerpc-mm-use-core_kernel_text-helper.patch
microblaze-use-is_kernel_text-helper.patch
alpha-use-is_kernel_text-helper.patch

