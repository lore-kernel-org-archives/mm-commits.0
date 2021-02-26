Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953B7C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A0E64EE2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhBZBXp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhBZBX2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:23:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFDA364F2F;
        Fri, 26 Feb 2021 01:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302559;
        bh=PIRKltMzDX6lIYu03elXo987LbwCwiie6L7C2qh3XIc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Rn3T/DutKgxnW/JhKprfyi8BNvPOiFTBHvaoEEL/WE3K72eoX40qZqmCwqRu1MSml
         Vg+EjVG6XyMPstOFL9cYx+nTTJ2q9bJggsTc4O+Pb213Lq0Hu+TkFojAUg0jxdJSnz
         DC8pHm9cPdlM0JNrieqcOEQpmKeKcQ5k+N7X4ATE=
Date:   Thu, 25 Feb 2021 17:22:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daniel.thompson@linaro.org,
        dianders@chromium.org, jason.wessel@windriver.com,
        linux-mm@kvack.org, mhiramat@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rostedt@goodmis.org, sumit.garg@linaro.org,
        torvalds@linux-foundation.org
Subject:  [patch 115/118] kgdb: fix to kill breakpoints on initmem
 after boot
Message-ID: <20210226012238.KcjJKp31i%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sumit Garg <sumit.garg@linaro.org>
Subject: kgdb: fix to kill breakpoints on initmem after boot

Currently breakpoints in kernel .init.text section are not handled
correctly while allowing to remove them even after corresponding pages
have been freed.

Fix it via killing .init.text section breakpoints just prior to initmem
pages being freed.

Doug: "HW breakpoints aren't handled by this patch but it's probably
not such a big deal".

Link: https://lkml.kernel.org/r/20210224081652.587785-1-sumit.garg@linaro.org
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Suggested-by: Doug Anderson <dianders@chromium.org>
Acked-by: Doug Anderson <dianders@chromium.org>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kgdb.h      |    2 ++
 init/main.c               |    1 +
 kernel/debug/debug_core.c |   11 +++++++++++
 3 files changed, 14 insertions(+)

--- a/include/linux/kgdb.h~kgdb-fix-to-kill-breakpoints-on-initmem-after-boot
+++ a/include/linux/kgdb.h
@@ -359,9 +359,11 @@ extern atomic_t			kgdb_active;
 extern bool dbg_is_early;
 extern void __init dbg_late_init(void);
 extern void kgdb_panic(const char *msg);
+extern void kgdb_free_init_mem(void);
 #else /* ! CONFIG_KGDB */
 #define in_dbg_master() (0)
 #define dbg_late_init()
 static inline void kgdb_panic(const char *msg) {}
+static inline void kgdb_free_init_mem(void) { }
 #endif /* ! CONFIG_KGDB */
 #endif /* _KGDB_H_ */
--- a/init/main.c~kgdb-fix-to-kill-breakpoints-on-initmem-after-boot
+++ a/init/main.c
@@ -1426,6 +1426,7 @@ static int __ref kernel_init(void *unuse
 	async_synchronize_full();
 	kprobe_free_init_mem();
 	ftrace_free_init_mem();
+	kgdb_free_init_mem();
 	free_initmem();
 	mark_readonly();
 
--- a/kernel/debug/debug_core.c~kgdb-fix-to-kill-breakpoints-on-initmem-after-boot
+++ a/kernel/debug/debug_core.c
@@ -455,6 +455,17 @@ setundefined:
 	return 0;
 }
 
+void kgdb_free_init_mem(void)
+{
+	int i;
+
+	/* Clear init memory breakpoints. */
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (init_section_contains((void *)kgdb_break[i].bpt_addr, 0))
+			kgdb_break[i].state = BP_UNDEFINED;
+	}
+}
+
 #ifdef CONFIG_KGDB_KDB
 void kdb_dump_stack_on_cpu(int cpu)
 {
_
