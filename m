Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B09C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECF1861A70
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349601AbhI3VYD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 17:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349614AbhI3VXv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 17:23:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2214161A55;
        Thu, 30 Sep 2021 21:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633036928;
        bh=hLQKcy9pOAhVpZl2rjK0O08gMdXTPVa1hYxt0q9QU+4=;
        h=Date:From:To:Subject:From;
        b=ZetBnlQWuUW4hZZ2QARgImegZ+7XeQc8TcWnABEQJz8b8nZeH0+q/1bIOp9UHZvpY
         ZGE3HhDY5RMx0jb/QHinwT0FacdqNbXmL1hnG4QB5bXR+WJt7Wx1CWZeJvWi2BgX5l
         JqDTWlhO09ciyVEYhyYVs4UXXgVUnZeUHAn14RL4=
Date:   Thu, 30 Sep 2021 14:22:07 -0700
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
Subject:  +
 sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch
 added to -mm tree
Message-ID: <20210930212207.cCV-50zHt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sections: provide internal __is_kernel() and __is_kernel_text() helper
has been added to the -mm tree.  Its filename is
     sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: sections: provide internal __is_kernel() and __is_kernel_text() helper

An internal __is_kernel() helper which only check the kernel address
ranges, and an internal __is_kernel_text() helper which only check text
section ranges.

Link: https://lkml.kernel.org/r/20210930071143.63410-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
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
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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

slub-add-back-check-for-free-nonslab-objects.patch
mm-nommu-kill-arch_get_unmapped_area.patch
kallsyms-remove-arch-specific-text-and-data-check.patch
kallsyms-fix-address-checks-for-kernel-related-range.patch
sections-move-and-rename-core_kernel_data-to-is_kernel_core_data.patch
sections-move-is_kernel_inittext-into-sectionsh.patch
x86-mm-rename-__is_kernel_text-to-is_x86_32_kernel_text.patch
sections-provide-internal-__is_kernel-and-__is_kernel_text-helper.patch
mm-kasan-use-is_kernel-helper.patch
extable-use-is_kernel_text-helper.patch
powerpc-mm-use-core_kernel_text-helper.patch
microblaze-use-is_kernel_text-helper.patch
alpha-use-is_kernel_text-helper.patch

