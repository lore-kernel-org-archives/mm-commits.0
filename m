Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB839C432BE
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 22:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FB5360F41
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 22:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhHDWvK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Aug 2021 18:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235323AbhHDWu6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 4 Aug 2021 18:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEABF61106;
        Wed,  4 Aug 2021 22:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628117445;
        bh=eOrtnZZ+6SyAUtoRPrqLdxdoIxer0F1taCEmqeQrDuQ=;
        h=Date:From:To:Subject:From;
        b=VXrVq0Y+AYvJ3xqLHnF95TyXGNnM2ObSP05FzVtlmgJrCYurh/Joy44FiHOX9iAcq
         pyGzsszRlY6yt1de9/oHfvY3d9/fQG2Cn2en66cezYPt+d7F1uTZzBQiI/8DwB1ucx
         y4JkgQ5xy383xpzzMv32Odtim4tyw+n+dd2oh8bI=
Date:   Wed, 04 Aug 2021 15:50:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        timmurray@google.com, shakeelb@google.com, rientjes@google.com,
        riel@surriel.com, oleg@redhat.com, minchan@kernel.org,
        mhocko@suse.com, luto@kernel.org, jengelh@inai.de,
        jannh@google.com, hch@infradead.org, hannes@cmpxchg.org,
        guro@fb.com, fweimer@redhat.com, david@redhat.com,
        christian.brauner@ubuntu.com, christian@brauner.io,
        surenb@google.com
Subject:  + mm-introduce-process_mrelease-system-call.patch added to
 -mm tree
Message-ID: <20210804225042.LTri6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce process_mrelease system call
has been added to the -mm tree.  Its filename is
     mm-introduce-process_mrelease-system-call.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-process_mrelease-system-call.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-process_mrelease-system-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: introduce process_mrelease system call

Patch series "mm: introduce process_mrelease system call", v6.


This patch (of 2):

In modern systems it's not unusual to have a system component monitoring
memory conditions of the system and tasked with keeping system memory
pressure under control.  One way to accomplish that is to kill
non-essential processes to free up memory for more important ones. 
Examples of this are Facebook's OOM killer daemon called oomd and
Android's low memory killer daemon called lmkd.

For such system component it's important to be able to free memory quickly
and efficiently.  Unfortunately the time process takes to free up its
memory after receiving a SIGKILL might vary based on the state of the
process (uninterruptible sleep), size and OPP level of the core the
process is running.  A mechanism to free resources of the target process
in a more predictable way would improve system's ability to control its
memory pressure.

Introduce process_mrelease system call that releases memory of a dying
process from the context of the caller.  This way the memory is freed in a
more controllable way with CPU affinity and priority of the caller.  The
workload of freeing the memory will also be charged to the caller.  The
operation is allowed only on a dying process.

After previous discussions [1, 2, 3] the decision was made [4] to
introduce a dedicated system call to cover this use case.

The API is as follows,

          int process_mrelease(int pidfd, unsigned int flags);

        DESCRIPTION
          The process_mrelease() system call is used to free the memory of
          an exiting process.

          The pidfd selects the process referred to by the PID file
          descriptor.
          (See pidfd_open(2) for further information)

          The flags argument is reserved for future use; currently, this
          argument must be specified as 0.

        RETURN VALUE
          On success, process_mrelease() returns 0. On error, -1 is
          returned and errno is set to indicate the error.

        ERRORS
          EBADF  pidfd is not a valid PID file descriptor.

          EAGAIN Failed to release part of the address space.

          EINTR  The call was interrupted by a signal; see signal(7).

          EINVAL flags is not 0.

          EINVAL The memory of the task cannot be released because the
                 process is not exiting, the address space is shared
                 with another live process or there is a core dump in
                 progress.

          ENOSYS This system call is not supported, for example, without
                 MMU support built into Linux.

          ESRCH  The target process does not exist (i.e., it has terminated
                 and been waited on).

[1] https://lore.kernel.org/lkml/20190411014353.113252-3-surenb@google.com/
[2] https://lore.kernel.org/linux-api/20201113173448.1863419-1-surenb@google.com/
[3] https://lore.kernel.org/linux-api/20201124053943.1684874-3-surenb@google.com/
[4] https://lore.kernel.org/linux-api/20201223075712.GA4719@lst.de/

Link: https://lkml.kernel.org/r/20210804185004.1304692-1-surenb@google.com
Link: https://lkml.kernel.org/r/20210804185004.1304692-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Christian Brauner <christian@brauner.io>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jan Engelhardt <jengelh@inai.de>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

--- a/mm/oom_kill.c~mm-introduce-process_mrelease-system-call
+++ a/mm/oom_kill.c
@@ -28,6 +28,7 @@
 #include <linux/sched/task.h>
 #include <linux/sched/debug.h>
 #include <linux/swap.h>
+#include <linux/syscalls.h>
 #include <linux/timex.h>
 #include <linux/jiffies.h>
 #include <linux/cpuset.h>
@@ -1141,3 +1142,67 @@ void pagefault_out_of_memory(void)
 	out_of_memory(&oc);
 	mutex_unlock(&oom_lock);
 }
+
+SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
+{
+#ifdef CONFIG_MMU
+	struct mm_struct *mm = NULL;
+	struct task_struct *task;
+	unsigned int f_flags;
+	struct pid *pid;
+	long ret = 0;
+
+	if (flags)
+		return -EINVAL;
+
+	pid = pidfd_get_pid(pidfd, &f_flags);
+	if (IS_ERR(pid))
+		return PTR_ERR(pid);
+
+	task = get_pid_task(pid, PIDTYPE_PID);
+	if (!task) {
+		ret = -ESRCH;
+		goto put_pid;
+	}
+
+	/*
+	 * If the task is dying and in the process of releasing its memory
+	 * then get its mm.
+	 */
+	task = find_lock_task_mm(task);
+	if (!task) {
+		ret = -ESRCH;
+		goto put_pid;
+	}
+	if (task_will_free_mem(task) && (task->flags & PF_KTHREAD) == 0) {
+		mm = task->mm;
+		mmget(mm);
+	}
+	task_unlock(task);
+	if (!mm) {
+		ret = -EINVAL;
+		goto put_task;
+	}
+
+	if (test_bit(MMF_OOM_SKIP, &mm->flags))
+		goto put_mm;
+
+	if (mmap_read_lock_killable(mm)) {
+		ret = -EINTR;
+		goto put_mm;
+	}
+	if (!__oom_reap_task_mm(mm))
+		ret = -EAGAIN;
+	mmap_read_unlock(mm);
+
+put_mm:
+	mmput(mm);
+put_task:
+	put_task_struct(task);
+put_pid:
+	put_pid(pid);
+	return ret;
+#else
+	return -ENOSYS;
+#endif /* CONFIG_MMU */
+}
_

Patches currently in -mm which might be from surenb@google.com are

mm-memcg-add-mem_cgroup_disabled-checks-in-vmpressure-and-swap-related-functions.patch
mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
mm-memcg-inline-swap-related-functions-to-improve-disabled-memcg-config.patch
mm-introduce-process_mrelease-system-call.patch
mm-wire-up-syscall-process_mrelease.patch

