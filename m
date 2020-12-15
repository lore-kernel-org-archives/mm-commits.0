Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6232BC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29B23206D4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgLOCRV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:17:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgLOCQs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:16:48 -0500
Date:   Mon, 14 Dec 2020 18:16:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998568;
        bh=T+qsWWAAFOzi5jvN4QszYD2ylbtBaXxdyyQ5JG+UaVA=;
        h=From:To:Subject:From;
        b=cm5akZdDzJXjdHenLp9Ni/67pFj1XjqEG+suD0T5EHvgkP0l7tdJOAOea6I2RST0F
         YeaOZAYdtpS8AVc89saIti/N/uDyQrtSjGrUbJgqGpz+1C3jx+ppzkYxcqXJ2oznNt
         r3vxl31eqRY9Siox1NGYyYpttp8UFeGoGJ9wpcaI=
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, chinwen.chang@mediatek.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, jannh@google.com,
        laoar.shao@gmail.com, ldufour@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        rostedt@goodmis.org, vbabka@suse.cz, walken@google.com
Subject:  [folded-merged]
 mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3.patch removed from
 -mm tree
Message-ID: <20201215021607.W4MRf0sa5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3
has been removed from the -mm tree.  Its filename was
     mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3.patch

This patch was dropped because it was folded into mmap_lock-add-tracepoints-around-lock-acquisition.patch

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3

Changes from v2 -> v3:

Split up the free loop, so now we do it in three steps: 1) loop through
setting the buffers to NULL, 2) synchronize_rcu() *once*, 3) loop through
freeing each of the buffers. This requires allocating some memory to hold
the not-yet-freed buffer pointers, but it means much less waiting as doing
synchronize_rcu() in a loop is expensive. Again, per Steven's suggestion.

Changes from v1 -> v2:

Rewrote the fix to use mutex + RCU instead of doing some hand-rolled
reference count thing, as per Steven's suggestion.

Link: https://lkml.kernel.org/r/20201207213358.573750-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap_lock.c |  161 +++++++++++++++++++----------------------------
 1 file changed, 67 insertions(+), 94 deletions(-)

--- a/mm/mmap_lock.c~mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3
+++ a/mm/mmap_lock.c
@@ -3,13 +3,13 @@
 #include <trace/events/mmap_lock.h>
 
 #include <linux/mm.h>
-#include <linux/atomic.h>
 #include <linux/cgroup.h>
 #include <linux/memcontrol.h>
 #include <linux/mmap_lock.h>
+#include <linux/mutex.h>
 #include <linux/percpu.h>
+#include <linux/rcupdate.h>
 #include <linux/smp.h>
-#include <linux/spinlock.h>
 #include <linux/trace_events.h>
 
 EXPORT_TRACEPOINT_SYMBOL(mmap_lock_start_locking);
@@ -19,28 +19,13 @@ EXPORT_TRACEPOINT_SYMBOL(mmap_lock_relea
 #ifdef CONFIG_MEMCG
 
 /*
- * This is unfortunately complicated... _reg() and _unreg() may be called
- * in parallel, separately for each of our three event types. To save memory,
- * all of the event types share the same buffers. Furthermore, trace events
- * might happen in parallel with _unreg(); we need to ensure we don't free the
- * buffers before all inflights have finished. Because these events happen
- * "frequently", we also want to prevent new inflights from starting once the
- * _unreg() process begins. And, for performance reasons, we want to avoid any
- * locking in the trace event path.
- *
- * So:
- *
- * - Use a spinlock to serialize _reg() and _unreg() calls.
- * - Keep track of nested _reg() calls with a lock-protected counter.
- * - Define a flag indicating whether or not unregistration has begun (and
- *   therefore that there should be no new buffer uses going forward).
- * - Keep track of inflight buffer users with a reference count.
+ * Our various events all share the same buffer (because we don't want or need
+ * to allocate a set of buffers *per event type*), so we need to protect against
+ * concurrent _reg() and _unreg() calls, and count how many _reg() calls have
+ * been made.
  */
-static DEFINE_SPINLOCK(reg_lock);
-static int reg_types_rc; /* Protected by reg_lock. */
-static bool unreg_started; /* Doesn't need synchronization. */
-/* atomic_t instead of refcount_t, as we want ordered inc without locks. */
-static atomic_t inflight_rc = ATOMIC_INIT(0);
+static DEFINE_MUTEX(reg_lock);
+static int reg_refcount; /* Protected by reg_lock. */
 
 /*
  * Size of the buffer for memcg path names. Ignoring stack trace support,
@@ -54,119 +39,107 @@ static atomic_t inflight_rc = ATOMIC_INI
  */
 #define CONTEXT_COUNT 4
 
-DEFINE_PER_CPU(char *, memcg_path_buf);
-DEFINE_PER_CPU(int, memcg_path_buf_idx);
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
 
 int trace_mmap_lock_reg(void)
 {
-	unsigned long flags;
 	int cpu;
+	char *new;
 
-	/*
-	 * Serialize _reg() and _unreg(). Without this, e.g. _unreg() might
-	 * start cleaning up while _reg() is only partially completed.
-	 */
-	spin_lock_irqsave(&reg_lock, flags);
+	mutex_lock(&reg_lock);
 
 	/* If the refcount is going 0->1, proceed with allocating buffers. */
-	if (reg_types_rc++)
+	if (reg_refcount++)
 		goto out;
 
+	tmp_bufs = kmalloc_array(num_possible_cpus(), sizeof(*tmp_bufs),
+				 GFP_KERNEL);
+	if (tmp_bufs == NULL)
+		goto out_fail;
+
 	for_each_possible_cpu(cpu) {
-		per_cpu(memcg_path_buf, cpu) = NULL;
-	}
-	for_each_possible_cpu(cpu) {
-		per_cpu(memcg_path_buf, cpu) = kmalloc(
-			MEMCG_PATH_BUF_SIZE * CONTEXT_COUNT, GFP_NOWAIT);
-		if (per_cpu(memcg_path_buf, cpu) == NULL)
-			goto out_fail;
-		per_cpu(memcg_path_buf_idx, cpu) = 0;
+		new = kmalloc(MEMCG_PATH_BUF_SIZE * CONTEXT_COUNT, GFP_KERNEL);
+		if (new == NULL)
+			goto out_fail_free;
+		rcu_assign_pointer(per_cpu(memcg_path_buf, cpu), new);
+		/* Don't need to wait for inflights, they'd have gotten NULL. */
 	}
 
-	/* Reset unreg_started flag, allowing new trace events. */
-	WRITE_ONCE(unreg_started, false);
-	/* Add the registration +1 to the inflight refcount. */
-	atomic_inc(&inflight_rc);
-
 out:
-	spin_unlock_irqrestore(&reg_lock, flags);
+	mutex_unlock(&reg_lock);
 	return 0;
 
+out_fail_free:
+	free_memcg_path_bufs();
 out_fail:
-	for_each_possible_cpu(cpu) {
-		if (per_cpu(memcg_path_buf, cpu) != NULL)
-			kfree(per_cpu(memcg_path_buf, cpu));
-		else
-			break;
-	}
+	/* Since we failed, undo the earlier ref increment. */
+	--reg_refcount;
 
-	/* Since we failed, undo the earlier increment. */
-	--reg_types_rc;
-
-	spin_unlock_irqrestore(&reg_lock, flags);
+	mutex_unlock(&reg_lock);
 	return -ENOMEM;
 }
 
 void trace_mmap_lock_unreg(void)
 {
-	unsigned long flags;
-	int cpu;
-
-	spin_lock_irqsave(&reg_lock, flags);
+	mutex_lock(&reg_lock);
 
 	/* If the refcount is going 1->0, proceed with freeing buffers. */
-	if (--reg_types_rc)
+	if (--reg_refcount)
 		goto out;
 
-	/* This was the last registration; start preventing new events... */
-	WRITE_ONCE(unreg_started, true);
-	/* Remove the registration +1 from the inflight refcount. */
-	atomic_dec(&inflight_rc);
-	/*
-	 * Wait for inflight refcount to be zero (all inflights stopped). Since
-	 * we have a spinlock we can't sleep, so just spin. Because trace events
-	 * are "fast", and because we stop new inflights from starting at this
-	 * point with unreg_started, this should be a short spin.
-	 */
-	while (atomic_read(&inflight_rc))
-		barrier();
-
-	for_each_possible_cpu(cpu) {
-		kfree(per_cpu(memcg_path_buf, cpu));
-	}
+	free_memcg_path_bufs();
 
 out:
-	spin_unlock_irqrestore(&reg_lock, flags);
+	mutex_unlock(&reg_lock);
 }
 
 static inline char *get_memcg_path_buf(void)
 {
+	char *buf;
 	int idx;
 
-	/*
-	 * If unregistration is happening, stop. Yes, this check is racy;
-	 * that's fine. It just means _unreg() might spin waiting for an extra
-	 * event or two. Use-after-free is actually prevented by the refcount.
-	 */
-	if (READ_ONCE(unreg_started))
+	rcu_read_lock();
+	buf = rcu_dereference(*this_cpu_ptr(&memcg_path_buf));
+	if (buf == NULL) {
+		rcu_read_unlock();
 		return NULL;
-	/*
-	 * Take a reference, unless the registration +1 has been released
-	 * and there aren't already existing inflights (refcount is zero).
-	 */
-	if (!atomic_inc_not_zero(&inflight_rc))
-		return NULL;
-
+	}
 	idx = this_cpu_add_return(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE) -
 	      MEMCG_PATH_BUF_SIZE;
-	return &this_cpu_read(memcg_path_buf)[idx];
+	return &buf[idx];
 }
 
 static inline void put_memcg_path_buf(void)
 {
 	this_cpu_sub(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE);
-	/* We're done with this buffer; drop the reference. */
-	atomic_dec(&inflight_rc);
+	rcu_read_unlock();
 }
 
 /*
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mmap_lock-add-tracepoints-around-lock-acquisition.patch
userfaultfd-selftests-make-__su64-format-specifiers-portable.patch
userfaultfd-selftests-make-__su64-format-specifiers-portable-v2.patch

