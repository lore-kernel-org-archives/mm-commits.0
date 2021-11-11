Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C40C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42AF561250
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhKKCzd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:59054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 943A861452;
        Thu, 11 Nov 2021 02:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599164;
        bh=c2SdSx6mAyuH7ZZWGutgDipI30Nwug+znlItBBVKrLg=;
        h=Date:From:To:Subject:From;
        b=HSipkbnQhAKn8TMzTf18MidkCif4nSx+ZJMgC6lN2ecrWQqdFJC4B/bnTzsMu0i7z
         VHeF45dfWCSut2DQ1TtqUBHG5MPvlVQrksB5nuq3+tmXIlHwDrbEq7eFqMQSw/LSgk
         AmCoyKphfKUnmsHytVx0e6X0xnG6XBI4CFD/JyiA=
Date:   Wed, 10 Nov 2021 18:52:43 -0800
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
 sections-move-is_kernel_inittext-into-sectionsh.patch removed from -mm tree
Message-ID: <20211111025243.43-SaVphP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sections: move is_kernel_inittext() into sections.h
has been removed from the -mm tree.  Its filename was
     sections-move-is_kernel_inittext-into-sectionsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: sections: move is_kernel_inittext() into sections.h

The is_kernel_inittext() and init_kernel_text() are with same
functionality, let's just keep is_kernel_inittext() and move it into
sections.h, then update all the callers.

Link: https://lkml.kernel.org/r/20210930071143.63410-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
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
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/unwind_orc.c   |    2 +-
 include/asm-generic/sections.h |   14 ++++++++++++++
 include/linux/kallsyms.h       |    8 --------
 include/linux/kernel.h         |    1 -
 kernel/extable.c               |   12 ++----------
 5 files changed, 17 insertions(+), 20 deletions(-)

--- a/arch/x86/kernel/unwind_orc.c~sections-move-is_kernel_inittext-into-sectionsh
+++ a/arch/x86/kernel/unwind_orc.c
@@ -175,7 +175,7 @@ static struct orc_entry *orc_find(unsign
 	}
 
 	/* vmlinux .init slow lookup: */
-	if (init_kernel_text(ip))
+	if (is_kernel_inittext(ip))
 		return __orc_find(__start_orc_unwind_ip, __start_orc_unwind,
 				  __stop_orc_unwind_ip - __start_orc_unwind_ip, ip);
 
--- a/include/asm-generic/sections.h~sections-move-is_kernel_inittext-into-sectionsh
+++ a/include/asm-generic/sections.h
@@ -158,4 +158,18 @@ static inline bool is_kernel_rodata(unsi
 	       addr < (unsigned long)__end_rodata;
 }
 
+/**
+ * is_kernel_inittext - checks if the pointer address is located in the
+ *                      .init.text section
+ *
+ * @addr: address to check
+ *
+ * Returns: true if the address is located in .init.text, false otherwise.
+ */
+static inline bool is_kernel_inittext(unsigned long addr)
+{
+	return addr >= (unsigned long)_sinittext &&
+	       addr < (unsigned long)_einittext;
+}
+
 #endif /* _ASM_GENERIC_SECTIONS_H_ */
--- a/include/linux/kallsyms.h~sections-move-is_kernel_inittext-into-sectionsh
+++ a/include/linux/kallsyms.h
@@ -24,14 +24,6 @@
 struct cred;
 struct module;
 
-static inline int is_kernel_inittext(unsigned long addr)
-{
-	if (addr >= (unsigned long)_sinittext
-	    && addr < (unsigned long)_einittext)
-		return 1;
-	return 0;
-}
-
 static inline int is_kernel_text(unsigned long addr)
 {
 	if ((addr >= (unsigned long)_stext && addr < (unsigned long)_etext))
--- a/include/linux/kernel.h~sections-move-is_kernel_inittext-into-sectionsh
+++ a/include/linux/kernel.h
@@ -226,7 +226,6 @@ extern bool parse_option_str(const char
 extern char *next_arg(char *args, char **param, char **val);
 
 extern int core_kernel_text(unsigned long addr);
-extern int init_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
--- a/kernel/extable.c~sections-move-is_kernel_inittext-into-sectionsh
+++ a/kernel/extable.c
@@ -62,14 +62,6 @@ const struct exception_table_entry *sear
 	return e;
 }
 
-int init_kernel_text(unsigned long addr)
-{
-	if (addr >= (unsigned long)_sinittext &&
-	    addr < (unsigned long)_einittext)
-		return 1;
-	return 0;
-}
-
 int notrace core_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_stext &&
@@ -77,7 +69,7 @@ int notrace core_kernel_text(unsigned lo
 		return 1;
 
 	if (system_state < SYSTEM_FREEING_INITMEM &&
-	    init_kernel_text(addr))
+	    is_kernel_inittext(addr))
 		return 1;
 	return 0;
 }
@@ -94,7 +86,7 @@ int __kernel_text_address(unsigned long
 	 * Since we are after the module-symbols check, there's
 	 * no danger of address overlap:
 	 */
-	if (init_kernel_text(addr))
+	if (is_kernel_inittext(addr))
 		return 1;
 	return 0;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


