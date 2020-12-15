Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C700C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0353422509
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgLODEE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:04:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgLODD5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:03:57 -0500
Date:   Mon, 14 Dec 2020 19:03:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001396;
        bh=OfskB+X+y5zqaJ1FPX+wGDAMqzTr4kSab4gMbIHjZIY=;
        h=From:To:Subject:In-Reply-To:From;
        b=S6lOs6fI8SZDZGtU+ObUDMsjDlMsqxNn9kXGg5M8ZkjcyaIpETvla+c1LbE6wuZ9A
         QQ4E9AAMdq0uUocLa+gMwLN01FaKejjWfl1xIUy3Au5c4JUEyE9ChuRRgIDQQzDGGy
         Oqrsvh44GSgKh407zwdxCMgxF2yOWZiDmHZZwcKs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     a.p.zijlstra@chello.nl, akpm@linux-foundation.org, axboe@kernel.dk,
        ben.dooks@codethink.co.uk, bfields@redhat.com, cl@rock-chips.com,
        frederic@kernel.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mingo@redhat.com,
        mm-commits@vger.kernel.org, mtosatti@redhat.com, pauld@redhat.com,
        peterz@infradead.org, rdunlap@infradead.org,
        robdclark@chromium.org, rostedt@goodmis.org,
        stamatis.iliass@gmail.com, thara.gopinath@linaro.org,
        torvalds@linux-foundation.org, valentin.schneider@arm.com,
        vincent.donnefort@arm.com
Subject:  [patch 001/200] kthread: add kthread_work tracepoints
Message-ID: <20201215030314.gDnCPSO_Y%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>
Subject: kthread: add kthread_work tracepoints

While migrating some code from wq to kthread_worker, I found that I missed
the execute_start/end tracepoints.  So add similar tracepoints for
kthread_work.  And for completeness, queue_work tracepoint (although this
one differs slightly from the matching workqueue tracepoint).

Link: https://lkml.kernel.org/r/20201010180323.126634-1-robdclark@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Cc: Rob Clark <robdclark@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Phil Auld <pauld@redhat.com>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vincent Donnefort <vincent.donnefort@arm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Ilias Stamatis <stamatis.iliass@gmail.com>
Cc: Liang Chen <cl@rock-chips.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "J. Bruce Fields" <bfields@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/sched.h |   84 +++++++++++++++++++++++++++++++++
 kernel/kthread.c             |    9 +++
 2 files changed, 93 insertions(+)

--- a/include/trace/events/sched.h~kthread-add-kthread_work-tracepoints
+++ a/include/trace/events/sched.h
@@ -5,6 +5,7 @@
 #if !defined(_TRACE_SCHED_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_SCHED_H
 
+#include <linux/kthread.h>
 #include <linux/sched/numa_balancing.h>
 #include <linux/tracepoint.h>
 #include <linux/binfmts.h>
@@ -51,6 +52,89 @@ TRACE_EVENT(sched_kthread_stop_ret,
 	TP_printk("ret=%d", __entry->ret)
 );
 
+/**
+ * sched_kthread_work_queue_work - called when a work gets queued
+ * @worker:	pointer to the kthread_worker
+ * @work:	pointer to struct kthread_work
+ *
+ * This event occurs when a work is queued immediately or once a
+ * delayed work is actually queued (ie: once the delay has been
+ * reached).
+ */
+TRACE_EVENT(sched_kthread_work_queue_work,
+
+	TP_PROTO(struct kthread_worker *worker,
+		 struct kthread_work *work),
+
+	TP_ARGS(worker, work),
+
+	TP_STRUCT__entry(
+		__field( void *,	work	)
+		__field( void *,	function)
+		__field( void *,	worker)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+		__entry->function	= work->func;
+		__entry->worker		= worker;
+	),
+
+	TP_printk("work struct=%p function=%ps worker=%p",
+		  __entry->work, __entry->function, __entry->worker)
+);
+
+/**
+ * sched_kthread_work_execute_start - called immediately before the work callback
+ * @work:	pointer to struct kthread_work
+ *
+ * Allows to track kthread work execution.
+ */
+TRACE_EVENT(sched_kthread_work_execute_start,
+
+	TP_PROTO(struct kthread_work *work),
+
+	TP_ARGS(work),
+
+	TP_STRUCT__entry(
+		__field( void *,	work	)
+		__field( void *,	function)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+		__entry->function	= work->func;
+	),
+
+	TP_printk("work struct %p: function %ps", __entry->work, __entry->function)
+);
+
+/**
+ * sched_kthread_work_execute_end - called immediately after the work callback
+ * @work:	pointer to struct work_struct
+ * @function:   pointer to worker function
+ *
+ * Allows to track workqueue execution.
+ */
+TRACE_EVENT(sched_kthread_work_execute_end,
+
+	TP_PROTO(struct kthread_work *work, kthread_work_func_t function),
+
+	TP_ARGS(work, function),
+
+	TP_STRUCT__entry(
+		__field( void *,	work	)
+		__field( void *,	function)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+		__entry->function	= function;
+	),
+
+	TP_printk("work struct %p: function %ps", __entry->work, __entry->function)
+);
+
 /*
  * Tracepoint for waking up a task:
  */
--- a/kernel/kthread.c~kthread-add-kthread_work-tracepoints
+++ a/kernel/kthread.c
@@ -704,8 +704,15 @@ repeat:
 	raw_spin_unlock_irq(&worker->lock);
 
 	if (work) {
+		kthread_work_func_t func = work->func;
 		__set_current_state(TASK_RUNNING);
+		trace_sched_kthread_work_execute_start(work);
 		work->func(work);
+		/*
+		 * Avoid dereferencing work after this point.  The trace
+		 * event only cares about the address.
+		 */
+		trace_sched_kthread_work_execute_end(work, func);
 	} else if (!freezing(current))
 		schedule();
 
@@ -834,6 +841,8 @@ static void kthread_insert_work(struct k
 {
 	kthread_insert_work_sanity_check(worker, work);
 
+	trace_sched_kthread_work_queue_work(worker, work);
+
 	list_add_tail(&work->node, pos);
 	work->worker = worker;
 	if (!worker->current_work && likely(worker->task))
_
