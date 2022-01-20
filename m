Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38CC6C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiATCKG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:10:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51232 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiATCJ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 974C0B81911
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD979C340E3;
        Thu, 20 Jan 2022 02:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644597;
        bh=K8x2+rrKbvMgE+PltXot5aEDL/xetbBzK1muFCoSfNk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=W6P1fLbRwdXkSki68o1YuG/FquOLOJBD6ekK3KDCVxalVBpMsjqdQSpnT2O60U1fr
         a4OTPowaFk5xr8o0e6jpmp7viJdJMCyKD1RZ/A0kNZwcOO2m9PVWTusSWAsbJUwmdE
         6tzqEPmiXo/VeRA2P4VDvC1GD7kFckU3ALv4lBJo=
Date:   Wed, 19 Jan 2022 18:09:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.popov@linux.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, elver@google.com,
        glider@google.com, john.ogness@linutronix.de, linux-mm@kvack.org,
        mcgrof@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        pmladek@suse.com, rostedt@goodmis.org, rppt@kernel.org,
        torvalds@linux-foundation.org, wei.liu@kernel.org
Subject:  [patch 42/55] panic: use error_report_end tracepoint on
 warnings
Message-ID: <20220120020956.7nXS_wTfb%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: panic: use error_report_end tracepoint on warnings

Introduce the error detector "warning" to the error_report event and use
the error_report_end tracepoint at the end of a warning report.

This allows in-kernel tests but also userspace to more easily determine
if a warning occurred without polling kernel logs.

[akpm@linux-foundation.org: add comma to enum list, per Andy]
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
+	ERROR_DETECTOR_WARN,
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
