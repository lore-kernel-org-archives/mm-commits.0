Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D5E0C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 655D261872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbhKKCza (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:58998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCz3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9559960F46;
        Thu, 11 Nov 2021 02:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599161;
        bh=uGoNaoa89QPl81Vyf5+8DtqeqN22lHg1KInDc6vWDpE=;
        h=Date:From:To:Subject:From;
        b=GtKm+aXUIlOMhlbOMqKJ6jCvHekBVr59mOz4hnMiJU09vCu7R+mv+ZHRsC0Mw7yRA
         Q/OGVquSMqNIm86KFOfmiKqgksP/4JuWDALoqC7c8GHsa6ky9CoHjhtA12p8c0+6nW
         PwiAmOgKy044TujoF/tuDJGf7M0ZDLv8VwokkNAs=
Date:   Wed, 10 Nov 2021 18:52:40 -0800
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
 sections-move-and-rename-core_kernel_data-to-is_kernel_core_data.patch
 removed from -mm tree
Message-ID: <20211111025240.W7T0BU2bI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sections: move and rename core_kernel_data() to is_kernel_core_data()
has been removed from the -mm tree.  Its filename was
     sections-move-and-rename-core_kernel_data-to-is_kernel_core_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: sections: move and rename core_kernel_data() to is_kernel_core_data()

Move core_kernel_data() into sections.h and rename it to
is_kernel_core_data(), also make it return bool value, then update all the
callers.

Link: https://lkml.kernel.org/r/20210930071143.63410-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dmitry Vyukov <dvyukov@google.com>
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

 include/asm-generic/sections.h |   16 ++++++++++++++++
 include/linux/kernel.h         |    1 -
 kernel/extable.c               |   18 ------------------
 kernel/trace/ftrace.c          |    2 +-
 net/sysctl_net.c               |    2 +-
 5 files changed, 18 insertions(+), 21 deletions(-)

--- a/include/asm-generic/sections.h~sections-move-and-rename-core_kernel_data-to-is_kernel_core_data
+++ a/include/asm-generic/sections.h
@@ -129,6 +129,22 @@ static inline bool init_section_intersec
 }
 
 /**
+ * is_kernel_core_data - checks if the pointer address is located in the
+ *			 .data section
+ *
+ * @addr: address to check
+ *
+ * Returns: true if the address is located in .data, false otherwise.
+ * Note: On some archs it may return true for core RODATA, and false
+ *       for others. But will always be true for core RW data.
+ */
+static inline bool is_kernel_core_data(unsigned long addr)
+{
+	return addr >= (unsigned long)_sdata &&
+	       addr < (unsigned long)_edata;
+}
+
+/**
  * is_kernel_rodata - checks if the pointer address is located in the
  *                    .rodata section
  *
--- a/include/linux/kernel.h~sections-move-and-rename-core_kernel_data-to-is_kernel_core_data
+++ a/include/linux/kernel.h
@@ -227,7 +227,6 @@ extern char *next_arg(char *args, char *
 
 extern int core_kernel_text(unsigned long addr);
 extern int init_kernel_text(unsigned long addr);
-extern int core_kernel_data(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
--- a/kernel/extable.c~sections-move-and-rename-core_kernel_data-to-is_kernel_core_data
+++ a/kernel/extable.c
@@ -82,24 +82,6 @@ int notrace core_kernel_text(unsigned lo
 	return 0;
 }
 
-/**
- * core_kernel_data - tell if addr points to kernel data
- * @addr: address to test
- *
- * Returns true if @addr passed in is from the core kernel data
- * section.
- *
- * Note: On some archs it may return true for core RODATA, and false
- *  for others. But will always be true for core RW data.
- */
-int core_kernel_data(unsigned long addr)
-{
-	if (addr >= (unsigned long)_sdata &&
-	    addr < (unsigned long)_edata)
-		return 1;
-	return 0;
-}
-
 int __kernel_text_address(unsigned long addr)
 {
 	if (kernel_text_address(addr))
--- a/kernel/trace/ftrace.c~sections-move-and-rename-core_kernel_data-to-is_kernel_core_data
+++ a/kernel/trace/ftrace.c
@@ -323,7 +323,7 @@ int __register_ftrace_function(struct ft
 	if (!ftrace_enabled && (ops->flags & FTRACE_OPS_FL_PERMANENT))
 		return -EBUSY;
 
-	if (!core_kernel_data((unsigned long)ops))
+	if (!is_kernel_core_data((unsigned long)ops))
 		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
 
 	add_ftrace_ops(&ftrace_ops_list, ops);
--- a/net/sysctl_net.c~sections-move-and-rename-core_kernel_data-to-is_kernel_core_data
+++ a/net/sysctl_net.c
@@ -144,7 +144,7 @@ static void ensure_safe_net_sysctl(struc
 		addr = (unsigned long)ent->data;
 		if (is_module_address(addr))
 			where = "module";
-		else if (core_kernel_data(addr))
+		else if (is_kernel_core_data(addr))
 			where = "kernel";
 		else
 			continue;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


