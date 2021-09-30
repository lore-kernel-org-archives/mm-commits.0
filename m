Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6D2C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 951DF61A6F
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349648AbhI3VYI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 17:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349614AbhI3VYD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 17:24:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1563E61A6C;
        Thu, 30 Sep 2021 21:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633036940;
        bh=maMe0i3QBae6zIuHsA9yXhbjJS2Bo2zKo12xYPzNzB8=;
        h=Date:From:To:Subject:From;
        b=SeCrAWAwGhV1jr1s8QqSEO0jIJ+28xstC5UE84IrWikYCFK5viqtwxHWd+mKDKdP/
         onDOEgwBJfG++X1SBoVoNcETxk4LLOE+DPhPtOZBuFqxuN+7u5HxWuG7x2Su5qTcU5
         bT39csSd1bLS9Sjn9fuw3dP0QV+DQ9jROteaGicE=
Date:   Thu, 30 Sep 2021 14:22:19 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, arnd@arndb.de, ast@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de,
        christophe.leroy@csgroup.eu, davem@davemloft.net,
        dvyukov@google.com, glider@google.com, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, michal.simek@xilinx.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org,
        pmladek@suse.com, rostedt@goodmis.org, rth@twiddle.net,
        ryabinin.a.a@gmail.com, senozhatsky@chromium.org,
        tglx@linutronix.de, wangkefeng.wang@huawei.com
Subject:  + microblaze-use-is_kernel_text-helper.patch added to -mm
 tree
Message-ID: <20210930212219.FHQWabaKp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: use is_kernel_text() helper
has been added to the -mm tree.  Its filename is
     microblaze-use-is_kernel_text-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/microblaze-use-is_kernel_text-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/microblaze-use-is_kernel_text-helper.patch

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
Subject: microblaze: use is_kernel_text() helper

Use is_kernel_text() helper to simplify code.

Link: https://lkml.kernel.org/r/20210930071143.63410-11-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/mm/pgtable.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/microblaze/mm/pgtable.c~microblaze-use-is_kernel_text-helper
+++ a/arch/microblaze/mm/pgtable.c
@@ -34,6 +34,7 @@
 #include <linux/mm_types.h>
 #include <linux/pgtable.h>
 #include <linux/memblock.h>
+#include <linux/kallsyms.h>
 
 #include <asm/pgalloc.h>
 #include <linux/io.h>
@@ -171,7 +172,7 @@ void __init mapin_ram(void)
 	for (s = 0; s < lowmem_size; s += PAGE_SIZE) {
 		f = _PAGE_PRESENT | _PAGE_ACCESSED |
 				_PAGE_SHARED | _PAGE_HWEXEC;
-		if ((char *) v < _stext || (char *) v >= _etext)
+		if (!is_kernel_text(v))
 			f |= _PAGE_WRENABLE;
 		else
 			/* On the MicroBlaze, no user access
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

