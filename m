Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779ADC4332D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AC6A64F14
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhBZBUG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhBZBUE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:20:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F06B64F2A;
        Fri, 26 Feb 2021 01:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302389;
        bh=/j3GQ5gE/sRa1CKC+gCcNAg/ncAnjBKCm1yVIYvaiXU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AQXJhQaOZLXEnh5BaQQ8wZhzit4pQVL/GfwlS1/Pz5N3I2t3GBbXDj9pxCkY3IALA
         Q1uOauL9rm7qv28v1TUl8UcX1P/bE7krikYX3Rdne+dqfi9cmu17eppU/sfdszdm5U
         IGKkA81WdpxQtXgosp1e4pXHWJupfeL0MkN8djU0=
Date:   Thu, 25 Feb 2021 17:19:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 068/118] kfence: use error_report_end tracepoint
Message-ID: <20210226011947.q-ylOvRJZ%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexander Potapenko <glider@google.com>
Subject: kfence: use error_report_end tracepoint

Make it possible to trace KFENCE error reporting.  A good usecase is
watching for trace events from the userspace to detect and process memory
corruption reports from the kernel.

Link: https://lkml.kernel.org/r/20210121131915.1331302-3-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/report.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kfence/report.c~kfence-use-error_report_end-tracepoint
+++ a/mm/kfence/report.c
@@ -14,6 +14,7 @@
 #include <linux/seq_file.h>
 #include <linux/stacktrace.h>
 #include <linux/string.h>
+#include <trace/events/error_report.h>
 
 #include <asm/kfence.h>
 
@@ -248,6 +249,7 @@ void kfence_report_error(unsigned long a
 		show_regs(regs);
 	else
 		dump_stack_print_info(KERN_ERR);
+	trace_error_report_end(ERROR_DETECTOR_KFENCE, address);
 	pr_err("==================================================================\n");
 
 	lockdep_on();
_
