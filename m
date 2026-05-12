Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC33338237C
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778622113; cv=none; b=Mc0pP2LKmQ1qryGHn/Yxon/VLWRHeYpdbcosP9ekBsdBv7lgiQGZnNR7Ceybd4F3UW/WtJOfb9VpG3PgePkT2FJLHR0HTfADpUHF9yD4nI3Jm252l2CXKDnkv7+hDnn1k1B/wy7H/DCT2MWn6QdDgAkxdnuhqWjQRsoZH806FBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778622113; c=relaxed/simple;
	bh=CyiS6puKQoK3lbl1zeJSMVdYgc/5m7iq0s5Vf1Rn6lA=;
	h=Date:To:From:Subject:Message-Id; b=uKe+NgGcY/nsWd+3esG+ZTjrbsHK2rE8u7fMpAQsQv99jDaZ2qebI1w8Kas50BTLKaCzRcqPnNc5knj49esZarN/ML/ApPV8isFxjsxdRwi9WRYAEHIBd7LsjpVOPFB73yi8TUylvwoqV9beDeO3g0OiNSi2M19gvifW/OAVbdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cmmq9PaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cmmq9PaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FBFC2BCB0;
	Tue, 12 May 2026 21:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778622112;
	bh=CyiS6puKQoK3lbl1zeJSMVdYgc/5m7iq0s5Vf1Rn6lA=;
	h=Date:To:From:Subject:From;
	b=cmmq9PaQnE7IdIsiCqgWkTOBOfBt7W54Oc9qymIeSeL4I5W3yi73cXVgxaoS71aKm
	 eclZzM8TbzBsSEPk8yYOFbrqJ0/zOKfuiOvC3Nf+BH5/KSdQgLNjs7/i4B3nJl+9xR
	 N3q7Wzt9yocOVOMkV0VVmpVlALVUhDagqqcT/m9g=
Date: Tue, 12 May 2026 14:41:51 -0700
To: mm-commits@vger.kernel.org,timmurray@google.com,surenb@google.com,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,hca@linux.ibm.com,david@kernel.org,brauner@kernel.org,minchan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch removed from -mm tree
Message-Id: <20260512214152.92FBFC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
has been removed from the -mm tree.  Its filename was
     mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch

This patch was dropped because an updated version will be issued

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


