Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B0BC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61C7C61208
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbhKICg4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:36:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:52300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236255AbhKICg4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D489611CC;
        Tue,  9 Nov 2021 02:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425250;
        bh=aWzP+yZXLsdeYemkw9GGfAVdpImQ+8+EenNwBfM+Olg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DdcmLGUAf9ByK8Qnw6O3p5boZUi8hq0U6pSlpPiFhRy49XkDA305wFqvYN+0Cq+u5
         0RRN+mnisaOkcgrXKDoWQ7ykasWJ5gqjYWUGIcQ4akImCLfAcZfy3UUsQm6SxOe96N
         uGzdKatT4JMag3rx8lAsTrRjgXCY4Y+jKE4sAG5w=
Date:   Mon, 08 Nov 2021 18:34:09 -0800
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
Subject:  [patch 51/87] extable: use is_kernel_text() helper
Message-ID: <20211109023409.MRWi1-bFl%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
