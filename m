Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E74C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B015261284
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbhKIChA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:52384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236255AbhKICg7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB1EE60FDA;
        Tue,  9 Nov 2021 02:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425254;
        bh=aTXWwIRaKXjV37K+XBL4yEK9A6L//sXSf/HD43b9M4c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UQBgQ4+p5/XbWwASrUsz7EmNa24XhPp16L8ioazz/GVju+2peVf3a1aqshQR1+/nW
         8vlycIopR/v/zFBMXERnMdX/VcI3HRn7v82i4oPzzYxAUDuXawJTCz0JPhb6VuIj3+
         m24jdSXLu3Ue4dIvXGqkDPe7Td5qfT+NHyc7Jk0U=
Date:   Mon, 08 Nov 2021 18:34:13 -0800
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
Subject:  [patch 52/87] powerpc/mm: use core_kernel_text() helper
Message-ID: <20211109023413.LVu2wHvb2%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: powerpc/mm: use core_kernel_text() helper

Use core_kernel_text() helper to simplify code, also drop etext, _stext,
_sinittext, _einittext declaration which already declared in section.h.

Link: https://lkml.kernel.org/r/20210930071143.63410-10-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
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
