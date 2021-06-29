Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F098BC11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D946561D13
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhF2Cm6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2Cm6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77FF461D0C;
        Tue, 29 Jun 2021 02:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934430;
        bh=my3oSbLjGzoJueqZAXcoiBN1OEWQvjUNyNR4NpH8q7E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Nmd3QUMIHK2wnPDRFvDBOO4G2WdK7RS6FsI7JFMO21lHHoru0wqeePw80/l9Q/pix
         0y0+J+h6vsfXu300i5OJQNjp9ZaxaRD2hg4X70TNXpjW4Q/Dg7M7tHMS2KCbwOMKB9
         ydQ/iET3WtZAfbjiDiusSEW3IslBH1oGIjZTW4ns=
Date:   Mon, 28 Jun 2021 19:40:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bo.he@intel.com, dvyukov@google.com,
        elver@google.com, glider@google.com, linux-mm@kvack.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, pmladek@suse.com,
        psodagud@quicinc.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com,
        senozhatsky@chromium.org, torvalds@linux-foundation.org,
        yanmin_zhang@linux.intel.com
Subject:  [patch 138/192] printk: introduce dump_stack_lvl()
Message-ID: <20210629024030.7_lNcozaJ%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

[elver@google.com: add missing dump_stack_lvl() stub if CONFIG_PRINTK=n]
  Link: https://lkml.kernel.org/r/YJ0KAM0hQev1AmWe@elver.google.com
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

 include/linux/printk.h |    5 +++++
 lib/dump_stack.c       |   20 +++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

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
@@ -269,6 +270,10 @@ static inline void show_regs_print_info(
 {
 }
 
+static inline void dump_stack_lvl(const char *log_lvl)
+{
+}
+
 static inline void dump_stack(void)
 {
 }
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
