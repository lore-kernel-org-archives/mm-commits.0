Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05D6C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 22:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243736AbiCWWMy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 18:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241228AbiCWWMy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 18:12:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DA48F98B
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 15:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23ADE61743
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 22:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726E1C340E8;
        Wed, 23 Mar 2022 22:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648073482;
        bh=VIbdAssNc0vPo0jQh08STd4KALBn3HCTgQcCspp8j2M=;
        h=Date:To:From:Subject:From;
        b=HNF7ZmMQUY6VNEQaQemkVm8+X3j/vB2apwKc/FkE66BtnbLC1gsoNEHTLMsxtE3qv
         8Rep4CASdu5iJ1qxIPvOxV6g8RyP1g0Wlgfhjr5gcYiQq7HVgTjv5lbxEb4NWhaESv
         kny8Of/kfh9sDysHvQiF3ATSFqKy0QEUU0m8IQGs=
Date:   Wed, 23 Mar 2022 15:11:21 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        wangkefeng.wang@huawei.com, v.narang@samsung.com,
        swboyd@chromium.org, senozhatsky@chromium.org, rostedt@goodmis.org,
        pmladek@suse.com, ojeda@kernel.org, mcgrof@kernel.org,
        mbenes@suse.cz, linux@rasmusvillemoes.dk, catalin.marinas@arm.com,
        andriy.shevchenko@linux.intel.com, maninder1.s@samsung.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] kallsyms-print-module-name-in-%ps-s-case-when-kallsyms-is-disabled.patch removed from -mm tree
Message-Id: <20220323221122.726E1C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kallsyms: print module name in %ps/S case when KALLSYMS is disabled
has been removed from the -mm tree.  Its filename was
     kallsyms-print-module-name-in-%ps-s-case-when-kallsyms-is-disabled.patch

This patch was dropped because it is obsolete

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
Cc: Luis Chamberlain <mcgrof@kernel.org>
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


