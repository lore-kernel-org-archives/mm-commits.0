Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F2DC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C924823A63
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbhAUWF6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 17:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbhAUWFz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 17:05:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CEA323A60;
        Thu, 21 Jan 2021 22:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611266712;
        bh=+aIOkypEINHPSGyBRUhgkDRuHHs8VDef4Kn/NMNbkFU=;
        h=Date:From:To:Subject:From;
        b=1epLn07CS3bOIpXaGzOQ2X9CyvSbErS8mzNZJV7YZgMzASbZfrpIHuauhRVteayJe
         WjdMCg7E25PC+s4s6S0Ri+TYRMDEkqrbrRiJTkQMADQzUQzx+cOae9I15GJrNdgMhV
         dB7reYrY5yz6BlAflIjwIjo3LsO8VdjxKeEltYok=
Date:   Thu, 21 Jan 2021 14:05:10 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, gregkh@linuxfoundation.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, vbabka@suse.cz
Subject:  + kfence-use-error_report_end-tracepoint.patch added to
 -mm tree
Message-ID: <20210121220510.nO_M-KIME%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: use error_report_end tracepoint
has been added to the -mm tree.  Its filename is
     kfence-use-error_report_end-tracepoint.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-use-error_report_end-tracepoint.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-use-error_report_end-tracepoint.patch

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
 
@@ -246,6 +247,7 @@ void kfence_report_error(unsigned long a
 		show_regs(regs);
 	else
 		dump_stack_print_info(KERN_ERR);
+	trace_error_report_end(ERROR_DETECTOR_KFENCE, address);
 	pr_err("==================================================================\n");
 
 	lockdep_on();
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

