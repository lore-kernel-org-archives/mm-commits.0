Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B269C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F6861208
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhKIChH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236255AbhKIChH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64EB961279;
        Tue,  9 Nov 2021 02:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425262;
        bh=5/bV2pS0GOCjBVCFfGQYDxe27cYt3sbVk483/799KO0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s0MngS40uMPG5sxChqEIFVzu+xj6P5TvJ1CysRESe9qxlrkgb+aXlwHZs8uwD7XJz
         98VvJF8Bq6ABgmOfMexbv4q6fJeV0sFys6zXq07hsjJR6hROwLCtzmTkyzZwFsZpvX
         yl2r5zhHVGBXYXJnHLAXKIagjksLKS0J1iffni3A=
Date:   Mon, 08 Nov 2021 18:34:20 -0800
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
Subject:  [patch 54/87] alpha: use is_kernel_text() helper
Message-ID: <20211109023420.Ta2syQJnO%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
