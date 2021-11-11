Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEC6C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 631036162E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhKKCzv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AABC261108;
        Thu, 11 Nov 2021 02:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599182;
        bh=KCzqhEQaTuWROk/17SLruy9AnGFLO2SCQdO4q0zPCRg=;
        h=Date:From:To:Subject:From;
        b=RXw7J2V5AVkYOQY0/UIxltAqit4cWajstuvyojMmPdzUQPqLXYy7g0hOocYg6Ktqm
         ZxSo8sphb8AX4V2s3ykCrOeTcL1nezBKM/m6Qr0BHHQO+OR7SHZtdlWN5K+mNJGXQR
         bKbJjCTGQ6B6al27iziOlBMD9rHHW8x88kqPfEOM=
Date:   Wed, 10 Nov 2021 18:53:01 -0800
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
Subject:  [merged] microblaze-use-is_kernel_text-helper.patch
 removed from -mm tree
Message-ID: <20211111025301.uqAEw5xz8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: use is_kernel_text() helper
has been removed from the -mm tree.  Its filename was
     microblaze-use-is_kernel_text-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: microblaze: use is_kernel_text() helper

Use is_kernel_text() helper to simplify code.

Link: https://lkml.kernel.org/r/20210930071143.63410-11-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
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


