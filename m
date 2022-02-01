Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0697DC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 21:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiBAV2U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiBAV2T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 16:28:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A20C061714
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 13:28:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D82F06178D
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 21:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9341C340EC;
        Tue,  1 Feb 2022 21:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643750898;
        bh=BDOUPfVX2SYm1qIQHwrmtyDco1vtGZUoKtr5K6c2+5c=;
        h=Date:To:From:Subject:From;
        b=JNlMhoQoX0tpAC/pV/SF9MmC2IoflzgRDrw4x5sfjne6hy6looqsmXvb0rSNbs6NI
         FJhJI/9TDkfyEhaSstY4gXuRSKb5ObJ9XtTEiQAGSJLvIFl6xpSSKry93oZAKoT1oG
         cHL03+uCLAyV3pnmCbPPnXKnpDx+HzE05xiai5a4=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 13:28:16 -0800
Date:   Tue, 01 Feb 2022 13:28:16 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org,
        wangkefeng.wang@huawei.com, v.narang@samsung.com,
        swboyd@chromium.org, senozhatsky@chromium.org, rostedt@goodmis.org,
        pmladek@suse.com, ojeda@kernel.org, mbenes@suse.cz,
        linux@rasmusvillemoes.dk, catalin.marinas@arm.com,
        andriy.shevchenko@linux.intel.com, maninder1.s@samsung.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-print-module-name-in-%ps-s-case-when-kallsyms-is-disabled.patch added to -mm tree
Message-Id: <20220201212816.C9341C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kallsyms: print module name in %ps/S case when KALLSYMS is disabled
has been added to the -mm tree.  Its filename is
     kallsyms-print-module-name-in-%ps-s-case-when-kallsyms-is-disabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kallsyms-print-module-name-in-%25ps-s-case-when-kallsyms-is-disabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kallsyms-print-module-name-in-%25ps-s-case-when-kallsyms-is-disabled.patch

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
Subject: kallsyms: print module name in %ps/S case when KALLSYMS is disabled

original:
With KALLSYMS
                   %pS                               %ps
[16.4200]  hello_init+0x0/0x24 [crash]        hello_init [crash]

Without KALLSYMS:
[16.2200]      0xbe200040                         0xbe200040

With Patch (Without KALLSYMS:) load address + current offset [Module Name]

[13.5993]  0xbe200000+0x40 [crash]           0xbe200000+0x40 [crash]

It will help in better debugging and checking when KALLSYMS is disabled,
user will get information about module name and load address of module.

verified for arm64:
/ # insmod /crash.ko

[   19.263556] 0xffff800000ec0000+0x38 [crash]

..

[   19.276023] Call trace:
[   19.276277]  0xffff800000ec0000+0x28 [crash]
[   19.276567]  0xffff800000ec0000+0x58 [crash]
[   19.276727]  0xffff800000ec0000+0x74 [crash]
[   19.276866]  0xffff8000080127d0
[   19.276978]  0xffff80000812d95c
[   19.277085]  0xffff80000812f554

Link: https://lkml.kernel.org/r/20220201040044.1528568-1-maninder1.s@samsung.com
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
Co-developed-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |   27 +++++++++++++++++++++++++++
 lib/vsprintf.c           |    5 +++--
 2 files changed, 30 insertions(+), 2 deletions(-)

--- a/include/linux/kallsyms.h~kallsyms-print-module-name-in-%ps-s-case-when-kallsyms-is-disabled
+++ a/include/linux/kallsyms.h
@@ -163,6 +163,33 @@ static inline bool kallsyms_show_value(c
 	return false;
 }
 
+#ifdef CONFIG_MODULES
+static inline int fill_minimal_module_info(char *sym, int size, unsigned long value)
+{
+	struct module *mod;
+	unsigned long offset;
+	int ret = 0;
+
+	preempt_disable();
+	mod = __module_address(value);
+	if (mod) {
+		offset = value - (unsigned long)mod->core_layout.base;
+		snprintf(sym, size - 1, "0x%lx+0x%lx [%s]",
+				(unsigned long)mod->core_layout.base, offset, mod->name);
+
+		sym[size - 1] = '\0';
+		ret = 1;
+	}
+
+	preempt_enable();
+	return ret;
+}
+#else
+static inline int fill_minimal_module_info(char *sym, int size, unsigned long value)
+{
+	return 0;
+}
+#endif /*CONFIG_MODULES*/
 #endif /*CONFIG_KALLSYMS*/
 
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
--- a/lib/vsprintf.c~kallsyms-print-module-name-in-%ps-s-case-when-kallsyms-is-disabled
+++ a/lib/vsprintf.c
@@ -984,9 +984,7 @@ char *symbol_string(char *buf, char *end
 		    struct printf_spec spec, const char *fmt)
 {
 	unsigned long value;
-#ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-#endif
 
 	if (fmt[1] == 'R')
 		ptr = __builtin_extract_return_addr(ptr);
@@ -1006,6 +1004,9 @@ char *symbol_string(char *buf, char *end
 
 	return string_nocheck(buf, end, sym, spec);
 #else
+	if (fill_minimal_module_info(sym, KSYM_SYMBOL_LEN, value))
+		return string_nocheck(buf, end, sym, spec);
+
 	return special_hex_number(buf, end, value, sizeof(void *));
 #endif
 }
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

kallsyms-print-module-name-in-%ps-s-case-when-kallsyms-is-disabled.patch

