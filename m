Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C07C43219
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377942AbiATVbY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377944AbiATVbY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A80C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:31:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6E1B618CD
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EE5C340E3;
        Thu, 20 Jan 2022 21:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714283;
        bh=YxBZADMnL4RIn6M0k7LktMazCWEfgtVmf+oBpnvdWyg=;
        h=Date:From:To:Subject:From;
        b=nvqSejvh2vLk071Pq5MLQ5Pucxk2js+ew/SQy2O7TkFGlZRNfNxm7PF828CFa8Ghm
         x4Q9Yl6UmCTxUtdu4RRNUlC2ae9VVWgC2+InuAMVjQWJTqSlTKcpYw3KK5PaXX7aQc
         x3QBcu1J7Rbu//uqFVFdRdiO1h1b2FBYhKCp9uU0=
Date:   Thu, 20 Jan 2022 13:31:22 -0800
From:   akpm@linux-foundation.org
To:     alex.popov@linux.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, elver@google.com, glider@google.com,
        john.ogness@linutronix.de, mcgrof@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        rppt@kernel.org, wei.liu@kernel.org
Subject:  [merged]
 panic-use-error_report_end-tracepoint-on-warnings.patch removed from -mm
 tree
Message-ID: <20220120213122.FT2y-nEFl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: use error_report_end tracepoint on warnings
has been removed from the -mm tree.  Its filename was
     panic-use-error_report_end-tracepoint-on-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch

