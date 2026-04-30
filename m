Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4374342E019
	for <mm-commits@vger.kernel.org>; Thu, 30 Apr 2026 14:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777560190; cv=none; b=IPhGoRqIDD6Rm3dhwZx9EAh2+Zk6oU4IyNwkBLtTA+MWiNVmV0IoBqYyDbWHqdiaau7xM9ymSkxGahk2MJrIwzSeVTaLErWRZbH4S3O62PpoAf9XJK7QS2wtfureSXJANHHNNrRYxXsA9O8G2wZ//L63nyTzKQDHw/W3ISd0riI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777560190; c=relaxed/simple;
	bh=TL8XCufbe7k31T2ImMhvIoKOEygcLSt90VFmrp21bUw=;
	h=Date:To:From:Subject:Message-Id; b=Qv+UYxVdnf+A7TiLuOjhZQwbkVUS+8lnvTD9KcDJgdHa2Tw9jxDlkt7qXLqc4dHnKgGv9zLYSuCxb7ZTZkX31i8a2HNL+OlYwANAdjTFXc7HVPGrTQqw6ZnTufEXgnqPywAOf6I5aLVMxiFx6baI7pklLNDbS7A3K+RmtrrfgB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vu5kbgBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vu5kbgBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B806CC2BCB3;
	Thu, 30 Apr 2026 14:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777560189;
	bh=TL8XCufbe7k31T2ImMhvIoKOEygcLSt90VFmrp21bUw=;
	h=Date:To:From:Subject:From;
	b=Vu5kbgBFNcVEowy4uBDv1wA674otClEwGRFfM3kieGNbsiTzA4r/ImJpaRTfJDT5b
	 AXY4uTL4SfVFObI7p4FKSiBIpwgK3RK92ZrI5TrfcpLPFn2GYtp4fpZl9a0rBj0TCA
	 TKfv3dUOEkFqdCfMh3a76ZcJ2XU/LZF/CRrN2Bdc=
Date: Thu, 30 Apr 2026 07:43:09 -0700
To: mm-commits@vger.kernel.org,timmurray@google.com,surenb@google.com,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,hca@linux.ibm.com,david@kernel.org,brauner@kernel.org,minchan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch added to mm-new branch
Message-Id: <20260430144309.B806CC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
has been added to the -mm mm-new branch.  Its filename is
     mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
Date: Wed, 29 Apr 2026 14:13:59 -0700

Currently, process_mrelease() requires userspace to send a SIGKILL signal
prior to invocation.  This separation introduces a scheduling race window
where the victim task may receive the signal and enter the exit path
before the reaper can invoke process_mrelease().

When the victim enters the exit path (do_exit -> exit_mm), it clears its
task->mm immediately.  This causes process_mrelease() to fail with -ESRCH,
leaving the actual address space teardown (exit_mmap) to be deferred until
the mm's reference count drops to zero.  In the field (e.g., Android),
arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
remote VM accesses) frequently delay this teardown indefinitely, defeating
the purpose of expedited reclamation.

In Android's LMKD scenarios, this delay keeps memory pressure high, forcing
the system to unnecessarily kill additional innocent background apps before
the memory from the first victim is recovered.

This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
an integrated auto-kill mode. When specified, process_mrelease() directly
injects a SIGKILL into the target task after finding its mm.

To solve the race condition, we grab the mm reference via mmgrab() before
sending the SIGKILL. If the user passed PROCESS_MRELEASE_REAP_KILL, we assume
it will free its memory and proceed with reaping, making the logic as simple
as reap = reap_kill || task_will_free_mem(p).

To handle shared address spaces safely in the auto-kill mode, we bail out
immediately if the mm is marked with MMF_MULTIPROCESS when
PROCESS_MRELEASE_REAP_KILL is specified. This protects existing users of
process_mrelease() from behavior changes while preventing unsafe reaping of
shared memory.

This policy differs from the global OOM killer, which kills all processes
sharing the same mm to guarantee memory reclamation at all costs (preventing
system hangs). However, process_mrelease() is invoked by userspace policy.
If it fails due to sharing, userspace can simply adapt and select another
victim process (such as another background app in Android case) to release
memory. We do not need to force success or affect processes that were not
targeted.

Fundamentally, this allows process_mrelease() to trigger targeted memory
reclaim (via oom_reaper infrastructure) quickly, even if the victim is
not yet in the exit path, while reusing existing race handling between
reaper and exit_mmap.

Link: https://lore.kernel.org/20260429211359.3829683-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Suggested-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mman.h |    4 ++++
 mm/oom_kill.c             |   27 ++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

--- a/include/uapi/linux/mman.h~mm-process_mrelease-introduce-process_mrelease_reap_kill-flag
+++ a/include/uapi/linux/mman.h
@@ -56,4 +56,8 @@ struct cachestat {
 	__u64 nr_recently_evicted;
 };
 
+/* Flags for process_mrelease */
+#define PROCESS_MRELEASE_REAP_KILL	(1 << 0)
+#define PROCESS_MRELEASE_VALID_FLAGS	(PROCESS_MRELEASE_REAP_KILL)
+
 #endif /* _UAPI_LINUX_MMAN_H */
--- a/mm/oom_kill.c~mm-process_mrelease-introduce-process_mrelease_reap_kill-flag
+++ a/mm/oom_kill.c
@@ -20,6 +20,7 @@
 
 #include <linux/oom.h>
 #include <linux/mm.h>
+#include <uapi/linux/mman.h>
 #include <linux/err.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
@@ -1201,9 +1202,11 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 	unsigned int f_flags;
 	bool reap = false;
 	long ret = 0;
+	bool reap_kill;
 
-	if (flags)
+	if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
 		return -EINVAL;
+	reap_kill = !!(flags & PROCESS_MRELEASE_REAP_KILL);
 
 	task = pidfd_get_task(pidfd, &f_flags);
 	if (IS_ERR(task))
@@ -1220,19 +1223,29 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 	}
 
 	mm = p->mm;
-	mmgrab(mm);
+	if (reap_kill && mm_flags_test(MMF_MULTIPROCESS, mm)) {
+		ret = -EINVAL;
+		task_unlock(p);
+		goto put_task;
+	}
 
-	if (task_will_free_mem(p))
-		reap = true;
-	else {
+	reap = reap_kill || task_will_free_mem(p);
+	if (!reap) {
 		/* Error only if the work has not been done already */
 		if (!mm_flags_test(MMF_OOM_SKIP, mm))
 			ret = -EINVAL;
+		task_unlock(p);
+		goto put_task;
 	}
+
+	mmgrab(mm);
 	task_unlock(p);
 
-	if (!reap)
-		goto drop_mm;
+	if (reap_kill) {
+		ret = kill_pid(task_tgid(task), SIGKILL, 0);
+		if (ret)
+			goto drop_mm;
+	}
 
 	if (mmap_read_lock_killable(mm)) {
 		ret = -EINTR;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch

