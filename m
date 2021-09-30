Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35807C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A8A861A6E
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349722AbhI3VYI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 17:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349648AbhI3VYA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 17:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 145E961A08;
        Thu, 30 Sep 2021 21:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633036937;
        bh=IzmywyZMDZXduTve2xHfI10+xwUbrIAHvnJBQ/6y3Ck=;
        h=Date:From:To:Subject:From;
        b=VYGQdc2aJeNxH3UgFq8bdb9aIH4Xh1mZfP+Copv1armMNknYkXB7Ynl7J1KbiGo+T
         535t5/CERWEC6eiSjOOAWo85u3TDe+E4RSamEq5qNtK175fV5Wmo+gx6KVttj28ncS
         YmUDBJbK8BXIsDEdbPDgglHTQq485QHfFy8imiKE=
Date:   Thu, 30 Sep 2021 14:22:16 -0700
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
Subject:  + powerpc-mm-use-core_kernel_text-helper.patch added to
 -mm tree
Message-ID: <20210930212216.eUotpqY7_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: use core_kernel_text() helper
has been added to the -mm tree.  Its filename is
     powerpc-mm-use-core_kernel_text-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-use-core_kernel_text-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-use-core_kernel_text-helper.patch

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
Subject: powerpc/mm: use core_kernel_text() helper

Use core_kernel_text() helper to simplify code, also drop etext, _stext,
_sinittext, _einittext declaration which already declared in section.h.

Link: https://lkml.kernel.org/r/20210930071143.63410-10-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable_32.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/arch/powerpc/mm/pgtable_32.c~powerpc-mm-use-core_kernel_text-helper
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -33,8 +33,6 @@
 
 #include <mm/mmu_decl.h>
 
-extern char etext[], _stext[], _sinittext[], _einittext[];
-
 static u8 early_fixmap_pagetable[FIXMAP_PTE_SIZE] __page_aligned_data;
 
 notrace void __init early_ioremap_init(void)
@@ -104,14 +102,13 @@ static void __init __mapin_ram_chunk(uns
 {
 	unsigned long v, s;
 	phys_addr_t p;
-	int ktext;
+	bool ktext;
 
 	s = offset;
 	v = PAGE_OFFSET + s;
 	p = memstart_addr + s;
 	for (; s < top; s += PAGE_SIZE) {
-		ktext = ((char *)v >= _stext && (char *)v < etext) ||
-			((char *)v >= _sinittext && (char *)v < _einittext);
+		ktext = core_kernel_text(v);
 		map_kernel_page(v, p, ktext ? PAGE_KERNEL_TEXT : PAGE_KERNEL);
 		v += PAGE_SIZE;
 		p += PAGE_SIZE;
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

