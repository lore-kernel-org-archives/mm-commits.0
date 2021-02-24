Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA26BC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 08:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E06064D74
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 08:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhBXI44 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 03:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231607AbhBXI44 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 03:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0760564D79;
        Wed, 24 Feb 2021 08:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614156975;
        bh=zrb3rqrWdbIrTVmtcnr6CsoRu/No2Y2eKfF6ZPueWoA=;
        h=Date:From:To:Subject:From;
        b=zA3P15ppyiOquvVAL+Y9TuuSC+80ysl5osUVoisnLI7GjdPfVVjkN6lNEvUy0GZB7
         83UrnPyvK3lxmcGXs/dVTfZlkFv1B/bt+rH+r9AXTVOZ5QqUTB0htv0C5IlWU3OR4I
         Nu9py8hQWMhPyzm66gQV2C0F/QAhBw1Wov0mAuyE=
Date:   Wed, 24 Feb 2021 00:56:14 -0800
From:   akpm@linux-foundation.org
To:     daniel.thompson@linaro.org, dianders@chromium.org,
        jason.wessel@windriver.com, mhiramat@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rostedt@goodmis.org, sumit.garg@linaro.org
Subject:  +
 kgdb-fix-to-kill-breakpoints-on-initmem-after-boot.patch added to -mm tree
Message-ID: <20210224085614.PZv0UvHTW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kgdb: fix to kill breakpoints on initmem after boot
has been added to the -mm tree.  Its filename is
     kgdb-fix-to-kill-breakpoints-on-initmem-after-boot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kgdb-fix-to-kill-breakpoints-on-initmem-after-boot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kgdb-fix-to-kill-breakpoints-on-initmem-after-boot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sumit Garg <sumit.garg@linaro.org>
Subject: kgdb: fix to kill breakpoints on initmem after boot

Currently breakpoints in kernel .init.text section are not handled
correctly while allowing to remove them even after corresponding pages
have been freed.

Fix it via killing .init.text section breakpoints just prior to initmem
pages being freed.

Link: https://lkml.kernel.org/r/20210224081652.587785-1-sumit.garg@linaro.org
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Suggested-by: Doug Anderson <dianders@chromium.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
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
@@ -1428,6 +1428,7 @@ static int __ref kernel_init(void *unuse
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

Patches currently in -mm which might be from sumit.garg@linaro.org are

kgdb-fix-to-kill-breakpoints-on-initmem-after-boot.patch

