Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCB5C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75AA261872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhKKCzp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D27A461075;
        Thu, 11 Nov 2021 02:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599176;
        bh=gitwMTdLYlEAnP/drDj6Y94hBVFNijuOmKexbTRDKc8=;
        h=Date:From:To:Subject:From;
        b=QcUP9lL94/Xem0rmYw34syfmBBzoEa52vYMoS4BJkGhBiaIY/yPF8AacvknR4L6Ps
         qhPJ8Hj/9mz88q11unuZwBRc+qsRUpjf2KMETfxmhwtnH3582Oc1jIG3aicT74CBhr
         UbCaKtnkWDsxkA5T91wigTCC6LLDtQv0eOGPULmc=
Date:   Wed, 10 Nov 2021 18:52:55 -0800
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
Subject:  [merged] extable-use-is_kernel_text-helper.patch removed
 from -mm tree
Message-ID: <20211111025255.EHlrXyib6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: extable: use is_kernel_text() helper
has been removed from the -mm tree.  Its filename was
     extable-use-is_kernel_text-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: extable: use is_kernel_text() helper

The core_kernel_text() should check the gate area, as it is part of kernel
text range, use is_kernel_text() in core_kernel_text().

Link: https://lkml.kernel.org/r/20210930071143.63410-9-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
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
Cc: Michal Simek <monstr@monstr.eu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/extable.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/extable.c~extable-use-is_kernel_text-helper
+++ a/kernel/extable.c
@@ -64,8 +64,7 @@ const struct exception_table_entry *sear
 
 int notrace core_kernel_text(unsigned long addr)
 {
-	if (addr >= (unsigned long)_stext &&
-	    addr < (unsigned long)_etext)
+	if (is_kernel_text(addr))
 		return 1;
 
 	if (system_state < SYSTEM_FREEING_INITMEM &&
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


