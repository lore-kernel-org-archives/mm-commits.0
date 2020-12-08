Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FF0C4361B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 01:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C5AE20DD4
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 01:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgLHB27 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 20:28:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgLHB26 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 20:28:58 -0500
Date:   Mon, 07 Dec 2020 17:28:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607390896;
        bh=NfEK6XGcejn3vRojJS0uEF5YFtF6KjEnKI0Ttv2HkNc=;
        h=From:To:Subject:From;
        b=I6voUNFn6TLm72TyAs8lwIbYpUnaDp28fPuS2Kh+ekyMATS6BC2iTzcGc3a1ASqiJ
         ctAgmQcKZBVGthjbWFlAnIYKkfBhgzpkEeRr/oOC9877GglpBilhKxqUZSwPTXF/kd
         bYKzzJ1suvk3O899aHPn4oCLBXXHzRht3VowMOfk=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz,
        rostedt@goodmis.org, rientjes@google.com, mingo@redhat.com,
        ldufour@linux.ibm.com, laoar.shao@gmail.com, jannh@google.com,
        dbueso@suse.de, daniel.m.jordan@oracle.com,
        chinwen.chang@mediatek.com, axelrasmussen@google.com
Subject:  +
 mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3.patch added to -mm
 tree
Message-ID: <20201208012815.B5nvD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3
has been added to the -mm tree.  Its filename is
     mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3.patch

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
Subject: mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3

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
mmap_lock-add-tracepoints-around-lock-acquisition-fix.patch
mmap_lock-add-tracepoints-around-lock-acquisition-fix-v3.patch
userfaultfd-selftests-make-__su64-format-specifiers-portable.patch
userfaultfd-selftests-make-__su64-format-specifiers-portable-v2.patch

