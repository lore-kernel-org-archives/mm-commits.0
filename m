From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-support-vector-address-ranges-for-process_madvise.patch added to -mm
 tree
Date: Thu, 23 Apr 2020 15:44:20 -0700
Message-ID: <20200423224420.KZLkNkOTO%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgDWWoW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 18:44:22 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjunroy@google.com, bgeffon@google.com, dancol@google.com, hannes@cmpxchg.org, joaodias@google.com, joel@joelfernandes.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, oleksandr@redhat.com, rientjes@google.com, shakeelb@google.com, sj38.park@gmail.com, sonnyrao@google.com, sspatil@google.com, surenb@google.com, timmurray@google.com, vbabka@suse.cz


The patch titled
     Subject: mm: support vector address ranges for process_madvise
has been added to the -mm tree.  Its filename is
     mm-support-vector-address-ranges-for-process_madvise.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-support-vector-address-ranges-for-process_madvise.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-support-vector-address-ranges-for-process_madvise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: support vector address ranges for process_madvise

This patch extends a) process_madvise(2) support vector address ranges in
a system call and then b) support the vector address ranges to local
process as well as external process.

Android app has thousands of vmas due to zygote so it's totally waste of
CPU and power if we should call the syscall one by one for each vma. 
(With testing 2000-vma syscall vs 1-vector syscall, it showed 15%
performance improvement.  I think it would be bigger in real practice
because the testing ran very cache friendly environment).

Another potential use case for the vector range is to amortize the cost of
TLB shootdowns for multiple ranges when using MADV_DONTNEED; this could
benefit users like TCP receive zerocopy and malloc implementations.  In
future, we could find more usecases for other advises so let's make it
happens as API since we introduce a new syscall at this moment.  With
that, existing madvise(2) user could replace it with process_madvise(2)
with their own pid if they want to have batch address ranges support
feature.

So finally, the API is as follows,

  ssize_t process_madvise(idtype_t idtype, id_t id,
		const struct iovec *iovec, unsigned long vlen,
                int advice, unsigned long flags);

DESCRIPTION
  The process_madvise() system call is used to give advice or directions
  to the kernel about the address ranges from external process as well as
  local process. It provides the advice to address ranges of process
  described by iovec and vlen. The goal of such advice is to improve system
  or application performance.

  The idtype and id arguments select the target process to be advised as
  follows:

    idtype == P_PID
      select the process whose process ID matches id

    idtype == P_PIDFD
      select the process referred to by the PID file descriptor
      specified in id. (See pidofd_open(2) for further information)

  The pointer iovec points to an array of iovec structures, defined in
  <sys/uio.h> as:

    struct iovec {
    	void *iov_base;		/* starting address */
	size_t iov_len;		/* number of bytes to be advised */
    };

  The iovec describes address ranges beginning at address(iov_base)
  and with size length of bytes(iov_len).

  The vlen represents the number of elements in iovec.

  The advice is indicated in the advice argument, which is one of the
  following at this moment if the target process specified by idtype and
  id is external.

    MADV_COLD
    MADV_PAGEOUT
    MADV_MERGEABLE
    MADV_UNMERGEABLE

  Permission to provide a hint to external process is governed by a
  ptrace access mode PTRACE_MODE_ATTACH_FSCREDS check; see ptrace(2).

  The process_madvise supports every advice madvise(2) has if target
  process is in same thread group with calling process so user could
  use process_madvise(2) to extend existing madvise(2) to support
  vector address ranges.

RETURN VALUE
  On success, process_madvise() returns the number of bytes advised.
  This return value may be less than the total number of requested
  bytes, if an error occurred. The caller should check return value
  to determine whether a partial advice occurred.

Link: http://lkml.kernel.org/r/20200423145215.72666-2-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Daniel Colascione <dancol@google.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: John Dias <joaodias@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   47 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

--- a/mm/madvise.c~mm-support-vector-address-ranges-for-process_madvise
+++ a/mm/madvise.c
@@ -1195,20 +1195,39 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	return do_madvise(current, current->mm, start, len_in, behavior);
 }
 
-SYSCALL_DEFINE6(process_madvise, int, which, pid_t, upid, unsigned long, start,
-		size_t, len_in, int, behavior, unsigned long, flags)
+static int do_process_madvise(struct task_struct *target_task,
+		struct mm_struct *mm, struct iov_iter *iter, int behavior)
 {
-	int ret;
+	struct iovec iovec;
+	int ret = 0;
+
+	while (iov_iter_count(iter)) {
+		iovec = iov_iter_iovec(iter);
+		ret = do_madvise(target_task, mm, (unsigned long)iovec.iov_base,
+					iovec.iov_len, behavior);
+		if (ret < 0)
+			break;
+		iov_iter_advance(iter, iovec.iov_len);
+	}
+
+	return ret;
+}
+
+SYSCALL_DEFINE6(process_madvise, int, which, pid_t, upid,
+		const struct iovec __user *, vec, unsigned long, vlen,
+		int, behavior, unsigned long, flags)
+{
+	ssize_t ret;
 	struct pid *pid;
 	struct task_struct *task;
 	struct mm_struct *mm;
+	struct iovec iovstack[UIO_FASTIOV];
+	struct iovec *iov = iovstack;
+	struct iov_iter iter;
 
 	if (flags != 0)
 		return -EINVAL;
 
-	if (!process_madvise_behavior_valid(behavior))
-		return -EINVAL;
-
 	switch (which) {
 	case P_PID:
 		if (upid <= 0)
@@ -1236,13 +1255,27 @@ SYSCALL_DEFINE6(process_madvise, int, wh
 		goto put_pid;
 	}
 
+	if (task->mm != current->mm &&
+			!process_madvise_behavior_valid(behavior)) {
+		ret = -EINVAL;
+		goto release_task;
+	}
+
 	mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
 	if (IS_ERR_OR_NULL(mm)) {
 		ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
 		goto release_task;
 	}
 
-	ret = do_madvise(task, mm, start, len_in, behavior);
+	ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
+	if (ret >= 0) {
+		size_t total_len = iov_iter_count(&iter);
+
+		ret = do_process_madvise(task, mm, &iter, behavior);
+		if (ret >= 0)
+			ret = total_len - iov_iter_count(&iter);
+		kfree(iov);
+	}
 	mmput(mm);
 release_task:
 	put_task_struct(task);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-pass-task-and-mm-to-do_madvise.patch
mm-pass-task-and-mm-to-do_madvise-fix.patch
mm-introduce-external-memory-hinting-api.patch
mm-introduce-external-memory-hinting-api-fix.patch
mm-check-fatal-signal-pending-of-target-process.patch
pid-move-pidfd_get_pid-function-to-pidc.patch
mm-support-both-pid-and-pidfd-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise-fix.patch
