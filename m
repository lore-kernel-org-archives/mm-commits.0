Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF39C433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64DF6613D9
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhEIAyf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 20:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEIAyf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 20:54:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E4DE60240;
        Sun,  9 May 2021 00:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620521612;
        bh=u7mYYOYRP9tqU8Y4hPn+ye+sq08IZ8alAz/ydNX0coM=;
        h=Date:From:To:Subject:From;
        b=TfOwt1OqNEFFgYKK386JToHmDaleS/3oHFw6FicyjpTi/fneEhut3ydiPOy2sM2Wx
         /L3SNSUIIQ1p7As1R6hP1z8XLH9H0+Famq/ebyry0EIzIoMm1Q3g3nMh1uyJiadvZ+
         7Vl8Wxgb/tb1g932ncWjY9f/jias50f51Q43hpfw=
Date:   Sat, 08 May 2021 17:53:31 -0700
From:   akpm@linux-foundation.org
To:     bo.he@intel.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mingo@kernel.org, mm-commits@vger.kernel.org,
        pmladek@suse.com, psodagud@quicinc.com, rostedt@goodmis.org,
        ryabinin.a.a@gmail.com, senozhatsky@chromium.org,
        yanmin_zhang@linux.intel.com
Subject:  + printk-introduce-dump_stack_lvl.patch added to -mm tree
Message-ID: <20210509005331.2RK5euUib%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: printk: introduce dump_stack_lvl()
has been added to the -mm tree.  Its filename is
     printk-introduce-dump_stack_lvl.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/printk-introduce-dump_stack_lvl.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/printk-introduce-dump_stack_lvl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: printk: introduce dump_stack_lvl()

dump_stack() is used for many different cases, which may require a log
level consistent with other kernel messages surrounding the dump_stack()
call.  Without that, certain systems that are configured to ignore the
default level messages will miss stack traces in critical error reports.

This patch introduces dump_stack_lvl() that behaves similarly to
dump_stack(), but accepts a custom log level.  The old dump_stack()
becomes equal to dump_stack_lvl(KERN_DEFAULT).

A somewhat similar patch has been proposed in 2012:
https://lore.kernel.org/lkml/1332493269.2359.9.camel@hebo/ , but wasn't
merged.

Link: https://lkml.kernel.org/r/20210506105405.3535023-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: he, bo <bo.he@intel.com>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: Prasad Sodagudi <psodagud@quicinc.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    1 +
 lib/dump_stack.c       |   20 +++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/include/linux/printk.h~printk-introduce-dump_stack_lvl
+++ a/include/linux/printk.h
@@ -206,6 +206,7 @@ void __init setup_log_buf(int early);
 __printf(1, 2) void dump_stack_set_arch_desc(const char *fmt, ...);
 void dump_stack_print_info(const char *log_lvl);
 void show_regs_print_info(const char *log_lvl);
+extern asmlinkage void dump_stack_lvl(const char *log_lvl) __cold;
 extern asmlinkage void dump_stack(void) __cold;
 extern void printk_safe_flush(void);
 extern void printk_safe_flush_on_panic(void);
--- a/lib/dump_stack.c~printk-introduce-dump_stack_lvl
+++ a/lib/dump_stack.c
@@ -73,10 +73,10 @@ void show_regs_print_info(const char *lo
 	dump_stack_print_info(log_lvl);
 }
 
-static void __dump_stack(void)
+static void __dump_stack(const char *log_lvl)
 {
-	dump_stack_print_info(KERN_DEFAULT);
-	show_stack(NULL, NULL, KERN_DEFAULT);
+	dump_stack_print_info(log_lvl);
+	show_stack(NULL, NULL, log_lvl);
 }
 
 /**
@@ -87,7 +87,7 @@ static void __dump_stack(void)
 #ifdef CONFIG_SMP
 static atomic_t dump_lock = ATOMIC_INIT(-1);
 
-asmlinkage __visible void dump_stack(void)
+asmlinkage __visible void dump_stack_lvl(const char *log_lvl)
 {
 	unsigned long flags;
 	int was_locked;
@@ -117,7 +117,7 @@ retry:
 		goto retry;
 	}
 
-	__dump_stack();
+	__dump_stack(log_lvl);
 
 	if (!was_locked)
 		atomic_set(&dump_lock, -1);
@@ -125,9 +125,15 @@ retry:
 	local_irq_restore(flags);
 }
 #else
-asmlinkage __visible void dump_stack(void)
+asmlinkage __visible void dump_stack_lvl(const char *log_lvl)
 {
-	__dump_stack();
+	__dump_stack(log_lvl);
 }
 #endif
+EXPORT_SYMBOL(dump_stack_lvl);
+
+asmlinkage __visible void dump_stack(void)
+{
+	dump_stack_lvl(KERN_DEFAULT);
+}
 EXPORT_SYMBOL(dump_stack);
_

Patches currently in -mm which might be from glider@google.com are

printk-introduce-dump_stack_lvl.patch
kasan-use-dump_stack_lvlkern_err-to-print-stacks.patch

