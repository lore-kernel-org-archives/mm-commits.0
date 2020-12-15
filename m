Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9730FC2BBCD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69A2F22510
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgLOX65 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729251AbgLOXUD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:20:03 -0500
Date:   Tue, 15 Dec 2020 15:19:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074362;
        bh=H+DHgi8fMCpk/wi7xIq5maHa5ooxFCvIDOQqRRC6Jlk=;
        h=From:To:Subject:From;
        b=IPDYKbmXtTMomnNS3rCGcXBQXUiJZwF2pu26hCaXx1ocrY3nfN+tVHnKlRRIpL8og
         ct1eEO9ay7pJcqsiL2YTL+eWL/EPWvPrWkk7lxHE1xj+dTmolawA+I5VFAxXwjSfnp
         HXEjI5Qs+HEKXHwoZQklOQF9gZujc/WYH6YNuDW4=
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, chinwen.chang@mediatek.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, jannh@google.com,
        laoar.shao@gmail.com, ldufour@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        rostedt@goodmis.org, vbabka@suse.cz, walken@google.com
Subject:  [merged]
 mmap_lock-add-tracepoints-around-lock-acquisition.patch removed from -mm
 tree
Message-ID: <20201215231921.-xivdZK4J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap_lock: add tracepoints around lock acquisition
has been removed from the -mm tree.  Its filename was
     mmap_lock-add-tracepoints-around-lock-acquisition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[axelrasmussen@google.com: fix use-after-free race and css ref leak in tracepoints]
  Link: https://lkml.kernel.org/r/20201130233504.3725241-1-axelrasmussen@google.com
[axelrasmussen@google.com: v3]
  Link: https://lkml.kernel.org/r/20201207213358.573750-1-axelrasmussen@google.com
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

 include/linux/mmap_lock.h        |   94 +++++++++++
 include/trace/events/mmap_lock.h |  107 +++++++++++++
 mm/Makefile                      |    2 
 mm/mmap_lock.c                   |  230 +++++++++++++++++++++++++++++
 4 files changed, 427 insertions(+), 6 deletions(-)

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
@@ -0,0 +1,230 @@
+// SPDX-License-Identifier: GPL-2.0
+#define CREATE_TRACE_POINTS
+#include <trace/events/mmap_lock.h>
+
+#include <linux/mm.h>
+#include <linux/cgroup.h>
+#include <linux/memcontrol.h>
+#include <linux/mmap_lock.h>
+#include <linux/mutex.h>
+#include <linux/percpu.h>
+#include <linux/rcupdate.h>
+#include <linux/smp.h>
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
+static DEFINE_MUTEX(reg_lock);
+static int reg_refcount; /* Protected by reg_lock. */
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
+static DEFINE_PER_CPU(char __rcu *, memcg_path_buf);
+static char **tmp_bufs;
+static DEFINE_PER_CPU(int, memcg_path_buf_idx);
+
+/* Called with reg_lock held. */
+static void free_memcg_path_bufs(void)
+{
+	int cpu;
+	char **old = tmp_bufs;
+
+	for_each_possible_cpu(cpu) {
+		*(old++) = rcu_dereference_protected(
+			per_cpu(memcg_path_buf, cpu),
+			lockdep_is_held(&reg_lock));
+		rcu_assign_pointer(per_cpu(memcg_path_buf, cpu), NULL);
+	}
+
+	/* Wait for inflight memcg_path_buf users to finish. */
+	synchronize_rcu();
+
+	old = tmp_bufs;
+	for_each_possible_cpu(cpu) {
+		kfree(*(old++));
+	}
+
+	kfree(tmp_bufs);
+	tmp_bufs = NULL;
+}
+
+int trace_mmap_lock_reg(void)
+{
+	int cpu;
+	char *new;
+
+	mutex_lock(&reg_lock);
+
+	/* If the refcount is going 0->1, proceed with allocating buffers. */
+	if (reg_refcount++)
+		goto out;
+
+	tmp_bufs = kmalloc_array(num_possible_cpus(), sizeof(*tmp_bufs),
+				 GFP_KERNEL);
+	if (tmp_bufs == NULL)
+		goto out_fail;
+
+	for_each_possible_cpu(cpu) {
+		new = kmalloc(MEMCG_PATH_BUF_SIZE * CONTEXT_COUNT, GFP_KERNEL);
+		if (new == NULL)
+			goto out_fail_free;
+		rcu_assign_pointer(per_cpu(memcg_path_buf, cpu), new);
+		/* Don't need to wait for inflights, they'd have gotten NULL. */
+	}
+
+out:
+	mutex_unlock(&reg_lock);
+	return 0;
+
+out_fail_free:
+	free_memcg_path_bufs();
+out_fail:
+	/* Since we failed, undo the earlier ref increment. */
+	--reg_refcount;
+
+	mutex_unlock(&reg_lock);
+	return -ENOMEM;
+}
+
+void trace_mmap_lock_unreg(void)
+{
+	mutex_lock(&reg_lock);
+
+	/* If the refcount is going 1->0, proceed with freeing buffers. */
+	if (--reg_refcount)
+		goto out;
+
+	free_memcg_path_bufs();
+
+out:
+	mutex_unlock(&reg_lock);
+}
+
+static inline char *get_memcg_path_buf(void)
+{
+	char *buf;
+	int idx;
+
+	rcu_read_lock();
+	buf = rcu_dereference(*this_cpu_ptr(&memcg_path_buf));
+	if (buf == NULL) {
+		rcu_read_unlock();
+		return NULL;
+	}
+	idx = this_cpu_add_return(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE) -
+	      MEMCG_PATH_BUF_SIZE;
+	return &buf[idx];
+}
+
+static inline void put_memcg_path_buf(void)
+{
+	this_cpu_sub(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE);
+	rcu_read_unlock();
+}
+
+/*
+ * Write the given mm_struct's memcg path to a percpu buffer, and return a
+ * pointer to it. If the path cannot be determined, or no buffer was available
+ * (because the trace event is being unregistered), NULL is returned.
+ *
+ * Note: buffers are allocated per-cpu to avoid locking, so preemption must be
+ * disabled by the caller before calling us, and re-enabled only after the
+ * caller is done with the pointer.
+ *
+ * The caller must call put_memcg_path_buf() once the buffer is no longer
+ * needed. This must be done while preemption is still disabled.
+ */
+static const char *get_mm_memcg_path(struct mm_struct *mm)
+{
+	char *buf = NULL;
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
+
+	if (memcg == NULL)
+		goto out;
+	if (unlikely(memcg->css.cgroup == NULL))
+		goto out_put;
+
+	buf = get_memcg_path_buf();
+	if (buf == NULL)
+		goto out_put;
+
+	cgroup_path(memcg->css.cgroup, buf, MEMCG_PATH_BUF_SIZE);
+
+out_put:
+	css_put(&memcg->css);
+out:
+	return buf;
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


