Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16993C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3493206CB
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgLOCQs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:16:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgLOCQq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:16:46 -0500
Date:   Mon, 14 Dec 2020 18:16:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998564;
        bh=an/oy5R+oF8cJf3Ywb83sfOUyoa0Og7WYN2SbkloEEA=;
        h=From:To:Subject:From;
        b=qO/FbQmAWkVpB/cjb6Y7Ayva8kMnPr+NLjhAz4y1jPoCRtFgQsJcJjEzgkBhgsw3b
         wR02jp79TEDuF4IFo35RIDmAI6fasQ9vpCYVCNS87f/pX/v04gxQQvrRfMzdQ8pDZR
         VF2ZhnG81GwhE2uMSgx4cVcE6nKqWXAcD0MZBgoo=
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, chinwen.chang@mediatek.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, jannh@google.com,
        laoar.shao@gmail.com, ldufour@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        rostedt@goodmis.org, vbabka@suse.cz, walken@google.com
Subject:  [folded-merged]
 mmap_lock-add-tracepoints-around-lock-acquisition-fix.patch removed from
 -mm tree
Message-ID: <20201215021603.0zRSVNCG3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap_lock: fix use-after-free race and css ref leak in tracepoints
has been removed from the -mm tree.  Its filename was
     mmap_lock-add-tracepoints-around-lock-acquisition-fix.patch

This patch was dropped because it was folded into mmap_lock-add-tracepoints-around-lock-acquisition.patch

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: mmap_lock: fix use-after-free race and css ref leak in tracepoints

syzbot reported[1] a use-after-free introduced in 0f818c4bc1f3.  The bug
is that an ongoing trace event might race with the tracepoint being
disabled (and therefore the _unreg() callback being called).  Consider
this ordering:

T1: trace event fires, get_mm_memcg_path() is called
T1: get_memcg_path_buf() returns a buffer pointer
T2: trace_mmap_lock_unreg() is called, buffers are freed
T1: cgroup_path() is called with the now-freed buffer

The solution in this commit is to switch to mutex + RCU. With the RCU
API we can first stop new buffers from being handed out, then wait for
existing users to finish, and *then* free the buffers.

I have a simple reproducer program which spins up two pools of threads,
doing the following in a tight loop:

  Pool 1:
  mmap(NULL, 4096, PROT_READ | PROT_WRITE,
       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0)
  munmap()

  Pool 2:
  echo 1 > /sys/kernel/debug/tracing/events/mmap_lock/enable
  echo 0 > /sys/kernel/debug/tracing/events/mmap_lock/enable

This triggers the use-after-free very quickly. With this patch, I let it
run for an hour without any BUGs.

While fixing this, I also noticed and fixed a css ref leak.  Previously we
called get_mem_cgroup_from_mm(), but we never called css_put() to release
that reference.  get_mm_memcg_path() now does this properly.

[1]: https://syzkaller.appspot.com/bug?extid=19e6dd9943972fa1c58a

Link: https://lkml.kernel.org/r/20201130233504.3725241-1-axelrasmussen@google.com
Fixes: 0f818c4bc1f3 ("mm: mmap_lock: add tracepoints around lock acquisition")
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

 mm/mmap_lock.c |  100 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 85 insertions(+), 15 deletions(-)

--- a/mm/mmap_lock.c~mmap_lock-add-tracepoints-around-lock-acquisition-fix
+++ a/mm/mmap_lock.c
@@ -3,6 +3,7 @@
 #include <trace/events/mmap_lock.h>
 
 #include <linux/mm.h>
+#include <linux/atomic.h>
 #include <linux/cgroup.h>
 #include <linux/memcontrol.h>
 #include <linux/mmap_lock.h>
@@ -18,13 +19,28 @@ EXPORT_TRACEPOINT_SYMBOL(mmap_lock_relea
 #ifdef CONFIG_MEMCG
 
 /*
- * Our various events all share the same buffer (because we don't want or need
- * to allocate a set of buffers *per event type*), so we need to protect against
- * concurrent _reg() and _unreg() calls, and count how many _reg() calls have
- * been made.
+ * This is unfortunately complicated... _reg() and _unreg() may be called
+ * in parallel, separately for each of our three event types. To save memory,
+ * all of the event types share the same buffers. Furthermore, trace events
+ * might happen in parallel with _unreg(); we need to ensure we don't free the
+ * buffers before all inflights have finished. Because these events happen
+ * "frequently", we also want to prevent new inflights from starting once the
+ * _unreg() process begins. And, for performance reasons, we want to avoid any
+ * locking in the trace event path.
+ *
+ * So:
+ *
+ * - Use a spinlock to serialize _reg() and _unreg() calls.
+ * - Keep track of nested _reg() calls with a lock-protected counter.
+ * - Define a flag indicating whether or not unregistration has begun (and
+ *   therefore that there should be no new buffer uses going forward).
+ * - Keep track of inflight buffer users with a reference count.
  */
 static DEFINE_SPINLOCK(reg_lock);
-static int reg_refcount;
+static int reg_types_rc; /* Protected by reg_lock. */
+static bool unreg_started; /* Doesn't need synchronization. */
+/* atomic_t instead of refcount_t, as we want ordered inc without locks. */
+static atomic_t inflight_rc = ATOMIC_INIT(0);
 
 /*
  * Size of the buffer for memcg path names. Ignoring stack trace support,
@@ -46,9 +62,14 @@ int trace_mmap_lock_reg(void)
 	unsigned long flags;
 	int cpu;
 
+	/*
+	 * Serialize _reg() and _unreg(). Without this, e.g. _unreg() might
+	 * start cleaning up while _reg() is only partially completed.
+	 */
 	spin_lock_irqsave(&reg_lock, flags);
 
-	if (reg_refcount++)
+	/* If the refcount is going 0->1, proceed with allocating buffers. */
+	if (reg_types_rc++)
 		goto out;
 
 	for_each_possible_cpu(cpu) {
@@ -62,6 +83,11 @@ int trace_mmap_lock_reg(void)
 		per_cpu(memcg_path_buf_idx, cpu) = 0;
 	}
 
+	/* Reset unreg_started flag, allowing new trace events. */
+	WRITE_ONCE(unreg_started, false);
+	/* Add the registration +1 to the inflight refcount. */
+	atomic_inc(&inflight_rc);
+
 out:
 	spin_unlock_irqrestore(&reg_lock, flags);
 	return 0;
@@ -74,7 +100,8 @@ out_fail:
 			break;
 	}
 
-	--reg_refcount;
+	/* Since we failed, undo the earlier increment. */
+	--reg_types_rc;
 
 	spin_unlock_irqrestore(&reg_lock, flags);
 	return -ENOMEM;
@@ -87,9 +114,23 @@ void trace_mmap_lock_unreg(void)
 
 	spin_lock_irqsave(&reg_lock, flags);
 
-	if (--reg_refcount)
+	/* If the refcount is going 1->0, proceed with freeing buffers. */
+	if (--reg_types_rc)
 		goto out;
 
+	/* This was the last registration; start preventing new events... */
+	WRITE_ONCE(unreg_started, true);
+	/* Remove the registration +1 from the inflight refcount. */
+	atomic_dec(&inflight_rc);
+	/*
+	 * Wait for inflight refcount to be zero (all inflights stopped). Since
+	 * we have a spinlock we can't sleep, so just spin. Because trace events
+	 * are "fast", and because we stop new inflights from starting at this
+	 * point with unreg_started, this should be a short spin.
+	 */
+	while (atomic_read(&inflight_rc))
+		barrier();
+
 	for_each_possible_cpu(cpu) {
 		kfree(per_cpu(memcg_path_buf, cpu));
 	}
@@ -102,6 +143,20 @@ static inline char *get_memcg_path_buf(v
 {
 	int idx;
 
+	/*
+	 * If unregistration is happening, stop. Yes, this check is racy;
+	 * that's fine. It just means _unreg() might spin waiting for an extra
+	 * event or two. Use-after-free is actually prevented by the refcount.
+	 */
+	if (READ_ONCE(unreg_started))
+		return NULL;
+	/*
+	 * Take a reference, unless the registration +1 has been released
+	 * and there aren't already existing inflights (refcount is zero).
+	 */
+	if (!atomic_inc_not_zero(&inflight_rc))
+		return NULL;
+
 	idx = this_cpu_add_return(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE) -
 	      MEMCG_PATH_BUF_SIZE;
 	return &this_cpu_read(memcg_path_buf)[idx];
@@ -110,27 +165,42 @@ static inline char *get_memcg_path_buf(v
 static inline void put_memcg_path_buf(void)
 {
 	this_cpu_sub(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE);
+	/* We're done with this buffer; drop the reference. */
+	atomic_dec(&inflight_rc);
 }
 
 /*
  * Write the given mm_struct's memcg path to a percpu buffer, and return a
- * pointer to it. If the path cannot be determined, NULL is returned.
+ * pointer to it. If the path cannot be determined, or no buffer was available
+ * (because the trace event is being unregistered), NULL is returned.
  *
  * Note: buffers are allocated per-cpu to avoid locking, so preemption must be
  * disabled by the caller before calling us, and re-enabled only after the
  * caller is done with the pointer.
+ *
+ * The caller must call put_memcg_path_buf() once the buffer is no longer
+ * needed. This must be done while preemption is still disabled.
  */
 static const char *get_mm_memcg_path(struct mm_struct *mm)
 {
+	char *buf = NULL;
 	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
 
-	if (memcg != NULL && likely(memcg->css.cgroup != NULL)) {
-		char *buf = get_memcg_path_buf();
+	if (memcg == NULL)
+		goto out;
+	if (unlikely(memcg->css.cgroup == NULL))
+		goto out_put;
 
-		cgroup_path(memcg->css.cgroup, buf, MEMCG_PATH_BUF_SIZE);
-		return buf;
-	}
-	return NULL;
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
 }
 
 #define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mmap_lock-add-tracepoints-around-lock-acquisition.patch
mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3.patch
userfaultfd-selftests-make-__su64-format-specifiers-portable.patch
userfaultfd-selftests-make-__su64-format-specifiers-portable-v2.patch

