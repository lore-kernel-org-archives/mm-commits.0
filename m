Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4E3C43217
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358172AbiATCIy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42260 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358174AbiATCIp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78A7061546
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57159C004E1;
        Thu, 20 Jan 2022 02:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644524;
        bh=1KbcQ4+l/4Mb2iB9UXocY5nJhNL/FYDLF16N0zfCOpI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s+MOdeYl+ixwwgYKV9lwmUf6Etqyg/sbuJUEEuOivAZWKtgBYcyZH2ffjcxeUWP5q
         hjQ04wA+hTsCRns4/AtxbuLjgka3tec57eypSc9zvKa1Mv5g/31QRcfBQPRCEqcuAJ
         raqvEIzSw1LwMnjWgvQqAh+DamAXAx4emfWt0yBc=
Date:   Wed, 19 Jan 2022 18:08:43 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexei.starovoitov@gmail.com,
        andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
        david@redhat.com, keescook@chromium.org, laoar.shao@gmail.com,
        linux-mm@kvack.org, mathieu.desnoyers@efficios.com,
        mirq-linux@rere.qmqm.pl, mm-commits@vger.kernel.org,
        peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 19/55] kthread: dynamically allocate memory to
 store kthread's full name
Message-ID: <20220120020843.lomJxoH7T%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: kthread: dynamically allocate memory to store kthread's full name

When I was implementing a new per-cpu kthread cfs_migration, I found the
comm of it "cfs_migration/%u" is truncated due to the limitation of
TASK_COMM_LEN.  For example, the comm of the percpu thread on CPU10~19 all
have the same name "cfs_migration/1", which will confuse the user.  This
issue is not critical, because we can get the corresponding CPU from the
task's Cpus_allowed.  But for kthreads corresponding to other hardware
devices, it is not easy to get the detailed device info from task comm,
for example,

    jbd2/nvme0n1p2-
    xfs-reclaim/sdf

Currently there are so many truncated kthreads:

    rcu_tasks_kthre
    rcu_tasks_rude_
    rcu_tasks_trace
    poll_mpt3sas0_s
    ext4-rsv-conver
    xfs-reclaim/sd{a, b, c, ...}
    xfs-blockgc/sd{a, b, c, ...}
    xfs-inodegc/sd{a, b, c, ...}
    audit_send_repl
    ecryptfs-kthrea
    vfio-irqfd-clea
    jbd2/nvme0n1p2-
    ...

We can shorten these names to work around this problem, but it may be not
applied to all of the truncated kthreads.  Take 'jbd2/nvme0n1p2-' for
example, it is a nice name, and it is not a good idea to shorten it.

One possible way to fix this issue is extending the task comm size, but as
task->comm is used in lots of places, that may cause some potential buffer
overflows.  Another more conservative approach is introducing a new
pointer to store kthread's full name if it is truncated, which won't
introduce too much overhead as it is in the non-critical path.  Finally we
make a dicision to use the second approach.  See also the discussions in
this thread:
https://lore.kernel.org/lkml/20211101060419.4682-1-laoar.shao@gmail.com/

After this change, the full name of these truncated kthreads will be
displayed via /proc/[pid]/comm:

    rcu_tasks_kthread
    rcu_tasks_rude_kthread
    rcu_tasks_trace_kthread
    poll_mpt3sas0_statu
    ext4-rsv-conversion
    xfs-reclaim/sdf1
    xfs-blockgc/sdf1
    xfs-inodegc/sdf1
    audit_send_reply
    ecryptfs-kthread
    vfio-irqfd-cleanup
    jbd2/nvme0n1p2-8

Link: https://lkml.kernel.org/r/20211120112850.46047-1-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c         |    3 +++
 include/linux/kthread.h |    1 +
 kernel/kthread.c        |   32 ++++++++++++++++++++++++++++++--
 3 files changed, 34 insertions(+), 2 deletions(-)

--- a/fs/proc/array.c~kthread-dynamically-allocate-memory-to-store-kthreads-full-name
+++ a/fs/proc/array.c
@@ -92,6 +92,7 @@
 #include <linux/string_helpers.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_struct.h>
+#include <linux/kthread.h>
 
 #include <asm/processor.h>
 #include "internal.h"
@@ -102,6 +103,8 @@ void proc_task_name(struct seq_file *m,
 
 	if (p->flags & PF_WQ_WORKER)
 		wq_worker_comm(tcomm, sizeof(tcomm), p);
+	else if (p->flags & PF_KTHREAD)
+		get_kthread_comm(tcomm, sizeof(tcomm), p);
 	else
 		__get_task_comm(tcomm, sizeof(tcomm), p);
 
--- a/include/linux/kthread.h~kthread-dynamically-allocate-memory-to-store-kthreads-full-name
+++ a/include/linux/kthread.h
@@ -33,6 +33,7 @@ struct task_struct *kthread_create_on_cp
 					  unsigned int cpu,
 					  const char *namefmt);
 
+void get_kthread_comm(char *buf, size_t buf_size, struct task_struct *tsk);
 void set_kthread_struct(struct task_struct *p);
 
 void kthread_set_per_cpu(struct task_struct *k, int cpu);
--- a/kernel/kthread.c~kthread-dynamically-allocate-memory-to-store-kthreads-full-name
+++ a/kernel/kthread.c
@@ -60,6 +60,8 @@ struct kthread {
 #ifdef CONFIG_BLK_CGROUP
 	struct cgroup_subsys_state *blkcg_css;
 #endif
+	/* To store the full name if task comm is truncated. */
+	char *full_name;
 };
 
 enum KTHREAD_BITS {
@@ -93,6 +95,18 @@ static inline struct kthread *__to_kthre
 	return kthread;
 }
 
+void get_kthread_comm(char *buf, size_t buf_size, struct task_struct *tsk)
+{
+	struct kthread *kthread = to_kthread(tsk);
+
+	if (!kthread || !kthread->full_name) {
+		__get_task_comm(buf, buf_size, tsk);
+		return;
+	}
+
+	strscpy_pad(buf, kthread->full_name, buf_size);
+}
+
 void set_kthread_struct(struct task_struct *p)
 {
 	struct kthread *kthread;
@@ -118,9 +132,13 @@ void free_kthread_struct(struct task_str
 	 * or if kmalloc() in kthread() failed.
 	 */
 	kthread = to_kthread(k);
+	if (!kthread)
+		return;
+
 #ifdef CONFIG_BLK_CGROUP
-	WARN_ON_ONCE(kthread && kthread->blkcg_css);
+	WARN_ON_ONCE(kthread->blkcg_css);
 #endif
+	kfree(kthread->full_name);
 	kfree(kthread);
 }
 
@@ -406,12 +424,22 @@ struct task_struct *__kthread_create_on_
 	task = create->result;
 	if (!IS_ERR(task)) {
 		char name[TASK_COMM_LEN];
+		va_list aq;
+		int len;
 
 		/*
 		 * task is already visible to other tasks, so updating
 		 * COMM must be protected.
 		 */
-		vsnprintf(name, sizeof(name), namefmt, args);
+		va_copy(aq, args);
+		len = vsnprintf(name, sizeof(name), namefmt, aq);
+		va_end(aq);
+		if (len >= TASK_COMM_LEN) {
+			struct kthread *kthread = to_kthread(task);
+
+			/* leave it truncated when out of memory. */
+			kthread->full_name = kvasprintf(GFP_KERNEL, namefmt, args);
+		}
 		set_task_comm(task, name);
 	}
 	kfree(create);
_
