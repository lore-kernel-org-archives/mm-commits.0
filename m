Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A090C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 03:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbhKXDii (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhKXDih (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 22:38:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0699E60F50;
        Wed, 24 Nov 2021 03:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637724928;
        bh=ejkg/UPaFR8txORxv2LV9u+Ge00a5jqUvExA77FqVFY=;
        h=Date:From:To:Subject:From;
        b=sPmaSHtEbWVTkLF34Y6fT7dC1qD9f7HLr2ar+zVyJ+36bCjBuEB5erO8maZ4LHruo
         1Wwwsa5C0RtdYoSL0FXSJrHZdapWUFiAmnGOOtbV5NRLlmzBBYAZOo13aUnQplLZjF
         tGMZII0G6BC55St66e9bbAlizooD8xkDAjK/QMCk=
Date:   Tue, 23 Nov 2021 19:35:27 -0800
From:   akpm@linux-foundation.org
To:     alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
        arnaldo.melo@gmail.com, david@redhat.com, keescook@chromium.org,
        laoar.shao@gmail.com, mathieu.desnoyers@efficios.com,
        mirq-linux@rere.qmqm.pl, mm-commits@vger.kernel.org,
        peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  +
 kthread-dynamically-allocate-memory-to-store-kthreads-full-name.patch added
 to -mm tree
Message-ID: <20211124033527.JywQiRmgM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: dynamically allocate memory to store kthread's full name
has been added to the -mm tree.  Its filename is
     kthread-dynamically-allocate-memory-to-store-kthreads-full-name.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kthread-dynamically-allocate-memory-to-store-kthreads-full-name.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kthread-dynamically-allocate-memory-to-store-kthreads-full-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>

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

Patches currently in -mm which might be from laoar.shao@gmail.com are

fs-exec-replace-strlcpy-with-strscpy_pad-in-__set_task_comm.patch
fs-exec-replace-strncpy-with-strscpy_pad-in-__get_task_comm.patch
drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm.patch
fs-binfmt_elf-replace-open-coded-string-copy-with-get_task_comm.patch
samples-bpf-test_overhead_kprobe_kern-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm.patch
tools-bpf-bpftool-skeleton-replace-bpf_probe_read_kernel-with-bpf_probe_read_kernel_str-to-get-task-comm.patch
tools-testing-selftests-bpf-replace-open-coded-16-with-task_comm_len.patch
kthread-dynamically-allocate-memory-to-store-kthreads-full-name.patch

