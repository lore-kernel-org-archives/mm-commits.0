Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81DEC388F9
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 01:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E96922256
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 01:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FXw1C8od"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgKTBYp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Nov 2020 20:24:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgKTBYo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Nov 2020 20:24:44 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1426C22254;
        Fri, 20 Nov 2020 01:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605835483;
        bh=WMAY+73XItlYRe/NcqW5wxyPpi3mZQAnxBSPWbdx3g0=;
        h=Date:From:To:Subject:From;
        b=FXw1C8odd3e+eGu8dPaQ2X0t/JhUk3G4Q0prABXkK3wwokY3Uz+2WOUdcqGZ5L6d+
         JlQ72y5OxXn21SmXwm9MggErWQlNlU5W1l9EOnNzUXwi7GvZ4plnaXPtrhs4e1JGcv
         TLcLQYuW+2sHDyyTZ0YSFcj7h/2L2MizHvJljIak=
Date:   Thu, 19 Nov 2020 17:24:42 -0800
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, chinwen.chang@mediatek.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, jannh@google.com,
        laoar.shao@gmail.com, ldufour@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        rostedt@goodmis.org, vbabka@suse.cz, walken@google.com
Subject:  + mmap_lock-add-tracepoints-around-lock-acquisition.patch
 added to -mm tree
Message-ID: <20201120012442.uBYHBkN_L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap_lock: add tracepoints around lock acquisition
has been added to the -mm tree.  Its filename is
     mmap_lock-add-tracepoints-around-lock-acquisition.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmap_lock-add-tracepoints-around-lock-acquisition.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmap_lock-add-tracepoints-around-lock-acquisition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: mmap_lock: add tracepoints around lock acquisition

The goal of these tracepoints is to be able to debug lock contention
issues.  This lock is acquired on most (all?) mmap / munmap / page fault
operations, so a multi-threaded process which does a lot of these can
experience significant contention.

We trace just before we start acquisition, when the acquisition returns
(whether it succeeded or not), and when the lock is released (or
downgraded).  The events are broken out by lock type (read / write).

The events are also broken out by memcg path.  For container-based
workloads, users often think of several processes in a memcg as a single
logical "task", so collecting statistics at this level is useful.

The end goal is to get latency information.  This isn't directly included
in the trace events.  Instead, users are expected to compute the time
between "start locking" and "acquire returned", using e.g.  synthetic
events or BPF.  The benefit we get from this is simpler code.

Because we use tracepoint_enabled() to decide whether or not to trace,
this patch has effectively no overhead unless tracepoints are enabled at
runtime.  If tracepoints are enabled, there is a performance impact, but
how much depends on exactly what e.g.  the BPF program does.

[rostedt@goodmis.org: in-depth examples of tracepoint_enabled() usage, and per-cpu-per-context buffer design]
Link: https://lkml.kernel.org/r/20201105211739.568279-2-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h        |   94 +++++++++++++-
 include/trace/events/mmap_lock.h |  107 ++++++++++++++++
 mm/Makefile                      |    2 
 mm/mmap_lock.c                   |  187 +++++++++++++++++++++++++++++
 4 files changed, 384 insertions(+), 6 deletions(-)

--- a/include/linux/mmap_lock.h~mmap_lock-add-tracepoints-around-lock-acquisition
+++ a/include/linux/mmap_lock.h
@@ -1,11 +1,65 @@
 #ifndef _LINUX_MMAP_LOCK_H
 #define _LINUX_MMAP_LOCK_H
 
+#include <linux/lockdep.h>
+#include <linux/mm_types.h>
 #include <linux/mmdebug.h>
+#include <linux/rwsem.h>
+#include <linux/tracepoint-defs.h>
+#include <linux/types.h>
 
 #define MMAP_LOCK_INITIALIZER(name) \
 	.mmap_lock = __RWSEM_INITIALIZER((name).mmap_lock),
 
+DECLARE_TRACEPOINT(mmap_lock_start_locking);
+DECLARE_TRACEPOINT(mmap_lock_acquire_returned);
+DECLARE_TRACEPOINT(mmap_lock_released);
+
+#ifdef CONFIG_TRACING
+
+void __mmap_lock_do_trace_start_locking(struct mm_struct *mm, bool write);
+void __mmap_lock_do_trace_acquire_returned(struct mm_struct *mm, bool write,
+					   bool success);
+void __mmap_lock_do_trace_released(struct mm_struct *mm, bool write);
+
+static inline void __mmap_lock_trace_start_locking(struct mm_struct *mm,
+						   bool write)
+{
+	if (tracepoint_enabled(mmap_lock_start_locking))
+		__mmap_lock_do_trace_start_locking(mm, write);
+}
+
+static inline void __mmap_lock_trace_acquire_returned(struct mm_struct *mm,
+						      bool write, bool success)
+{
+	if (tracepoint_enabled(mmap_lock_acquire_returned))
+		__mmap_lock_do_trace_acquire_returned(mm, write, success);
+}
+
+static inline void __mmap_lock_trace_released(struct mm_struct *mm, bool write)
+{
+	if (tracepoint_enabled(mmap_lock_released))
+		__mmap_lock_do_trace_released(mm, write);
+}
+
+#else /* !CONFIG_TRACING */
+
+static inline void __mmap_lock_trace_start_locking(struct mm_struct *mm,
+						   bool write)
+{
+}
+
+static inline void __mmap_lock_trace_acquire_returned(struct mm_struct *mm,
+						      bool write, bool success)
+{
+}
+
+static inline void __mmap_lock_trace_released(struct mm_struct *mm, bool write)
+{
+}
+
+#endif /* CONFIG_TRACING */
+
 static inline void mmap_init_lock(struct mm_struct *mm)
 {
 	init_rwsem(&mm->mmap_lock);
@@ -13,57 +67,86 @@ static inline void mmap_init_lock(struct
 
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
+	__mmap_lock_trace_start_locking(mm, true);
 	down_write(&mm->mmap_lock);
+	__mmap_lock_trace_acquire_returned(mm, true, true);
 }
 
 static inline void mmap_write_lock_nested(struct mm_struct *mm, int subclass)
 {
+	__mmap_lock_trace_start_locking(mm, true);
 	down_write_nested(&mm->mmap_lock, subclass);
+	__mmap_lock_trace_acquire_returned(mm, true, true);
 }
 
 static inline int mmap_write_lock_killable(struct mm_struct *mm)
 {
-	return down_write_killable(&mm->mmap_lock);
+	int ret;
+
+	__mmap_lock_trace_start_locking(mm, true);
+	ret = down_write_killable(&mm->mmap_lock);
+	__mmap_lock_trace_acquire_returned(mm, true, ret == 0);
+	return ret;
 }
 
 static inline bool mmap_write_trylock(struct mm_struct *mm)
 {
-	return down_write_trylock(&mm->mmap_lock) != 0;
+	bool ret;
+
+	__mmap_lock_trace_start_locking(mm, true);
+	ret = down_write_trylock(&mm->mmap_lock) != 0;
+	__mmap_lock_trace_acquire_returned(mm, true, ret);
+	return ret;
 }
 
 static inline void mmap_write_unlock(struct mm_struct *mm)
 {
 	up_write(&mm->mmap_lock);
+	__mmap_lock_trace_released(mm, true);
 }
 
 static inline void mmap_write_downgrade(struct mm_struct *mm)
 {
 	downgrade_write(&mm->mmap_lock);
+	__mmap_lock_trace_acquire_returned(mm, false, true);
 }
 
 static inline void mmap_read_lock(struct mm_struct *mm)
 {
+	__mmap_lock_trace_start_locking(mm, false);
 	down_read(&mm->mmap_lock);
+	__mmap_lock_trace_acquire_returned(mm, false, true);
 }
 
 static inline int mmap_read_lock_killable(struct mm_struct *mm)
 {
-	return down_read_killable(&mm->mmap_lock);
+	int ret;
+
+	__mmap_lock_trace_start_locking(mm, false);
+	ret = down_read_killable(&mm->mmap_lock);
+	__mmap_lock_trace_acquire_returned(mm, false, ret == 0);
+	return ret;
 }
 
 static inline bool mmap_read_trylock(struct mm_struct *mm)
 {
-	return down_read_trylock(&mm->mmap_lock) != 0;
+	bool ret;
+
+	__mmap_lock_trace_start_locking(mm, false);
+	ret = down_read_trylock(&mm->mmap_lock) != 0;
+	__mmap_lock_trace_acquire_returned(mm, false, ret);
+	return ret;
 }
 
 static inline void mmap_read_unlock(struct mm_struct *mm)
 {
 	up_read(&mm->mmap_lock);
+	__mmap_lock_trace_released(mm, false);
 }
 
 static inline bool mmap_read_trylock_non_owner(struct mm_struct *mm)
 {
-	if (down_read_trylock(&mm->mmap_lock)) {
+	if (mmap_read_trylock(mm)) {
 		rwsem_release(&mm->mmap_lock.dep_map, _RET_IP_);
 		return true;
 	}
@@ -73,6 +156,7 @@ static inline bool mmap_read_trylock_non
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 {
 	up_read_non_owner(&mm->mmap_lock);
+	__mmap_lock_trace_released(mm, false);
 }
 
 static inline void mmap_assert_locked(struct mm_struct *mm)
--- /dev/null
+++ a/include/trace/events/mmap_lock.h
@@ -0,0 +1,107 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mmap_lock
+
+#if !defined(_TRACE_MMAP_LOCK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MMAP_LOCK_H
+
+#include <linux/tracepoint.h>
+#include <linux/types.h>
+
+struct mm_struct;
+
+extern int trace_mmap_lock_reg(void);
+extern void trace_mmap_lock_unreg(void);
+
+TRACE_EVENT_FN(mmap_lock_start_locking,
+
+	TP_PROTO(struct mm_struct *mm, const char *memcg_path, bool write),
+
+	TP_ARGS(mm, memcg_path, write),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__string(memcg_path, memcg_path)
+		__field(bool, write)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__assign_str(memcg_path, memcg_path);
+		__entry->write = write;
+	),
+
+	TP_printk(
+		"mm=%p memcg_path=%s write=%s\n",
+		__entry->mm,
+		__get_str(memcg_path),
+		__entry->write ? "true" : "false"
+	),
+
+	trace_mmap_lock_reg, trace_mmap_lock_unreg
+);
+
+TRACE_EVENT_FN(mmap_lock_acquire_returned,
+
+	TP_PROTO(struct mm_struct *mm, const char *memcg_path, bool write,
+		bool success),
+
+	TP_ARGS(mm, memcg_path, write, success),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__string(memcg_path, memcg_path)
+		__field(bool, write)
+		__field(bool, success)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__assign_str(memcg_path, memcg_path);
+		__entry->write = write;
+		__entry->success = success;
+	),
+
+	TP_printk(
+		"mm=%p memcg_path=%s write=%s success=%s\n",
+		__entry->mm,
+		__get_str(memcg_path),
+		__entry->write ? "true" : "false",
+		__entry->success ? "true" : "false"
+	),
+
+	trace_mmap_lock_reg, trace_mmap_lock_unreg
+);
+
+TRACE_EVENT_FN(mmap_lock_released,
+
+	TP_PROTO(struct mm_struct *mm, const char *memcg_path, bool write),
+
+	TP_ARGS(mm, memcg_path, write),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__string(memcg_path, memcg_path)
+		__field(bool, write)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__assign_str(memcg_path, memcg_path);
+		__entry->write = write;
+	),
+
+	TP_printk(
+		"mm=%p memcg_path=%s write=%s\n",
+		__entry->mm,
+		__get_str(memcg_path),
+		__entry->write ? "true" : "false"
+	),
+
+	trace_mmap_lock_reg, trace_mmap_lock_unreg
+);
+
+#endif /* _TRACE_MMAP_LOCK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/mm/Makefile~mmap_lock-add-tracepoints-around-lock-acquisition
+++ a/mm/Makefile
@@ -52,7 +52,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   mm_init.o percpu.o slab_common.o \
 			   compaction.o vmacache.o \
 			   interval_tree.o list_lru.o workingset.o \
-			   debug.o gup.o $(mmu-y)
+			   debug.o gup.o mmap_lock.o $(mmu-y)
 
 # Give 'page_alloc' its own module-parameter namespace
 page-alloc-y := page_alloc.o
--- /dev/null
+++ a/mm/mmap_lock.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+#define CREATE_TRACE_POINTS
+#include <trace/events/mmap_lock.h>
+
+#include <linux/mm.h>
+#include <linux/cgroup.h>
+#include <linux/memcontrol.h>
+#include <linux/mmap_lock.h>
+#include <linux/percpu.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
+#include <linux/trace_events.h>
+
+EXPORT_TRACEPOINT_SYMBOL(mmap_lock_start_locking);
+EXPORT_TRACEPOINT_SYMBOL(mmap_lock_acquire_returned);
+EXPORT_TRACEPOINT_SYMBOL(mmap_lock_released);
+
+#ifdef CONFIG_MEMCG
+
+/*
+ * Our various events all share the same buffer (because we don't want or need
+ * to allocate a set of buffers *per event type*), so we need to protect against
+ * concurrent _reg() and _unreg() calls, and count how many _reg() calls have
+ * been made.
+ */
+static DEFINE_SPINLOCK(reg_lock);
+static int reg_refcount;
+
+/*
+ * Size of the buffer for memcg path names. Ignoring stack trace support,
+ * trace_events_hist.c uses MAX_FILTER_STR_VAL for this, so we also use it.
+ */
+#define MEMCG_PATH_BUF_SIZE MAX_FILTER_STR_VAL
+
+/*
+ * How many contexts our trace events might be called in: normal, softirq, irq,
+ * and NMI.
+ */
+#define CONTEXT_COUNT 4
+
+DEFINE_PER_CPU(char *, memcg_path_buf);
+DEFINE_PER_CPU(int, memcg_path_buf_idx);
+
+int trace_mmap_lock_reg(void)
+{
+	unsigned long flags;
+	int cpu;
+
+	spin_lock_irqsave(&reg_lock, flags);
+
+	if (reg_refcount++)
+		goto out;
+
+	for_each_possible_cpu(cpu) {
+		per_cpu(memcg_path_buf, cpu) = NULL;
+	}
+	for_each_possible_cpu(cpu) {
+		per_cpu(memcg_path_buf, cpu) = kmalloc(
+			MEMCG_PATH_BUF_SIZE * CONTEXT_COUNT, GFP_NOWAIT);
+		if (per_cpu(memcg_path_buf, cpu) == NULL)
+			goto out_fail;
+		per_cpu(memcg_path_buf_idx, cpu) = 0;
+	}
+
+out:
+	spin_unlock_irqrestore(&reg_lock, flags);
+	return 0;
+
+out_fail:
+	for_each_possible_cpu(cpu) {
+		if (per_cpu(memcg_path_buf, cpu) != NULL)
+			kfree(per_cpu(memcg_path_buf, cpu));
+		else
+			break;
+	}
+
+	--reg_refcount;
+
+	spin_unlock_irqrestore(&reg_lock, flags);
+	return -ENOMEM;
+}
+
+void trace_mmap_lock_unreg(void)
+{
+	unsigned long flags;
+	int cpu;
+
+	spin_lock_irqsave(&reg_lock, flags);
+
+	if (--reg_refcount)
+		goto out;
+
+	for_each_possible_cpu(cpu) {
+		kfree(per_cpu(memcg_path_buf, cpu));
+	}
+
+out:
+	spin_unlock_irqrestore(&reg_lock, flags);
+}
+
+static inline char *get_memcg_path_buf(void)
+{
+	int idx;
+
+	idx = this_cpu_add_return(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE) -
+	      MEMCG_PATH_BUF_SIZE;
+	return &this_cpu_read(memcg_path_buf)[idx];
+}
+
+static inline void put_memcg_path_buf(void)
+{
+	this_cpu_sub(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE);
+}
+
+/*
+ * Write the given mm_struct's memcg path to a percpu buffer, and return a
+ * pointer to it. If the path cannot be determined, NULL is returned.
+ *
+ * Note: buffers are allocated per-cpu to avoid locking, so preemption must be
+ * disabled by the caller before calling us, and re-enabled only after the
+ * caller is done with the pointer.
+ */
+static const char *get_mm_memcg_path(struct mm_struct *mm)
+{
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
+
+	if (memcg != NULL && likely(memcg->css.cgroup != NULL)) {
+		char *buf = get_memcg_path_buf();
+
+		cgroup_path(memcg->css.cgroup, buf, MEMCG_PATH_BUF_SIZE);
+		return buf;
+	}
+	return NULL;
+}
+
+#define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
+	do {                                                                   \
+		const char *memcg_path;                                        \
+		preempt_disable();                                             \
+		memcg_path = get_mm_memcg_path(mm);                            \
+		trace_mmap_lock_##type(mm,                                     \
+				       memcg_path != NULL ? memcg_path : "",   \
+				       ##__VA_ARGS__);                         \
+		if (likely(memcg_path != NULL))                                \
+			put_memcg_path_buf();                                  \
+		preempt_enable();                                              \
+	} while (0)
+
+#else /* !CONFIG_MEMCG */
+
+int trace_mmap_lock_reg(void)
+{
+	return 0;
+}
+
+void trace_mmap_lock_unreg(void)
+{
+}
+
+#define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
+	trace_mmap_lock_##type(mm, "", ##__VA_ARGS__)
+
+#endif /* CONFIG_MEMCG */
+
+/*
+ * Trace calls must be in a separate file, as otherwise there's a circular
+ * dependency between linux/mmap_lock.h and trace/events/mmap_lock.h.
+ */
+
+void __mmap_lock_do_trace_start_locking(struct mm_struct *mm, bool write)
+{
+	TRACE_MMAP_LOCK_EVENT(start_locking, mm, write);
+}
+EXPORT_SYMBOL(__mmap_lock_do_trace_start_locking);
+
+void __mmap_lock_do_trace_acquire_returned(struct mm_struct *mm, bool write,
+					   bool success)
+{
+	TRACE_MMAP_LOCK_EVENT(acquire_returned, mm, write, success);
+}
+EXPORT_SYMBOL(__mmap_lock_do_trace_acquire_returned);
+
+void __mmap_lock_do_trace_released(struct mm_struct *mm, bool write)
+{
+	TRACE_MMAP_LOCK_EVENT(released, mm, write);
+}
+EXPORT_SYMBOL(__mmap_lock_do_trace_released);
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mmap_lock-add-tracepoints-around-lock-acquisition.patch

