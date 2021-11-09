Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E892C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED22661207
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbhKICgw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:36:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236255AbhKICgw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6911C6128B;
        Tue,  9 Nov 2021 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425247;
        bh=aEosDWS8htDHm5SG02EgyFAoA8xa3GLk0G6aDLRKcy0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gAfdacjI9ALoXnnOS1rPc/nlJL8YPmE1lfmXJTYkZgS3Pdg0FDiFpjv/9BrkjYPBA
         rm1nCeLVSO1s9gELhdXLkn3cBhkDsyRXS/RG0TlFvA0gnnqwFgYUawoi6pFpwJlROx
         LGLZqmhzZr1XQybtvFkQLJnbJN84fWc0wcxP7rUA=
Date:   Mon, 08 Nov 2021 18:34:05 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
        ast@kernel.org, benh@kernel.crashing.org, bp@alien8.de,
        christophe.leroy@csgroup.eu, davem@davemloft.net,
        dvyukov@google.com, glider@google.com, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, mattst88@gmail.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au,
        paulus@samba.org, pmladek@suse.com, rostedt@goodmis.org,
        rth@twiddle.net, ryabinin.a.a@gmail.com, senozhatsky@chromium.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com
Subject:  [patch 50/87] mm: kasan: use is_kernel() helper
Message-ID: <20211109023405.Wew0iv7nf%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kasan: use is_kernel() helper

Directly use is_kernel() helper in kernel_or_module_addr().

Link: https://lkml.kernel.org/r/20210930071143.63410-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
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

 mm/kasan/report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/report.c~mm-kasan-use-is_kernel-helper
+++ a/mm/kasan/report.c
@@ -226,7 +226,7 @@ static void describe_object(struct kmem_
 
 static inline bool kernel_or_module_addr(const void *addr)
 {
-	if (addr >= (void *)_stext && addr < (void *)_end)
+	if (is_kernel((unsigned long)addr))
 		return true;
 	if (is_module_address((unsigned long)addr))
 		return true;
_
