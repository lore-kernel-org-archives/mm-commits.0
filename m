Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC06C433E9
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3920064F31
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhB0CcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhB0Cbu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:31:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E15E64F1F;
        Sat, 27 Feb 2021 02:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393069;
        bh=QHBVj11wQxVBRQTsa01iS/8cN6FIEfcIHOXHxn8+PZU=;
        h=Date:From:To:Subject:From;
        b=mWqBar0p/qJVxggVhKv4Niwpdl/GHionsJQ/BHDrLBsmizTmXsiaEPt/VI62isXHV
         4KjuSSg2mhfxwtsnXfLLOTDUTbL8pTJa75YLR2pjGtvfSkVFghnSmsPtbys7CGJATc
         3T3lYNWRHY7nZbSToO0YyA6YZPkYhui+6GuwUTKg=
Date:   Fri, 26 Feb 2021 18:31:09 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, gregkh@linuxfoundation.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, vbabka@suse.cz
Subject:  [merged] kasan-use-error_report_end-tracepoint.patch
 removed from -mm tree
Message-ID: <20210227023109.kOAnUXaMf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use error_report_end tracepoint
has been removed from the -mm tree.  Its filename was
     kasan-use-error_report_end-tracepoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


