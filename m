Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFC5C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D83320799
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbhAUWG0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 17:06:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726306AbhAUWF4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 17:05:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A67023A61;
        Thu, 21 Jan 2021 22:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611266716;
        bh=aLNGEBCPbgywTmRurkL1iLYoLUtlZfyC76HDvmCc738=;
        h=Date:From:To:Subject:From;
        b=fypiKgI7cK+0Mqvd1nn8fE9FevqOFJhEed8Z5e+E5rKnvrqhfi6WTRN5c90HQyzsi
         yRcAvzcBf5wtKe9JrMIyx4ZPM+TpLz/LByueiJROdTFsLgjnu6KjaqQGaiuzi/wGBm
         vgiIANZTnDg2bS84oRSVqT7lf2O7LuUC2uojOC6o=
Date:   Thu, 21 Jan 2021 14:05:14 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, gregkh@linuxfoundation.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, vbabka@suse.cz
Subject:  + kasan-use-error_report_end-tracepoint.patch added to
 -mm tree
Message-ID: <20210121220514.lnywtyEdr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use error_report_end tracepoint
has been added to the -mm tree.  Its filename is
     kasan-use-error_report_end-tracepoint.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-use-error_report_end-tracepoint.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-use-error_report_end-tracepoint.patch

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
Subject: kasan: use error_report_end tracepoint

Make it possible to trace KASAN error reporting.  A good usecase is
watching for trace events from the userspace to detect and process memory
corruption reports from the kernel.

Link: https://lkml.kernel.org/r/20210121131915.1331302-4-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/kasan/report.c~kasan-use-error_report_end-tracepoint
+++ a/mm/kasan/report.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/sched/task_stack.h>
 #include <linux/uaccess.h>
+#include <trace/events/error_report.h>
 
 #include <asm/sections.h>
 
@@ -84,8 +85,9 @@ static void start_report(unsigned long *
 	pr_err("==================================================================\n");
 }
 
-static void end_report(unsigned long *flags)
+static void end_report(unsigned long *flags, unsigned long addr)
 {
+	trace_error_report_end(ERROR_DETECTOR_KASAN, addr);
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
@@ -355,7 +357,7 @@ void kasan_report_invalid_free(void *obj
 	print_address_description(object, tag);
 	pr_err("\n");
 	print_memory_metadata(object);
-	end_report(&flags);
+	end_report(&flags, (unsigned long)object);
 }
 
 static void __kasan_report(unsigned long addr, size_t size, bool is_write,
@@ -401,7 +403,7 @@ static void __kasan_report(unsigned long
 		dump_stack();
 	}
 
-	end_report(&flags);
+	end_report(&flags, addr);
 }
 
 bool kasan_report(unsigned long addr, size_t size, bool is_write,
_

Patches currently in -mm which might be from glider@google.com are

mm-add-kernel-electric-fence-infrastructure.patch
x86-kfence-enable-kfence-for-x86.patch
mm-kfence-insert-kfence-hooks-for-slab.patch
mm-kfence-insert-kfence-hooks-for-slub.patch
kfence-kasan-make-kfence-compatible-with-kasan.patch
tracing-add-error_report_end-trace-point.patch
kfence-use-error_report_end-tracepoint.patch
kasan-use-error_report_end-tracepoint.patch

