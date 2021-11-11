Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68143C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 519E76162E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhKKCzy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1CB161250;
        Thu, 11 Nov 2021 02:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599185;
        bh=qYdODnmARBhbqOsV7R3bhefFcgh4OAkzF0XBCS1ShzY=;
        h=Date:From:To:Subject:From;
        b=bNy2CXy6iv3akSAm4IRQ0refNiLzh4FMNCULCPjXgJVFJbSyCLt1dRyGe8+XkIRkq
         dlMzrjOGDWdO2xoSmzdTJdBTTZ+Y2qsAO4qTLE95IuZ+KATmH1a2F4w2t4/JdxkBoP
         DeNX8fbLcP0GJ788Dsxpweh8NK5Y5jj9R2VF23xc=
Date:   Wed, 10 Nov 2021 18:53:04 -0800
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
Subject:  [merged] alpha-use-is_kernel_text-helper.patch removed
 from -mm tree
Message-ID: <20211111025304.ioMT3osRC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: use is_kernel_text() helper
has been removed from the -mm tree.  Its filename was
     alpha-use-is_kernel_text-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: alpha: use is_kernel_text() helper

Use is_kernel_text() helper to simplify code.

Link: https://lkml.kernel.org/r/20210930071143.63410-12-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
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
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/traps.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/alpha/kernel/traps.c~alpha-use-is_kernel_text-helper
+++ a/arch/alpha/kernel/traps.c
@@ -129,9 +129,7 @@ dik_show_trace(unsigned long *sp, const
 		extern char _stext[], _etext[];
 		unsigned long tmp = *sp;
 		sp++;
-		if (tmp < (unsigned long) &_stext)
-			continue;
-		if (tmp >= (unsigned long) &_etext)
+		if (!is_kernel_text(tmp))
 			continue;
 		printk("%s[<%lx>] %pSR\n", loglvl, tmp, (void *)tmp);
 		if (i > 40) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


