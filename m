Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDBD9C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAF6264F33
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhB0CcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230194AbhB0Cbp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:31:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EE6F64F21;
        Sat, 27 Feb 2021 02:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393064;
        bh=BecSOhVty6Mjq8x1B/saMpV3ENribPHTA2vpF87ZB58=;
        h=Date:From:To:Subject:From;
        b=o+/v1STo/7Wi93rAWS/arpii9+JBgrEqmjBbEfSmeDnQLeZz3GPZ7IigEFXCbPL7Q
         Zqnm15qKLKN9JuCavOwzefAL3rm0Tofio5OQr0nZyDi5ezB9hJKP8c/t5d6FBXeBtz
         FX6mvST+xmBr87NvNin0FV6Va8N/wA28iM9IG1Us=
Date:   Fri, 26 Feb 2021 18:31:04 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, gregkh@linuxfoundation.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, vbabka@suse.cz
Subject:  [merged] tracing-add-error_report_end-trace-point.patch
 removed from -mm tree
Message-ID: <20210227023104.qyeWcQZRt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tracing: add error_report_end trace point
has been removed from the -mm tree.  Its filename was
     tracing-add-error_report_end-trace-point.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: tracing: add error_report_end trace point

Patch series "Add error_report_end tracepoint to KFENCE and KASAN", v3.

This patchset adds a tracepoint, error_repor_end, that is to be used by
KFENCE, KASAN, and potentially other bug detection tools, when they print
an error report.  One of the possible use cases is userspace collection of
kernel error reports: interested parties can subscribe to the tracing
event via tracefs, and get notified when an error report occurs.


This patch (of 3):

Introduce error_report_end tracepoint.  It can be used in debugging tools
like KASAN, KFENCE, etc.  to provide extensions to the error reporting
mechanisms (e.g.  allow tests hook into error reporting, ease error report
collection from production kernels).  Another benefit would be making use
of ftrace for debugging or benchmarking the tools themselves.

Should we need it, the tracepoint name leaves us with the possibility to
introduce a complementary error_report_start tracepoint in the future.

Link: https://lkml.kernel.org/r/20210121131915.1331302-1-glider@google.com
Link: https://lkml.kernel.org/r/20210121131915.1331302-2-glider@google.com
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

 include/trace/events/error_report.h |   74 ++++++++++++++++++++++++++
 kernel/trace/Makefile               |    1 
 kernel/trace/error_report-traces.c  |   12 ++++
 3 files changed, 87 insertions(+)

--- /dev/null
+++ a/include/trace/events/error_report.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Declarations for error reporting tracepoints.
+ *
+ * Copyright (C) 2021, Google LLC.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM error_report
+
+#if !defined(_TRACE_ERROR_REPORT_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_ERROR_REPORT_H
+
+#include <linux/tracepoint.h>
+
+#ifndef __ERROR_REPORT_DECLARE_TRACE_ENUMS_ONCE_ONLY
+#define __ERROR_REPORT_DECLARE_TRACE_ENUMS_ONCE_ONLY
+
+enum error_detector {
+	ERROR_DETECTOR_KFENCE,
+	ERROR_DETECTOR_KASAN
+};
+
+#endif /* __ERROR_REPORT_DECLARE_TRACE_ENUMS_ONCE_ONLY */
+
+#define error_detector_list	\
+	EM(ERROR_DETECTOR_KFENCE, "kfence")	\
+	EMe(ERROR_DETECTOR_KASAN, "kasan")
+/* Always end the list with an EMe. */
+
+#undef EM
+#undef EMe
+
+#define EM(a, b)	TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
+
+error_detector_list
+
+#undef EM
+#undef EMe
+
+#define EM(a, b) { a, b },
+#define EMe(a, b) { a, b }
+
+#define show_error_detector_list(val) \
+	__print_symbolic(val, error_detector_list)
+
+DECLARE_EVENT_CLASS(error_report_template,
+		    TP_PROTO(enum error_detector error_detector, unsigned long id),
+		    TP_ARGS(error_detector, id),
+		    TP_STRUCT__entry(__field(enum error_detector, error_detector)
+					     __field(unsigned long, id)),
+		    TP_fast_assign(__entry->error_detector = error_detector;
+				   __entry->id = id;),
+		    TP_printk("[%s] %lx",
+			      show_error_detector_list(__entry->error_detector),
+			      __entry->id));
+
+/**
+ * error_report_end - called after printing the error report
+ * @error_detector:	short string describing the error detection tool
+ * @id:			pseudo-unique descriptor identifying the report
+ *			(e.g. the memory access address)
+ *
+ * This event occurs right after a debugging tool finishes printing the error
+ * report.
+ */
+DEFINE_EVENT(error_report_template, error_report_end,
+	     TP_PROTO(enum error_detector error_detector, unsigned long id),
+	     TP_ARGS(error_detector, id));
+
+#endif /* _TRACE_ERROR_REPORT_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- /dev/null
+++ a/kernel/trace/error_report-traces.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Error reporting trace points.
+ *
+ * Copyright (C) 2021, Google LLC.
+ */
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/error_report.h>
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(error_report_end);
+
--- a/kernel/trace/Makefile~tracing-add-error_report_end-trace-point
+++ a/kernel/trace/Makefile
@@ -81,6 +81,7 @@ obj-$(CONFIG_SYNTH_EVENTS) += trace_even
 obj-$(CONFIG_HIST_TRIGGERS) += trace_events_hist.o
 obj-$(CONFIG_BPF_EVENTS) += bpf_trace.o
 obj-$(CONFIG_KPROBE_EVENTS) += trace_kprobe.o
+obj-$(CONFIG_TRACEPOINTS) += error_report-traces.o
 obj-$(CONFIG_TRACEPOINTS) += power-traces.o
 ifeq ($(CONFIG_PM),y)
 obj-$(CONFIG_TRACEPOINTS) += rpm-traces.o
_

Patches currently in -mm which might be from glider@google.com are


