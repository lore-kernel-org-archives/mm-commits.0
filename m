Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9469BC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84E8161350
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbhKICgh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:36:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236411AbhKICgh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69FA760FDA;
        Tue,  9 Nov 2021 02:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425232;
        bh=z++KKNdmEeQGAC0gz082/AzbkFM2U+LcHISTekBiDcQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Zi/Pqx+j6xZNRDxkqU2M757VQG0ZtlumvFwnOoPlwkSdMckdMl1FOXorSi3X229Fi
         4B5dsgfmJfW3XR5k/H1+nd5tWGRZVz9ldyIe2ipcrmHiua8+auGlnZifQaKTgZaJI1
         0zqsdu5JaLnTeuRG7XrVloV3hGV63KdbDmWqGqoI=
Date:   Mon, 08 Nov 2021 18:33:51 -0800
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
Subject:  [patch 46/87] sections: move and rename
 core_kernel_data() to is_kernel_core_data()
Message-ID: <20211109023351.3dOksI0WC%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
