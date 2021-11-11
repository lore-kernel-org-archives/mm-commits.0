Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A18C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AD3460F46
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhKKCz1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCz0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9055361075;
        Thu, 11 Nov 2021 02:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599158;
        bh=IFeY/B2hTaRWQOCNxOTMrXzC0kze6dMKASMT4F6YKqY=;
        h=Date:From:To:Subject:From;
        b=OzYFoMvtQz4yIqAis3hhKPORAzPS24pWSauD3WAw5gDqOA/Q6j0mqOkwhGzK2Hj1C
         ZD5syeAFIdt/mSou64P/RhBbIhD92fA+/MlaQUzoM8vugydBQHAm2Q6k0xdliAaOxd
         x/4NnLqEK9xuOJN9Pl1vKuPo+A/JvfLnTMJiyy70=
Date:   Wed, 10 Nov 2021 18:52:37 -0800
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
Subject:  [merged]
 kallsyms-fix-address-checks-for-kernel-related-range.patch removed from -mm
 tree
Message-ID: <20211111025237.5YBpfo9Pe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kallsyms: fix address-checks for kernel related range
has been removed from the -mm tree.  Its filename was
     kallsyms-fix-address-checks-for-kernel-related-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: kallsyms: fix address-checks for kernel related range

The is_kernel_inittext/is_kernel_text/is_kernel function should not
include the end address(the labels _einittext, _etext and _end) when check
the address range, the issue exists since Linux v2.6.12.

Link: https://lkml.kernel.org/r/20210930071143.63410-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
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
Cc: Richard Henderson <rth@twiddle.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/kallsyms.h~kallsyms-fix-address-checks-for-kernel-related-range
+++ a/include/linux/kallsyms.h
@@ -27,21 +27,21 @@ struct module;
 static inline int is_kernel_inittext(unsigned long addr)
 {
 	if (addr >= (unsigned long)_sinittext
-	    && addr <= (unsigned long)_einittext)
+	    && addr < (unsigned long)_einittext)
 		return 1;
 	return 0;
 }
 
 static inline int is_kernel_text(unsigned long addr)
 {
-	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext))
+	if ((addr >= (unsigned long)_stext && addr < (unsigned long)_etext))
 		return 1;
 	return in_gate_area_no_mm(addr);
 }
 
 static inline int is_kernel(unsigned long addr)
 {
-	if (addr >= (unsigned long)_stext && addr <= (unsigned long)_end)
+	if (addr >= (unsigned long)_stext && addr < (unsigned long)_end)
 		return 1;
 	return in_gate_area_no_mm(addr);
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


