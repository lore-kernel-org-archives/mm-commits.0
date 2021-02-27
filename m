Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16763C4332D
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9C2164F31
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhB0CcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhB0Cbr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:31:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89D1864F33;
        Sat, 27 Feb 2021 02:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393066;
        bh=5qCpOaRV48MSs0CnCNihJ9J7xkcDmpRgLmkfvn2v0OY=;
        h=Date:From:To:Subject:From;
        b=VY9oAKQ2h3hHXRxZFhJIARd17lfINn1V5yYzIY4kClNPVIbrYeVoqhZBToiXH1ctc
         gvHK8bYcEaMbuo+1KoV3hEzG0o7ewnXj3pkol7+BEdppNWmxX0QF74KEkomYUXmlnr
         LCnxFJC0Mjx1k8Q7M+uJn4QuKoZy1be81STxs+Aw=
Date:   Fri, 26 Feb 2021 18:31:06 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, gregkh@linuxfoundation.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, vbabka@suse.cz
Subject:  [merged] kfence-use-error_report_end-tracepoint.patch
 removed from -mm tree
Message-ID: <20210227023106.7ZX37THdK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: use error_report_end tracepoint
has been removed from the -mm tree.  Its filename was
     kfence-use-error_report_end-tracepoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from glider@google.com are


