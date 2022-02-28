Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0CDC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 06:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiB1GNt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 01:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiB1GNt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 01:13:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D9413CC9
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 22:13:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED34460FC0
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 06:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AB5C340E7;
        Mon, 28 Feb 2022 06:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646028789;
        bh=WJ4Xjb9N0yqm+xLMjq+yvaD+xUhNzW9lWCTuVl1fwI8=;
        h=Date:To:From:Subject:From;
        b=bzWECR6b8imQHYMIHmdK24K+mN2OEQDJ782cjjyRR6peG9Ztd9sGvyKD3MYdZg34L
         2CYG1uRP2IluYGLtD8y5nsskkREgL/a3D142vZ9nfZE929q6S7UDKzZ/ayzQQivfYM
         0VQNLZ9PTpLSVogFvYk3E+aaGElCzMBzWtGYeKOs=
Date:   Sun, 27 Feb 2022 22:13:08 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        v.narang@samsung.com, swboyd@chromium.org,
        senozhatsky@chromium.org, rostedt@goodmis.org, pmladek@suse.com,
        ojeda@kernel.org, mcgrof@kernel.org, linux@rasmusvillemoes.dk,
        atomlin@redhat.com, andriy.shevchenko@linux.intel.com,
        maninder1.s@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled.patch added to -mm tree
Message-Id: <20220228061309.44AB5C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kallsyms: enhance %pS/s/b printing when KALLSYSMS is disabled
has been added to the -mm tree.  Its filename is
     kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: kallsyms: enhance %pS/s/b printing when KALLSYSMS is disabled

with commit '82b37e632513 ("kallsyms: print module name in %ps/S
case when KALLSYMS is disabled"), module name printing was enhanced.

As per suggestion from Petr Mladek <pmladek@suse.com>, covering
other flavours also to print build id also.

for %pB no change as it needs to know symbol name to adjust address
value which can't be done without KALLSYMS.

original output with KALLSYMS:
[8.842129] ps function_1 [crash]
[8.842735] pS function_1+0x4/0x2c [crash]
[8.842890] pSb function_1+0x4/0x2c [crash b367e79021b9f3b0172f9a36d4261c1f528ca1b3]
[8.843175] pB function_1+0x4/0x2c [crash]
[8.843362] pBb function_1+0x4/0x2c [crash b367e79021b9f3b0172f9a36d4261c1f528ca1b3]

original output without KALLSYMS:
[12.487424] ps 0xffff800000eb008c
[12.487598] pS 0xffff800000eb008c
[12.487723] pSb 0xffff800000eb008c
[12.487850] pB 0xffff800000eb008c
[12.487967] pBb 0xffff800000eb008c

With patched kernel without KALLSYMS:
[9.205207] ps 0xffff800000eb008c [crash]
[9.205564] pS 0xffff800000eb0000+0x8c [crash]
[9.205757] pSb 0xffff800000eb0000+0x8c [crash b367e79021b9f3b0172f9a36d4261c1f528ca1b3]
[9.206066] pB 0xffff800000eb0000+0x8c [crash]
[9.206257] pBb 0xffff800000eb0000+0x8c [crash b367e79021b9f3b0172f9a36d4261c1f528ca1b3]

Link: https://lkml.kernel.org/r/20220228053447.1584704-1-maninder1.s@samsung.com
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Co-developed-by: Vaneet Narang <v.narang@samsung.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |   27 -------------
 kernel/module.c          |    4 -
 lib/vsprintf.c           |   76 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 76 insertions(+), 31 deletions(-)

--- a/include/linux/kallsyms.h~kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled
+++ a/include/linux/kallsyms.h
@@ -163,33 +163,6 @@ static inline bool kallsyms_show_value(c
 	return false;
 }
 
-#ifdef CONFIG_MODULES
-static inline int fill_minimal_module_info(char *sym, int size, unsigned long value)
-{
-	struct module *mod;
-	unsigned long offset;
-	int ret = 0;
-
-	preempt_disable();
-	mod = __module_address(value);
-	if (mod) {
-		offset = value - (unsigned long)mod->core_layout.base;
-		snprintf(sym, size - 1, "0x%lx+0x%lx [%s]",
-				(unsigned long)mod->core_layout.base, offset, mod->name);
-
-		sym[size - 1] = '\0';
-		ret = 1;
-	}
-
-	preempt_enable();
-	return ret;
-}
-#else
-static inline int fill_minimal_module_info(char *sym, int size, unsigned long value)
-{
-	return 0;
-}
-#endif /*CONFIG_MODULES*/
 #endif /*CONFIG_KALLSYMS*/
 
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
--- a/kernel/module.c~kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled
+++ a/kernel/module.c
@@ -1465,12 +1465,10 @@ resolve_symbol_wait(struct module *mod,
 	return ksym;
 }
 
-#ifdef CONFIG_KALLSYMS
 static inline bool sect_empty(const Elf_Shdr *sect)
 {
 	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
 }
-#endif
 
 /*
  * /sys/module/foo/sections stuff
@@ -2799,7 +2797,7 @@ static void add_kallsyms(struct module *
 }
 #endif /* CONFIG_KALLSYMS */
 
-#if IS_ENABLED(CONFIG_KALLSYMS) && IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
 static void init_build_id(struct module *mod, const struct load_info *info)
 {
 	const Elf_Shdr *sechdr;
--- a/lib/vsprintf.c~kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled
+++ a/lib/vsprintf.c
@@ -979,6 +979,80 @@ char *bdev_name(char *buf, char *end, st
 }
 #endif
 
+#if !defined(CONFIG_KALLSYMS) && defined(CONFIG_MODULES)
+static int sprint_module_info(char *buf, char *end, unsigned long value,
+			     const char *fmt)
+{
+	struct module *mod;
+	unsigned long offset = 1;
+	unsigned long base;
+	int ret = 0;
+	const char *modname;
+	int modbuildid = 0;
+	int len;
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
+	const unsigned char *buildid = NULL;
+#endif
+
+	if (is_ksym_addr(value))
+		return 0;
+
+	if (*fmt == 'B' && fmt[1] == 'b')
+		modbuildid = 1;
+	else if (*fmt == 'S' && (fmt[1] == 'b' || (fmt[1] == 'R' && fmt[2] == 'b')))
+		modbuildid = 1;
+	else if (*fmt != 's') {
+		/*
+		 * do nothing.
+		 */
+	} else
+		offset = 0;
+
+	preempt_disable();
+	mod = __module_address(value);
+	if (mod) {
+		ret = 1;
+		modname = mod->name;
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
+		if (modbuildid)
+			buildid = mod->build_id;
+#endif
+		if (offset) {
+			base = (unsigned long)mod->core_layout.base;
+			offset = value - base;
+		}
+	}
+
+	preempt_enable();
+	if (!ret)
+		return 0;
+
+	/* address belongs to module */
+	if (offset)
+		len = sprintf(buf, "0x%lx+0x%lx", base, offset);
+	else
+		len = sprintf(buf, "0x%lx", value);
+
+	len += sprintf(buf + len, " [%s", modname);
+#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
+	if (modbuildid && buildid) {
+		/* build ID should match length of sprintf */
+		static_assert(sizeof(typeof_member(struct module, build_id)) == 20);
+		len += sprintf(buf + len, " %20phN", buildid);
+	}
+#endif
+	len += sprintf(buf + len, "]");
+
+	return len;
+}
+#else
+static inline int sprint_module_info(char *buf, char *end, unsigned long value,
+			     const char *fmt)
+{
+	return 0;
+}
+#endif
+
 static noinline_for_stack
 char *symbol_string(char *buf, char *end, void *ptr,
 		    struct printf_spec spec, const char *fmt)
@@ -1004,7 +1078,7 @@ char *symbol_string(char *buf, char *end
 
 	return string_nocheck(buf, end, sym, spec);
 #else
-	if (fill_minimal_module_info(sym, KSYM_SYMBOL_LEN, value))
+	if (sprint_module_info(sym, end, value, fmt))
 		return string_nocheck(buf, end, sym, spec);
 
 	return special_hex_number(buf, end, value, sizeof(void *));
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

kallsyms-print-module-name-in-%ps-s-case-when-kallsyms-is-disabled.patch
kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled.patch

