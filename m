Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092D0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 01:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9B64615E6
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 01:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344099AbhKPBGy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 20:06:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245377AbhKOTUZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27EE163467;
        Mon, 15 Nov 2021 18:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637001215;
        bh=ks93p6nOQ7ww9wnCvkcksmnFOPIKuHaRFgwoQMa+woo=;
        h=Date:From:To:Subject:From;
        b=jb9YyFAVRdAXQTFAUnbyftfeA3nOaKHcSoy7MTBBh446DvOKLpEoOkDJBc+HkwIzE
         n5nuUmrzjoj3LLZiC6ly0qgDEchnzG0ULiTmdn/tBSQMQsEZg7HKC3qpIRFz0G44z3
         iBNryd5vrwZtGnFrqvFqz05M7Yj6ZN5/kfsEj/NA=
Date:   Mon, 15 Nov 2021 10:33:34 -0800
From:   akpm@linux-foundation.org
To:     alex.popov@linux.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, elver@google.com, glider@google.com,
        john.ogness@linutronix.de, mcgrof@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        rppt@kernel.org, wei.liu@kernel.org
Subject:  + panic-use-error_report_end-tracepoint-on-warnings.patch
 added to -mm tree
Message-ID: <20211115183334.ADiGygGp3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: use error_report_end tracepoint on warnings
has been added to the -mm tree.  Its filename is
     panic-use-error_report_end-tracepoint-on-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/panic-use-error_report_end-tracepoint-on-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/panic-use-error_report_end-tracepoint-on-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: panic: use error_report_end tracepoint on warnings

Introduce the error detector "warning" to the error_report event and use
the error_report_end tracepoint at the end of a warning report.

This allows in-kernel tests but also userspace to more easily determine
if a warning occurred without polling kernel logs.

Link: https://lkml.kernel.org/r/20211115085630.1756817-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Popov <alex.popov@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/error_report.h |    8 +++++---
 kernel/panic.c                      |    2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/include/trace/events/error_report.h~panic-use-error_report_end-tracepoint-on-warnings
+++ a/include/trace/events/error_report.h
@@ -17,14 +17,16 @@
 
 enum error_detector {
 	ERROR_DETECTOR_KFENCE,
-	ERROR_DETECTOR_KASAN
+	ERROR_DETECTOR_KASAN,
+	ERROR_DETECTOR_WARN
 };
 
 #endif /* __ERROR_REPORT_DECLARE_TRACE_ENUMS_ONCE_ONLY */
 
-#define error_detector_list	\
+#define error_detector_list			\
 	EM(ERROR_DETECTOR_KFENCE, "kfence")	\
-	EMe(ERROR_DETECTOR_KASAN, "kasan")
+	EM(ERROR_DETECTOR_KASAN, "kasan")	\
+	EMe(ERROR_DETECTOR_WARN, "warning")
 /* Always end the list with an EMe. */
 
 #undef EM
--- a/kernel/panic.c~panic-use-error_report_end-tracepoint-on-warnings
+++ a/kernel/panic.c
@@ -32,6 +32,7 @@
 #include <linux/bug.h>
 #include <linux/ratelimit.h>
 #include <linux/debugfs.h>
+#include <trace/events/error_report.h>
 #include <asm/sections.h>
 
 #define PANIC_TIMER_STEP 100
@@ -609,6 +610,7 @@ void __warn(const char *file, int line,
 	print_irqtrace_events(current);
 
 	print_oops_end_marker();
+	trace_error_report_end(ERROR_DETECTOR_WARN, (unsigned long)caller);
 
 	/* Just a warning, don't kill lockdep. */
 	add_taint(taint, LOCKDEP_STILL_OK);
_

Patches currently in -mm which might be from elver@google.com are

panic-use-error_report_end-tracepoint-on-warnings.patch

