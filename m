Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8663FFAB7
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778693319; cv=none; b=djhvoS3U7QdsTZxtRBsF2TQH7qB5fCWTuzrWAGLqMHR1n+4WT2lkE+Uo582/l+c87/qOvwoe1gfKUkpe+xNZ3ionqEzHCrh5JfYYuiPnlAxV6FKe3gYiepMc/9hti7p40X5JQE6022q5zcje/kHl2fiQSaawUugY7ZF6Paqps9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778693319; c=relaxed/simple;
	bh=uwy2dXCHFXjwIBhWFIfubJwdRrIBULdasULVyeNtvgQ=;
	h=Date:To:From:Subject:Message-Id; b=A3Za9906UllsHseYdPPDkOCoHUxM7CHIsYNEmaba9r7p+148i9a5vCj4Uyk7PQyjTy74YBQiD1UCtBZVLpjtozcLBN494kTC0qUph2qCLJRv17/kV06pFyGCWNCyw28JxBngSXF+zKgONWGCPskOFdOoj1i2M40lKjwR6OmJ5vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tl8R34Wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tl8R34Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAF0C19425;
	Wed, 13 May 2026 17:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778693319;
	bh=uwy2dXCHFXjwIBhWFIfubJwdRrIBULdasULVyeNtvgQ=;
	h=Date:To:From:Subject:From;
	b=tl8R34WqB6Eye3Fv9BPCbcM+xarapemWCxZzr1jD9G6yI3BrUpTKCufAv2NuLfxyc
	 P9+F4cnBwPkIDNP5eOV8beHnr0Y9xvV8t2xxyQ4yu8CQ9ptPrLB4kE1TofEHWtaDm0
	 SM+xqkYpnt/tdBaFWHYRq5H/ZNIdetHl5TtixSh4=
Date: Wed, 13 May 2026 10:28:38 -0700
To: mm-commits@vger.kernel.org,timmurray@google.com,surenb@google.com,minchan@kernel.org,mhocko@suse.com,lkp@intel.com,hca@linux.ibm.com,david@kernel.org,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix.patch added to mm-new branch
Message-Id: <20260513172839.0CAF0C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix
Date: Wed May 13 10:22:14 AM PDT 2026

move kill_all_shared_mm() inside CONFIG_MMU

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   66 ++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

--- a/mm/oom_kill.c~mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix
+++ a/mm/oom_kill.c
@@ -676,6 +676,39 @@ static void wake_oom_reaper(struct timer
 }
 
 /*
+ * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
+ * @victim: the targeted OOM process group leader
+ * @mm:     the virtual memory space being reaped
+ *
+ * Traverse all threads globally and signal any user processes sharing the
+ * identical mm footprints, ensuring no concurrent users pin the memory. Skips
+ * the system global init and kernel worker threads.
+ */
+static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
+{
+	struct task_struct *p;
+	bool failed = false;
+
+	rcu_read_lock();
+	for_each_process(p) {
+		if (!process_shares_mm(p, mm))
+			continue;
+		if (is_global_init(p)) {
+			failed = true;
+			continue;
+		}
+		if (unlikely(p->flags & PF_KTHREAD))
+			continue;
+
+		if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
+			failed = true;
+	}
+	rcu_read_unlock();
+
+	return failed ? -EBUSY : 0;
+}
+
+/*
  * Give the OOM victim time to exit naturally before invoking the oom_reaping.
  * The timers timeout is arbitrary... the longer it is, the longer the worst
  * case scenario for the OOM can take. If it is too small, the oom_reaper can
@@ -910,39 +943,6 @@ static bool task_will_free_mem(struct ta
 	return ret;
 }
 
-/*
- * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
- * @victim: the targeted OOM process group leader
- * @mm:     the virtual memory space being reaped
- *
- * Traverse all threads globally and signal any user processes sharing the identical
- * mm footprints, ensuring no concurrent users pin the memory. Skips the system
- * global init and kernel worker threads.
- */
-static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
-{
-	struct task_struct *p;
-	bool failed = false;
-
-	rcu_read_lock();
-	for_each_process(p) {
-		if (!process_shares_mm(p, mm))
-			continue;
-		if (is_global_init(p)) {
-			failed = true;
-			continue;
-		}
-		if (unlikely(p->flags & PF_KTHREAD))
-			continue;
-
-		if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
-			failed = true;
-	}
-	rcu_read_unlock();
-
-	return failed ? -EBUSY : 0;
-}
-
 static void __oom_kill_process(struct task_struct *victim, const char *message)
 {
 	struct task_struct *p;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch
mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix.patch
proc-rewrite-next_tgid-fix.patch

