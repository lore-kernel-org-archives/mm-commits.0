Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25BFC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E3F26162E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhKKCzj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D8616103C;
        Thu, 11 Nov 2021 02:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599170;
        bh=NJ4A6q2cfuxVhlplYVOTq4ac1g5avuRNncSyMAY4WE0=;
        h=Date:From:To:Subject:From;
        b=U40sCIyBDxGL3mYQyJGUEFPaKunWqhDjVyiHO4swjkXw3xNAXJ6usYcEEc3fBEQfq
         2G9M/UhBIOcYbYSlxq0jFmie3/FNqqzVlQtwJHifqM7r8Isde8zb3/1ZImJ42BnnLL
         i7uORfm7LTRRyA2IbJpx+SUpRg+ZiN7gXr6Agl2k=
Date:   Wed, 10 Nov 2021 18:52:49 -0800
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
 sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch
 removed from -mm tree
Message-ID: <20211111025249.TDRqgDoxf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sections: provide internal __is_kernel() and __is_kernel_text() helper
has been removed from the -mm tree.  Its filename was
     sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: sections: provide internal __is_kernel() and __is_kernel_text() helper

An internal __is_kernel() helper which only check the kernel address
ranges, and an internal __is_kernel_text() helper which only check text
section ranges.

Link: https://lkml.kernel.org/r/20210930071143.63410-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
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
Cc: Michal Simek <monstr@monstr.eu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/sections.h |   29 +++++++++++++++++++++++++++++
 include/linux/kallsyms.h       |    4 ++--
 2 files changed, 31 insertions(+), 2 deletions(-)

--- a/include/asm-generic/sections.h~sections-provide-internal-__is_kernel-and-__is_kernel_text-helper
+++ a/include/asm-generic/sections.h
@@ -172,4 +172,33 @@ static inline bool is_kernel_inittext(un
 	       addr < (unsigned long)_einittext;
 }
 
+/**
+ * __is_kernel_text - checks if the pointer address is located in the
+ *                    .text section
+ *
+ * @addr: address to check
+ *
+ * Returns: true if the address is located in .text, false otherwise.
+ * Note: an internal helper, only check the range of _stext to _etext.
+ */
+static inline bool __is_kernel_text(unsigned long addr)
+{
+	return addr >= (unsigned long)_stext &&
+	       addr < (unsigned long)_etext;
+}
+
+/**
+ * __is_kernel - checks if the pointer address is located in the kernel range
+ *
+ * @addr: address to check
+ *
+ * Returns: true if the address is located in the kernel range, false otherwise.
+ * Note: an internal helper, only check the range of _stext to _end.
+ */
+static inline bool __is_kernel(unsigned long addr)
+{
+	return addr >= (unsigned long)_stext &&
+	       addr < (unsigned long)_end;
+}
+
 #endif /* _ASM_GENERIC_SECTIONS_H_ */
--- a/include/linux/kallsyms.h~sections-provide-internal-__is_kernel-and-__is_kernel_text-helper
+++ a/include/linux/kallsyms.h
@@ -26,14 +26,14 @@ struct module;
 
 static inline int is_kernel_text(unsigned long addr)
 {
-	if ((addr >= (unsigned long)_stext && addr < (unsigned long)_etext))
+	if (__is_kernel_text(addr))
 		return 1;
 	return in_gate_area_no_mm(addr);
 }
 
 static inline int is_kernel(unsigned long addr)
 {
-	if (addr >= (unsigned long)_stext && addr < (unsigned long)_end)
+	if (__is_kernel(addr))
 		return 1;
 	return in_gate_area_no_mm(addr);
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


