Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74588C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EB976134F
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhKICgs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:36:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236255AbhKICgs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8EB661242;
        Tue,  9 Nov 2021 02:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425243;
        bh=3UJXY11dU5WfKmOiGxjUd//EJ3W2u2+TaJwAfJ6KdSc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DlI6npCpbdO75Xq8wMdCM+UvQ6DqLWfXm2KPdVCC50W6YUaBFkKll4i627F6RoUCh
         iCBzSx0PtI7ad0yeYlkzw7qoa1UI1nSMyt3Wm0vrcg/L/VCSvYdGilPh/Inrdlu6HD
         2wTG5HAk1Ad2tJLIeyE9/S/ELfJ4IgrTQHy055Eg=
Date:   Mon, 08 Nov 2021 18:34:02 -0800
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
Subject:  [patch 49/87] sections: provide internal __is_kernel()
 and __is_kernel_text() helper
Message-ID: <20211109023402.kPswBI3uu%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
