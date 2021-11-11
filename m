Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BDEC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62EC861361
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhKKCzm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B026561250;
        Thu, 11 Nov 2021 02:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599173;
        bh=H8jwV/SgzIHYGX9Cwzgrhjh4Ya5h05NJCq+G98HYjSM=;
        h=Date:From:To:Subject:From;
        b=KMWtHDeh+Za+xlNO2EOFqKbHiej40zzm1oKYUcLVvvXUQa6JaixmXQpiwAOrRq0w2
         DqkcqHRPMfrUc5jZfTFEYTFcC0BHXPBamymok27noelJ4trWb+R21TZ+f1tjVCpKDx
         Ed3RHC98pYVLU9nE81oJ73OwBNmt3GdtCPaoNIos=
Date:   Wed, 10 Nov 2021 18:52:52 -0800
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
Subject:  [merged] mm-kasan-use-is_kernel-helper.patch removed from
 -mm tree
Message-ID: <20211111025252.1d3sYo1bo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kasan: use is_kernel() helper
has been removed from the -mm tree.  Its filename was
     mm-kasan-use-is_kernel-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


