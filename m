Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B643C4743C
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 315D0613F9
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFDUaQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 16:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhFDUaP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 16:30:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6807613D8;
        Fri,  4 Jun 2021 20:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622838509;
        bh=QV94jSsL9j1GRje9iWsCXcHfuyUzEvACGLd/9hbMgcI=;
        h=Date:From:To:Subject:From;
        b=bqLr+IDJklqdpU774zkxBgC4F7pxcrcxM06PqVdLFxucV+0WfGazEoBolJ0dL9RiX
         Toc6Va3bc1p6TljkNrB1W8INcuISow6PT7/dDjX7JhHfvYQdDecqT0CSmH0MUpHMpB
         gMB+hByClZDGSuozwel9y+Rq8obGWlT7clRH+pOY=
Date:   Fri, 04 Jun 2021 13:28:28 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, mm-commits@vger.kernel.org,
        nsaenzju@redhat.com, rostedt@goodmis.org, vbabka@suse.cz
Subject:  +
 mm-mmap_lock-use-local-locks-instead-of-disabling-preemption.patch added to
 -mm tree
Message-ID: <20210604202828.q18iHIBOQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap_lock: use local locks instead of disabling preemption
has been added to the -mm tree.  Its filename is
     mm-mmap_lock-use-local-locks-instead-of-disabling-preemption.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap_lock-use-local-locks-instead-of-disabling-preemption.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap_lock-use-local-locks-instead-of-disabling-preemption.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: mm: mmap_lock: use local locks instead of disabling preemption

mmap_lock will explicitly disable/enable preemption upon manipulating its
local CPU variables.  This is to be expected, but in this case, it doesn't
play well with PREEMPT_RT.  The preemption disabled code section also
takes a spin-lock.  Spin-locks in RT systems will try to schedule, which
is exactly what we're trying to avoid.

To mitigate this, convert the explicit preemption handling to local_locks.
Which are RT aware, and will disable migration instead of preemption when
PREEMPT_RT=y.

The faulty call trace looks like the following:
    __mmap_lock_do_trace_*()
      preempt_disable()
      get_mm_memcg_path()
        cgroup_path()
          kernfs_path_from_node()
            spin_lock_irqsave() /* Scheduling while atomic! */

Link: https://lkml.kernel.org/r/20210604163506.2103900-1-nsaenzju@redhat.com
Fixes: 2b5067a8143e3 ("mm: mmap_lock: add tracepoints around lock acquisition ")
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Tested-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap_lock.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/mm/mmap_lock.c~mm-mmap_lock-use-local-locks-instead-of-disabling-preemption
+++ a/mm/mmap_lock.c
@@ -11,6 +11,7 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 #include <linux/trace_events.h>
+#include <linux/local_lock.h>
 
 EXPORT_TRACEPOINT_SYMBOL(mmap_lock_start_locking);
 EXPORT_TRACEPOINT_SYMBOL(mmap_lock_acquire_returned);
@@ -39,21 +40,30 @@ static int reg_refcount; /* Protected by
  */
 #define CONTEXT_COUNT 4
 
-static DEFINE_PER_CPU(char __rcu *, memcg_path_buf);
+struct memcg_path {
+	local_lock_t lock;
+	char __rcu *buf;
+	local_t buf_idx;
+};
+static DEFINE_PER_CPU(struct memcg_path, memcg_paths) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+	.buf_idx = LOCAL_INIT(0),
+};
+
 static char **tmp_bufs;
-static DEFINE_PER_CPU(int, memcg_path_buf_idx);
 
 /* Called with reg_lock held. */
 static void free_memcg_path_bufs(void)
 {
+	struct memcg_path *memcg_path;
 	int cpu;
 	char **old = tmp_bufs;
 
 	for_each_possible_cpu(cpu) {
-		*(old++) = rcu_dereference_protected(
-			per_cpu(memcg_path_buf, cpu),
+		memcg_path = per_cpu_ptr(&memcg_paths, cpu);
+		*(old++) = rcu_dereference_protected(memcg_path->buf,
 			lockdep_is_held(&reg_lock));
-		rcu_assign_pointer(per_cpu(memcg_path_buf, cpu), NULL);
+		rcu_assign_pointer(memcg_path->buf, NULL);
 	}
 
 	/* Wait for inflight memcg_path_buf users to finish. */
@@ -88,7 +98,7 @@ int trace_mmap_lock_reg(void)
 		new = kmalloc(MEMCG_PATH_BUF_SIZE * CONTEXT_COUNT, GFP_KERNEL);
 		if (new == NULL)
 			goto out_fail_free;
-		rcu_assign_pointer(per_cpu(memcg_path_buf, cpu), new);
+		rcu_assign_pointer(per_cpu_ptr(&memcg_paths, cpu)->buf, new);
 		/* Don't need to wait for inflights, they'd have gotten NULL. */
 	}
 
@@ -122,23 +132,24 @@ out:
 
 static inline char *get_memcg_path_buf(void)
 {
+	struct memcg_path *memcg_path = this_cpu_ptr(&memcg_paths);
 	char *buf;
 	int idx;
 
 	rcu_read_lock();
-	buf = rcu_dereference(*this_cpu_ptr(&memcg_path_buf));
+	buf = rcu_dereference(memcg_path->buf);
 	if (buf == NULL) {
 		rcu_read_unlock();
 		return NULL;
 	}
-	idx = this_cpu_add_return(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE) -
+	idx = local_add_return(MEMCG_PATH_BUF_SIZE, &memcg_path->buf_idx) -
 	      MEMCG_PATH_BUF_SIZE;
 	return &buf[idx];
 }
 
 static inline void put_memcg_path_buf(void)
 {
-	this_cpu_sub(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE);
+	local_sub(MEMCG_PATH_BUF_SIZE, &this_cpu_ptr(&memcg_paths)->buf_idx);
 	rcu_read_unlock();
 }
 
@@ -179,14 +190,14 @@ out:
 #define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
 	do {                                                                   \
 		const char *memcg_path;                                        \
-		preempt_disable();                                             \
+		local_lock(&memcg_paths.lock);				       \
 		memcg_path = get_mm_memcg_path(mm);                            \
 		trace_mmap_lock_##type(mm,                                     \
 				       memcg_path != NULL ? memcg_path : "",   \
 				       ##__VA_ARGS__);                         \
 		if (likely(memcg_path != NULL))                                \
 			put_memcg_path_buf();                                  \
-		preempt_enable();                                              \
+		local_unlock(&memcg_paths.lock);			       \
 	} while (0)
 
 #else /* !CONFIG_MEMCG */
_

Patches currently in -mm which might be from nsaenzju@redhat.com are

mm-mmap_lock-use-local-locks-instead-of-disabling-preemption.patch

