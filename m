From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 118/118] kcov: ignore fault-inject and stacktrace
Date: Thu, 30 Jan 2020 22:17:35 -0800
Message-ID: <20200131061735.RKRbBmv-Z%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgAaGRg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:17:36 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, dvyukov@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Dmitry Vyukov <dvyukov@google.com>
Subject: kcov: ignore fault-inject and stacktrace

Don't instrument 3 more files that contain debugging facilities and
produce large amounts of uninteresting coverage for every syscall.  The
following snippets are sprinkled all over the place in kcov traces in a
debugging kernel.  We already try to disable instrumentation of stack
unwinding code and of most debug facilities.  I guess we did not use
fault-inject.c at the time, and stacktrace.c was somehow missed (or
something has changed in kernel/configs).  This change both speeds up kcov
(kernel doesn't need to store these PCs, user-space doesn't need to
process them) and frees trace buffer capacity for more useful coverage.

should_fail
lib/fault-inject.c:149
fail_dump
lib/fault-inject.c:45

stack_trace_save
kernel/stacktrace.c:124
stack_trace_consume_entry
kernel/stacktrace.c:86
stack_trace_consume_entry
kernel/stacktrace.c:89
... a hundred frames skipped ...
stack_trace_consume_entry
kernel/stacktrace.c:93
stack_trace_consume_entry
kernel/stacktrace.c:86

Link: http://lkml.kernel.org/r/20200116111449.217744-1-dvyukov@gmail.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    1 +
 lib/Makefile    |    1 +
 mm/Makefile     |    1 +
 3 files changed, 3 insertions(+)

--- a/kernel/Makefile~kcov-ignore-fault-inject-and-stacktrace
+++ a/kernel/Makefile
@@ -27,6 +27,7 @@ KCOV_INSTRUMENT_softirq.o := n
 # and produce insane amounts of uninteresting coverage.
 KCOV_INSTRUMENT_module.o := n
 KCOV_INSTRUMENT_extable.o := n
+KCOV_INSTRUMENT_stacktrace.o := n
 # Don't self-instrument.
 KCOV_INSTRUMENT_kcov.o := n
 KASAN_SANITIZE_kcov.o := n
--- a/lib/Makefile~kcov-ignore-fault-inject-and-stacktrace
+++ a/lib/Makefile
@@ -16,6 +16,7 @@ KCOV_INSTRUMENT_rbtree.o := n
 KCOV_INSTRUMENT_list_debug.o := n
 KCOV_INSTRUMENT_debugobjects.o := n
 KCOV_INSTRUMENT_dynamic_debug.o := n
+KCOV_INSTRUMENT_fault-inject.o := n
 
 # Early boot use of cmdline, don't instrument it
 ifdef CONFIG_AMD_MEM_ENCRYPT
--- a/mm/Makefile~kcov-ignore-fault-inject-and-stacktrace
+++ a/mm/Makefile
@@ -20,6 +20,7 @@ KCOV_INSTRUMENT_kmemleak.o := n
 KCOV_INSTRUMENT_memcontrol.o := n
 KCOV_INSTRUMENT_mmzone.o := n
 KCOV_INSTRUMENT_vmstat.o := n
+KCOV_INSTRUMENT_failslab.o := n
 
 CFLAGS_init-mm.o += $(call cc-disable-warning, override-init)
 CFLAGS_init-mm.o += $(call cc-disable-warning, initializer-overrides)
_
